package lk.jiat.ee.web.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.jiat.ee.core.model.User;
import lk.jiat.ee.ejb.bean.BidServiceBean;
import lk.jiat.ee.ejb.remote.BidManager;

import java.io.IOException;


@WebServlet("/bid")
public class BidServlet extends HttpServlet {

    @EJB
    private BidServiceBean bidService;

    @EJB
    private BidManager bidManager;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String bidStr = req.getParameter("bid");
        String maxBidStr = req.getParameter("max-bid");
        User user = (User) req.getSession().getAttribute("user");

        // Check for valid session
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=session_expired");
            return;
        }

        // Validate bid string
        if (bidStr == null || bidStr.trim().isEmpty()) {
            req.setAttribute("error", "Bid amount is required.");
            req.getRequestDispatcher("/bidding-history.jsp").forward(req, resp);
            return;
        }

        try {
            int bidAmount = Integer.parseInt(bidStr.trim());
            int maxBidAmount = Integer.parseInt(maxBidStr.trim());

            int currentHighest = bidManager.getHighestBid();
            String currentHighestUser = bidManager.getHighestBidder();

            System.out.println("bid amount :"+bidAmount);
            System.out.println("max bid amount :"+maxBidAmount);
            System.out.println("chu :"+currentHighestUser);

            if (bidAmount <= currentHighest) {
                req.setAttribute("error", "Bid must be higher than the current highest bid ($" + currentHighest + ").");
            } else {
                if (!user.getUsername().equals(currentHighestUser)) {
                    // New highest bidder
                    if (maxBidAmount > bidAmount) {
                        bidService.placeAutoBid(user.getUsername(), maxBidAmount, bidAmount);

                    } else {
                        bidService.placeManualBid(user.getUsername(), bidAmount);
                    }
                } else {
                    // Existing highest bidder updating max bid
                    bidService.placeAutoBid(user.getUsername(), maxBidAmount, bidAmount);

                }

                req.setAttribute("success", "Bid placed successfully.");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid bid format. Please enter a valid number.");
        } catch (Exception e) {
            req.setAttribute("error", "An unexpected error occurred. Please try again.");
            e.printStackTrace();
        } finally {
            req.setAttribute("bidHistory", bidManager.getAllBids());
            req.getRequestDispatcher("/bidding-history.jsp").forward(req, resp);
        }

    }
}
