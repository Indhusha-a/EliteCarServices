<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Elite Car Services - Register</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<nav class="bg-white p-4 shadow-md">
  <div class="container mx-auto flex justify-between items-center">
    <a href="index.jsp" class="text-3xl font-bold text-gray-800 flex items-center">
      <img src="images/logo.jpg" alt="Elite Car Services Logo" class="h-12 w-auto">
      <h3> Elite Car Services </h3>
    </a>
    <div>
      <a href="index.jsp" class="bg-orange-500 text-white px-6 py-3 rounded hover:bg-blue-600">Home</a>
      <a href="login.jsp" class="bg-blue-500 text-white px-6 py-3 rounded hover:bg-blue-600">Login</a>
    </div>
  </div>
</nav>
<div class="container mx-auto p-6 flex justify-center">
  <div class="bg-white p-6 rounded shadow-md w-full max-w-md">
    <h2 class="text-2xl font-bold mb-4 text-center">Register</h2>
    <%
      String error = (String) session.getAttribute("error");
      if (error != null) {
    %>
    <p class="text-center text-red-500 mb-4"><%= error %></p>
    <%
        session.removeAttribute("error");
      }
    %>
    <form action="register" method="post">
      <div class="mb-4">
        <label for="name" class="block text-gray-700">Name</label>
        <input type="text" id="name" name="name" class="w-full p-2 border rounded" required>
      </div>
      <div class="mb-4">
        <label for="email" class="block text-gray-700">Email</label>
        <input type="email" id="email" name="email" class="w-full p-2 border rounded" required>
      </div>
      <div class="mb-4">
        <label for="phoneNumber" class="block text-gray-700">Phone Number</label>
        <input type="text" id="phoneNumber" name="phoneNumber" class="w-full p-2 border rounded" required>
      </div>
      <div id="carFields">
        <div class="car-entry mb-4">
          <label class="block text-gray-700">Car 1</label>
          <div class="flex space-x-2">
            <input type="text" name="carModel" placeholder="Car Model" class="w-2/3 p-2 border rounded" required>
            <input type="number" name="carYear" placeholder="Car Year" class="w-1/3 p-2 border rounded" required>
          </div>
        </div>
      </div>
      <button type="button" id="addCar" class="mb-4 bg-gray-500 text-white p-2 rounded hover:bg-gray-600">Add Another Car</button>
      <div class="mb-4">
        <label for="password" class="block text-gray-700">Password</label>
        <input type="password" id="password" name="password" class="w-full p-2 border rounded" required>
      </div>
      <div class="mb-4">
        <label for="confirmPassword" class="block text-gray-700">Confirm Password</label>
        <input type="password" id="confirmPassword" name="confirmPassword" class="w-full p-2 border rounded" required>
      </div>
      <button type="submit" class="w-full bg-blue-500 text-white p-2 rounded hover:bg-blue-600">Register</button>
    </form>
  </div>
</div>
<script>
  document.getElementById('addCar').addEventListener('click', function() {
    const carFields = document.getElementById('carFields');
    const carCount = carFields.getElementsByClassName('car-entry').length + 1;
    const newCarEntry = document.createElement('div');
    newCarEntry.className = 'car-entry mb-4';
    newCarEntry.innerHTML = `
                <label class="block text-gray-700">Car ${carCount}</label>
                <div class="flex space-x-2">
                    <input type="text" name="carModel" placeholder="Car Model" class="w-2/3 p-2 border rounded" required>
                    <input type="number" name="carYear" placeholder="Car Year" class="w-1/3 p-2 border rounded" required>
                </div>
            `;
    carFields.appendChild(newCarEntry);
  });
</script>
</body>
</html>
