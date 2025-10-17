<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 5/29/2025
  Time: 8:23 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.jiat.ee.core.model.User" %>
<%@ page import="lk.jiat.ee.core.model.Bid" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%
    List<Bid> bidHistory = (List<Bid>) request.getAttribute("bidHistory");

    String activityMessage = (String) request.getAttribute("activityMessage");

    lk.jiat.ee.core.model.User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("signup.jsp");
        return;
    }

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title> AutoBid | Bidding History</title>
    <script src="https://cdn.tailwindcss.com"></script>

</head>
<body class="bg-[#121212] text-white min-h-screen px-8 py-6">

<% String error = (String) request.getAttribute("error"); %>
<% if (error != null) { %>
<div class="auto-dismiss mb-4 p-4 rounded-xl bg-red-600 text-white shadow-md transition-opacity duration-500">
    <%= error %>
</div>
<% } %>

<% String success = (String) request.getAttribute("success"); %>
<% if (success != null) { %>
<div class="auto-dismiss mb-4 p-4 rounded-xl bg-green-600 text-white shadow-md transition-opacity duration-500">
    <%= success %>
</div>
<% } %>

<h2 class="text-3xl font-bold mb-6">Bidding History</h2>

    <div class="overflow-hidden rounded-2xl border border-gray-800 bg-[#1a1a1a] shadow-xl">
        <div class="overflow-hidden rounded-2xl border border-gray-800 bg-[#1a1a1a] shadow-xl">
            <div id="bid-history-container">
                Loading bids...
            </div>
        </div>
    </div>

<script>

    setTimeout(() => {
        document.querySelectorAll('.auto-dismiss').forEach(el => {
            el.classList.add('opacity-0');
            setTimeout(() => el.style.display = 'none', 500); // wait for fade transition
        });
    }, 4000);

    let lastShownMessage = '';
    let messageDisplayed = false;

    function checkForBidMessage() {
        fetch('<%= request.getContextPath() %>/latest-bid-message')
            .then(response => response.text())
            .then(message => {
                if (message && message.trim().length > 0 && message !== lastShownMessage) {
                    showMessage(message);
                    lastShownMessage = message;
                    messageDisplayed = true;

                    // Hide message after 5 seconds
                    setTimeout(hideMessage, 5000);
                }
            })
            .catch(error => console.error("Failed to check for messages:", error));
    }

    function showMessage(message) {
        const messageContainer = document.getElementById('message-container');
        messageContainer.innerHTML = `
            <div class="mb-4 p-4 rounded-xl bg-green-800 text-white shadow-md transition-all duration-300"
                 id="notification-message">
                ${message}
            </div>
        `;
    }

    function hideMessage() {
        const messageElement = document.getElementById('notification-message');
        if (messageElement) {
            messageElement.style.opacity = '0';
            setTimeout(() => {
                const container = document.getElementById('message-container');
                if (container) {
                    container.innerHTML = '';
                }
            }, 300);
        }
    }

    function refreshBidTable() {
        fetch('<%= request.getContextPath() %>/bidsHistory')
            .then(response => response.text())
            .then(html => {
                document.getElementById('bid-history-container').innerHTML = html;
            })
            .catch(error => console.error("Failed to refresh bids:", error));
    }
    refreshBidTable();
    setInterval(checkForBidMessage, 2000);
    setInterval(refreshBidTable, 3000); // Refresh every 3 seconds

</script>

</body>
</html>
