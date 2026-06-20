<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.food.Model.Restaurant, com.food.Model.User"%>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    int cartCount = 0;
    java.util.HashMap<?,?> cartMap = (java.util.HashMap<?,?>) session.getAttribute("cart");
    if (cartMap != null) cartCount = cartMap.size();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FoodRush — Delivering Taste & Luxury</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<style>
/* ===== CORE PREMIUM LAYOUT & UTILITIES ===== */
body {
    background-color: var(--dark); /* #07150F */
    color: var(--text); /* #CCCCCC */
    overflow-x: hidden;
}

/* Custom Scrollbar for premium feel */
::-webkit-scrollbar {
    width: 10px;
}
::-webkit-scrollbar-track {
    background: var(--dark);
}
::-webkit-scrollbar-thumb {
    background: var(--green-light);
    border: 2px solid var(--dark);
    border-radius: 10px;
}
::-webkit-scrollbar-thumb:hover {
    background: var(--gold);
}

/* Liquid Glass effect utility */
.liquid-glass {
    background: rgba(16, 40, 29, 0.75);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border: 1px solid rgba(212, 168, 79, 0.2);
    box-shadow: 
        0 8px 32px rgba(0, 0, 0, 0.35),
        inset 0 1px 1px rgba(212, 168, 79, 0.08);
}

/* Scroll reveal animations styling */
.reveal-element {
    opacity: 0;
    transform: translateY(35px);
    transition: opacity 1s cubic-bezier(0.16, 1, 0.3, 1), transform 1s cubic-bezier(0.16, 1, 0.3, 1);
}

.reveal-visible {
    opacity: 1;
    transform: translateY(0);
}

/* ===== LIQUID FLOATING NAVBAR ===== */
.navbar-floating-container {
    position: fixed;
    top: 24px;
    left: 50%;
    transform: translateX(-50%);
    width: 90%;
    max-width: 1200px;
    z-index: 10000;
    transition: all 0.5s cubic-bezier(0.16, 1, 0.3, 1);
}

.navbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 32px;
    height: 70px;
    border-radius: 20px;
    background: rgba(16, 40, 29, 0.75);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border: 1px solid rgba(212, 168, 79, 0.2);
    box-shadow: 
        0 8px 32px rgba(0, 0, 0, 0.35),
        inset 0 1px 1px rgba(212, 168, 79, 0.08);
    transition: all 0.5s cubic-bezier(0.16, 1, 0.3, 1);
}

.navbar-floating-container.scrolled {
    top: 10px;
    width: 95%;
}

.navbar-floating-container.scrolled .navbar {
    background: rgba(7, 21, 15, 0.85);
    height: 60px;
    border-radius: 16px;
    border-color: rgba(212, 168, 79, 0.3);
}

.nav-logo {
    font-size: 24px;
    font-weight: 800;
    color: var(--gold); /* #D4A84F */
    letter-spacing: -0.03em;
    display: flex;
    align-items: center;
    gap: 4px;
}

.nav-logo span {
    color: var(--light); /* #F7E6C1 */
    font-weight: 300;
}

.nav-menu {
    display: flex;
    gap: 36px;
    align-items: center;
}

.nav-link {
    color: #CCCCCC;
    font-size: 14px;
    font-weight: 500;
    position: relative;
    padding: 8px 0;
    transition: color 0.3s ease;
}

.nav-link::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    width: 0;
    height: 2px;
    background: var(--gold);
    transition: width 0.3s ease;
}

.nav-link:hover::after {
    width: 100%;
}

.nav-link:hover {
    color: var(--gold-hover);
}

.nav-actions {
    display: flex;
    align-items: center;
    gap: 20px;
}

.cart-icon-btn {
    position: relative;
    font-size: 18px;
    color: #CCCCCC;
    transition: color 0.3s ease, transform 0.2s ease;
    display: flex;
    align-items: center;
}

.cart-icon-btn:hover {
    color: var(--gold);
    transform: scale(1.08);
}

.cart-badge {
    position: absolute;
    top: -8px;
    right: -10px;
    background: var(--gold);
    color: var(--dark);
    font-size: 10px;
    font-weight: 700;
    width: 16px;
    height: 16px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 1px solid var(--dark);
}

.user-profile-chip {
    display: flex;
    align-items: center;
    gap: 8px;
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(212, 168, 79, 0.1);
    padding: 6px 14px;
    border-radius: 30px;
    font-size: 13px;
    font-weight: 500;
    color: #F7E6C1;
}

.user-avatar {
    width: 22px;
    height: 22px;
    border-radius: 50%;
    background: var(--gold);
    color: var(--dark);
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 11px;
}

.nav-btn-order-now {
    background: var(--gold);
    color: var(--dark);
    font-size: 13px;
    font-weight: 700;
    padding: 10px 22px;
    border-radius: 30px;
    box-shadow: 0 4px 14px rgba(212, 168, 79, 0.3);
    transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
    border: none;
    cursor: pointer;
}

.nav-btn-order-now:hover {
    transform: translateY(-2px);
    background: var(--gold-hover);
    box-shadow: 0 6px 20px rgba(212, 168, 79, 0.5);
    color: var(--dark);
}

/* ===== HERO SECTION ===== */
.hero {
    position: relative;
    height: 100vh;
    min-height: 720px;
    width: 100%;
    display: flex;
    align-items: center;
    overflow: hidden;
}

.hero-bg {
    width: 100%;
    height: 100%;
    object-fit: cover;
    filter: brightness(0.35);
}

.hero-slides {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    z-index: 1;
}

.hero-slide {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    opacity: 0;
    transition: opacity 1.2s cubic-bezier(0.25, 1, 0.5, 1);
}

.hero-slide.active {
    opacity: 1;
}

.hero-dots {
    position: absolute;
    bottom: 30px;
    left: 50%;
    transform: translateX(-50%);
    display: flex;
    gap: 12px;
    z-index: 10;
}

.hero-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.3);
    border: 1px solid rgba(212, 168, 79, 0.2);
    cursor: pointer;
    transition: all 0.3s ease;
}

.hero-dot.active {
    background: var(--gold);
    transform: scale(1.3);
    box-shadow: 0 0 8px var(--gold);
}

