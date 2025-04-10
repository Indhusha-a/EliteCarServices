<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.elitecarservices.model.User" %>
<%@ page import="com.elitecarservices.model.Car" %>
<html>
<head>
    <title>Elite Car Services - Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<nav class="bg-white p-4 shadow-md">
    <div class="container mx-auto flex justify-between items-center">
        <a href="index.jsp" class="text-3xl font-bold text-gray-800 flex items-center">
            <img src="images/logo.jpg" alt="Elite Car Services Logo" width="75" height="15">
            <h3> Elite Car Services </h3>
        </a>
        <div>
            <a href="logout" class="text-blue-500 hover:underline">Logout</a>
        </div>
    </div>
</nav>
<div class="container mx-auto p-6">
    <h1 class="text-3xl font-bold mb-6">Welcome, <%= user.getName() %>!</h1>
    <div class="bg-white p-6 rounded shadow-md mb-6">
        <h2 class="text-xl font-bold mb-4">Your Profile</h2>
        <p><strong>Email:</strong> <%= user.getEmail() %></p>
        <p><strong>Phone Number:</strong> <%= user.getPhoneNumber() %></p>
    </div>
    <div class="bg-white p-6 rounded shadow-md mb-6">
        <h2 class="text-xl font-bold mb-4">Your Cars</h2>
        <%
            String message = (String) session.getAttribute("message");
            if (message != null) {
        %>
        <p class="text-center text-green-500 mb-4"><%= message %></p>
        <%
                session.removeAttribute("message");
            }
            String error = (String) session.getAttribute("error");
            if (error != null) {
        %>
        <p class="text-center text-red-500 mb-4"><%= error %></p>
        <%
                session.removeAttribute("error");
            }
            for (Car car : user.getCars()) {
        %>
        <p><strong>Model:</strong> <%= car.getModel() %> | <strong>Year:</strong> <%= car.getYear() %></p>
        <%
            }
        %>
        <!-- Add Car Form -->
        <form action="login" method="post" class="mt-4">
            <input type="hidden" name="action" value="addCar">
            <div class="flex space-x-2 mb-4">
                <input type="text" name="carModel" placeholder="Car Model" class="w-2/3 p-2 border rounded" required>
                <input type="number" name="carYear" placeholder="Car Year" class="w-1/3 p-2 border rounded" required>
            </div>
            <button type="submit" class="bg-blue-500 text-white p-2 rounded hover:bg-blue-600">Add Car</button>
        </form>
    </div>
    <!-- Order Packages Section -->
    <div class="bg-white p-6 rounded shadow-md mb-6">
        <h2 class="text-xl font-bold mb-4">Order Packages</h2>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <a href="econoPlus.jsp" class="bg-gray-200 p-4 rounded text-center hover:bg-gray-300">
                <h3 class="text-lg font-semibold">Econo Plus</h3>
            </a>
            <a href="autoServicePlus.jsp" class="bg-gray-200 p-4 rounded text-center hover:bg-gray-300">
                <h3 class="text-lg font-semibold">Auto Service Plus</h3>
            </a>
            <a href="euroTotalPlus.jsp" class="bg-gray-200 p-4 rounded text-center hover:bg-gray-300">
                <h3 class="text-lg font-semibold">Euro Total Plus</h3>
            </a>
            <a href="totalCarePlus.jsp" class="bg-gray-200 p-4 rounded text-center hover:bg-gray-300">
                <h3 class="text-lg font-semibold">Total Care Plus</h3>
            </a>
        </div>
    </div>
</div>
</body>
</html>