<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.food.Model.Menu, com.food.Model.User"%>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    int cartCount = 0;
    java.util.HashMap<?,?> cartMap = (java.util.HashMap<?,?>) session.getAttribute("cart");
    if (cartMap != null) cartCount = cartMap.size();
    List<Menu> menus = (List<Menu>) request.getAttribute("menuByRestaurantId");
    String restName = (menus != null && !menus.isEmpty()) ? "" : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FoodRush — Menu</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<style>
/* ===== MENU FILTER BAR ===== */
.menu-search-bar {
    background: var(--green);
    border-bottom: 1px solid var(--border);
    padding: 16px 48px;
    display: flex;
    align-items: center;
    gap: 16px;
    margin-top: 52px; /* Push below fixed Apple navbar */
}
.ms-input {
    flex: 1;
    max-width: 440px;
    position: relative;
}
.ms-input input {
    width: 100%;
    height: 36px;
    background: var(--green-light);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: var(--radius-sm);
    padding: 0 12px 0 38px;
    color: white;
    font-size: 13px;
    outline: none;
    transition: var(--transition);
}
.ms-input input:focus {
    border-color: var(--gold);
    box-shadow: 0 0 0 3px rgba(212, 168, 79, 0.15);
}
.ms-input input::placeholder {
    color: var(--muted);
}
.ms-icon {
    position: absolute;
    left: 12px;
    top: 50%;
    transform: translateY(-50%);
    font-size: 14px;
    color: var(--muted);
}
.ms-filter {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
}
.ms-chip {
    padding: 6px 14px;
    border-radius: var(--radius-pill);
    background: transparent;
    border: 1px solid rgba(255, 255, 255, 0.15);
    color: rgba(255, 255, 255, 0.8);
    font-size: 12px;
    font-weight: 500;
    cursor: pointer;
    transition: var(--transition);
}
.ms-chip:hover, .ms-chip.active {
    border-color: var(--gold);
    color: var(--gold);
    background: rgba(212, 168, 79, 0.05);
}

/* ===== LAYOUT ===== */
.layout {
    display: grid;
    grid-template-columns: 240px 1fr;
    gap: 0;
    max-width: 1300px;
    margin: 0 auto;
    min-height: calc(100vh - 120px);
    width: 100%;
}

/* ===== SIDEBAR ===== */
.sidebar {
    border-right: 1px solid var(--border);
    padding: 30px 0;
    position: sticky;
    top: 120px;
    height: calc(100vh - 120px);
    overflow-y: auto;
}
.sidebar-title {
    padding: 0 20px 14px;
    font-size: 10px;
    font-weight: 700;
    color: var(--muted);
    text-transform: uppercase;
    letter-spacing: 0.08em;
}
.sidebar-link {
    display: block;
    padding: 10px 20px;
    font-size: 13px;
    font-weight: 500;
    color: var(--muted);
    cursor: pointer;
    transition: var(--transition);
    border-left: 2px solid transparent;
}
.sidebar-link:hover, .sidebar-link.active {
    color: var(--gold);
    border-left-color: var(--gold);
}

/* ===== MENU CONTENT ===== */
.menu-content {
    padding: 40px 48px;
}
.cat-section {
    margin-bottom: 48px;
}
.cat-section-title {
    font-size: 24px;
    font-weight: 700;
    color: white;
    margin-bottom: 24px;
    display: flex;
    align-items: center;
    gap: 10px;
    padding-bottom: 12px;
    border-bottom: 1px solid var(--border);
    letter-spacing: -0.02em;
}
.cat-count {
    font-size: 11px;
    font-weight: 600;
    color: var(--muted);
    background: rgba(255, 255, 255, 0.05);
    padding: 2px 8px;
    border-radius: 20px;
    border: 1px solid rgba(255, 255, 255, 0.08);
}

/* ===== MENU ITEM ROW ===== */
.menu-item {
    display: flex;
    align-items: flex-start;
    gap: 28px;
    padding: 24px 0;
    border-bottom: 1px solid var(--border);
    transition: var(--transition);
}
.menu-item:last-child {
    border-bottom: none;
}
.menu-item:hover {
    background: rgba(255, 255, 255, 0.02);
    margin: 0 -16px;
    padding: 24px 16px;
    border-radius: var(--radius-lg);
    border-bottom-color: transparent;
}
.item-info {
    flex: 1;
}
.item-name {
    font-size: 18px;
    font-weight: 600;
    color: white;
    margin-bottom: 6px;
    letter-spacing: -0.01em;
}
.menu-item:hover .item-name {
    color: var(--gold);
}
.item-desc {
    font-size: 13px;
    color: var(--muted);
    line-height: 1.5;
    margin-bottom: 12px;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}