.hero::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 200px;
    background: linear-gradient(to top, #07150F 15%, transparent 100%);
    z-index: 2;
    pointer-events: none;
}

.hero-container {
    position: relative;
    z-index: 3;
    width: 90%;
    max-width: 1200px;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    padding-top: 100px;
    height: 100vh;
    min-height: 720px;
}

.hero-content-left {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    width: 100%;
}

.hero-heading {
    font-size: 58px;
    font-weight: 900;
    line-height: 1.1;
    color: #F7E6C1;
    letter-spacing: -0.03em;
    margin-bottom: 20px;
    white-space: pre-line;
}

/* Character reveal class */
.char-reveal {
    display: inline-block;
    opacity: 0;
    transform: translateX(-18px);
    animation: revealChar 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@keyframes revealChar {
    to {
        opacity: 1;
        transform: translateX(0);
    }
}

.hero-subtitle {
    font-size: 18px;
    color: #CCCCCC;
    line-height: 1.6;
    margin-bottom: 36px;
    max-width: 580px;
    opacity: 0;
    transform: translateY(20px);
    animation: fadeUpEntrance 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.6s forwards;
}

.hero-cta {
    display: flex;
    gap: 16px;
    opacity: 0;
    transform: translateY(20px);
    animation: fadeUpEntrance 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.8s forwards;
}

@keyframes fadeUpEntrance {
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.btn-hero-primary {
    background: var(--gold);
    color: var(--dark);
    font-weight: 700;
    padding: 14px 32px;
    border-radius: 30px;
    box-shadow: 0 4px 14px rgba(212, 168, 79, 0.3);
    transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.btn-hero-primary:hover {
    transform: translateY(-3px);
    background: var(--gold-hover);
    box-shadow: 0 8px 24px rgba(212, 168, 79, 0.5);
    color: var(--dark);
}

.btn-hero-secondary {
    background: rgba(16, 40, 29, 0.5);
    backdrop-filter: blur(8px);
    -webkit-backdrop-filter: blur(8px);
    color: #F7E6C1;
    border: 1px solid var(--gold);
    font-weight: 600;
    padding: 14px 32px;
    border-radius: 30px;
    transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.btn-hero-secondary:hover {
    transform: translateY(-3px);
    background: rgba(212, 168, 79, 0.12);
    box-shadow: 0 6px 20px rgba(212, 168, 79, 0.2);
}

/* Floating Metrics Panel - Bottom Right & Side-by-Side */
.floating-metrics-card-wrapper {
    position: absolute;
    bottom: 50px;
    right: 0;
    z-index: 10;
    opacity: 0;
    transform: translateY(20px);
    animation: fadeUpEntrance 0.8s cubic-bezier(0.16, 1, 0.3, 1) 1s forwards;
}

.floating-metrics-card {
    background: rgba(16, 40, 29, 0.75);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border: 1px solid rgba(212, 168, 79, 0.2);
    box-shadow: 
        0 12px 40px rgba(0, 0, 0, 0.4),
        inset 0 1px 1px rgba(212, 168, 79, 0.08);
    border-radius: 24px;
    padding: 20px 28px;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    gap: 24px;
    width: 100%;
    max-width: 760px;
    animation: floatPanel 6s ease-in-out infinite;
}

@keyframes floatPanel {
    0%, 100% {
        transform: translateY(0);
    }
    50% {
        transform: translateY(-12px);
    }
}

.metric-item {
    display: flex;
    align-items: center;
    gap: 20px;
    flex: 1;
}

.metric-icon-wrap {
    width: 52px;
    height: 52px;
    border-radius: 14px;
    background: rgba(212, 168, 79, 0.08);
    border: 1px solid rgba(212, 168, 79, 0.15);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
    transition: all 0.3s ease;
}

.metric-item:hover .metric-icon-wrap {
    background: var(--gold);
    color: var(--dark);
    transform: scale(1.08) rotate(5deg);
}

.metric-info h4 {
    font-size: 16px;
    font-weight: 700;
    color: #F7E6C1;
    margin-bottom: 2px;
}

.metric-info p {
    font-size: 13px;
    color: #CCCCCC;
}

/* ===== FEATURE SECTION BELOW HERO ===== */
.features-section {
    padding: 100px 8% 60px;
    background-color: #07150F;
}

.section-title-premium {
    font-size: 40px;
    font-weight: 800;
    color: #F7E6C1;
    text-align: center;
    letter-spacing: -0.02em;
    margin-bottom: 48px;
}

.section-title-premium span {
    color: var(--gold);
    font-weight: 300;
}

.features-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 32px;
    max-width: 1200px;
    margin: 0 auto;
}

.feature-card {
    background: var(--green); /* #10281D */
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border: 1px solid rgba(212, 168, 79, 0.15);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
    border-radius: 20px;
    padding: 44px 36px;
    text-align: center;
    transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
    display: flex;
    flex-direction: column;
    align-items: center;
}

.feature-card:hover {
    transform: translateY(-8px);
    border-color: var(--gold);
    box-shadow: 0 12px 30px rgba(212, 168, 79, 0.15);
}

.feature-icon-container {
    width: 72px;
    height: 72px;
    border-radius: 50%;
    background: rgba(212, 168, 79, 0.08);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 24px;
    border: 1px solid rgba(212, 168, 79, 0.15);
    transition: all 0.3s ease;
}

.feature-card:hover .feature-icon-container {
    background: var(--gold);
    transform: scale(1.1);
}

.feature-card:hover .feature-icon-container svg {
    stroke: var(--dark);
}

.feature-card h3 {
    font-size: 20px;
    font-weight: 700;
    color: #F7E6C1;
    margin-bottom: 12px;
}

.feature-card p {
    font-size: 14px;
    color: #CCCCCC;
    line-height: 1.6;
}

/* ===== POPULAR CATEGORIES ===== */
.categories-section {
    padding: 60px 8% 60px;
    background: #07150F;
}

.categories-grid-premium {
    display: grid;
    grid-template-columns: repeat(6, 1fr);
    gap: 20px;
    max-width: 1200px;
    margin: 0 auto;
}

.category-card-premium {
    background: var(--green); /* #10281D */
    border: 1px solid rgba(212, 168, 79, 0.15);
    border-radius: 16px;
    overflow: hidden;
    cursor: pointer;
    transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
    text-align: center;
}

.category-card-premium:hover {
    transform: translateY(-6px);
    border-color: var(--gold);
    box-shadow: 0 8px 24px rgba(212, 168, 79, 0.2);
}

.cat-img-wrapper {
    position: relative;
    width: 100%;
    height: 120px;
    overflow: hidden;
}

.cat-img-wrapper img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
}

.category-card-premium:hover .cat-img-wrapper img {
    transform: scale(1.15);
}

.cat-name-premium {
    padding: 12px;
    font-size: 14px;
    font-weight: 700;
    color: #F7E6C1;
}

/* ===== CHIP WRAPPER (Dynamic filtering backup) ===== */
.categories-wrap {
    padding: 24px 8% 0;
    overflow-x: auto;
    display: flex;
    gap: 10px;
    scrollbar-width: none;
    background: var(--dark);
    margin-top: 10px;
    justify-content: center;
}

.categories-wrap::-webkit-scrollbar {
    display: none;
}

.cat-chip {
    display: flex;
    align-items: center;
    gap: 6px;
    background: transparent;
    border: 1px solid rgba(212, 168, 79, 0.2);
    color: #CCCCCC;
    padding: 8px 18px;
    border-radius: var(--radius-pill);
    cursor: pointer;
    transition: var(--transition);
    white-space: nowrap;
    font-size: 13px;
    font-weight: 500;
    flex-shrink: 0;
}

.cat-chip:hover, .cat-chip.active-chip {
    border-color: var(--gold);
    color: var(--gold);
    background: rgba(212, 168, 79, 0.08);
}

.cat-chip.active-chip {
    background: var(--gold)!important;
    color: #07150F!important;
    border-color: var(--gold)!important;
    font-weight: 700;
}

/* ===== RESTAURANT LISTING ===== */
.section {
    padding: 80px 8% 60px;
    background: #07150F;
}

.section-header-premium {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 40px;
    border-bottom: 1px solid rgba(212, 168, 79, 0.15);
    padding-bottom: 16px;
    flex-wrap: wrap;
    gap: 20px;
}

.section-title {
    font-size: 36px;
    font-weight: 800;
    color: white;
    letter-spacing: -0.02em;
}

.section-title span {
    font-weight: 300;
    color: #8A9690;
}

.search-container-premium {
    position: relative;
    max-width: 400px;
    width: 100%;
}

.search-input-premium {
    width: 100%;
    height: 44px;
    background: rgba(16, 40, 29, 0.75);
    backdrop-filter: blur(8px);
    -webkit-backdrop-filter: blur(8px);
    border: 1px solid rgba(212, 168, 79, 0.25);
    border-radius: var(--radius-pill);
    padding: 0 20px 0 44px;
    color: white;
    font-size: 14px;
    outline: none;
    transition: all 0.3s ease;
}

.search-input-premium:focus {
    border-color: var(--gold);
    box-shadow: 0 0 0 3px rgba(212, 168, 79, 0.15);
}

.search-icon-premium {
    position: absolute;
    left: 18px;
    top: 50%;
    transform: translateY(-50%);
    font-size: 14px;
    color: #8A9690;
    pointer-events: none;
}

.see-all {
    color: var(--gold);
    font-size: 14px;
    font-weight: 600;
    display: inline-flex;
    align-items: center;
    gap: 4px;
    transition: color 0.3s ease;
}

.see-all:hover {
    color: var(--gold-hover);
    text-decoration: none;
}

.restaurants-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(285px, 1fr));
    gap: 32px;
}

