package lk.jiat.ee.ejb.remote;

import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import lk.jiat.ee.core.model.Bid;

import java.time.LocalDateTime;
import java.util.*;

@Singleton
@Startup
public class BidManager {

    private final List<Bid> bids = new ArrayList<>();
    private String latestBidMessage;
    private LocalDateTime messageTimestamp;
    private final Set<String> usersWhoSeenMessage = new HashSet<>();
    private String highestBidder;
    private final Map<String, Integer> userMaxBidMap = new HashMap<>();

    // --- Public Methods ---

    public synchronized void addManualBid(String bidder, int amount) {
        bids.add(new Bid(bidder, amount, amount, LocalDateTime.now()));
        highestBidder = bidder;
        latestBidMessage = "User " + bidder + " has placed a manual bid of $" + amount + ".";
        messageTimestamp = LocalDateTime.now();
        usersWhoSeenMessage.clear();

    }

    public synchronized void placeAutoBid(String bidder, int maxAmount, int actualBidAmount) {
        userMaxBidMap.put(bidder, maxAmount);

        int currentHighest = getHighestBid();
        int minAllowed = currentHighest + 10;

        // Ensure the actual bid is valid
        if (actualBidAmount < minAllowed) {
            return; // Too low — ignore
        }

        // If bid is within limit, accept it
        if (actualBidAmount <= maxAmount) {
            bids.add(new Bid(bidder, actualBidAmount, maxAmount, LocalDateTime.now()));
            highestBidder = bidder;
            latestBidMessage = "User " + bidder + " placed an auto-bid of $" + actualBidAmount + ".";
            messageTimestamp = LocalDateTime.now();
            usersWhoSeenMessage.clear();
            autoBidLoop();
        }
    }




    public synchronized List<Bid> getAllBids() {
        return new ArrayList<>(bids);
    }

    public synchronized int getHighestBid() {
        return bids.stream().mapToInt(Bid::getAmount).max().orElse(0);
    }

    public synchronized String getLatestBidMessageForUser(String username) {
        if (latestBidMessage == null || usersWhoSeenMessage.contains(username)) {
            return null;
        }

        usersWhoSeenMessage.add(username);

        if (usersWhoSeenMessage.size() >= 10 ||
                (messageTimestamp != null &&
                        LocalDateTime.now().minusSeconds(30).isAfter(messageTimestamp))) {
            clearLatestBidMessage();
        }

        return latestBidMessage;
    }

    public synchronized String getLatestBidMessage() {
        return latestBidMessage;
    }

    public synchronized boolean hasRecentMessage() {
        return latestBidMessage != null &&
                messageTimestamp != null &&
                LocalDateTime.now().minusSeconds(10).isBefore(messageTimestamp);
    }

    public synchronized void clearLatestBidMessage() {
        latestBidMessage = null;
        messageTimestamp = null;
        usersWhoSeenMessage.clear();
    }

    public synchronized Bid getLatestBid() {
        return bids.isEmpty() ? null : bids.get(bids.size() - 1);
    }

    public synchronized void autoBidLoop() {
        boolean bidChanged;

        do {
            bidChanged = false;
            Bid currentHighest = getLatestBid();
            if (currentHighest == null) return;

            for (Map.Entry<String, Integer> entry : userMaxBidMap.entrySet()) {
                String bidder = entry.getKey();
                int maxAmount = entry.getValue();

                if (!bidder.equals(currentHighest.getBidder()) &&
                        maxAmount > currentHighest.getAmount()) {

                    int newAmount = currentHighest.getAmount() + 10;

                    if (newAmount <= maxAmount &&
                            (bids.isEmpty() || !bids.get(bids.size() - 1).getBidder().equals(bidder) ||
                                    bids.get(bids.size() - 1).getAmount() != newAmount)) {

                        bids.add(new Bid(bidder, newAmount, maxAmount, LocalDateTime.now()));
                        highestBidder = bidder;
                        latestBidMessage = "User " + bidder + " auto-raised bid to $" + newAmount + ".";
                        messageTimestamp = LocalDateTime.now();
                        usersWhoSeenMessage.clear();
                        bidChanged = true;
                        break;
                    }
                }
            }

        } while (bidChanged);
    }

    public synchronized String getHighestBidder() {
        return highestBidder;
    }
}