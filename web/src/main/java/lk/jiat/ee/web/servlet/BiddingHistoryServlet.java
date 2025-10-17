package lk.jiat.ee.web.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.jiat.ee.core.model.Bid;
import lk.jiat.ee.ejb.remote.BidManager;

import java.io.IOException;
import java.util.List;

@WebServlet("/bidsHistory")
public class BiddingHistoryServlet extends HttpServlet {

    @EJB
    private BidManager bidManager;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Bid> bids = bidManager.getAllBids();
        req.setAttribute("bids", bids);

        String message = bidManager.getLatestBidMessage();
        if (message != null) {
            req.setAttribute("activityMessage", message);
            bidManager.clearLatestBidMessage(); // Clear after showing once
        }

//        // ✅ (Optional) Add automatic bid increment info if available
//        Integer nextAutoBid = bidManager.getNextAutoBidAmount(); // <-- method you should have in BidManager
//        if (nextAutoBid != null) {
//            req.setAttribute("nextAutoBidAmount", nextAutoBid);
//        }

        req.getRequestDispatcher("/bid-table.jsp").forward(req, resp);
    }
}