.r-card {
    background: rgba(16, 40, 29, 0.75);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border: 1px solid rgba(212, 168, 79, 0.15);
    border-radius: 20px;
    overflow: hidden;
    transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
    cursor: pointer;
    display: flex;
    flex-direction: column;
    height: 100%;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
}

.r-card:hover {
    transform: scale(1.03) translateY(-4px);
    border-color: var(--gold);
    box-shadow: 0 15px 35px rgba(212, 168, 79, 0.18);
}

.r-card-img {
    position: relative;
    overflow: hidden;
}

.r-card-img img {
    width: 100%;
    height: 200px;
    object-fit: cover;
    display: block;
    transition: transform 0.5s ease;
}

.r-card:hover .r-card-img img {
    transform: scale(1.08);
}

.r-card-badges {
    position: absolute;
    top: 12px;
    left: 12px;
    z-index: 2;
}

.badge {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    padding: 6px 12px;
    border-radius: 8px;
    font-size: 12px;
    font-weight: 700;
    background: rgba(7, 21, 15, 0.8);
    color: white;
    backdrop-filter: blur(8px);
    -webkit-backdrop-filter: blur(8px);
    border: 1px solid rgba(212, 168, 79, 0.2);
}

.badge-rating {
    color: var(--gold);
}

.r-card-fav {
    position: absolute;
    top: 12px;
    right: 12px;
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background: rgba(7, 21, 15, 0.6);
    backdrop-filter: blur(8px);
    -webkit-backdrop-filter: blur(8px);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.3s ease;
    border: 1px solid rgba(212, 168, 79, 0.2);
    z-index: 2;
    color: white;
}

.r-card-fav:hover {
    background: rgba(212, 168, 79, 0.2);
    transform: scale(1.1);
}

.r-card-body {
    padding: 24px;
    flex: 1;
    display: flex;
    flex-direction: column;
    background: var(--green-light); /* #183628 */
}

.r-card-name {
    font-size: 20px;
    font-weight: 700;
    color: #F7E6C1;
    margin-bottom: 6px;
    letter-spacing: -0.02em;
}

.r-card-cuisine {
    font-size: 13px;
    color: #CCCCCC;
    margin-bottom: 20px;
    line-height: 1.3;
}

.r-card-meta {
    display: flex;
    align-items: center;
    gap: 16px;
    font-size: 12px;
    color: #8A9690;
    padding-top: 16px;
    border-top: 1px solid rgba(212, 168, 79, 0.15);
    margin-top: auto;
}

