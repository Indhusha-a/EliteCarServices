<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.elitecarservices.model.User" %>
<%@ page import="com.elitecarservices.model.Car" %>
<%@ page import="com.elitecarservices.model.ServiceRequest" %>
<%@ page import="com.elitecarservices.model.ServiceRequestList" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.IOException" %>
<html>
<head>
    <title>Elite Car Services - Admin Dashboard</title>
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
    com.elitecarservices.model.Admin admin = (com.elitecarservices.model.Admin) session.getAttribute("admin");
    if (admin == null) {
        session.setAttribute("error", "You must be logged in as an admin to access this page.");
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    // Load users from users.txt
    LinkedList<User> users = new LinkedList<>();
    String errorMessage = null;
    String usersFilePath = application.getRealPath("/WEB-INF/users.txt");
    File usersFile = new File(usersFilePath);
    try {
        if (!usersFile.exists()) {
            usersFile.getParentFile().mkdirs();
            usersFile.createNewFile();
        }
        try (BufferedReader reader = new BufferedReader(new FileReader(usersFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userData = line.split(",");
                if (userData.length < 5) continue;
                LinkedList<Car> cars = new LinkedList<>();
                if (userData[3] != null && !userData[3].trim().isEmpty()) {
                    String[] carData = userData[3].split(";");
                    for (String car : carData) {
                        if (car.trim().isEmpty()) continue;
                        String[] carDetails = car.split(":");
                        if (carDetails.length == 2) {
                            try {
                                int year = Integer.parseInt(carDetails[1]);
                                cars.add(new Car(carDetails[0], year));
                            } catch (NumberFormatException e) {
                                // Skip invalid car entries
                            }
                        }
                    }
                }
                users.add(new User(userData[0], userData[1], userData[2], cars, userData[4]));
            }
        }
    } catch (IOException e) {
        errorMessage = "Error loading users: " + e.getMessage();
    }

    // Load feedback from feedback.txt
    ArrayList<String[]> feedbackList = new ArrayList<>();
    String feedbackFilePath = application.getRealPath("/WEB-INF/feedback.txt");
    File feedbackFile = new File(feedbackFilePath);
    if (feedbackFile.exists()) {
        try (BufferedReader reader = new BufferedReader(new FileReader(feedbackFilePath))) {
            String line;
            String userName = null;
            String email = null;
            String packageName = null;
            String feedbackText = null;
            String date = null;
            int lineCount = 0;
            while ((line = reader.readLine()) != null) {
                if (line.startsWith("UserName: ")) {
                    userName = line.substring(10);
                    lineCount = 1;
                } else if (line.startsWith("Email: ") && lineCount == 1) {
                    email = line.substring(7);
                    lineCount = 2;
                } else if (line.startsWith("Package: ") && lineCount == 2) {
                    packageName = line.substring(9);
                    lineCount = 3;
                } else if (line.startsWith("Feedback: ") && lineCount == 3) {
                    feedbackText = line.substring(10);
                    lineCount = 4;
                } else if (line.startsWith("Date: ") && lineCount == 4) {
                    date = line.substring(6);
                    if (userName != null && email != null && packageName != null && feedbackText != null && date != null) {
                        feedbackList.add(new String[]{userName, email, packageName, feedbackText, date});
                    }
                    lineCount = 0;
                }
            }
        } catch (IOException e) {
            errorMessage = errorMessage != null ? errorMessage + "; Error loading feedback: " + e.getMessage() : "Error loading feedback: " + e.getMessage();
        }
    }
%>
<!-- Navigation Bar -->
<nav class="bg-white p-6 shadow-md fixed top-0 w-full z-10">
    <div class="container mx-auto flex justify-between items-center">
        <a href="adminDashboard.jsp" class="flex items-center">
            <img src="images/logo.jpg" alt="Elite Car Services Logo" class="h-10 w-auto mr-2">
            <h3 class="text-2xl font-bold text-gray-800">Elite Car Services</h3>
        </a>
        <div class="flex flex-col sm:flex-row gap-4">
            <a href="adminRegister.jsp" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Register New Admin</a>
            <a href="logout" class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700">Logout</a>
        </div>
    </div>
</nav>
<div class="container mx-auto p-6 mt-20">
    <h1 class="text-3xl font-bold mb-6">Welcome, <%= admin.getName() != null ? admin.getName() : "Admin" %>!</h1>

    <!-- Messages -->
    <div id="messages" class="mb-6 animate-fadeInRight-1">
        <%
            String sessionMessage = (String) session.getAttribute("message");
            String sessionError = (String) session.getAttribute("error");
            if (sessionMessage != null && !sessionMessage.contains("Service")) {
        %>
        <p class="text-green-500 transition-opacity duration-500"><%= sessionMessage %></p>
        <%
                session.removeAttribute("message");
            }
            if (sessionError != null && !sessionError.contains("Service")) {
        %>
        <p class="text-red-500 transition-opacity duration-500"><%= sessionError %></p>
        <%
                session.removeAttribute("error");
            }
            if (errorMessage != null) {
        %>
        <p class="text-red-500 transition-opacity duration-500"><%= errorMessage %></p>
        <% } %>
    </div>

    <!-- Users Table -->
    <div class="bg-white p-6 rounded-lg shadow-lg mb-6 animate-fadeInRight-2">
        <h2 class="text-xl font-bold mb-4">Manage Users</h2>
        <div class="overflow-x-auto">
            <table class="w-full table-auto border-collapse">
                <thead>
                <tr class="bg-gray-200">
                    <th class="px-4 py-2 text-left">Name</th>
                    <th class="px-4 py-2 text-left">Email</th>
                    <th class="px-4 py-2 text-left">Phone Number</th>
                    <th class="px-4 py-2 text-left">Cars</th>
                    <th class="px-4 py-2 text-left">Actions</th>
                </tr>
                </thead>
                <tbody>
                <% if (users.isEmpty()) { %>
                <tr>
                    <td colspan="5" class="px-4 py-2 text-center text-gray-500">No users found.</td>
                </tr>
                <% } else { %>
                <% for (User user : users) { %>
                <tr class="border-b">
                    <td class="px-4 py-2"><%= user.getName() != null ? user.getName() : "N/A" %></td>
                    <td class="px-4 py-2"><%= user.getEmail() != null ? user.getEmail() : "N/A" %></td>
                    <td class="px-4 py-2"><%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "N/A" %></td>
                    <td class="px-4 py-2">
                        <%
                            LinkedList<Car> userCars = user.getCars();
                            if (userCars == null || userCars.isEmpty()) {
                                out.print("No cars");
                            } else {
                                for (Car car : userCars) {
                                    if (car != null) {
                                        out.print(car.getModel() + " (" + car.getYear() + ")<br>");
                                    }
                                }
                            }
                        %>
                    </td>
                    <td class="px-4 py-2 flex space-x-2">
                        <!-- Update Form -->
                        <form action="adminDashboard" method="post" class="flex space-x-2">
                            <input type="hidden" name="action" value="updateUser">
                            <input type="hidden" name="userEmail" value="<%= user.getEmail() != null ? user.getEmail() : "" %>">
                            <input type="text" name="name" value="<%= user.getName() != null ? user.getName() : "" %>" class="p-1 border rounded w-24" required>
                            <input type="email" name="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" class="p-1 border rounded w-32" required>
                            <input type="text" name="phoneNumber" value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>" class="p-1 border rounded w-28" required>
                            <button type="submit" class="bg-blue-500 text-white px-2 py-1 rounded hover:bg-blue-600">Update</button>
                        </form>
                        <!-- Delete Form -->
                        <form action="adminDashboard" method="post">
                            <input type="hidden" name="action" value="deleteUser">
                            <input type="hidden" name="userEmail" value="<%= user.getEmail() != null ? user.getEmail() : "" %>">
                            <button type="submit" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Delete</button>
                        </form>
                    </td>
                </tr>
                <% } %>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Cars Section -->
    <div class="bg-white p-6 rounded-lg shadow-lg mb-6 animate-fadeInRight-3">
        <h2 class="text-xl font-bold mb-4">Manage Cars</h2>
        <% if (users.isEmpty()) { %>
        <p class="text-gray-500">No users or cars found.</p>
        <% } else { %>
        <% for (User user : users) { %>
        <div class="mb-6">
            <h3 class="text-lg font-semibold mb-2">User: <%= user.getName() != null ? user.getName() : "N/A" %> (<%= user.getEmail() != null ? user.getEmail() : "N/A" %>)</h3>
            <%
                LinkedList<Car> userCars = user.getCars();
                if (userCars == null || userCars.isEmpty()) {
            %>
            <p class="text-gray-500 ml-4">No cars registered.</p>
            <%
            } else {
            %>
            <div class="overflow-x-auto">
                <table class="w-full table-auto border-collapse ml-4">
                    <thead>
                    <tr class="bg-gray-200">
                        <th class="px-4 py-2 text-left">Model</th>
                        <th class="px-4 py-2 text-left">Year</th>
                        <th class="px-4 py-2 text-left">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (int i = 0; i < userCars.size(); i++) { %>
                    <% Car car = userCars.get(i); %>
                    <% if (car != null) { %>
                    <tr class="border-b">
                        <td class="px-4 py-2"><%= car.getModel() %></td>
                        <td class="px-4 py-2"><%= car.getYear() %></td>
                        <td class="px-4 py-2">
                            <form action="adminDashboard" method="post">
                                <input type="hidden" name="action" value="deleteCar">
                                <input type="hidden" name="userEmail" value="<%= user.getEmail() != null ? user.getEmail() : "" %>">
                                <input type="hidden" name="carIndex" value="<%= i %>">
                                <button type="submit" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <%
                }
            %>
        </div>
        <% } %>
        <% } %>
    </div>

    <!-- Service Requests Section -->
    <div class="bg-white p-6 rounded-lg shadow-lg mb-6 animate-fadeInRight-4">
        <h2 class="text-xl font-bold mb-4">Service Requests</h2>
        <%
            ServiceRequestList requestList = new ServiceRequestList();
            String bookingsFilePath = application.getRealPath("/WEB-INF/bookings.txt");
            String paymentsFilePath = application.getRealPath("/WEB-INF/payments.txt");
            boolean hasError = false;

            // Load payments into a map for lookup
            java.util.HashMap<String, String> paymentOptions = new java.util.HashMap<>();
            File paymentsFile = new File(paymentsFilePath);
            if (paymentsFile.exists()) {
                try (BufferedReader paymentReader = new BufferedReader(new FileReader(paymentsFilePath))) {
                    String line;
                    while ((line = paymentReader.readLine()) != null) {
                        String[] paymentData = line.split(",");
                        if (paymentData.length >= 9) {
                            String bookingRef = paymentData[8];
                            String paymentOption = paymentData[5];
                            paymentOptions.put(bookingRef, paymentOption);
                        }
                    }
                } catch (IOException e) {
                    hasError = true;
                    errorMessage = errorMessage != null ? errorMessage + "; Error loading payments: " + e.getMessage() : "Error loading payments: " + e.getMessage();
                }
            }

            // Load bookings
            File bookingsFile = new File(bookingsFilePath);
            if (!hasError && bookingsFile.exists()) {
                try (BufferedReader bookingReader = new BufferedReader(new FileReader(bookingsFilePath))) {
                    String line;
                    while ((line = bookingReader.readLine()) != null) {
                        String[] bookingData = line.split(",");
                        if (bookingData.length < 9) continue;
                        String status = bookingData.length > 10 ? bookingData[10] : "pending";

                        String date = bookingData[4];
                        String time = bookingData[5];
                        String branch = bookingData[3];
                        String packageName = bookingData[7];
                        String carDetails = bookingData[8];
                        String bookingReference = bookingData[6];
                        String paymentType = paymentOptions.getOrDefault(bookingReference, "N/A");

                        String[] carEntries = carDetails.split(";");
                        for (String carEntry : carEntries) {
                            String[] carData = carEntry.split(":");
                            if (carData.length >= 3) {
                                String car = carData[0] + ":" + carData[1];
                                String mileage = carData[2];
                                requestList.addRequest(new ServiceRequest(date, time, car, mileage, packageName, branch, paymentType, bookingReference, status));
                            }
                        }
                    }
                } catch (IOException e) {
                    hasError = true;
                    errorMessage = errorMessage != null ? errorMessage + "; Error loading bookings: " + e.getMessage() : "Error loading bookings: " + e.getMessage();
                }
            }

            if (hasError) {
        %>
        <p class="text-red-500">Error loading service requests.</p>
        <%
        } else {
            requestList.sortByDate();
            LinkedList<ServiceRequest> requests = requestList.getRequests();
            if (requests == null || requests.isEmpty()) {
        %>
        <p class="text-gray-500">No service requests found.</p>
        <%
        } else {
        %>
        <div class="overflow-x-auto">
            <table class="w-full table-auto border-collapse">
                <thead>
                <tr class="bg-gray-200">
                    <th class="px-4 py-2 text-left">Date</th>
                    <th class="px-4 py-2 text-left">Time</th>
                    <th class="px-4 py-2 text-left">Car</th>
                    <th class="px-4 py-2 text-left">Mileage</th>
                    <th class="px-4 py-2 text-left">Service</th>
                    <th class="px-4 py-2 text-left">Branch</th>
                    <th class="px-4 py-2 text-left">Payment Type</th>
                    <th class="px-4 py-2 text-left">Action</th>
                </tr>
                </thead>
                <tbody>
                <% for (ServiceRequest req : requests) { %>
                <tr class="border-b">
                    <td class="px-4 py-2"><%= req.getDate() != null ? req.getDate() : "N/A" %></td>
                    <td class="px-4 py-2"><%= req.getTime() != null ? req.getTime() : "N/A" %></td>
                    <td class="px-4 py-2"><%= req.getCar() != null ? req.getCar() : "N/A" %></td>
                    <td class="px-4 py-2"><%= req.getMileage() != null ? req.getMileage() : "N/A" %></td>
                    <td class="px-4 py-2"><%= req.getService() != null ? req.getService() : "N/A" %></td>
                    <td class="px-4 py-2"><%= req.getBranch() != null ? req.getBranch() : "N/A" %></td>
                    <td class="px-4 py-2"><%= req.getPaymentType() != null ? req.getPaymentType() : "N/A" %></td>
                    <td class="px-4 py-2">
                        <form action="markServiceDone" method="post">
                            <input type="hidden" name="bookingReference" value="<%= req.getBookingReference() != null ? req.getBookingReference() : "" %>">
                            <button type="submit" class="<%= req.getStatus() != null && req.getStatus().equals("done") ? "bg-gray-400 text-white px-2 py-1 rounded cursor-not-allowed" : "bg-green-500 text-white px-2 py-1 rounded hover:bg-green-600" %>" <%= req.getStatus() != null && req.getStatus().equals("done") ? "disabled" : "" %>>
                                <%= req.getStatus() != null && req.getStatus().equals("done") ? "Done" : "Mark as Done" %>
                            </button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <%
                }
            }
        %>
    </div>

    <!-- Feedback Management Section -->
    <div class="bg-white p-6 rounded-lg shadow-lg mb-6 animate-fadeInRight-5">
        <h2 class="text-xl font-bold mb-4">Feedback Management</h2>
        <%
            if (feedbackList.isEmpty()) {
        %>
        <p class="text-gray-500">No feedback found.</p>
        <%
        } else {
        %>
        <div class="overflow-x-auto">
            <table class="w-full table-auto border-collapse">
                <thead>
                <tr class="bg-gray-200">
                    <th class="px-4 py-2 text-left">User Name</th>
                    <th class="px-4 py-2 text-left">User Email</th>
                    <th class="px-4 py-2 text-left">Package</th>
                    <th class="px-4 py-2 text-left">Feedback</th>
                    <th class="px-4 py-2 text-left">Date</th>
                </tr>
                </thead>
                <tbody>
                <% for (String[] feedback : feedbackList) { %>
                <tr class="border-b">
                    <td class="px-4 py-2"><%= feedback[0] != null ? feedback[0] : "N/A" %></td>
                    <td class="px-4 py-2"><%= feedback[1] != null ? feedback[1] : "N/A" %></td>
                    <td class="px-4 py-2"><%= feedback[2] != null ? feedback[2] : "N/A" %></td>
                    <td class="px-4 py-2"><%= feedback[3] != null ? feedback[3] : "N/A" %></td>
                    <td class="px-4 py-2"><%= feedback[4] != null ? feedback[4] : "N/A" %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <%
            }
        %>
    </div>
</div>

<!-- JavaScript for hiding messages after 3 seconds -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const messages = document.getElementById('messages');
        if (messages && messages.children.length > 0) {
            setTimeout(() => {
                messages.style.opacity = '0';
                setTimeout(() => {
                    messages.innerHTML = '';
                    messages.style.opacity = '1';
                }, 500);
            }, 3000);
        }
    });
</script>
</body>
</html>