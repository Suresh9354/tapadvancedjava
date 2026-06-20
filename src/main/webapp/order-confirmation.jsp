<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.food.Model.Order, com.food.Model.OrderItem, com.food.Model.User"%>

<%
    Order order = (Order) request.getAttribute("order");
    User loggedInUser = (User) session.getAttribute("loggedInUser");

    // Estimated delivery: 30-45 mins from now (dummy)
    String estimatedTime = "30 - 45 minutes";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FoodRush - Order Confirmed!</title>

<link rel="stylesheet" href="css/style.css">
<style>
/* ===== SUCCESS BANNER ===== */
.success-banner {
    text-align: center;
    padding: 50px 20px 30px;
    animation: fadeIn 0.6s ease;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(-20px); }
    to   { opacity: 1; transform: translateY(0); }
}

.checkmark-circle {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--gold), var(--gold-hover));
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 24px;
    font-size: 48px;
    box-shadow: var(--gold-glow);
    animation: pop 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    color: var(--dark);
}

@keyframes pop {
    0%   { transform: scale(0.5); opacity: 0; }
    80%  { transform: scale(1.1); }
    100% { transform: scale(1);   opacity: 1; }
}

.success-banner h1 {
    font-size: 38px;
    color: var(--gold);
    margin-bottom: 12px;
    font-weight: 800;
}

.success-banner p {
    font-size: 17px;
    color: rgba(255, 255, 255, 0.85);
    max-width: 500px;
    margin: 0 auto;
    line-height: 1.7;
}

/* ===== INFO GRID & CHIPS ===== */
.info-grid {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 20px;
    padding: 30px 40px;
    max-width: 900px;
    margin: 0 auto;
}

.info-chip {
    background: var(--green);
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    padding: 18px 24px;
    text-align: center;
    min-width: 160px;
    transition: var(--transition);
}

.info-chip:hover {
    border-color: rgba(212, 168, 79, 0.35);
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.4), var(--green-glow);
}

.info-chip .chip-icon {
    font-size: 28px;
    margin-bottom: 8px;
}