.r-card-meta span {
    display: flex;
    align-items: center;
    gap: 4px;
}

.no-results {
    grid-column: 1/-1;
    text-align: center;
    padding: 80px 20px;
    display: none;
}
.no-results .emoji {
    font-size: 48px;
    margin-bottom: 12px;
}
.no-results h3 {
    font-size: 20px;
    color: white;
    margin-bottom: 6px;
}
.no-results p {
    color: #8A9690;
}

/* ===== SPECIAL OFFER BANNER ===== */
.offer-section {
    padding: 60px 8%;
    background: #07150F;
}

.offer-banner-card {
    position: relative;
    background: linear-gradient(135deg, #D4A84F 0%, #B88E3D 50%, #9C742C 100%);
    border-radius: 24px;
    padding: 60px 80px;
    display: grid;
    grid-template-columns: 1.2fr 0.8fr;
    align-items: center;
    gap: 40px;
    overflow: hidden;
    box-shadow: 0 15px 40px rgba(212, 168, 79, 0.25);
    border: 1px solid rgba(255, 255, 255, 0.15);
}

.offer-banner-card::before {
    content: '';
    position: absolute;
    top: -50%;
    left: -20%;
    width: 80%;
    height: 200%;
    background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, transparent 60%);
    pointer-events: none;
    transform: rotate(-15deg);
}

.offer-content {
    position: relative;
    z-index: 2;
}

.offer-tag {
    display: inline-block;
    background: #10281D;
    color: #D4A84F;
    font-size: 11px;
    font-weight: 700;
    padding: 6px 14px;
    border-radius: 30px;
    letter-spacing: 0.05em;
    margin-bottom: 20px;
    border: 1px solid rgba(212, 168, 79, 0.2);
}

.offer-banner-card h2 {
    font-size: 44px;
    font-weight: 800;
    color: #10281D;
    line-height: 1.2;
    margin-bottom: 12px;
    letter-spacing: -0.02em;
}

.offer-banner-card p {
    font-size: 16px;
    color: rgba(16, 40, 29, 0.8);
    margin-bottom: 32px;
    font-weight: 500;
}

.promo-code {
    font-weight: 700;
    text-decoration: underline;
    color: #10281D;
}

.btn-offer-claim {
    background: #10281D;
    color: #F7E6C1;
    font-weight: 700;
    padding: 14px 36px;
    border-radius: 30px;
    transition: all 0.3s ease;
    box-shadow: 0 4px 14px rgba(16, 40, 29, 0.3);
}

.btn-offer-claim:hover {
    background: #183628;
    transform: translateY(-3px) scale(1.02);
    box-shadow: 0 8px 20px rgba(16, 40, 29, 0.5);
}

.offer-graphics {
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 2;
}

.discount-badge-large {
    font-size: 72px;
    font-weight: 900;
    color: #10281D;
    line-height: 0.8;
    text-align: center;
    text-shadow: 0 2px 10px rgba(0,0,0,0.1);
    transform: rotate(6deg);
    background: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(8px);
    -webkit-backdrop-filter: blur(8px);
    border: 1px solid rgba(255, 255, 255, 0.25);
    border-radius: 50%;
    width: 180px;
    height: 180px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    box-shadow: 0 8px 32px rgba(0,0,0,0.15);
}

.off-text {
    font-size: 20px;
    font-weight: 700;
    letter-spacing: 0.05em;
}

/* ===== CUSTOMER REVIEWS ===== */
.reviews-section {
    padding: 60px 8% 100px;
    background: #07150F;
}

.reviews-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 32px;
    max-width: 1200px;
    margin: 0 auto;
}

