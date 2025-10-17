<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 5/29/2025
  Time: 9:16 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
    long currentTimeMillis = System.currentTimeMillis();
    long auctionEndMillis = currentTimeMillis + (1 * 60 * 1000); // 10 minutes from now
%>


<%@ page import="lk.jiat.ee.core.model.User" %>
<%
    lk.jiat.ee.core.model.User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("signup.jsp");
        return;
    }
%>
<html>
<head>
    <title>AutoBid | Premium Auctions</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: #1a1a1a;
            color: #ffffff;
            line-height: 1.6;
        }

        /* Header */
        .header {
            background: rgba(40, 44, 52, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .logo {
            display: flex;
            align-items: center;
        }

        .logo-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            margin-right: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 18px;
        }

        .logo-text {
            font-size: 1.5rem;
            font-weight: 700;
            color: #ffffff;
        }

        .nav-menu {
            display: flex;
            gap: 2rem;
            list-style: none;
        }

        .nav-menu a {
            color: #e5e7eb;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
            padding: 0.5rem 1rem;
            border-radius: 6px;
        }

        .nav-menu a:hover,
        .nav-menu a.active {
            color: #ffffff;
            background: rgba(79, 70, 229, 0.2);
        }

        .search-container {
            position: relative;
            flex: 1;
            max-width: 400px;
            margin: 0 2rem;
        }

        .search-input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 3rem;
            background: rgba(17, 24, 39, 0.6);
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            color: #ffffff;
            font-size: 0.9rem;
            outline: none;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            border-color: #4f46e5;
            background: rgba(17, 24, 39, 0.8);
        }

        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
        }

        .user-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .notification-btn,
        .profile-btn {
            padding: 0.5rem;
            background: rgba(17, 24, 39, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            color: #e5e7eb;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .notification-btn:hover,
        .profile-btn:hover {
            background: rgba(17, 24, 39, 0.8);
            color: #ffffff;
        }

        /* Main Content */
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .welcome-section {
            text-align: center;
            margin-bottom: 3rem;
            padding: 3rem 0;
            background: linear-gradient(135deg, rgba(79, 70, 229, 0.1), rgba(124, 58, 237, 0.1));
            border-radius: 16px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .welcome-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, #ffffff, #e5e7eb);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .welcome-subtitle {
            font-size: 1.2rem;
            color: #9ca3af;
            margin-bottom: 2rem;
        }

        .cta-button {
            display: inline-block;
            padding: 1rem 2rem;
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .cta-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(79, 70, 229, 0.3);
        }

        .cta-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .cta-button:hover::before {
            left: 100%;
        }

        /* Products Section */
        .products-section {
            margin-top: 3rem;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: #ffffff;
        }

        .view-all-btn {
            color: #4f46e5;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .view-all-btn:hover {
            color: #7c3aed;
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .product-card {
            background: rgba(40, 44, 52, 0.8);
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
            position: relative;
        }

        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
            border-color: rgba(79, 70, 229, 0.3);
        }

        .product-image {
            height: 200px;
            background: linear-gradient(135deg, #374151, #4b5563);
            position: relative;
            overflow: hidden;
        }

        .product-image::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(45deg, rgba(79, 70, 229, 0.1), rgba(124, 58, 237, 0.1));
        }

        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-card:hover .product-image img {
            transform: scale(1.05);
        }

        .auction-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .product-content {
            padding: 1.5rem;
        }

        .product-category {
            color: #4f46e5;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .product-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #ffffff;
            margin-bottom: 0.5rem;
        }

        .product-lot {
            color: #9ca3af;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .product-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .current-bid {
            color: #10b981;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .time-left {
            color: #f59e0b;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .bid-button {
            width: 100%;
            padding: 0.75rem;
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .bid-button:hover {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(79, 70, 229, 0.3);
        }

        /* Categories Filter */
        .filter-section {
            margin-bottom: 2rem;
        }

        .filter-tabs {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .filter-tab {
            padding: 0.75rem 1.5rem;
            background: rgba(17, 24, 39, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 25px;
            color: #e5e7eb;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .filter-tab:hover,
        .filter-tab.active {
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            color: white;
            border-color: transparent;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .nav-container {
                flex-direction: column;
                gap: 1rem;
                padding: 1rem;
            }

            .nav-menu {
                gap: 1rem;
            }

            .search-container {
                margin: 0;
                max-width: 100%;
            }

            .main-container {
                padding: 1rem;
            }

            .welcome-title {
                font-size: 2rem;
            }

            .products-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .section-header {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }

            .filter-tabs {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
<!-- Header -->
<header class="header">
    <div class="nav-container">
        <div class="logo">
            <div class="logo-icon">
                <svg viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <g clip-path="url(#clip0_6_330)">
                        <path
                                fill-rule="evenodd"
                                clip-rule="evenodd"
                                d="M24 0.757355L47.2426 24L24 47.2426L0.757355 24L24 0.757355ZM21 35.7574V12.2426L9.24264 24L21 35.7574Z"
                                fill="currentColor"
                        ></path>
                    </g>
                    <defs>
                        <clipPath id="clip0_6_330"><rect width="48" height="48" fill="white"></rect></clipPath>
                    </defs>
                </svg>
            </div>
            <div class="logo-text">AutoBid</div>
        </div>

        <nav>
            <ul class="nav-menu">
                <li><a href="#" class="active">Home</a></li>
                <li><a href="#">Auctions</a></li>
                <li><a href="#">Sell</a></li>
                <li><a href="#">My Garage</a></li>
            </ul>
        </nav>

        <div class="search-container">
            <span class="search-icon"></span>
            <input type="text" class="search-input" placeholder="Search auctions...">
        </div>

        <div class="user-actions">
            <button class="notification-btn">🔔</button>
            <button class="profile-btn">

            </button>
        </div>
    </div>
</header>

<!-- Main Content -->
<main class="main-container">
    <!-- Welcome Section -->
    <section class="welcome-section">
        <h1 class="welcome-title">Welcome, <%= user.getUsername() %></h1>
        <p class="welcome-subtitle">Ready to bid on premium vehicles?</p>
        <a href="#auctions" class="cta-button">Start Bidding</a>
    </section>

    <!-- Filter Section -->
    <section class="filter-section">
        <div class="filter-tabs">
            <button class="filter-tab active">All Categories</button>
            <button class="filter-tab">Sports Cars</button>
            <button class="filter-tab">Classic Cars</button>
            <button class="filter-tab">Luxury Cars</button>
            <button class="filter-tab">Motorcycles</button>
            <button class="filter-tab">Trucks</button>
        </div>
    </section>

    <!-- Featured Auctions -->
    <section class="products-section" id="auctions">
        <div class="section-header">
            <h2 class="section-title">Featured Auctions</h2>
            <a href="#" class="view-all-btn">View All →</a>
        </div>

        <div class="products-grid">
            <!-- Product Card 1 -->
            <div class="product-card">
                <div class="product-image">
                    <img src="https://images.unsplash.com/photo-1686015177135-17b0dd16b0bf?w=500&h=300&fit=crop&crop=center&auto=format" alt="1967 Ford Mustang" loading="lazy">
                    <div class="auction-badge">Live</div>
                </div>
                <div class="product-content">
                    <div class="product-category">Sports Cars</div>
                    <h3 class="product-title">1967 Ford Mustang</h3>
                    <p class="product-lot">Lot #12345 • Ends in 2 days</p>
                    <div class="product-stats">
                        <span class="current-bid">$45,000</span>
                        <span id="countdown" class="time-left">Loading...</span>
                    </div>
                    <button id="placeBidBtn" class="bid-button" onclick="goToLink();">Place Bid</button>
                </div>
            </div>

            <!-- Product Card 2 -->
            <div class="product-card">
                <div class="product-image">
                    <img src="https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=500&h=300&fit=crop&crop=center&auto=format" alt="1969 Chevrolet Camaro" loading="lazy">
                    <div class="auction-badge">Live</div>
                </div>
                <div class="product-content">
                    <div class="product-category">Classic Cars</div>
                    <h3 class="product-title">1969 Chevrolet Camaro</h3>
                    <p class="product-lot">Lot #12346 • Ends in 5 days</p>
                    <div class="product-stats">
                        <span class="current-bid">$38,500</span>
                        <span class="time-left">5d 8h left</span>
                    </div>
                    <button class="bid-button">Place Bid</button>
                </div>
            </div>

            <!-- Product Card 3 -->
            <div class="product-card">
                <div class="product-image">
                    <img src="https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=500&h=300&fit=crop&crop=center&auto=format" alt="Porsche 911" loading="lazy">
                    <div class="auction-badge">Live</div>
                </div>
                <div class="product-content">
                    <div class="product-category">Luxury Cars</div>
                    <h3 class="product-title">2018 Porsche 911</h3>
                    <p class="product-lot">Lot #12347 • Ends in 1 day</p>
                    <div class="product-stats">
                        <span class="current-bid">$89,000</span>
                        <span class="time-left">1d 6h left</span>
                    </div>
                    <button class="bid-button">Place Bid</button>
                </div>
            </div>

            <!-- Product Card 4 -->
            <div class="product-card">
                <div class="product-image">
                    <img src="https://images.unsplash.com/photo-1555215695-3004980ad54e?w=500&h=300&fit=crop&crop=center&auto=format" alt="BMW M3" loading="lazy">
                    <div class="auction-badge">Live</div>
                </div>
                <div class="product-content">
                    <div class="product-category">Sports Cars</div>
                    <h3 class="product-title">2020 BMW M3</h3>
                    <p class="product-lot">Lot #12348 • Ends in 3 days</p>
                    <div class="product-stats">
                        <span class="current-bid">$62,000</span>
                        <span class="time-left">3d 12h left</span>
                    </div>
                    <button class="bid-button">Place Bid</button>
                </div>
            </div>

            <!-- Product Card 5 -->
            <div class="product-card">
                <div class="product-image">
                    <img src="https://images.unsplash.com/photo-1584936874883-7fedea1f7d96?w=500&h=300&fit=crop&crop=center&auto=format" alt="Mercedes AMG" loading="lazy">
                    <div class="auction-badge">Live</div>
                </div>
                <div class="product-content">
                    <div class="product-category">Luxury Cars</div>
                    <h3 class="product-title">Mercedes-AMG GT</h3>
                    <p class="product-lot">Lot #12349 • Ends in 4 days</p>
                    <div class="product-stats">
                        <span class="current-bid">$95,500</span>
                        <span class="time-left">4d 2h left</span>
                    </div>
                    <button class="bid-button">Place Bid</button>
                </div>
            </div>

            <!-- Product Card 6 -->
            <div class="product-card">
                <div class="product-image">
                    <img src="https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=500&h=300&fit=crop&crop=center&auto=format" alt="Audi R8" loading="lazy">
                    <div class="auction-badge">Live</div>
                </div>
                <div class="product-content">
                    <div class="product-category">Sports Cars</div>
                    <h3 class="product-title">2019 Audi R8</h3>
                    <p class="product-lot">Lot #12350 • Ends in 6 days</p>
                    <div class="product-stats">
                        <span class="current-bid">$78,000</span>
                        <span class="time-left">6d 18h left</span>
                    </div>
                    <button class="bid-button">Place Bid</button>
                </div>
            </div>

            <!-- Product Card 7 -->
            <div class="product-card">
                <div class="product-image">
                    <img src="https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=500&h=300&fit=crop&crop=center&auto=format" alt="Lamborghini Huracan" loading="lazy">
                    <div class="auction-badge">Live</div>
                </div>
                <div class="product-content">
                    <div class="product-category">Luxury Cars</div>
                    <h3 class="product-title">2021 Lamborghini Huracan</h3>
                    <p class="product-lot">Lot #12351 • Ends in 7 days</p>
                    <div class="product-stats">
                        <span class="current-bid">$210,000</span>
                        <span class="time-left">7d 5h left</span>
                    </div>
                    <button class="bid-button">Place Bid</button>
                </div>
            </div>

            <!-- Product Card 8 -->
            <div class="product-card">
                <div class="product-image">
                    <img src="https://images.unsplash.com/photo-1493238792000-8113da705763?w=500&h=300&fit=crop&crop=center&auto=format" alt="Ferrari 488" loading="lazy">
                    <div class="auction-badge">Live</div>
                </div>
                <div class="product-content">
                    <div class="product-category">Sports Cars</div>
                    <h3 class="product-title">2019 Ferrari 488 GTB</h3>
                    <p class="product-lot">Lot #12352 • Ends in 3 days</p>
                    <div class="product-stats">
                        <span class="current-bid">$285,000</span>
                        <span class="time-left">3d 22h left</span>
                    </div>
                    <button class="bid-button">Place Bid</button>
                </div>
            </div>

            <!-- Product Card 9 -->
            <div class="product-card">
                <div class="product-image">
                    <img src="https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=500&h=300&fit=crop&crop=center&auto=format" alt="1967 Ford Mustang" loading="lazy">
                    <div class="auction-badge">Live</div>
                </div>
                <div class="product-content">
                    <div class="product-category">Sports Cars</div>
                    <h3 class="product-title">2020 McLaren 720S</h3>
                    <p class="product-lot">Lot #12353 • Ends in 5 days</p>
                    <div class="product-stats">
                        <span class="current-bid">$265,000</span>
                        <span class="time-left">5d 11h left</span>
                    </div>
                    <button class="bid-button">Place Bid</button>
                </div>
            </div>
        </div>
    </section>
</main>

<script>

    // Get auction end time from server
    const auctionEndTime = <%= auctionEndMillis %>;

    const countdownEl = document.getElementById('countdown');
    const placeBidBtn = document.getElementById('placeBidBtn');
    const bidInput = document.getElementById('bidInput');

    let timer;

    function updateCountdown() {
        const now = Date.now();
        let distance = auctionEndTime - now;

        if (distance <= 0) {
            countdownEl.textContent = 'Auction Ended';
            countdownEl.className = 'text-[#1b0e0e] text-sm font-bold leading-normal text-red-600';

            // Disable bidding when auction ends
            placeBidBtn.disabled = true;
            placeBidBtn.className = 'flex min-w-[84px] max-w-[480px] cursor-not-allowed items-center justify-center overflow-hidden rounded-xl h-10 px-4 bg-gray-400 text-[#fcf8f8] text-sm font-bold leading-normal tracking-[0.015em]';
            placeBidBtn.innerHTML = '<span class="truncate">Auction Ended</span>';

            bidInput.disabled = true;
            bidInput.className = 'form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-xl text-gray-400 focus:outline-0 focus:ring-0 border border-[#e7d0d1] bg-gray-100 focus:border-[#e7d0d1] h-14 placeholder:text-[#994d51] p-[15px] text-base font-normal leading-normal cursor-not-allowed';

            clearInterval(timer);
            return;
        }

        const days = Math.floor(distance / 86400000);     // 1000*60*60*24
        distance %= 86400000;
        const hours = Math.floor(distance / 3600000);     // 1000*60*60
        distance %= 3600000;
        const minutes = Math.floor(distance / 60000);     // 1000*60
        const seconds = Math.floor((distance % 60000) / 1000);

        let timeString = '';
        if (days > 0) {
            timeString += days + 'd ';
        }
        if (hours > 0 || days > 0) {
            timeString += hours + 'h ';
        }
        timeString += minutes + 'm ' + seconds + 's';

        countdownEl.textContent = timeString;

        // Change color as time gets closer to end
        if (distance < 300000) { // Less than 5 minutes
            countdownEl.className = 'text-[#1b0e0e] text-sm font-bold leading-normal text-red-600 animate-pulse';
        } else if (distance < 600000) { // Less than 10 minutes
            countdownEl.className = 'text-[#1b0e0e] text-sm font-bold leading-normal text-orange-600';
        } else {
            countdownEl.className = 'text-[#1b0e0e] text-sm font-bold leading-normal text-green-600';
        }
    }

    // Start the countdown
    updateCountdown(); // Initial call
    timer = setInterval(updateCountdown, 1000); // Update every second

    // Add some interactivity to the bid form
    document.querySelector('form').addEventListener('submit', function (e) {
        const now = Date.now();
        if (now >= auctionEndTime) {
            e.preventDefault();
            alert('Auction has ended. You can no longer place bids.');
            return;
        }

        const bidValue = bidInput.value;

        if (!bidValue || parseFloat(bidValue) < minBid) {
            e.preventDefault();
            alert('Please enter a valid bid amount (minimum Rs. ' + minBid.toLocaleString() + ')');
            return;
        }

    });


    //another
    function goToLink() {
        window.location.href = 'index.html';
    }
    // Filter functionality
    document.querySelectorAll('.filter-tab').forEach(tab => {
        tab.addEventListener('click', function() {
            document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
            this.classList.add('active');
        });
    });

    // Smooth scrolling for CTA button
    document.querySelector('.cta-button').addEventListener('click', function(e) {
        e.preventDefault();
        document.querySelector('#auctions').scrollIntoView({
            behavior: 'smooth'
        });
    });
</script>
</body>
</html>