.item-price {
    font-size: 16px;
    font-weight: 600;
    color: white;
}
.item-img-wrap {
    position: relative;
    flex-shrink: 0;
}
.item-img {
    width: 130px;
    height: 100px;
    object-fit: cover;
    border-radius: var(--radius-md);
    border: 1px solid var(--border);
    display: block;
}
.item-add-btn {
    position: absolute;
    bottom: -12px;
    left: 50%;
    transform: translateX(-50%);
    background: var(--gold);
    color: var(--dark);
    border: none;
    border-radius: var(--radius-pill);
    padding: 6px 20px;
    font-size: 12px;
    font-weight: 600;
    cursor: pointer;
    transition: var(--transition);
    white-space: nowrap;
    border: 1px solid rgba(255, 255, 255, 0.08);
}
.item-add-btn:hover {
    background: var(--gold-hover);
    transform: translateX(-50%) scale(1.03);
}

/* ===== FLOATING CART ===== */
.floating-cart {
    position: fixed;
    bottom: 28px;
    left: 50%;
    transform: translateX(-50%);
    background: var(--gold);
    color: var(--dark);
    padding: 14px 32px;
    border-radius: var(--radius-pill);
    font-size: 14px;
    font-weight: 600;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
    display: none;
    align-items: center;
    gap: 12px;
    z-index: 9999;
    cursor: pointer;
    transition: var(--transition);
}
.floating-cart.visible {
    display: flex;
}
.floating-cart:hover {
    transform: translateX(-50%) translateY(-2px);
    box-shadow: 0 14px 30px rgba(212, 168, 79, 0.4);
}
.fc-count {
    background: var(--dark);
    color: var(--gold);
    border-radius: 50%;
    width: 24px;
    height: 24px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 11px;
    font-weight: 700;
}

/* ===== NO MENU ===== */
.no-menu {
    grid-column: 1/-1;
    text-align: center;
    padding: 80px 20px;
}

/* ===== RESPONSIVE ===== */
@media (max-width: 900px) {
    .layout {
        grid-template-columns: 1fr;
    }
    .sidebar {
        display: none;
    }
    .menu-content {
        padding: 30px 24px;
    }
    .menu-search-bar {
        padding: 16px 24px;
        flex-direction: column;
        align-items: stretch;
    }
    .ms-input {
        max-width: none;
    }
}
@media (max-width: 600px) {
    .menu-item {
        gap: 16px;
    }
    .item-img {
        width: 100px;
        height: 80px;
    }
    .item-name {
        font-size: 15px;
    }
}
</style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="restaurant" class="nav-logo">Food<span>Rush</span></a>
    <div class="nav-search">
        <span class="search-icon">🔍</span>
        <input type="text" placeholder="Search menu..." id="menuSearch" oninput="searchMenu()">
    </div>
    <div class="nav-actions">
        <a href="cart" class="nav-btn nav-btn-ghost">
            🛒
            <% if (cartCount > 0) { %>
                <span class="cart-badge"><%= cartCount %></span>
            <% } %>
        </a>
        <% if (loggedInUser != null) { %>
            <div class="user-chip">
                <div class="user-avatar"><%= loggedInUser.getName().charAt(0) %></div>
                <%= loggedInUser.getName().split(" ")[0] %>
            </div>
            <a href="logout" class="nav-btn nav-btn-gold" onclick="return confirm('Log out of FoodRush?')">Logout</a>
        <% } else { %>
            <a href="login.jsp" class="nav-btn nav-btn-ghost">Login</a>
            <a href="register.jsp" class="nav-btn nav-btn-gold">Sign Up</a>
        <% } %>
    </div>
</nav>

<!-- MENU FILTER BAR -->
<div class="menu-search-bar">
    <div class="ms-input">
        <span class="ms-icon">🍽️</span>
        <input type="text" placeholder="Search for dishes..." id="menuSearch2" oninput="searchMenu()">
    </div>
    <div class="ms-filter">
        <div class="ms-chip active" onclick="filterMenu('all',this)">All</div>
        <div class="ms-chip" onclick="filterMenu('veg',this)">🟢 Veg</div>
        <div class="ms-chip" onclick="filterMenu('popular',this)">🔥 Popular</div>
        <div class="ms-chip" onclick="filterMenu('new',this)">✨ New</div>
    </div>
</div>