.review-card {
    background: rgba(16, 40, 29, 0.75);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border: 1px solid rgba(212, 168, 79, 0.15);
    border-radius: 20px;
    padding: 36px;
    box-shadow: 
        0 8px 32px rgba(0, 0, 0, 0.25),
        inset 0 1px 1px rgba(212, 168, 79, 0.08);
    transition: all 0.35s ease;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.review-card:hover {
    transform: translateY(-6px);
    border-color: var(--gold);
    box-shadow: 0 12px 30px rgba(212, 168, 79, 0.15);
}

.review-stars {
    font-size: 16px;
    margin-bottom: 20px;
    letter-spacing: 2px;
}

.review-text {
    font-size: 14px;
    color: #CCCCCC;
    line-height: 1.6;
    font-style: italic;
    margin-bottom: 24px;
}

.review-user {
    display: flex;
    align-items: center;
    gap: 16px;
}

.review-avatar-wrap {
    width: 44px;
    height: 44px;
    border-radius: 50%;
    background: rgba(212, 168, 79, 0.15);
    border: 1px solid var(--gold);
    display: flex;
    align-items: center;
    justify-content: center;
}

.review-avatar-text {
    font-weight: 700;
    color: var(--gold);
}

.review-user-info h4 {
    font-size: 14px;
    font-weight: 700;
    color: #F7E6C1;
}

.review-user-info p {
    font-size: 11px;
    color: #8A9690;
}

/* ===== PREMIUM FOOTER ===== */
.footer-premium {
    background: #040A08;
    border-top: 1px solid rgba(212, 168, 79, 0.15);
    padding: 80px 8% 40px;
    color: #CCCCCC;
}

.footer-grid-premium {
    display: grid;
    grid-template-columns: 1.5fr 1fr 1fr 1fr;
    gap: 48px;
    max-width: 1200px;
    margin: 0 auto;
}

.footer-logo-premium {
    font-size: 26px;
    font-weight: 800;
    color: var(--gold);
    letter-spacing: -0.03em;
    margin-bottom: 20px;
}

.footer-logo-premium span {
    color: #FFF;
    font-weight: 300;
}

.footer-tagline {
    font-size: 13px;
    line-height: 1.6;
    color: #8A9690;
    margin-bottom: 24px;
}

.footer-socials {
    display: flex;
    gap: 16px;
}

.social-icon {
    font-size: 12px;
    font-weight: 700;
    color: var(--gold);
    border: 1px solid rgba(212, 168, 79, 0.2);
    padding: 6px 14px;
    border-radius: 30px;
    transition: all 0.3s ease;
}

.social-icon:hover {
    background: var(--gold);
    color: var(--dark);
    border-color: var(--gold);
    transform: translateY(-2px);
}

.footer-col h4 {
    font-size: 15px;
    font-weight: 700;
    color: #F7E6C1;
    margin-bottom: 20px;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

.footer-col a {
    display: block;
    font-size: 13px;
    color: #8A9690;
    margin-bottom: 12px;
    transition: all 0.3s ease;
}

.footer-col a:hover {
    color: var(--gold);
    padding-left: 4px;
}

.footer-bottom-premium {
    max-width: 1200px;
    margin: 60px auto 0;
    padding-top: 32px;
    border-top: 1px solid rgba(212, 168, 79, 0.1);
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 20px;
    font-size: 12px;
    color: #8A9690;
}

.footer-bottom-links {
    display: flex;
    gap: 24px;
}

.footer-bottom-links a:hover {
    color: var(--gold);
}

/* ===== FLOATING CART BUTTON (Redesigned) ===== */
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
    font-weight: 700;
    box-shadow: 
        0 10px 30px rgba(0, 0, 0, 0.4),
        0 0 20px rgba(212, 168, 79, 0.25);
    display: none;
    align-items: center;
    gap: 12px;
    z-index: 9999;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
    border: 1px solid rgba(255,255,255,0.15);
}
.floating-cart.visible {
    display: flex;
}
.floating-cart:hover {
    transform: translateX(-50%) translateY(-3px);
    box-shadow: 
        0 14px 35px rgba(212, 168, 79, 0.45),
        0 0 30px rgba(212, 168, 79, 0.4);
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

/* ===== RESPONSIVE MEDIA QUERIES ===== */
@media (max-width: 1024px) {
    .hero-heading {
        font-size: 44px;
    }
    .hero-container {
        align-items: center;
        justify-content: center;
        height: auto;
        min-height: 100vh;
        padding-top: 140px;
        padding-bottom: 60px;
    }
    .hero-content-left {
        align-items: center;
        text-align: center;
    }
    .hero-subtitle {
        max-width: 100%;
    }
    .hero-cta {
        justify-content: center;
    }
    .floating-metrics-card-wrapper {
        position: relative;
        bottom: 0;
        right: 0;
        margin-top: 48px;
        display: flex;
        justify-content: center;
        width: 100%;
    }
    .floating-metrics-card {
        flex-direction: row;
        flex-wrap: wrap;
        justify-content: center;
        gap: 24px;
        max-width: 100%;
    }
    .features-grid, .reviews-grid {
        grid-template-columns: 1fr;
        gap: 24px;
    }
    .categories-grid-premium {
        grid-template-columns: repeat(3, 1fr);
    }
    .offer-banner-card {
        grid-template-columns: 1fr;
        padding: 40px;
        text-align: center;
    }
    .offer-graphics {
        display: none;
    }
    .footer-grid-premium {
        grid-template-columns: 1fr 1fr;
        gap: 32px;
    }
}

@media (max-width: 768px) {
    .navbar-floating-container {
        width: 95%;
        top: 10px;
    }
    .navbar {
        padding: 0 16px;
        height: 60px;
        border-radius: 16px;
    }
    .nav-menu {
        display: none; /* Hide middle links on smaller viewports */
    }
    .hero-heading {
        font-size: 34px;
    }
    .floating-metrics-card {
        flex-direction: column;
        align-items: flex-start;
        gap: 20px;
        padding: 24px;
    }
    .categories-grid-premium {
        grid-template-columns: repeat(2, 1fr);
    }
    .footer-grid-premium {
        grid-template-columns: 1fr;
    }
}
</style>
</head>
<body>

<!-- ===== FLOATING NAVBAR ===== -->
<div class="navbar-floating-container" id="navbarContainer">
    <nav class="navbar">
        <a href="restaurant" class="nav-logo">Food<span>Rush</span></a>
        
        <div class="nav-menu">
            <a href="#" class="nav-link">Home</a>
            <a href="#restaurants" class="nav-link">Restaurants</a>
            <a href="#offers" class="nav-link">Offers</a>
            <a href="#footer" class="nav-link">About</a>
            <a href="#footer" class="nav-link">Contact</a>
        </div>
        
        <div class="nav-actions">
            <a href="cart" class="cart-icon-btn">
                🛒
                <% if (cartCount > 0) { %>
                    <span class="cart-badge"><%= cartCount %></span>
                <% } %>
            </a>
            
            <% if (loggedInUser != null) { %>
                <div class="user-profile-chip">
                    <div class="user-avatar"><%= loggedInUser.getName().charAt(0) %></div>
                    <%= loggedInUser.getName().split(" ")[0] %>
                </div>
                <a href="logout" class="nav-btn-order-now" style="background:#ff3b30;color:white;" onclick="return confirm('Log out of FoodRush?')">
                    Logout
                </a>
            <% } else { %>
                <a href="login.jsp" class="nav-link" style="padding:0 8px;">Login</a>
                <a href="register.jsp" class="nav-btn-order-now">Order Now</a>
            <% } %>
        </div>
    </nav>
</div>

<!-- ===== HERO SECTION ===== -->
<section class="hero">
    <div class="hero-slides" id="heroSlides">
        <div class="hero-slide active"><img src="images/hero1.png" alt="Gourmet Biryani" class="hero-bg"></div>
        <div class="hero-slide"><img src="images/hero2.png" alt="Delicious Burger" class="hero-bg"></div>
        <div class="hero-slide"><img src="images/hero3.png" alt="Artisanal Pizza" class="hero-bg"></div>
        <div class="hero-slide"><img src="images/hero4.png" alt="Grilled Dishes" class="hero-bg"></div>
        <div class="hero-slide"><img src="images/hero5.png" alt="Luxury Desserts" class="hero-bg"></div>
    </div>
    <div class="hero-dots" id="heroDots"></div>
    
    <div class="hero-container">
        <div class="hero-content-left">
            <h1 class="hero-heading" id="heroHeading">Order Delicious Food
            Delivered To Your Door</h1>
            
            <p class="hero-subtitle">
                Discover the best restaurants near you and enjoy fast delivery, exclusive offers, and unforgettable flavors.
            </p>
            
            <div class="hero-cta">
                <a href="#restaurants" class="btn-hero-primary">Order Food</a>
                <a href="#restaurants" class="btn-hero-secondary">Explore Restaurants</a>
            </div>
        </div>
    </div>
</section>

<!-- ===== FEATURE SECTION BELOW HERO ===== -->
<section class="features-section reveal-element">
    <h2 class="section-title-premium">Why Choose <span>FoodRush?</span></h2>
    <div class="features-grid">
        <div class="feature-card">
            <div class="feature-icon-container">
                <svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="#D4A84F" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <circle cx="18.5" cy="17.5" r="2.5"></circle>
                  <circle cx="5.5" cy="17.5" r="2.5"></circle>
                  <path d="M16 17.5h-5.5a1.5 1.5 0 0 1-1.5-1.5v-6a1.5 1.5 0 0 1 1.5-1.5h3.5a1.5 1.5 0 0 1 1.5 1.5v3"></path>
                  <path d="M5.5 15h1.5a1 1 0 0 0 1-1v-4a1 1 0 0 0-1-1H4.5a1 1 0 0 0-1 1v4a1 1 0 0 0 1 1h1"></path>
                  <path d="M8 8h6"></path>
                </svg>
            </div>
            <h3>Fast Delivery</h3>
            <p>Hot, delicious, and fresh meals delivered straight to your door in 30 minutes average. Real-time updates all the way.</p>
        </div>
        
        <div class="feature-card">
            <div class="feature-icon-container">
                <svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="#D4A84F" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M6 18h12a2 2 0 0 0 2-2v-3.5a5.5 5.5 0 0 0-11 0V16A2 2 0 0 0 6 18z"></path>
                  <path d="M9 18v3a1 1 0 0 0 1 1h4a1 1 0 0 0 1-1v-3"></path>
                  <path d="M12 2a4 4 0 0 1 4 4c0 1.25-.57 2.37-1.47 3.12A5.5 5.5 0 0 1 12 7.5a5.5 5.5 0 0 1-2.53 1.62C8.57 8.37 8 7.25 8 6a4 4 0 0 1 4-4z"></path>
                </svg>
            </div>
            <h3>Fresh Food</h3>
            <p>Prepared by certified gourmet chefs under strict cleanliness guidelines. 100% premium quality check on every ingredient.</p>
        </div>
        
        <div class="feature-card">
            <div class="feature-icon-container">
                <svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="#D4A84F" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M3.82 10.8a1 1 0 0 1 0-1.6l4.9-4.9a1 1 0 0 1 1.6 0l4.9 4.9a1 1 0 0 1 0 1.6l-4.9 4.9a1 1 0 0 1-1.6 0z"></path>
                  <circle cx="12" cy="12" r="2"></circle>
                  <path d="m15 9-6 6"></path>
                </svg>
            </div>
            <h3>Best Offers</h3>
            <p>Unlock unmatched exclusive discounts, flat cashbacks, and special restaurant partner vouchers tailored just for you.</p>
        </div>
    </div>
</section>

<!-- ===== POPULAR CATEGORIES ===== -->
<section class="categories-section reveal-element">
    <h2 class="section-title-premium">Popular <span>Categories</span></h2>
    <div class="categories-grid-premium">
        
        <div class="category-card-premium" onclick="filterByCategory('biryani', document.getElementById('cat-chip-biryani'))">
            <div class="cat-img-wrapper">
                <img src="images/biriyani.jpg" alt="Biryani">
            </div>
            <div class="cat-name-premium">Biryani</div>
        </div>
        
        <div class="category-card-premium" onclick="filterByCategory('pizza', document.getElementById('cat-chip-pizza'))">
            <div class="cat-img-wrapper">
                <img src="images/pizza.jpg" alt="Pizza">
            </div>
            <div class="cat-name-premium">Pizza</div>
        </div>
        
        <div class="category-card-premium" onclick="filterByCategory('burger', document.getElementById('cat-chip-burger'))">
            <div class="cat-img-wrapper">
                <img src="images/burger.jpg" alt="Burger">
            </div>
            <div class="cat-name-premium">Burger</div>
        </div>
        
        <div class="category-card-premium" onclick="filterByCategory('chinese', document.getElementById('cat-chip-chinese'))">
            <div class="cat-img-wrapper">
                <img src="images/chinese.jpg" alt="Chinese">
            </div>
            <div class="cat-name-premium">Chinese</div>
        </div>
        
        <div class="category-card-premium" onclick="filterByCategory('south indian', document.getElementById('cat-chip-southindian'))">
            <div class="cat-img-wrapper">
                <img src="images/southindian.jpg" alt="South Indian">
            </div>
            <div class="cat-name-premium">South Indian</div>
        </div>
        
        <div class="category-card-premium" onclick="filterByCategory('dessert', document.getElementById('cat-chip-dessert'))">
            <div class="cat-img-wrapper">
                <img src="images/cake.jpg" alt="Desserts">
            </div>
            <div class="cat-name-premium">Desserts</div>
        </div>
        
    </div>
</section>

<!-- ===== DYNAMIC CATEGORY FILTER CHIPS ===== -->
<div class="categories-wrap reveal-element" id="catWrap">
    <div class="cat-chip active-chip" id="cat-chip-all" onclick="filterByCategory('',this)">🍽️ All</div>
    <div class="cat-chip" id="cat-chip-pizza" onclick="filterByCategory('pizza',this)">🍕 Pizza</div>
    <div class="cat-chip" id="cat-chip-burger" onclick="filterByCategory('burger',this)">🍔 Burgers</div>
    <div class="cat-chip" id="cat-chip-chicken" onclick="filterByCategory('chicken',this)">🍗 Chicken</div>
    <div class="cat-chip" id="cat-chip-biryani" onclick="filterByCategory('biryani',this)">🍛 Biryani</div>
    <div class="cat-chip" id="cat-chip-chinese" onclick="filterByCategory('chinese',this)">🍜 Chinese</div>
    <div class="cat-chip" id="cat-chip-healthy" onclick="filterByCategory('healthy',this)">🥗 Healthy</div>
    <div class="cat-chip" id="cat-chip-dessert" onclick="filterByCategory('dessert',this)">🍰 Desserts</div>
    <div class="cat-chip" id="cat-chip-coffee" onclick="filterByCategory('coffee',this)">☕ Coffee</div>
    <div class="cat-chip" id="cat-chip-southindian" onclick="filterByCategory('south indian',this)">🥘 South Indian</div>
    <div class="cat-chip" id="cat-chip-northindian" onclick="filterByCategory('north indian',this)">🍲 North Indian</div>
</div>

<!-- ===== RESTAURANTS SECTION ===== -->
<section class="section reveal-element" id="restaurants">
    <div class="section-header-premium">
        <h2 class="section-title">Popular <span>Restaurants</span></h2>
        
        <div class="search-container-premium">
            <span class="search-icon-premium">🔍</span>
            <input type="text" id="searchInput" class="search-input-premium"
                   placeholder="Search restaurants, cuisines or dishes..."
                   oninput="filterRestaurants()">
        </div>
        
        <a href="javascript:void(0)" class="see-all" onclick="filterByCategory('',document.getElementById('cat-chip-all'))">
            View All →
        </a>
    </div>

    <div class="restaurants-grid" id="restaurantGrid">

        <%
        List<Restaurant> allRestaurants = (List<Restaurant>) request.getAttribute("allRestaurants");
        if (allRestaurants != null) {
            for (Restaurant restaurant : allRestaurants) {
        %>

        <a href="menu?RestaurantID=<%= restaurant.getRestaurantId() %>"
           class="r-card restaurant-card-link"
           data-name="<%= restaurant.getName().toLowerCase() %>"
           data-cuisine="<%= restaurant.getCuisineType().toLowerCase() %>">

            <div class="r-card-img">
                <img src="<%= restaurant.getImagePath() %>" alt="<%= restaurant.getName() %>" onerror="this.src='images/hero1.png'">
                <div class="r-card-badges">
                    <span class="badge badge-rating">⭐ <%= restaurant.getRating() %></span>
                </div>
                <button class="r-card-fav" onclick="event.preventDefault()">🤍</button>
            </div>

            <div class="r-card-body">
                <div class="r-card-name"><%= restaurant.getName() %></div>
                <div class="r-card-cuisine"><%= restaurant.getCuisineType() %></div>
                <div class="r-card-meta">
                    <span>🕒 <%= restaurant.getDeliveryTime() %> mins</span>
                    <span>📍 <%= restaurant.getAddress() %></span>
                </div>
            </div>
        </a>

        <%
            }
        }
        %>

        <!-- No Results -->
        <div class="no-results" id="noResults">
            <div class="emoji">😕</div>
            <h3>No Restaurants Found</h3>
            <p>Try searching for a different kitchen name or cuisine style.</p>
        </div>

    </div>
</section>

<!-- ===== SPECIAL OFFER BANNER ===== -->
<section class="offer-section reveal-element" id="offers">
    <div class="offer-banner-card">
        <div class="offer-content">
            <span class="offer-tag">LIMITED TIME GOURMET PROMO</span>
            <h2>Get 50% OFF on Your First Order</h2>
            <p>Unlock unforgettable flavors from top-tier kitchens. Use code <span class="promo-code">WELCOME50</span> at checkout.</p>
            <a href="#restaurants" class="btn btn-offer-claim">Claim Offer</a>
        </div>
        <div class="offer-graphics">
            <span class="discount-badge-large">50%<br><span class="off-text">OFF</span></span>
        </div>
    </div>
</section>

<!-- ===== CUSTOMER REVIEWS ===== -->
<section class="reviews-section reveal-element">
    <h2 class="section-title-premium">What Our <span>Connoisseurs Say</span></h2>
    <div class="reviews-grid">
        
        <div class="review-card">
            <div>
                <div class="review-stars">⭐⭐⭐⭐⭐</div>
                <p class="review-text">"FoodRush has completely elevated our dining experience at home. The speed of delivery is incredible, but the selection of high-end gourmet options is the real game-changer. The presentation was outstanding!"</p>
            </div>
            <div class="review-user">
                <div class="review-avatar-wrap">
                    <div class="review-avatar-text">E</div>
                </div>
                <div class="review-user-info">
                    <h4>Eleanor Vance</h4>
                    <p>Verified Gastronome</p>
                </div>
            </div>
        </div>
        
        <div class="review-card">
            <div>
                <div class="review-stars">⭐⭐⭐⭐⭐</div>
                <p class="review-text">"I ordered the special gourmet biryani and it arrived hot and perfectly cooked. The glassmorphic design and ease of checkout match the premium quality of the service. Highly recommended!"</p>
            </div>
            <div class="review-user">
                <div class="review-avatar-wrap">
                    <div class="review-avatar-text">A</div>
                </div>
                <div class="review-user-info">
                    <h4>Aron Finch</h4>
                    <p>Food Blogger</p>
                </div>
            </div>
        </div>
        
        <div class="review-card">
            <div>
                <div class="review-stars">⭐⭐⭐⭐⭐</div>
                <p class="review-text">"From the floating navbar design to the stellar chef hat service, FoodRush feels like a Michelin-star app. The 30-minute delivery average holds true every single time. Absolutely stellar experience."</p>
            </div>
            <div class="review-user">
                <div class="review-avatar-wrap">
                    <div class="review-avatar-text">S</div>
                </div>
                <div class="review-user-info">
                    <h4>Sophia Rodriguez</h4>
                    <p>Regular Patron</p>
                </div>
            </div>
        </div>
        
    </div>
</section>

<!-- ===== FOOTER ===== -->
<footer class="footer-premium" id="footer">
    <div class="footer-grid-premium">
        
        <div class="footer-col footer-about">
            <div class="footer-logo-premium">Food<span>Rush</span></div>
            <p class="footer-tagline">Apple-inspired luxury food delivery. Enjoy unforgettable flavors from top-tier kitchens straight to your doorstep.</p>
            <div class="footer-socials">
                <a href="#" class="social-icon">Instagram</a>
                <a href="#" class="social-icon">Facebook</a>
                <a href="#" class="social-icon">Twitter</a>
            </div>
        </div>
        
        <div class="footer-col">
            <h4>Company</h4>
            <a href="#">About Us</a>
            <a href="#">Careers</a>
            <a href="#">Partner with us</a>
            <a href="#">Blog</a>
        </div>
        
        <div class="footer-col">
            <h4>Restaurants</h4>
            <a href="#restaurants">Popular Outlets</a>
            <a href="#restaurants">New Listings</a>
            <a href="#restaurants">Cuisine Categories</a>
            <a href="#restaurants">Premium Selections</a>
        </div>
        
        <div class="footer-col">
            <h4>Help Center</h4>
            <a href="#">FAQ & Support</a>
            <a href="#">Order Tracking</a>
            <a href="#">Refund Policy</a>
            <a href="#">Contact Support</a>
        </div>
        
    </div>
    
    <div class="footer-bottom-premium">
        <p>© 2026 FoodRush. Crafted for the ultimate gastronomic experience.</p>
        <div class="footer-bottom-links">
            <a href="#">Terms of Service</a>
            <a href="#">Privacy Policy</a>
            <a href="#">Security</a>
        </div>
    </div>
</footer>

<!-- ===== FLOATING CART ===== -->
<a href="cart" class="floating-cart <%= cartCount > 0 ? "visible" : "" %>" id="floatingCart">
    <span class="fc-count"><%= cartCount %></span>
    <span><%= cartCount %> item<%= cartCount != 1 ? "s" : "" %> in cart</span>
    <span>View Cart →</span>
</a>

<script>
// ── Scroll Reveal intersection observer ─────────────────
const revealElements = document.querySelectorAll('.reveal-element');
const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('reveal-visible');
        }
    });
}, { threshold: 0.1 });

