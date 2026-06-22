<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.food.Model.CartItem, com.food.Model.User"%>

<%
    // Cart is forwarded as a request attribute by CartServlet (for GET /cart with no action)
    @SuppressWarnings("unchecked")
    HashMap<Integer, CartItem> cart =
            (HashMap<Integer, CartItem>) request.getAttribute("cart");

    // Fallback: if somehow accessed directly, try session
    if (cart == null) {
        cart = (HashMap<Integer, CartItem>) session.getAttribute("cart");
    }

    double grandTotal = 0;
    if (cart != null) {
        for (CartItem item : cart.values()) {
            grandTotal += item.getSubTotal();
        }
    }
    
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    int cartCount = 0;
    if (cart != null) cartCount = cart.size();

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
<title>FoodRush - Your Cart</title>

<link rel="stylesheet" href="css/style.css">
<style>
/* ===== CART LAYOUT ===== */
.cart-wrapper {
    width: 92%;
    max-width: 1100px;
    margin: 40px auto 60px;
    display: grid;
    grid-template-columns: 1fr 380px;
    gap: 32px;
}

.cart-items-section {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

/* ===== CART ITEM CARD ===== */
.cart-card {
    background: var(--green);
    border-radius: var(--radius-lg);
    display: flex;
    align-items: center;
    gap: 20px;
    padding: 24px;
    border: 1px solid rgba(255, 255, 255, 0.04);
    transition: var(--transition);
}

.cart-card:hover {
    border-color: rgba(255, 255, 255, 0.08);
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
}

.cart-card img {
    width: 80px;
    height: 80px;
    object-fit: cover;
    border-radius: var(--radius-md);
    border: 1px solid var(--border);
    flex-shrink: 0;
}

.item-info {
    flex: 1;
}

.item-info h3 {
    font-size: 17px;
    font-weight: 600;
    color: white;
    margin-bottom: 4px;
}

.item-price {
    color: var(--gold);
    font-size: 14px;
    font-weight: 500;
}

/* Quantity Adjuster (Thin circle rings) */
.qty-controls {
    display: flex;
    align-items: center;
    gap: 12px;
    background: var(--green-light);
    padding: 4px 12px;
    border-radius: var(--radius-pill);
    border: 1px solid rgba(255, 255, 255, 0.08);
}

.qty-btn {
    background: transparent;
    border: none;
    color: rgba(255, 255, 255, 0.8);
    width: 20px;
    height: 20px;
    font-size: 16px;
    font-weight: 400;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: var(--transition);
}

.qty-btn:hover {
    color: var(--gold);
}

.qty-display {
    font-size: 14px;
    font-weight: 600;
    color: white;
    min-width: 18px;
    text-align: center;
}

.subtotal {
    font-size: 16px;
    font-weight: 600;
    color: white;
    min-width: 80px;
    text-align: right;
}

.remove-btn {
    background: transparent;
    border: 1px solid rgba(255, 59, 48, 0.5);
    color: #ff3b30;
    padding: 6px 14px;
    border-radius: var(--radius-pill);
    cursor: pointer;
    font-size: 12px;
    font-weight: 500;
    transition: var(--transition);
}

.remove-btn:hover {
    background: #ff3b30;
    color: white;
}

/* ===== BILLING SUMMARY CARD ===== */
.summary-card {
    background: var(--green);
    border-radius: var(--radius-lg);
    padding: 32px;
    border: 1px solid rgba(255, 255, 255, 0.05);
    position: sticky;
    top: 92px; /* Sticky below navbar */
    height: fit-content;
}

.summary-title {
    font-size: 20px;
    font-weight: 700;
    color: white;
    border-bottom: 1px solid var(--border);
    padding-bottom: 16px;
    margin-bottom: 24px;
    letter-spacing: -0.015em;
}

.billing-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
    font-size: 13px;
    color: var(--muted);
}

.billing-row.total-row {
    margin-top: 24px;
    padding-top: 20px;
    border-top: 1px solid var(--border);
    color: white;
}

.billing-row.total-row span {
    font-size: 16px;
    font-weight: 600;
}

.billing-row.total-row strong {
    font-size: 22px;
    color: var(--gold);
    font-weight: 700;
}

.checkout-btn {
    width: 100%;
    margin-top: 20px;
}

/* ===== EMPTY CART ===== */
.empty-cart {
    text-align: center;
    padding: 80px 20px;
    grid-column: 1/-1;
    background: var(--green);
    border-radius: var(--radius-lg);
    border: 1px solid rgba(255, 255, 255, 0.04);
}

.empty-cart h2 {
    font-size: 26px;
    color: white;
    margin-bottom: 12px;
    font-weight: 600;
}

.empty-cart p {
    color: var(--muted);
    margin-bottom: 24px;
    font-size: 14px;
}

.empty-cart .btn-primary {
    max-width: 220px;
}

