<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en-US">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Elite Car Services - Login</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 flex items-center justify-center min-h-screen">
<nav class="bg-white p-4 shadow-md w-full">
  <div class="container mx-auto flex justify-between items-center">
    <a href="index.jsp" class="text-3xl font-bold text-red-800 flex items-center">
      <img src="images/logo.jpg" alt="Elite Car Services Logo" class="h-12 w-auto mr-2">
      <h3>Elite Car Services</h3>
    </a>
    <div class="space-x-4">
      <a href="index.jsp" class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700">Home</a>
      <a href="adminRegister.jsp" class="bg-yellow-600 text-white px-4 py-2 rounded hover:bg-yellow-700">Register</a>
    </div>
  </div>
</nav>
<div class="bg-white p-6 rounded shadow-md w-full max-w-md mt-10">
  <h2 class="text-2xl font-bold text-center text-red-800 mb-6">Login</h2>
  <%
    String error = (String) session.getAttribute("error");
    if (error != null) {
  %>
  <p class="text-center text-red-600 mb-4"><%= error %></p>
  <%
      session.removeAttribute("error");
    }
  %>
  <form action="<%= request.getContextPath() %>/login" method="post" class="space-y-4">
    <div>
      <label for="email" class="block text-gray-700">Email</label>
      <input type="email" id="email" name="email" class="w-full p-2 border border-gray-300 rounded bg-white" required>
    </div>
    <div>
      <label for="password" class="block text-gray-700">Password</label>
      <input type="password" id="password" name="password" class="w-full p-2 border border-gray-300 rounded bg-white" required>
    </div>
    <div class="text-center">
      <a href="forgotPassword.jsp" class="text-red-600 hover:underline">Forgot Password?</a>
    </div>
    <div class="text-center">
      <a href="adminLogin.jsp" class="text-red-600 hover:underline">Are you an Admin? Login from here</a>
    </div>
    <button type="submit" class="w-full bg-red-600 text-white p-2 rounded hover:bg-red-700">Login</button>
    <p class="text-center mt-2">Don't have an account? <a href="register.jsp" class="text-red-600 hover:underline">Register</a></p>
  </form>
</div>
</body>
</html>