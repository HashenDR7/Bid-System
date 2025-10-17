package lk.jiat.ee.web.servlet;


import jakarta.ejb.EJB;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.jiat.ee.ejb.remote.BidManager;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/live-bid")
public class LiveBidServlet extends HttpServlet {

    @EJB
    private BidManager bidManager;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int highestBid = bidManager.getHighestBid();

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        out.print("{\"amount\": " + highestBid + "}");
        out.flush();
    }
}
