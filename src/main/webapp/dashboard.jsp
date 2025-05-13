<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.elitecarservices.model.User" %>
<%@ page import="com.elitecarservices.model.Car" %>
<%@ page import="com.elitecarservices.model.ServiceRecord" %>
<%@ page import="com.elitecarservices.model.ServiceHistory" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.LinkedList" %>
<html>
<head>
    <title>Elite Car Services - Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes fadeInRight {
            from { opacity: 0; transform: translateX(30px); }
            to { opacity: 1; transform: translateX(0); }
        }
        .animate-fadeInRight-1 {
            animation: fadeInRight 1.2s ease-out 0.3s forwards;
        }
        .animate-fadeInRight-2 {
            animation: fadeInRight 1.2s ease-out 0.6s forwards;
        }
        .animate-fadeInRight-3 {
            animation: fadeInRight 1.2s ease-out 0.9s forwards;
        }
        .animate-fadeInRight-4 {
            animation: fadeInRight 1.2s ease-out 1.2s forwards;
        }
        .animate-fadeInRight-5 {
            animation: fadeInRight 1.2s ease-out 1.5s forwards;
        }
    </style>
</head>
<body class="bg-blue-100">
<%
    User user = (User) session.getAttribute("user");
    com.elitecarservices.model.Admin admin = (com.elitecarservices.model.Admin) session.getAttribute("admin");
    if (user == null && admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (admin != null) {
        response.sendRedirect("adminDashboard.jsp");
        return;
    }
%>
<!-- Navigation Bar -->
<nav class="bg-white p-4 shadow-md w-full fixed top-0 z-10">
    <div class="container mx-auto flex justify-between items-center">
        <a href="dashboard.jsp" class="text-3xl font-bold text-gray-800 flex items-center">
            <img src="images/logo.jpg" alt="Elite Car Services Logo" class="h-12 w-auto">
            <h3> Elite Car Services </h3>
        </a>
        <div>
            <a href="logout" class="inline-block bg-red-600 text-white px-4 py-2 rounded-md font-semibold hover:bg-red-700 transition" aria-label="Log out of your account">Logout</a>
        </div>
    </div>
</nav>
<div class="container mx-auto p-6 mt-20">
    <h1 class="text-3xl font-bold mb-6">Welcome, <%= user.getName() %>!</h1>

    <!-- Profile Section -->
    <div class="bg-white p-6 rounded shadow-md mb-6 animate-fadeInRight-1">
        <h2 class="text-xl font-bold mb-4">Your Profile</h2>
        <p><strong>Email:</strong> <%= user.getEmail() %></p>
        <p><strong>Phone Number:</strong> <%= user.getPhoneNumber() %></p>
        <form action="login" method="post" class="mt-4">
            <input type="hidden" name="action" value="updateProfile">
            <div class="flex space-x-2 mb-4">
                <input type="email" name="email" placeholder="New Email" value="<%= user.getEmail() %>" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" class="w-1/2 p-2 border rounded" required>
                <input type="text" name="phone" placeholder="New Phone Number" value="<%= user.getPhoneNumber() %>" pattern="\d{10,15}" class="w-1/2 p-2 border rounded" required>
            </div>
            <button type="submit" class="bg-green-500 text-white p-2 rounded hover:bg-green-600">Update Profile</button>
        </form>
        <div id="profile-messages" class="mt-2">
            <%
                String profileMessage = (String) session.getAttribute("message");
                String profileError = (String) session.getAttribute("error");
                if (profileMessage != null && profileMessage.contains("Profile")) {
            %>
            <p class="text-green-500 transition-opacity duration-500"><%= profileMessage %></p>
            <%
                    session.removeAttribute("message");
                }
                if (profileError != null && (profileError.contains("email") || profileError.contains("Phone"))) {
            %>
            <p class="text-red-500 transition-opacity duration-500"><%= profileError %></p>
            <%
                    session.removeAttribute("error");
                }
            %>
        </div>
    </div>

    <!-- Cars Section -->
    <div class="bg-white p-6 rounded shadow-md mb-6 animate-fadeInRight-2">
        <h2 class="text-xl font-bold mb-4">Your Cars</h2>
        <%
            for (int i = 0; i < user.getCars().size(); i++) {
                Car car = user.getCars().get(i);
        %>
        <div class="flex justify-between items-center mb-2">
            <p><strong>Model:</strong> <%= car.getModel() %> | <strong>Year:</strong> <%= car.getYear() %></p>
            <form action="login" method="post">
                <input type="hidden" name="action" value="deleteCar">
                <input type="hidden" name="carIndex" value="<%= i %>">
                <button type="submit" class="bg-red-500 text-white p-1 rounded hover:bg-red-600">Delete</button>
            </form>
        </div>
        <% } %>
        <form action="login" method="post" class="mt-4">
            <input type="hidden" name="action" value="addCar">
            <div class="flex space-x-2 mb-4">
                <input type="text" name="carModel" placeholder="Car Model" class="w-2/3 p-2 border rounded" required>
                <input type="number" name="carYear" placeholder="Car Year" min="1900" max="2026" class="w-1/3 p-2 border rounded" required>
            </div>
            <button type="submit" class="bg-blue-500 text-white p-2 rounded hover:bg-blue-600">Add Car</button>
        </form>
        <div id="car-messages" class="mt-2">
            <%
                if (profileMessage != null && (profileMessage.contains("Car added") || profileMessage.contains("Car deleted"))) {
            %>
            <p class="text-green-500 transition-opacity duration-500"><%= profileMessage %></p>
            <%
                    session.removeAttribute("message");
                }
                if (profileError != null && (profileError.contains("car") || profileError.contains("Car"))) {
            %>
            <p class="text-red-500 transition-opacity duration-500"><%= profileError %></p>
            <%
                    session.removeAttribute("error");
                }
            %>
        </div>
    </div>

    <!-- Order Packages Section -->
    <div class="bg-white p-6 rounded shadow-md mb-6 animate-fadeInRight-3">
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

    <!-- Service History Section -->
    <div class="bg-white p-6 rounded shadow-md mb-6 animate-fadeInRight-4">
        <h2 class="text-xl font-bold mb-4">Service History</h2>
        <%
            ServiceHistory history = new ServiceHistory();
            String bookingsFilePath = application.getRealPath("/WEB-INF/bookings.txt");
            boolean hasError = false;
            try (BufferedReader reader = new BufferedReader(new FileReader(bookingsFilePath))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] data = line.split(",");
                    if (data.length >= 9 && data[1].equals(user.getEmail())) {
                        String date = data[4];
                        String packageName = data[7];
                        String carDetails = data[8];
                        String[] carEntries = carDetails.split(";");
                        for (String carEntry : carEntries) {
                            String[] carData = carEntry.split(":");
                            if (carData.length >= 3) {
                                String vehicle = carData[0] + ":" + carData[1];
                                String mileage = carData[2];
                                history.addRecord(new ServiceRecord(date, mileage, vehicle, packageName));
                            }
                        }
                    }
                }
            } catch (IOException e) {
                hasError = true;
            }
            if (hasError) {
        %>
        <p class="text-red-500">Error loading service history.</p>
        <%
        } else {
            history.sortByDate();
            LinkedList<ServiceRecord> records = history.getRecords();
            if (records.isEmpty()) {
        %>
        <p>No service history available.</p>
        <%
        } else {
        %>
        <table class="w-full border-collapse border border-gray-300">
            <thead>
            <tr class="bg-gray-200">
                <th class="border border-gray-300 p-2">Date</th>
                <th class="border border-gray-300 p-2">Mileage</th>
                <th class="border border-gray-300 p-2">Vehicle</th>
                <th class="border border-gray-300 p-2">Service</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (ServiceRecord record : records) {
            %>
            <tr>
                <td class="border border-gray-300 p-2"><%= record.getDate() %></td>
                <td class="border border-gray-300 p-2"><%= record.getMileage() %></td>
                <td class="border border-gray-300 p-2"><%= record.getVehicle() %></td>
                <td class="border border-gray-300 p-2"><%= record.getService() %></td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
        <%
                }
            }
        %>
        <h3 class="text-lg font-semibold mt-6 mb-2">Add Service History</h3>
        <form action="serviceHistory" method="post" class="mt-4">
            <div class="mb-4">
                <label for="date" class="block text-gray-700">Date</label>
                <input type="date" id="date" name="date" class="w-full p-2 border rounded" required>
            </div>
            <div class="mb-4">
                <label for="mileage" class="block text-gray-700">Mileage</label>
                <input type="number" id="mileage" name="mileage" class="w-full p-2 border rounded" required>
            </div>
            <div class="mb-4">
                <label for="vehicle" class="block text-gray-700">Vehicle</label>
                <select id="vehicle" name="vehicle" class="w-full p-2 border rounded" required>
                    <%
                        for (Car car : user.getCars()) {
                    %>
                    <option value="<%= car.getModel() + ":" + car.getYear() %>"><%= car.getModel() %> (<%= car.getYear() %>)</option>
                    <%
                        }
                    %>
                </select>
            </div>
            <div class="mb-4">
                <label for="service" class="block text-gray-700">Service</label>
                <select id="service" name="service" class="w-full p-2 border rounded" required>
                    <option value="Econo Plus">Econo Plus</option>
                    <option value="Auto Service Plus">Auto Service Plus</option>
                    <option value="Euro Total Plus">Euro Total Plus</option>
                    <option value="Total Care Plus">Total Care Plus</option>
                    <option value="Other">Other</option>
                </select>
            </div>
            <button type="submit" class="bg-blue-500 text-white p-2 rounded hover:bg-blue-600">Add Service Record</button>
        </form>
        <div id="service-messages" class="mt-2">
            <%
                if (profileMessage != null && profileMessage.contains("Service history")) {
            %>
            <p class="text-green-500 transition-opacity duration-500"><%= profileMessage %></p>
            <%
                    session.removeAttribute("message");
                }
                if (profileError != null && profileError.contains("Service history")) {
            %>
            <p class="text-red-500 transition-opacity duration-500"><%= profileError %></p>
            <%
                    session.removeAttribute("error");
                }
            %>
        </div>
    </div>

    <!-- Feedback and Review Management Section -->
    <div class="bg-white p-6 rounded shadow-md mb-6 animate-fadeInRight-5">
        <h2 class="text-xl font-bold mb-4">Feedback and Review Management</h2>
        <a href="feedback.jsp" class="bg-blue-500 text-white p-2 rounded hover:bg-blue-600">Submit Feedback</a>
    </div>
</div>

<!-- JavaScript for Messages -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const profileMessages = document.getElementById('profile-messages');
        const carMessages = document.getElementById('car-messages');
        const serviceMessages = document.getElementById('service-messages');

        // Hide messages after 3 seconds
        function hideMessages(container) {
            if (container && container.querySelector('p')) {
                setTimeout(() => {
                    container.querySelector('p').style.opacity = '0';
                    setTimeout(() => {
                        container.querySelector('p').remove();
                    }, 500);
                }, 3000);
            }
        }

        hideMessages(profileMessages);
        hideMessages(carMessages);
        hideMessages(serviceMessages);
    });
</script>
</body>
</html>