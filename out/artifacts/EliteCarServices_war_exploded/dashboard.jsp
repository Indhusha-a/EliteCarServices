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
        <a href="index.jsp" class="text-xl font-bold text-gray-800">Elite Car Services</a>
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
    <div class="bg-white p-6 rounded shadow-md">
        <h2 class="text-xl font-bold mb-4">Your Cars</h2>
        <%
            for (Car car : user.getCars()) {
        %>
        <p><strong>Model:</strong> <%= car.getModel() %> | <strong>Year:</strong> <%= car.getYear() %></p>
        <%
            }
        %>
    </div>
</div>
</body>
</html>