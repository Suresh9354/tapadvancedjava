<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.food.Model.CartItem, com.food.Model.User"%>

<%
    @SuppressWarnings("unchecked")
    HashMap<Integer, CartItem> cart =
            (HashMap<Integer, CartItem>) request.getAttribute("cart");

    double grandTotal = (double) request.getAttribute("grandTotal");
    String userAddress = (String) request.getAttribute("userAddress");
    if (userAddress == null) userAddress = "";

    User loggedInUser = (User) session.getAttribute("loggedInUser");

    String error = (String) request.getAttribute("error");

    int currentRestaurantId = 0;
    if (cart != null && !cart.isEmpty()) {
        CartItem firstItem = cart.values().iterator().next();
        currentRestaurantId = firstItem.getRestaurantId();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FoodRush - Checkout</title>

<link rel="stylesheet" href="css/style.css">
<style>
/* ===== CHECKOUT LAYOUT ===== */
.checkout-wrapper {
    width: 92%;
    max-width: 1100px;
    margin: 40px auto 60px;
    display: grid;
    grid-template-columns: 1fr 400px;
    gap: 30px;
}

/* ===== CARD COMPONENT ===== */
.section-card {
    background: var(--green);
    border-radius: var(--radius-lg);
    padding: 28px;
    border: 1px solid var(--border);
    transition: var(--transition);
}
.section-card:hover {
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.4), var(--green-glow);
}

.section-title {
    font-size: 20px;
    font-weight: 800;
    color: var(--gold);
    margin-bottom: 22px;
    display: flex;
    align-items: center;
    gap: 10px;
    border-bottom: 1px solid var(--border);
    padding-bottom: 14px;
}

/* ===== ORDER SUMMARY ===== */
.order-item-row {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 14px 0;
    border-bottom: 1px solid var(--border);
}
.order-item-row:last-child {
    border-bottom: none;
}
.order-item-row img {
    width: 60px;
    height: 60px;
    border-radius: var(--radius-md);
    object-fit: cover;
    border: 1px solid var(--border);
    flex-shrink: 0;
}
.item-details {
    flex: 1;
}
.item-details h4 {
    color: white;
    font-size: 15px;
    font-weight: 700;
    margin-bottom: 4px;
}
.item-details span {
    color: var(--muted);
    font-size: 13px;
}
.item-subtotal {
    font-weight: 800;
    color: var(--gold);
    font-size: 16px;
}

.total-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 20px;
    padding-top: 16px;
    border-top: 1.5px solid var(--border);
}
.total-row .label {
    font-size: 17px;
    font-weight: 700;
    color: var(--light);
}
.total-row .value {
    font-size: 24px;
    font-weight: 800;
    color: var(--gold);
}

/* ===== PAYMENT METHOD STYLING ===== */
.payment-options {
    display: flex;
    flex-direction: column;
    gap: 14px;
}
.payment-option {
    position: relative;
}
.payment-option input[type="radio"] {
    position: absolute;
    opacity: 0;
    width: 0;
    height: 0;
}
.payment-option label {
    display: flex;
    align-items: center;
    gap: 16px;
    background: var(--green-light);
    border: 2px solid var(--border);
    border-radius: var(--radius-md);
    padding: 16px 20px;
    cursor: pointer;
    transition: var(--transition);
    width: 100%;
}
.payment-option input[type="radio"]:checked + label {
    border-color: var(--gold);
    background: rgba(212, 168, 79, 0.1);
    box-shadow: var(--gold-glow);
}
.payment-option label:hover {
    border-color: rgba(212, 168, 79, 0.4);
}
.payment-icon {
    font-size: 28px;
    line-height: 1;
}
.payment-text strong {
    display: block;
    font-size: 15px;
    font-weight: 700;
    color: white;
    margin-bottom: 2px;
}
.payment-text small {
    color: var(--muted);
    font-size: 12px;
}

/* ===== DUMMY CARD DETAILS PANEL ===== */
.card-fields {
    max-height: 0;
    overflow: hidden;
    opacity: 0;
    transition: max-height 0.4s cubic-bezier(0, 1, 0, 1), opacity 0.3s ease;
    margin-top: 0;
    padding: 0;
    background: var(--green-light);
    border-radius: var(--radius-md);
    border: 1px solid var(--border);
}
.card-fields.visible {
    max-height: 500px;
    opacity: 1;
    margin-top: 16px;
    padding: 20px;
    transition: max-height 0.4s cubic-bezier(1, 0, 1, 0), opacity 0.3s ease;
}
.card-fields .form-group {
    margin-bottom: 14px;
}
.card-fields input {
    background: #0f2219;
}
.card-row {
    display: flex;
    gap: 12px;
}
.card-row .form-group {
    flex: 1;
}

/* ===== ERROR PANEL ===== */
.error-box {
    background: rgba(231,76,60,0.15);
    border: 1px solid #e74c3c;
    border-radius: var(--radius-md);
    padding: 12px 16px;
    margin-bottom: 20px;
    color: #ff6b6b;
    font-size: 14px;
    font-weight: 600;
}

/* ===== PLACE ORDER BUTTON ===== */
.place-order-btn {
    width: 100%;
    margin-top: 18px;
}

.secure-badge {
    text-align: center;
    margin-top: 16px;
    color: var(--muted);
    font-size: 12px;
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 6px;
}

