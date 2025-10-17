package lk.jiat.ee.web.servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/auction-time")
public class TimeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final LocalDateTime FIXED_END_TIME = LocalDateTime.of(2025, 6, 15, 18, 30, 0);
    private static final LocalDateTime DYNAMIC_END_TIME = LocalDateTime.now().plusDays(7).plusHours(12);
    private LocalDateTime configurableEndTime;

    @Override
    public void init() throws ServletException {
        super.init();
        String endTimeStr = getServletContext().getInitParameter("auction.end.time");
        if (endTimeStr != null) {
            try {
                configurableEndTime = LocalDateTime.parse(endTimeStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            } catch (Exception e) {
                configurableEndTime = LocalDateTime.now().plusDays(3);
            }
        } else {
            configurableEndTime = LocalDateTime.now().plusDays(3);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setHeader("Access-Control-Allow-Origin", "*"); // Enable CORS if frontend is hosted separately

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime endTime = getEndTime(request);

        Duration remaining = Duration.between(now, endTime);
        long totalSeconds = remaining.getSeconds();
        if (totalSeconds < 0) totalSeconds = 0;

        long days = totalSeconds / 86400;
        long hours = (totalSeconds % 86400) / 3600;
        long minutes = (totalSeconds % 3600) / 60;
        long seconds = totalSeconds % 60;

        String endTimeString = endTime.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);

        String jsonResponse = String.format(
                "{\"days\":%d,\"hours\":%d,\"minutes\":%d,\"seconds\":%d,\"endTime\":\"%s\"}",
                days, hours, minutes, seconds, endTimeString
        );

        try (PrintWriter out = response.getWriter()) {
            out.print(jsonResponse);
        }
    }

    private LocalDateTime getEndTime(HttpServletRequest request) {
        String mode = request.getParameter("mode");

        if ("fixed".equalsIgnoreCase(mode)) {
            return FIXED_END_TIME;
        } else if ("dynamic".equalsIgnoreCase(mode)) {
            return DYNAMIC_END_TIME;
        } else if ("custom".equalsIgnoreCase(mode)) {
            String customTime = request.getParameter("endTime");
            if (customTime != null) {
                try {
                    return LocalDateTime.parse(customTime, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
                } catch (Exception e) {
                    return configurableEndTime;
                }
            }
        }

        return configurableEndTime;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String newEndTime = request.getParameter("endTime");
        response.setContentType("application/json");

        try (PrintWriter out = response.getWriter()) {
            if (newEndTime != null) {
                try {
                    configurableEndTime = LocalDateTime.parse(newEndTime, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
                    out.print("{\"status\":\"success\",\"message\":\"End time updated\"}");
                } catch (Exception e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"status\":\"error\",\"message\":\"Invalid date format\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\":\"error\",\"message\":\"Missing endTime parameter\"}");
            }
        }
    }
}
