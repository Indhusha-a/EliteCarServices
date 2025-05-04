<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en-US">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Elite Car Services - Admin Register</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
<!-- Navigation Bar -->
<nav class="bg-white p-4 shadow-md w-full fixed top-0">
  <div class="container mx-auto flex justify-between items-center">
    <a href="index.jsp" class="text-3xl font-bold text-gray-800 flex items-center">
      <img src="images/logo.jpg" alt="Elite Car Services Logo" class="h-12 w-auto mr-2">
      <h3>Elite Car Services</h3>
    </a>
    <div class="space-x-4">
      <a href="index.jsp" class="bg-orange-500 text-white px-4 py-2 rounded hover:bg-orange-600">Home</a>
      <a href="login.jsp" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Login</a>
    </div>
  </div>
</nav>
<!-- Register Form -->
<div class="bg-white p-6 rounded shadow-md w-full max-w-md mt-20">
  <h2 class="text-2xl font-bold text-center mb-6">Admin Register</h2>
  <form action="adminRegister" method="post" class="space-y-4">
    <div>
      <label for="name" class="block text-gray-700">Name</label>
      <input type="text" id="name" name="name" class="w-full p-2 border rounded" required>
    </div>
    <div>
      <label for="idNumber" class="block text-gray-700">ID Number</label>
      <input type="text" id="idNumber" name="idNumber" class="w-full p-2 border rounded" required>
    </div>
    <div>
      <label for="contactNumber" class="block text-gray-700">Contact Number</label>
      <input type="text" id="contactNumber" name="contactNumber" class="w-full p-2 border rounded" required>
    </div>
    <div>
      <label for="email" class="block text-gray-700">Email</label>
      <input type="email" id="email" name="email" class="w-full p-2 border rounded" required>
    </div>
    <div>
      <label for="password" class="block text-gray-700">Password</label>
      <input type="password" id="password" name="password" class="w-full p-2 border rounded" required>
    </div>
    <div>
      <label for="confirmPassword" class="block text-gray-700">Confirm Password</label>
      <input type="password" id="confirmPassword" name="confirmPassword" class="w-full p-2 border rounded" required>
    </div>
    <button type="submit" class="w-full bg-blue-500 text-white p-2 rounded hover:bg-blue-600">Register</button>
  </form>
</div>
</body>
</html>