/* ===== RESPONSIVE ===== */
@media (max-width: 900px) {
    .checkout-wrapper {
        grid-template-columns: 1fr;
    }
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
        <div class="progress-step active">
            <div class="progress-step-circle">2</div>
            <span class="progress-step-label">Checkout</span>
        </div>
        <div class="progress-step-line"></div>
        <div class="progress-step">
            <div class="progress-step-circle">3</div>
            <span class="progress-step-label">Confirmed</span>
        </div>
    </div>

    <!-- MAIN CHECKOUT LAYOUT -->
    <form action="checkout" method="post">
    <div class="checkout-wrapper">

        <!-- LEFT: Delivery + Payment -->
        <div>
            <!-- Delivery Address -->
            <div class="section-card" style="margin-bottom:24px;">
                <div class="section-title">📍 Delivery Address</div>

                <div class="form-group">
                    <label>Full Delivery Address</label>
                    <textarea name="deliveryAddress" required class="form-input"
                        placeholder="Enter your full delivery address..."><%= userAddress %></textarea>
                </div>
            </div>

            <!-- Payment Method -->
            <div class="section-card">
                <div class="section-title">💳 Payment Method</div>

                <% if (error != null) { %>
                    <div class="error-box">⚠ <%= error %></div>
                <% } %>

                <div class="payment-options">
                    <!-- Cash on Delivery -->
                    <div class="payment-option">
                        <input type="radio" id="cod" name="paymentMethod" value="COD" checked>
                        <label for="cod">
                            <span class="payment-icon">💵</span>
                            <div class="payment-text">
                                <strong>Cash on Delivery</strong>
                                <small>Pay in cash when your order arrives</small>
                            </div>
                        </label>
                    </div>

                    <!-- Card on Delivery (Dummy) -->
                    <div class="payment-option">
                        <input type="radio" id="card" name="paymentMethod" value="CARD">
                        <label for="card">
                            <span class="payment-icon">💳</span>
                            <div class="payment-text">
                                <strong>Pay by Card</strong>
                                <small>Visa / MasterCard / RuPay (Demo only)</small>
                            </div>
                        </label>
                    </div>

                    <!-- Dummy Card Fields -->
                    <div class="card-fields" id="cardFields">
                        <div class="form-group">
                            <label>Card Number</label>
                            <input type="text" class="form-input" placeholder="1234  5678  9012  3456"
                                   maxlength="19" oninput="formatCard(this)">
                        </div>
                        <div class="card-row">
                            <div class="form-group">
                                <label>Expiry Date</label>
                                <input type="text" class="form-input" placeholder="MM / YY" maxlength="7">
                            </div>
                            <div class="form-group">
                                <label>CVV</label>
                                <input type="password" class="form-input" placeholder="•••" maxlength="3">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Name on Card</label>
                            <input type="text" class="form-input" placeholder="e.g. Suresh Kumar">
                        </div>
                    </div>

                    <!-- UPI (Dummy) -->
                    <div class="payment-option">
                        <input type="radio" id="upi" name="paymentMethod" value="UPI">
                        <label for="upi">
                            <span class="payment-icon">📱</span>
                            <div class="payment-text">
                                <strong>UPI Payment</strong>
                                <small>Google Pay / PhonePe / BHIM (Demo only)</small>
                            </div>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <!-- RIGHT: Order Summary -->
        <div>
            <div class="section-card" style="position: sticky; top: 92px;">
                <div class="section-title">🧾 Order Summary</div>

                <% for (CartItem item : cart.values()) { %>
                    <div class="order-item-row">
                        <img src="<%= item.getImagePath() %>" alt="<%= item.getItemName() %>" onerror="this.src='images/default-food.jpg'">
                        <div class="item-details">
                            <h4><%= item.getItemName() %></h4>
                            <span>₹<%= item.getPrice() %> × <%= item.getQuantity() %></span>
                        </div>
                        <div class="item-subtotal">₹<%= String.format("%.2f", item.getSubTotal()) %></div>
                    </div>
                <% } %>

                <div class="total-row">
                    <span class="label">Grand Total</span>
                    <span class="value">₹<%= String.format("%.2f", grandTotal) %></span>
                </div>

                <button type="submit" class="btn btn-primary place-order-btn">
                    🎉 Place Order
                </button>
                <a href="menu?RestaurantID=<%= currentRestaurantId %>" class="btn btn-outline place-order-btn" style="margin-top: 12px; display: inline-flex; width: 100%;">← Add More Items</a>

                <div class="secure-badge">
                    🔒 Secure Checkout &nbsp;|&nbsp; FoodRush © 2026
                </div>
            </div>
        </div>

    </div>
    </form>
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
// Toggle dummy card fields when Card radio is selected
function toggleCardFields(radioValue) {
    const cardFields = document.getElementById('cardFields');
    if (radioValue === 'CARD') {
        cardFields.classList.add('visible');
    } else {
        cardFields.classList.remove('visible');
    }
}

// Format card number with spaces
function formatCard(input) {
    let val = input.value.replace(/\D/g, '').substring(0, 16);
    let formatted = val.match(/.{1,4}/g);
    input.value = formatted ? formatted.join('  ') : val;
}

// Wire up all payment radios to toggle card fields
document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('input[name="paymentMethod"]').forEach(function(radio) {
        radio.addEventListener('change', function () {
            toggleCardFields(this.value);
        });
    });
});

window.addEventListener('scroll', () => {
    const navbar = document.getElementById('navbar');
    if (navbar) {
        navbar.classList.toggle('scrolled', scrollY > 40);
    }
});
</script>
</body>
</html>