revealElements.forEach(el => revealObserver.observe(el));

// ── Character Stagger Reveal for Heading ────────────────
document.addEventListener('DOMContentLoaded', () => {
    const heading = document.getElementById('heroHeading');
    if (heading) {
        const text = heading.innerText.trim();
        heading.innerHTML = '';
        let charCount = 0;
        
        text.split('\n').forEach((line, lineIdx) => {
            const lineContainer = document.createElement('div');
            lineContainer.style.display = 'block';
            
            line.split(' ').forEach((word) => {
                const wordSpan = document.createElement('span');
                wordSpan.style.display = 'inline-block';
                wordSpan.style.whiteSpace = 'nowrap';
                
                word.split('').forEach((char) => {
                    const charSpan = document.createElement('span');
                    charSpan.className = 'char-reveal';
                    charSpan.textContent = char;
                    charSpan.style.animationDelay = `${charCount * 0.025}s`;
                    wordSpan.appendChild(charSpan);
                    charCount++;
                });
                
                lineContainer.appendChild(wordSpan);
                // add space after word
                const space = document.createTextNode(' ');
                lineContainer.appendChild(space);
            });
            
            heading.appendChild(lineContainer);
        });
    }
});

function scrollToRestaurants() {
    document.getElementById('restaurants').scrollIntoView({behavior:'smooth'});
}

