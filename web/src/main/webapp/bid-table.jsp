<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 5/29/2025
  Time: 9:53 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.jiat.ee.core.model.Bid" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

<%
    List<Bid> bidHistory = (List<Bid>) request.getAttribute("bids"); // Use "bids" as set by servlet
    String activityMessage = (String) request.getAttribute("activityMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (bidHistory == null) {
        out.write("<p>No bids to show.</p>");
        return;
    }
%>


<% if (activityMessage != null) { %>
<div class="mb-4 p-4 rounded-xl bg-green-800 text-white shadow-md">
    <%= activityMessage %>
</div>
<% } %>


<table class="min-w-full text-sm text-left">
    <thead class="bg-[#2a2a2a] text-gray-300 uppercase tracking-wide">
    <tr>
        <th class="px-6 py-4 font-semibold">Bidder</th>
        <th class="px-6 py-4 font-semibold">Bid Amount</th>
        <th class="px-6 py-4 font-semibold">Time</th>
    </tr>
    </thead>
    <tbody class="divide-y divide-[#e7d0d1] text-[#994d51]">
    <% for (Bid bid : bidHistory) {
        String bidder = bid.getBidder();
        int amount = bid.getAmount();
        LocalDateTime bidTime = bid.getTimestamp();
        LocalDateTime now = LocalDateTime.now();
        long hoursAgo = ChronoUnit.HOURS.between(bidTime, now);
        String timeDisplay = hoursAgo < 1 ? ChronoUnit.MINUTES.between(bidTime, now) + " minutes ago" :
                hoursAgo < 24 ? hoursAgo + " hours ago" :
                        ChronoUnit.DAYS.between(bidTime, now) + " days ago";
    %>
    <tr class="hover:bg-[#f3ebeb] transition duration-200">
        <td class="px-6 py-4 font-medium"><%= bidder %></td>
        <td class="px-6 py-4 text-[#994d51]">Rs. <%= String.format("%,d", amount) %> .00</td>
        <td class="px-6 py-4 text-[#8b5a5d]"><%= timeDisplay %></td>
    </tr>
    <% } %>
    </tbody>
</table>
