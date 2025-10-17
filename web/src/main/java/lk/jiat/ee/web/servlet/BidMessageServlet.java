package lk.jiat.ee.web.servlet;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.jiat.ee.core.model.User;
import lk.jiat.ee.ejb.remote.BidManager;

import java.io.IOException;

@WebServlet("/latest-bid-message")
public class BidMessageServlet extends HttpServlet {

    @EJB
    private BidManager bidManager;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/plain");
        resp.setCharacterEncoding("UTF-8");

        // Get current user from session
        User user = (User) req.getSession().getAttribute("user");

        String message = "";
        if (user != null) {
            // Check if there's a recent message (within last 10 seconds)
            if (bidManager.hasRecentMessage()) {
                message = bidManager.getLatestBidMessage();
            }
        }

        resp.getWriter().write(message != null ? message : "");
    }
}