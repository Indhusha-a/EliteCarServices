<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Elite Car Services - Admin Register</title>
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
            <a href="adminLogin.jsp" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Admin Login</a>
        </div>
    </div>
</nav>
<!-- Register Form -->
<div class="container mx-auto mt-20 px-4">
    <div class="bg-white p-6 rounded-lg shadow-lg w-full max-w-lg sm:max-w-md mx-auto animate-fadeInRight">
        <h2 class="text-2xl font-bold text-center mb-6">Admin Register</h2>
        <%
            String error = (String) session.getAttribute("error");
            String message = (String) session.getAttribute("message");
            if (error != null) {
        %>
        <p class="text-center text-red-500 mb-4 transition-opacity duration-500"><%= error %></p>
        <%
                session.removeAttribute("error");
            }
            if (message != null) {
        %>
        <p class="text-center text-green-500 mb-4 transition-opacity duration-500"><%= message %></p>
        <%
                session.removeAttribute("message");
            }
        %>
        <form action="<%= request.getContextPath() %>/adminRegister" method="post" class="space-y-4">
            <div class="grid gap-2">
                <label for="name" class="text-gray-700 font-medium">Name</label>
                <input type="text" id="name" name="name" class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500" required>
            </div>
            <div class="grid gap-2">
                <label for="idNumber" class="text-gray-700 font-medium">ID Number</label>
                <input type="text" id="idNumber" name="idNumber" class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500" required>
            </div>
            <div class="grid gap-2">
                <label for="contactNumber" class="text-gray-700 font-medium">Contact Number</label>
                <input type="text" id="contactNumber" name="contactNumber" class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500" required>
            </div>
            <div class="grid gap-2">
                <label for="email" class="text-gray-700 font-medium">Email</label>
                <input type="email" id="email" name="email" class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500" required>
            </div>
            <div class="grid gap-2">
                <label for="password" class="text-gray-700 font-medium">Password</label>
                <input type="password" id="password" name="password" class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500" required>
            </div>
            <div class="grid gap-2">
                <label for="confirmPassword" class="text-gray-700 font-medium">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500" required>
            </div>
            <div class="grid gap-2">
                <label for="specialCode" class="text-gray-700 font-medium">Special Code</label>
                <input type="text" id="specialCode" name="specialCode" class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500" required>
            </div>
            <button type="submit" class="w-full bg-blue-500 text-white py-3 rounded hover:bg-blue-600 transition">Register</button>
        </form>
    </div>
</div>
</body>
</html>