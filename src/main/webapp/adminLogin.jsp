<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Elite Car Services - Admin Login</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center h-screen">
<!-- Navigation Bar -->
<nav class="bg-white p-4 shadow-md w-full fixed top-0">
  <div class="container mx-auto flex justify-between items-center">
    <div class="flex items-center">
      <img src="images/logo.jpg" alt="Elite Car Services Logo" class="h-12 mr-4">
      <h1 class="text-3xl font-bold text-gray-800">Elite Car Services</h1>
    </div>
    <div class="space-x-4">
      <a href="index.jsp" class="bg-orange-500 text-white px-4 py-2 rounded hover:bg-orange-600">Home</a>
      <a href="login.jsp" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Login</a>
      <a href="register.jsp" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">Register</a>
    </div>
  </div>
</nav>
<!-- Login Form -->
<div class="container mx-auto p-4 mt-20">
  <div class="bg-white p-6 rounded shadow-md w-full max-w-md mx-auto">
    <h2 class="text-2xl font-bold mb-4 text-center">Admin Login</h2>
    <% String error = (String) session.getAttribute("error");
      if (error != null) { %>
    <p class="text-red-500 text-center mb-4"><%= error %></p>
    <% session.removeAttribute("error"); } %>
    <form action="adminLogin" method="post">
      <div class="mb-4">
        <label for="email" class="block text-gray-700">Email</label>
        <input type="email" id="email" name="email" class="w-full p-2 border rounded" required>
      </div>
      <div class="mb-4">
        <label for="password" class="block text-gray-700">Password</label>
        <input type="password" id="password" name="password" class="w-full p-2 border rounded" required>
      </div>
      <button type="submit" class="w-full bg-blue-500 text-white p-2 rounded hover:bg-blue-600">Login</button>
    </form>
    <p class="text-center mt-4">
      <a href="login.jsp" class="text-blue-500 hover:underline">Back to User Login</a>
    </p>
  </div>
</div>
</body>
</html>