/* ===== RESPONSIVE ===== */
@media (max-width: 900px) {
    .cart-wrapper {
        grid-template-columns: 1fr;
        gap: 24px;
    }
    .summary-card {
        position: static;
    }
}

@media (max-width: 600px) {
    .cart-card {
        flex-direction: column;
        align-items: stretch;
        gap: 16px;
    }
    .cart-card img {
        width: 100%;
        height: 120px;
    }
    .subtotal {
        text-align: left;
        min-width: 0;
    }
    .cart-card form {
        width: 100%;
    }
    .remove-btn {
        width: 100%;
        text-align: center;
    }
}
</style>
</head>
<!-- ===== NAVBAR ===== -->
<nav class="navbar" id="navbar">
    <a href="restaurant" class="nav-logo">Food<span>Rush</span></a>
    
    <div class="nav-actions">
        <a href="cart" class="nav-btn nav-btn-ghost">
            🛒
            <% if (cartCount > 0) { %>
                <span class="cart-badge"><%= cartCount %></span>
            <% } else { %>
                Cart
            <% } %>
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
        <div class="progress-step active">
            <div class="progress-step-circle">1</div>
            <span class="progress-step-label">Cart</span>
        </div>
        <div class="progress-step-line"></div>
        <div class="progress-step">
            <div class="progress-step-circle">2</div>
            <span class="progress-step-label">Checkout</span>
        </div>
        <div class="progress-step-line"></div>
        <div class="progress-step">
            <div class="progress-step-circle">3</div>
            <span class="progress-step-label">Confirmed</span>
        </div>
    </div>

    <!-- ===== CART LAYOUT ===== -->
    <div class="cart-wrapper">
        <% 
            String cartAlert = (String) session.getAttribute("cartAlert");
            if (cartAlert != null) {
                session.removeAttribute("cartAlert");
        %>
            <div class="alert-banner" style="background: rgba(212, 168, 79, 0.15); border: 1px solid var(--gold); color: var(--gold); padding: 12px 20px; border-radius: var(--radius-md); margin-bottom: 8px; font-size: 14px; grid-column: 1/-1; display: flex; align-items: center; gap: 8px;">
                ⚠️ <span><%= cartAlert %></span>
            </div>
        <% } %>

        <% if (cart != null && !cart.isEmpty()) { %>
            <!-- Left Column: Items List -->
            <div class="cart-items-section">
                <% for (CartItem item : cart.values()) { %>
                    <div class="cart-card">
                        <img src="<%= item.getImagePath() %>" alt="<%= item.getItemName() %>" onerror="this.src='images/default-food.jpg'">
                        
                        <div class="item-info">
                            <h3><%= item.getItemName() %></h3>
                            <div class="item-price">₹<%= item.getPrice() %></div>
                        </div>

                        <!-- Quantity Adjuster controls -->
                        <div class="qty-controls">
                            <form action="cart" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="decrease">
                                <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                <button type="submit" class="qty-btn">−</button>
                            </form>
                            <span class="qty-display"><%= item.getQuantity() %></span>
                            <form action="cart" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="increase">
                                <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                <button type="submit" class="qty-btn">+</button>
                            </form>
                        </div>

                        <div class="subtotal">₹<%= String.format("%.2f", item.getSubTotal()) %></div>

                        <form action="cart" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                            <button type="submit" class="remove-btn">🗑 Remove</button>
                        </form>
                    </div>
                <% } %>
            </div>

            <!-- Right Column: Billing Summary -->
            <div class="summary-card">
                <div class="summary-title">Bill Details</div>
                
                <div class="billing-row">
                    <span>Item Total</span>
                    <span>₹<%= String.format("%.2f", grandTotal) %></span>
                </div>
                
                <div class="billing-row">
                    <span>Delivery Partner Fee</span>
                    <span>₹40.00</span>
                </div>
                
                <div class="billing-row">
                    <span>Taxes and Restaurant Charges</span>
                    <span>₹25.00</span>
                </div>
                
                <div class="billing-row total-row">
                    <span>To Pay</span>
                    <strong>₹<%= String.format("%.2f", grandTotal + 65) %></strong>
                </div>

                <a href="checkout" class="btn btn-primary checkout-btn">Proceed to Checkout →</a>
                <a href="menu?RestaurantID=<%= currentRestaurantId %>" class="btn btn-outline checkout-btn" style="margin-top: 12px;">← Add More Items</a>
            </div>
        <% } else { %>
            <!-- Empty Cart State -->
            <div class="empty-cart">
                <div style="font-size:64px; margin-bottom:16px;">😕</div>
                <h2>Your cart is empty</h2>
                <p>You can go to the home page to view more restaurants.</p>
                <a href="restaurant" class="btn btn-primary">Browse Restaurants</a>
            </div>
        <% } %>
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
</html>