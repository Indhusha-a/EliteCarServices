<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en-US">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Elite Car Services - Edit User</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
<!-- Navigation Bar -->
<nav class="bg-white p-4 shadow-md w-full fixed top-0">
  <div class="container mx-auto flex justify-between items-center">
    <a href="dashboard.jsp" class="text-3xl font-bold text-gray-800 flex items-center">
      <img src="images/logo.jpg" alt="Elite Car Services Logo" class="h-12 w-auto mr-2">
      <h3>Elite Car Services</h3>
    </a>
    <div>
      <a href="logout" class="inline-block bg-red-600 text-white px-4 py-2 rounded-md font-semibold hover:bg-red-700 transition">Logout</a>
    </div>
  </div>
</nav>
<!-- Edit Form -->
<div class="bg-white p-6 rounded shadow-md w-full max-w-md mt-20">
  <h2 class="text-2xl font-bold text-center mb-6">Edit User</h2>
  <%
    String userData = (String) request.getAttribute("userData");
    String name = "";
    String email = "";
    String phone = "";
    if (userData != null) {
      String[] parts = userData.split(",");
      if (parts.length >= 3) {
        name = parts[0];
        email = parts[1];
        phone = parts[2];
      }
    }
  %>
  <form action="EditUserServlet" method="post" class="space-y-4">
    <input type="hidden" name="oldEmail" value="<%= email %>">
    <div>
      <label for="name" class="block text-gray-700">Name</label>
      <input type="text" id="name" name="name" class="w-full p-2 border rounded" value="<%= name %>" required>
    </div>
    <div>
      <label for="email" class="block text-gray-700">Email</label>
      <input type="email" id="email" name="email" class="w-full p-2 border rounded" value="<%= email %>" required>
    </div>
    <div>
      <label for="phone" class="block text-gray-700">Phone Number</label>
      <input type="text" id="phone" name="phone" class="w-full p-2 border rounded" value="<%= phone %>" required>
    </div>
    <button type="submit" class="w-full bg-blue-500 text-white p-2 rounded hover:bg-blue-600">Save Changes</button>
  </form>
</div>
</body>
</html>
