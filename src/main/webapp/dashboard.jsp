<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.elitecarservices.model.User" %>
<%@ page import="com.elitecarservices.model.Admin" %>
<%@ page import="com.elitecarservices.model.Car" %>
<%@ page import="java.io.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Elite Car Services - Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .dropdown {
            position: relative;
            display: inline-block;
        }
        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
            right: 0;
        }
        .dropdown:hover .dropdown-content {
            display: block;
        }
        .dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }
        .dropdown-content a:hover {
            background-color: #f1f1f1;
        }
    </style>
</head>
<body class="bg-gray-100">
<!-- Authentication Check -->
<%
    User user = (User) session.getAttribute("user");
    Admin admin = (Admin) session.getAttribute("admin");
    if (user == null && admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!-- Navigation Bar -->
<nav class="bg-white p-4 shadow-md w-full">
    <div class="container mx-auto flex justify-between items-center">
        <a href="dashboard.jsp" class="text-3xl font-bold text-gray-800 flex items-center">
            <img src="images/logo.jpg" alt="Elite Car Services Logo" class="h-12 w-auto mr-2">
            <h3>Elite Car Services</h3>
        </a>
        <div class="space-x-4">
            <a href="logout" class="inline-block bg-red-600 text-white px-4 py-2 rounded-md font-semibold hover:bg-red-700 transition" aria-label="log out of your account">Logout</a>
            <% if (user != null) { %>
            <div class="dropdown">
                <button class="inline-block bg-gray-600 text-white px-4 py-2 rounded-md font-semibold hover:bg-gray-700 transition">Services</button>
                <div class="dropdown-content">
                    <a href="econoPlus.jsp">Econo Plus</a>
                    <a href="autoServicePlus.jsp">Auto Service Plus</a>
                    <a href="euroTotalPlus.jsp">Euro Total Plus</a>
                    <a href="totalCarePlus.jsp">Total Care Plus</a>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</nav>
<!-- Main Content -->
<div class="container mx-auto p-6">
    <h1 class="text-3xl font-bold mb-6">Welcome, <% if (admin != null) out.print(admin.getName()); else out.print(user.getName()); %>!</h1>
    <div class="bg-white p-6 rounded shadow-md mb-6">
        <h2 class="text-xl font-bold mb-4">Your Profile</h2>
        <p><strong>Email:</strong> <% if (admin != null) out.print(admin.getEmail()); else out.print(user.getEmail()); %></p>
        <p><strong>Phone Number:</strong> <% if (admin != null) out.print(admin.getContactNumber()); else out.print(user.getPhoneNumber()); %></p>
    </div>
    <% if (user != null) { %>
    <div class="bg-white p-6 rounded shadow-md mb-6">
        <h2 class="text-xl font-bold mb-4">Your Cars</h2>
        <% if (user.getCars() != null && !user.getCars().isEmpty()) { %>
        <ul class="list-disc pl-5">
            <% for (Car car : user.getCars()) { %>
            <li>Model: <%= car.getModel() %> | Year: <%= car.getYear() %></li>
            <% } %>
        </ul>
        <% } else { %>
        <p>No cars added yet.</p>
        <% } %>
        <form action="dashboard" method="post" class="mt-4">
            <div class="flex space-x-4">
                <input type="text" name="carModel" placeholder="Car Model" class="p-2 border rounded">
                <input type="number" name="carYear" placeholder="Car Year" class="p-2 border rounded" min="1900" max="2025">
                <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Car</button>
            </div>
        </form>
    </div>
    <div class="bg-white p-6 rounded shadow-md mb-6">
        <h2 class="text-xl font-bold mb-4">Order Packages</h2>
        <div class="flex space-x-4">
            <a href="econoPlus.jsp" class="inline-block bg-gray-200 text-gray-800 px-6 py-3 rounded-md font-semibold hover:bg-gray-300 transition">Econo Plus</a>
            <a href="autoServicePlus.jsp" class="inline-block bg-gray-200 text-gray-800 px-6 py-3 rounded-md font-semibold hover:bg-gray-300 transition">Auto Service Plus</a>
            <a href="euroTotalPlus.jsp" class="inline-block bg-gray-200 text-gray-800 px-6 py-3 rounded-md font-semibold hover:bg-gray-300 transition">Euro Total Plus</a>
            <a href="totalCarePlus.jsp" class="inline-block bg-gray-200 text-gray-800 px-6 py-3 rounded-md font-semibold hover:bg-gray-300 transition">Total Care Plus</a>
        </div>
    </div>
    <% } %>
    <!-- Admin Functionalities -->
    <% if (admin != null) { %>
    <!-- Manage Users -->
    <div class="bg-white p-6 rounded shadow-md mb-6">
        <h2 class="text-xl font-bold mb-4">Manage Users</h2>
        <table class="w-full table-auto">
            <thead>
            <tr class="bg-gray-200">
                <th class="px-4 py-2">Name</th>
                <th class="px-4 py-2">Email</th>
                <th class="px-4 py-2">Phone</th>
                <th class="px-4 py-2">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                File file = new File(application.getRealPath("/WEB-INF/users.txt"));
                if (file.exists()) {
                    BufferedReader reader = new BufferedReader(new FileReader(file));
                    String line;
                    while ((line = reader.readLine()) != null) {
                        String[] parts = line.split(",");
                        if (parts.length >= 3) {
                            String name = parts[0];
                            String email = parts[1];
                            String phone = parts[2];
            %>
            <tr>
                <td class="border px-4 py-2"><%= name %></td>
                <td class="border px-4 py-2"><%= email %></td>
                <td class="border px-4 py-2"><%= phone %></td>
                <td class="border px-4 py-2">
                    <form action="EditUserServlet" method="get" class="inline">
                        <input type="hidden" name="email" value="<%= email %>">
                        <button type="submit" class="bg-blue-500 text-white px-2 py-1 rounded hover:bg-blue-600">Edit</button>
                    </form>
                    <form action="RemoveUserServlet" method="post" class="inline">
                        <input type="hidden" name="email" value="<%= email %>">
                        <button type="submit" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Remove</button>
                    </form>
                </td>
            </tr>
            <%
                        }
                    }
                    reader.close();
                }
            %>
            </tbody>
        </table>
    </div>
    <!-- Manage Packages -->
    <div class="bg-white p-6 rounded shadow-md mb-6">
        <h2 class="text-xl font-bold mb-4">Manage Packages</h2>
        <!-- Add Package -->
        <form action="ManagePackagesServlet" method="post" class="mb-6">
            <input type="hidden" name="action" value="add">
            <div class="mb-4">
                <label for="packageName" class="block text-gray-700">Package Name</label>
                <input type="text" id="packageName" name="packageName" class="w-full p-2 border rounded" required>
            </div>
            <div class="mb-4">
                <label for="packageDescription" class="block text-gray-700">Description</label>
                <textarea id="packageDescription" name="packageDescription" class="w-full p-2 border rounded" required></textarea>
            </div>
            <button type="submit" class="bg-blue-500 text-white p-2 rounded hover:bg-blue-600">Add Package</button>
        </form>
        <!-- List Packages -->
        <table class="w-full table-auto">
            <thead>
            <tr class="bg-gray-200">
                <th class="px-4 py-2">Package Name</th>
                <th class="px-4 py-2">Description</th>
                <th class="px-4 py-2">Action</th>
            </tr>
            </thead>
            <tbody>
            <%
                File packagesFile = new File(application.getRealPath("/WEB-INF/packages.txt"));
                if (packagesFile.exists()) {
                    BufferedReader reader = new BufferedReader(new FileReader(packagesFile));
                    String line;
                    while ((line = reader.readLine()) != null) {
                        String[] parts = line.split("\\|");
                        if (parts.length >= 2) {
                            String name = parts[0];
                            String description = parts[1];
            %>
            <tr>
                <td class="border px-4 py-2"><%= name %></td>
                <td class="border px-4 py-2"><%= description %></td>
                <td class="border px-4 py-2">
                    <form action="ManagePackagesServlet" method="post">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="packageName" value="<%= name %>">
                        <button type="submit" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Remove</button>
                    </form>
                </td>
            </tr>
            <%
                        }
                    }
                    reader.close();
                }
            %>
            </tbody>
        </table>
    </div>
    <% } %>
</div>
</body>
</html>