// ── Navbar scroll effect ───────────────────────────────
window.addEventListener('scroll', () => {
    document.getElementById('navbarContainer').classList.toggle('scrolled', window.scrollY > 40);
});

// ── Search & Category Filter ───────────────────────────
let activeCuisine = '';

function filterRestaurants() {
    const q       = document.getElementById('searchInput').value.toLowerCase().trim();
    const cards   = document.querySelectorAll('.restaurant-card-link');
    let   visible = 0;

    cards.forEach(card => {
        const name    = card.dataset.name    || '';
        const cuisine = card.dataset.cuisine || '';
        const show    = (name.includes(q) || cuisine.includes(q))
                     && (activeCuisine === '' || cuisine.includes(activeCuisine));
        card.style.display = show ? '' : 'none';
        if (show) visible++;
    });

    document.getElementById('noResults').style.display = visible ? 'none' : 'block';
}

function filterByCategory(cuisine, chip) {
    activeCuisine = cuisine.toLowerCase();
    
    // Deactivate all chips
    document.querySelectorAll('.cat-chip').forEach(c => c.classList.remove('active-chip'));
    
    // Find active chip if clicked from Category Grid
    if (chip) {
        chip.classList.add('active-chip');
    } else {
        // Fallback matching to chips
        const targetId = cuisine ? `cat-chip-${cuisine.replace(' ', '')}` : 'cat-chip-all';
        const targetChip = document.getElementById(targetId);
        if (targetChip) targetChip.classList.add('active-chip');
    }
    
    document.getElementById('searchInput').value = '';
    filterRestaurants();
    scrollToRestaurants();
}

