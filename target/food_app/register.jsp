<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FoodRush - Register</title>

<link rel="stylesheet" href="css/style.css">
<style>
body {
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background: linear-gradient(rgba(7, 21, 15, 0.82), rgba(7, 21, 15, 0.82)), url("images/hero1.png");
    background-size: cover;
    background-position: center;
    padding: 20px;
}

.login-logo {
    text-align: center;
    font-size: 38px;
    font-weight: 900;
    color: var(--gold);
    margin-bottom: 8px;
    letter-spacing: -0.5px;
}

.login-logo span {
    color: white;
}

.subtitle {
    text-align: center;
    color: rgba(255, 255, 255, 0.75);
    font-size: 15px;
    margin-bottom: 30px;
}

.error-box {
    background: rgba(231,76,60,0.15);
    border: 1px solid #e74c3c;
    border-radius: var(--radius-md);
    padding: 12px;
    color: #ff4d4d;
    font-weight: 600;
    text-align: center;
    margin-bottom: 20px;
    font-size: 14px;
}

.links {
    text-align: center;
    margin-top: 24px;
    font-size: 14px;
}

.links p {
    color: var(--muted);
    margin-bottom: 6px;
}

.links a {
    color: var(--gold);
    font-weight: 700;
}
.links a:hover {
    color: var(--gold-hover);
    text-decoration: underline;
}
.glass-container .btn {
    width: 100%;
}
</style>
</head>

<body>
    <div class="glass-container">
        <div class="login-logo">
            Food<span>Rush</span>
        </div>

        <div class="subtitle">
            Create Your Account
        </div>

        <%
        String error = (String)request.getAttribute("error");
        if(error != null){
        %>
            <div class="error-box">
                <%= error %>
            </div>
        <%
        }
        %>

        <form action="register" method="post">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text"
                       class="form-input"
                       name="name"
                       placeholder="Enter your name"
                       required>
            </div>

            <div class="form-group">
                <label>Email</label>
                <input type="email"
                       class="form-input"
                       name="email"
                       placeholder="Enter your email"
                       required>
            </div>

            <div class="form-group">
                <label>Password</label>
                <input type="password"
                       class="form-input"
                       name="password"
                       placeholder="Enter password"
                       required>
            </div>

            <div class="form-group">
                <label>Address</label>
                <textarea
                    class="form-input"
                    name="address"
                    placeholder="Enter your address"
                    required></textarea>
            </div>

            <button class="btn btn-primary" type="submit">
                Register
            </button>
        </form>

        <div class="links">
            <p>Already have an account?</p>
            <a href="login.jsp">Login</a>
        </div>
    </div>
</body>
</html>
