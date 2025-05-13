<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Elite Car Services - Admin Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes fadeInRight {
            from { opacity: 0; transform: translateX(30px); }
            to { opacity: 1; transform: translateX(0); }
        }
        .animate-fadeInRight {
            animation: fadeInRight 1.2s ease-out 0.3s forwards;
        }
    </style>
</head>
<body class="bg-blue-100 flex items-center justify-center min-h-screen">
<!-- Navigation Bar -->
<nav class="bg-white p-6 shadow-md w-full fixed top-0 z-10">
    <div class="container mx-auto flex justify-between items-center">
        <a href="index.jsp" class="flex items-center">
            <img src="images/logo.jpg" alt="Elite Car Services Logo" class="h-10 w-auto mr-2">
            <h3 class="text-2xl font-bold text-gray-800">Elite Car Services</h3>
        </a>
        <div class="flex flex-col sm:flex-row gap-4">
            <a href="index.jsp" class="bg-orange-500 text-white px-4 py-2 rounded hover:bg-orange-600">Home</a>
            <a href="login.jsp" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">User Login</a>
        </div>
    </div>
</nav>
<!-- Login Form -->
<div class="container mx-auto mt-20 px-4">
    <div class="bg-white p-6 rounded-lg shadow-lg w-full max-w-lg sm:max-w-md mx-auto animate-fadeInRight">
        <h2 class="text-2xl font-bold text-center mb-6">Admin Login</h2>
        <%
            String error = (String) session.getAttribute("error");
            if (error != null) {
        %>
        <p class="text-center text-red-500 mb-4 transition-opacity duration-500"><%= error %></p>
        <%
                session.removeAttribute("error");
            }
        %>
        <form action="<%= request.getContextPath() %>/adminLogin" method="post" class="space-y-4">
            <div class="grid gap-2">
                <label for="email" class="text-gray-700 font-medium">Email</label>
                <input type="email" id="email" name="email" class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500" required>
            </div>
            <div class="grid gap-2">
                <label for="password" class="text-gray-700 font-medium">Password</label>
                <input type="password" id="password" name="password" class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500" required>
            </div>
            <button type="submit" class="w-full bg-blue-500 text-white py-3 rounded hover:bg-blue-600 transition">Login</button>
            <p class="text-center mt-4">
                <a href="login.jsp" class="text-blue-500 hover:underline">Back to User Login</a>
            </p>
        </form>
    </div>
</div>
<!-- JavaScript for fading out error message -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const errorMessage = document.querySelector('.text-red-500');
        if (errorMessage) {
            setTimeout(() => {
                errorMessage.style.opacity = '0';
                setTimeout(() => {
                    errorMessage.remove();
                }, 500);
            }, 3000);
        }
    });
</script>
</body>
</html>