// ── Heart toggle ───────────────────────────────────────
document.querySelectorAll('.r-card-fav').forEach(btn => {
    btn.addEventListener('click', function(e) {
        e.preventDefault();
        this.textContent = this.textContent === '🤍' ? '❤️' : '🤍';
    });
});

// ── Hero Slider logic ──────────────────────────────────
const slides = document.querySelectorAll('.hero-slide');
const dotsWrap = document.getElementById('heroDots');
let current = 0;

if (slides.length > 0 && dotsWrap) {
    slides.forEach((_, i) => {
        const d = document.createElement('div');
        d.className = 'hero-dot' + (i === 0 ? ' active' : '');
        d.onclick = () => goTo(i);
        dotsWrap.appendChild(d);
    });
}

function goTo(n) {
    if (slides.length === 0) return;
    slides[current].classList.remove('active');
    if (dotsWrap && dotsWrap.children[current]) {
        dotsWrap.children[current].classList.remove('active');
    }
    current = n;
    slides[current].classList.add('active');
    if (dotsWrap && dotsWrap.children[current]) {
        dotsWrap.children[current].classList.add('active');
    }
}

// Auto slide every 4 seconds
setInterval(() => {
    goTo((current + 1) % slides.length);
}, 4000);
</script>
</body>
</html>