<!-- LAYOUT: Sidebar + Menu Items -->
<div class="layout">

    <!-- SIDEBAR (category anchors) -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-title">Menu Categories</div>
        <%
        if (menus != null && !menus.isEmpty()) {
            java.util.Set<String> seen = new java.util.LinkedHashSet<>();
            for (Menu menu : menus) {
                String cat = menu.getCategory() != null && !menu.getCategory().isEmpty()
                             ? menu.getCategory() : "Featured";
                seen.add(cat);
            }
            for (String cat : seen) {
        %>
        <div class="sidebar-link" onclick="scrollToCategory('<%= cat.replaceAll("\\s+","_") %>')"
             id="link_<%= cat.replaceAll("\\s+","_") %>">
            <%= cat %>
        </div>
        <%
            }
        }
        %>
    </aside>

    <!-- MENU ITEMS -->
    <main class="menu-content" id="menuContent">

        <%
        if (menus == null || menus.isEmpty()) {
        %>
        <div class="no-menu">
            <div style="font-size:64px;margin-bottom:16px;">🍽️</div>
            <h2 style="color:var(--gold);margin-bottom:8px;">Menu Coming Soon</h2>
            <p style="color:var(--muted);">This restaurant hasn't added items yet.</p>
        </div>

        <%
        } else {
            // Group menus by category
            java.util.LinkedHashMap<String, java.util.List<Menu>> grouped = new java.util.LinkedHashMap<>();
            for (Menu menu : menus) {
                String cat = menu.getCategory() != null && !menu.getCategory().isEmpty()
                             ? menu.getCategory() : "Featured";
                grouped.computeIfAbsent(cat, k -> new java.util.ArrayList<>()).add(menu);
            }

            for (java.util.Map.Entry<String, java.util.List<Menu>> entry : grouped.entrySet()) {
                String cat = entry.getKey();
                java.util.List<Menu> items = entry.getValue();
        %>

        <section class="cat-section" id="cat_<%= cat.replaceAll("\\s+","_") %>">
            <div class="cat-section-title">
                <%= cat %>
                <span class="cat-count"><%= items.size() %> items</span>
            </div>

            <%
            for (Menu menu : items) {
            %>
            <div class="menu-item" data-name="<%= menu.getItemName().toLowerCase() %>">

                <div class="item-veg veg" title="Vegetarian"></div>

                <div class="item-info">
                    <div class="item-name"><%= menu.getItemName() %></div>
                    <div class="item-desc"><%= menu.getDescription() %></div>
                    <div class="item-price">₹<%= menu.getPrice() %></div>
                </div>

                <div class="item-img-wrap">
                    <img src="<%= menu.getImagePath() %>"
                         alt="<%= menu.getItemName() %>"
                         class="item-img"
                         onerror="this.src='images/default-food.jpg'">

                    <form action="cart" method="post">
                        <input type="hidden" name="action"       value="add">
                        <input type="hidden" name="menuId"       value="<%= menu.getMenuId() %>">
                        <input type="hidden" name="restaurantId" value="<%= menu.getRestaurantId() %>">
                        <input type="hidden" name="itemName"     value="<%= menu.getItemName() %>">
                        <input type="hidden" name="price"        value="<%= menu.getPrice() %>">
                        <input type="hidden" name="imagePath"    value="<%= menu.getImagePath() %>">
                        <button type="submit" class="item-add-btn">ADD +</button>
                    </form>
                </div>

            </div>
            <%
            }
            %>

        </section>

        <%
            }
        }
        %>

    </main>
</div>

<!-- FLOATING CART -->
<a href="cart" class="floating-cart <%= cartCount > 0 ? "visible" : "" %>" id="floatingCart">
    <span class="fc-count"><%= cartCount %></span>
    <span><%= cartCount %> item<%= cartCount != 1 ? "s" : "" %> in cart</span>
    <span>View Cart →</span>
</a>

<script>
// ── Menu search ────────────────────────────────────────
function searchMenu() {
    const q1  = document.getElementById('menuSearch').value.toLowerCase();
    const q2  = document.getElementById('menuSearch2').value.toLowerCase();
    const q   = q1 || q2;
    document.querySelectorAll('.menu-item').forEach(item => {
        const name = item.dataset.name || '';
        item.style.display = name.includes(q) ? '' : 'none';
    });
}

// ── Category filter chips ──────────────────────────────
function filterMenu(type, chip) {
    document.querySelectorAll('.ms-chip').forEach(c => c.classList.remove('active'));
    chip.classList.add('active');
    // For now shows all — extend with veg/price data-attributes
    document.querySelectorAll('.menu-item').forEach(item => item.style.display = '');
}

// ── Scroll to category section ─────────────────────────
function scrollToCategory(id) {
    const el = document.getElementById('cat_' + id);
    if (el) el.scrollIntoView({behavior:'smooth', block:'start'});
    document.querySelectorAll('.sidebar-link').forEach(l => l.classList.remove('active'));
    const link = document.getElementById('link_' + id);
    if (link) link.classList.add('active');
}

// ── Highlight sidebar on scroll ────────────────────────
const sections = document.querySelectorAll('.cat-section');
const links    = document.querySelectorAll('.sidebar-link');

const obs = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            const id = entry.target.id.replace('cat_','');
            links.forEach(l => l.classList.remove('active'));
            const link = document.getElementById('link_' + id);
            if (link) link.classList.add('active');
        }
    });
}, {threshold:0.4});

sections.forEach(s => obs.observe(s));
</script>
</body>
</html>