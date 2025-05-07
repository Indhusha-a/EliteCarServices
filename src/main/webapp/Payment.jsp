<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.elitecarservices.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<html>
<head>
    <title>Elite Car Services - Payment Invoice</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        function toggleBankDetails() {
            const paymentOption = document.querySelector('input[name="paymentOption"]:checked').value;
            const bankDetails = document.getElementById('bankDetails');
            bankDetails.style.display = paymentOption === 'Bank Transfer' ? 'block' : 'none';
        }
    </script>
</head>
<body class="bg-gray-100">
<!-- Navigation Bar -->
<nav class="bg-white p-4 shadow-md">
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
<!-- Main Content -->
<div class="container mx-auto p-6 flex justify-center">
    <div class="bg-white p-6 rounded shadow-md w-full max-w-2xl">
        <h2 class="text-2xl font-bold mb-4 text-center">Payment Invoice</h2>
        <%
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            String error = (String) session.getAttribute("error");
            if (error != null) {
        %>
        <p class="text-center text-red-500 mb-4"><%= error %></p>
        <%
                session.removeAttribute("error");
            }
            String packageName = (String) session.getAttribute("packageName");
            if (packageName == null) {
                packageName = "Unknown";
            }
            String bookingReference = (String) session.getAttribute("bookingReference");
            if (bookingReference == null) {
                bookingReference = "N/A";
            }
            // Set price and description based on package
            int price;
            String description;
            switch (packageName) {
                case "Econo Plus":
                    price = 3500;
                    description = "The Econo Plus package offers comprehensive vehicle care, including: Oil & Filter change with filter inspection;Preventive Maintenance;Wash & Vacuum;Aubrite Top Gloss Liquid Wax;Inspection Report – 17 points;Battery Test Report;Scan Report;Battery Terminal Protector and Door Hinge Treatment";
                    break;
                case "Auto Service Plus":
                    price = 5000;
                    description = "The Auto Service Plus package covers a 61-point inspection checklist for Japanese Non-Hybrid vehicles, including: Oil & Filter change along with filter inspection;Preventive Maintenance;Wash & Vacuum;Aubrite Top Gloss Liquid Wax;Inspection Report -61 points;Battery Test Report;Scan Report;Battery Terminal Protector and Door Hinge Treatment";
                    break;
                case "Euro Total Plus":
                    price = 7000;
                    description = "The Euro Total Plus package brings European quality with a 101-point inspection checklist, including: Oil & Filter change along with filter inspection;Preventive Maintenance;Wash & Vacuum;Aubrite Top Gloss Liquid Wax;Engine Degreaser;UK Standard inspection report -101 points;Battery Test Report;Scan Report;Battery Terminal Protector and Door Hinge Treatment";
                    break;
                case "Total Care Plus":
                    price = 9000;
                    description = "The Total Care Plus package includes a 139-point inspection checklist, ensuring mechanical and cosmetic care, including: Oil & Filter change along with filter inspection;Preventive Maintenance;Wash & Vacuum;Aubrite Carnauba Hand Made Wax;Engine Degreaser;Mini Valet/Leather treatment;UK Standard inspection report -101 points;Battery Test Report;Scan Report;Battery Terminal Protector and Door Hinge Treatment";
                    break;
                default:
                    price = 0;
                    description = "No description available for this package.";
            }
            // Get current date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String invoiceDate = dateFormat.format(new Date());
        %>
        <!-- Invoice Details -->
        <div class="mb-6">
            <h3 class="text-xl font-semibold mb-2">Invoice Details</h3>
            <p><strong>Customer:</strong> <%= user.getName() %></p>
            <p><strong>Email:</strong> <%= user.getEmail() %></p>
            <p><strong>Phone Number:</strong> <%= user.getPhoneNumber() %></p>
            <p><strong>Booking Reference:</strong> <%= bookingReference %></p>
            <p><strong>Invoice Date:</strong> <%= invoiceDate %></p>
        </div>
        <!-- Package Details -->
        <div class="mb-6">
            <h3 class="text-xl font-semibold mb-2">Package Details</h3>
            <p><strong>Package:</strong> <%= packageName %></p>
            <p class="text-gray-700"><%= description %></p>
            <p class="mt-2"><strong>Price:</strong> Rs. <%= price %></p>
        </div>
        <!-- Total Price -->
        <div class="mb-6 text-center">
            <h3 class="text-3xl font-bold text-blue-600">Total: Rs. <%= price %></h3>
        </div>
        <!-- Payment Form -->
        <form action="payment" method="post">
            <!-- Payment Options -->
            <div class="mb-4">
                <label class="block text-gray-700 mb-2">Payment Option</label>
                <div class="flex flex-col">
                    <label class="mb-2">
                        <input type="radio" name="paymentOption" value="Pay at Visit" onclick="toggleBankDetails()" checked>
                        Pay at Visit
                    </label>
                    <label class="mb-2">
                        <input type="radio" name="paymentOption" value="Card" onclick="toggleBankDetails()">
                        Card
                    </label>
                    <label class="mb-2">
                        <input type="radio" name="paymentOption" value="Bank Transfer" onclick="toggleBankDetails()">
                        Bank Transfer
                    </label>
                </div>
            </div>
            <!-- Bank Details (Hidden by Default) -->
            <div id="bankDetails" class="mb-4 hidden">
                <label for="bankInfo" class="block text-gray-700">Bank Details</label>
                <textarea id="bankInfo" class="w-full p-2 border rounded" rows="4" readonly>
Bank name: Commercial Bank
Acc No: 8017313864
Branch: Maharagama
Name: Elite.services
                </textarea>
            </div>
            <!-- Payment Reference -->
            <div class="mb-4">
                <label for="paymentReference" class="block text-gray-700">Payment Reference</label>
                <input type="text" id="paymentReference" name="paymentReference" class="w-full p-2 border rounded" required>
            </div>
            <!-- Hidden Fields -->
            <input type="hidden" name="packageName" value="<%= packageName %>">
            <input type="hidden" name="price" value="<%= price %>">
            <input type="hidden" name="invoiceDate" value="<%= invoiceDate %>">
            <input type="hidden" name="bookingReference" value="<%= bookingReference %>">
            <!-- Proceed Button -->
            <button type="submit" class="w-full bg-blue-500 text-white p-2 rounded hover:bg-blue-600">Proceed</button>
        </form>
    </div>
</div>
</body>
</html>