.info-chip .chip-label {
    font-size: 11px;
    color: var(--muted);
    margin-bottom: 4px;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.info-chip .chip-value {
    font-size: 16px;
    font-weight: 800;
    color: white;
}

.info-chip .chip-value.gold {
    color: var(--gold);
}

/* ===== DELIVERY TRACKER ===== */
.tracker {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 0;
    padding: 20px 40px 50px;
    flex-wrap: wrap;
    max-width: 700px;
    margin: 0 auto;
}

.tracker-step {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10px;
    flex: 1;
    min-width: 100px;
}

.tracker-icon {
    width: 52px;
    height: 52px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    background: var(--green);
    border: 2px solid rgba(255, 255, 255, 0.15);
    color: var(--muted);
    transition: var(--transition);
}

.tracker-step.active .tracker-icon {
    background: rgba(212, 168, 79, 0.15);
    border-color: var(--gold);
    color: var(--gold);
    animation: pulse 1.8s infinite;
}

@keyframes pulse {
    0%, 100% { box-shadow: 0 0 0 0 rgba(212, 168, 79, 0.4); }
    50%       { box-shadow: 0 0 0 10px rgba(212, 168, 79, 0); }
}

.tracker-step.done .tracker-icon {
    background: var(--gold);
    border-color: var(--gold);
    color: var(--dark);
}

.tracker-label {
    font-size: 12px;
    color: var(--muted);
    text-align: center;
    font-weight: 600;
}

.tracker-step.active .tracker-label,
.tracker-step.done .tracker-label {
    color: var(--gold);
}

.tracker-line {
    height: 2px;
    width: 60px;
    background: rgba(255, 255, 255, 0.08);
    margin-bottom: 24px;
}

.tracker-line.done {
    background: var(--gold);
}

/* ===== ITEMS TABLE ===== */
.order-details {
    width: 90%;
    max-width: 750px;
    margin: 20px auto 60px;
    background: var(--green);
    padding: 30px;
    border-radius: var(--radius-lg);
    border: 1px solid var(--border);
}

.order-details h2 {
    color: var(--gold);
    font-size: 20px;
    margin-bottom: 20px;
    border-bottom: 1px solid var(--border);
    padding-bottom: 12px;
    display: flex;
    align-items: center;
    gap: 10px;
    font-weight: 800;
}

.items-table {
    width: 100%;
    border-collapse: collapse;
}

.items-table thead tr {
    background: var(--green-light);
}

.items-table th {
    padding: 14px 16px;
    text-align: left;
    color: var(--gold);
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 1px;
    font-weight: 700;
}

.items-table tbody tr {
    border-bottom: 1px solid var(--border);
    transition: var(--transition);
}

.items-table tbody tr:hover {
    background: rgba(27, 58, 45, 0.35);
}

.items-table td {
    padding: 14px 16px;
    color: #e0e0e0;
    font-size: 15px;
}

.items-table .item-total {
    color: var(--gold);
    font-weight: 800;
}

/* Grand total row */
.grand-row td {
    padding: 18px 16px;
    border-top: 2px solid rgba(212, 168, 79, 0.25);
}

.grand-row .label-cell {
    color: var(--light);
    font-size: 18px;
    font-weight: 800;
    text-align: right;
}

.grand-row .total-cell {
    color: var(--gold);
    font-size: 22px;
    font-weight: 800;
}

/* ===== ACTION BUTTONS ===== */
.action-buttons {
    display: flex;
    justify-content: center;
    gap: 20px;
    flex-wrap: wrap;
    padding-bottom: 60px;
}

.action-buttons .btn {
    min-width: 220px;
}
</style>
</head>
<!-- ===== NAVBAR ===== -->
<nav class="navbar" id="navbar">
    <a href="restaurant" class="nav-logo">Food<span>Rush</span></a>
    
    <div class="nav-actions">
        <a href="cart" class="nav-btn nav-btn-ghost">
            🛒 Cart
        </a>

        <% if (loggedInUser != null) { %>
            <div class="user-chip">
                <div class="user-avatar"><%= loggedInUser.getName().charAt(0) %></div>
                <%= loggedInUser.getName().split(" ")[0] %>
            </div>
            <a href="logout" class="nav-btn nav-btn-gold"
               onclick="return confirm('Log out of FoodRush?')">
                Logout
            </a>
        <% } else { %>
            <a href="login.jsp" class="nav-btn nav-btn-ghost">Login</a>
            <a href="register.jsp" class="nav-btn nav-btn-gold">Sign Up</a>
        <% } %>
    </div>
</nav>

<div class="main-content">
    <!-- ===== PROGRESS BAR ===== -->
    <div class="progress-steps">
        <div class="progress-step done">
            <div class="progress-step-circle">✓</div>
            <span class="progress-step-label">Cart</span>
        </div>
        <div class="progress-step-line done"></div>
        <div class="progress-step done">
            <div class="progress-step-circle">✓</div>
            <span class="progress-step-label">Checkout</span>
        </div>
        <div class="progress-step-line done"></div>
        <div class="progress-step done">
            <div class="progress-step-circle">✓</div>
            <span class="progress-step-label">Confirmed</span>
        </div>
    </div>

    <!-- SUCCESS BANNER -->
    <div class="success-banner">
        <div class="checkmark-circle">✓</div>
        <h1>Order Placed! 🎉</h1>
        <p>
            Thank you, <strong><%= loggedInUser != null ? loggedInUser.getName() : "Customer" %></strong>!
            <br>Your order has been received and is being prepared.
        </p>
    </div>

    <!-- ORDER INFO CHIPS -->
    <div class="info-grid">
        <div class="info-chip">
            <div class="chip-icon">🧾</div>
            <div class="chip-label">Order ID</div>
            <div class="chip-value gold">#<%= order.getOrderId() %></div>
        </div>

        <div class="info-chip">
            <div class="chip-icon">💳</div>
            <div class="chip-label">Payment</div>
            <div class="chip-value">
                <%= order.getPaymentMethod().equals("COD")  ? "Cash on Delivery" :
                    order.getPaymentMethod().equals("CARD") ? "Card Payment"     :
                    order.getPaymentMethod().equals("UPI")  ? "UPI Payment"      :
                    order.getPaymentMethod() %>
            </div>
        </div>

        <div class="info-chip">
            <div class="chip-icon">⏱</div>
            <div class="chip-label">Est. Delivery</div>
            <div class="chip-value"><%= estimatedTime %></div>
        </div>

        <div class="info-chip">
            <div class="chip-icon">📋</div>
            <div class="chip-label">Status</div>
            <div class="chip-value gold"><%= order.getStatus() %></div>
        </div>

        <div class="info-chip">
            <div class="chip-icon">💰</div>
            <div class="chip-label">Total Paid</div>
            <div class="chip-value gold">₹<%= String.format("%.2f", order.getTotalAmount()) %></div>
        </div>
    </div>

    <!-- DELIVERY TRACKER -->
    <div class="tracker">
        <div class="tracker-step done">
            <div class="tracker-icon">✓</div>
            <div class="tracker-label">Order<br>Placed</div>
        </div>
        <div class="tracker-line done"></div>
        <div class="tracker-step active">
            <div class="tracker-icon">👨‍🍳</div>
            <div class="tracker-label">Being<br>Prepared</div>
        </div>
        <div class="tracker-line"></div>
        <div class="tracker-step">
            <div class="tracker-icon">🛵</div>
            <div class="tracker-label">Out for<br>Delivery</div>
        </div>
        <div class="tracker-line"></div>
        <div class="tracker-step">
            <div class="tracker-icon">🏠</div>
            <div class="tracker-label">Delivered</div>
        </div>
    </div>

    <!-- ORDER ITEMS TABLE -->
    <div class="order-details">
        <h2>🧾 Items in This Order</h2>

        <% if (order.getItems() != null && !order.getItems().isEmpty()) { %>
        <table class="items-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Menu ID</th>
                    <th>Qty</th>
                    <th>Item Total</th>
                </tr>
            </thead>
            <tbody>
                <%
                int sno = 1;
                for (OrderItem item : order.getItems()) {
                %>
                <tr>
                    <td><%= sno++ %></td>
                    <td>Menu #<%= item.getMenuId() %></td>
                    <td><%= item.getQuantity() %></td>
                    <td class="item-total">₹<%= String.format("%.2f", item.getItemTotal()) %></td>
                </tr>
                <% } %>
            </tbody>
            <tfoot>
                <tr class="grand-row">
                    <td colspan="3" class="label-cell">Grand Total</td>
                    <td class="total-cell">₹<%= String.format("%.2f", order.getTotalAmount()) %></td>
                </tr>
            </tfoot>
        </table>
        <% } else { %>
        <p style="color:#888;">No items found for this order.</p>
        <% } %>
    </div>

    <!-- ACTION BUTTONS -->
    <div class="action-buttons">
        <a href="restaurant" class="btn btn-primary">🏠 Back to Restaurants</a>
        <a href="cart" class="btn btn-outline">🛒 View Cart</a>
    </div>
</div>

<!-- ===== FOOTER ===== -->
<footer>
    <div class="footer-logo">FoodRush 🍕</div>
    <div class="footer-copy">© 2026 FoodRush · Delivering Happiness</div>
    <div class="footer-links">
        <a href="#">About</a>
        <a href="#">Help</a>
        <a href="#">Privacy</a>
    </div>
</footer>

<script>
window.addEventListener('scroll', () => {
    const navbar = document.getElementById('navbar');
    if (navbar) {
        navbar.classList.toggle('scrolled', scrollY > 40);
    }
});
</script>
</body>
</html>
