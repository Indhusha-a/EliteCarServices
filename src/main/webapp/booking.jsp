<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.elitecarservices.model.User" %>
<%@ page import="com.elitecarservices.model.Car" %>
<html>
<head>
    <title>Elite Car Services - Booking</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes fadeInRight {
            from { opacity: 0; transform: translateX(30px); }
            to { opacity: 1; transform: translateX(0); }
        }
        .animate-fadeInRight {
            animation: fadeInRight 1.2s ease-out 0.3s forwards;
        }
    </style>
    <script>
        function toggleMileageInput(checkbox, carIndex) {
            const mileageInput = document.getElementById('mileage-' + carIndex);
            mileageInput.disabled = !checkbox.checked;
            if (!checkbox.checked) {
                mileageInput.value = '';
            }
        }
        function enableInput(fieldId) {
            const input = document.getElementById(fieldId);
            input.readOnly = false;
            input.classList.remove('bg-gray-200');
            input.focus();
        }
    </script>
</head>
<body class="bg-blue-100">
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
<div class="container mx-auto p-6 flex justify-center">
    <div class="bg-white p-6 rounded shadow-md w-full max-w-md animate-fadeInRight">
        <h2 class="text-2xl font-bold mb-4 text-center">Book a Service</h2>
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
        %>
        <form action="booking" method="post">
            <div class="mb-4">
                <label for="name" class="block text-gray-700">Name</label>
                <div class="flex items-center">
                    <input type="text" id="name" name="name" value="<%= user.getName() %>" class="w-full p-2 border rounded bg-gray-200" readonly required>
                    <button type="button" onclick="enableInput('name')" class="ml-2 bg-gray-500 text-white px-3 py-1 rounded hover:bg-gray-600">Change</button>
                </div>
            </div>
            <div class="mb-4">
                <label for="phoneNumber" class="block text-gray-700">Phone Number</label>
                <div class="flex items-center">
                    <input type="text" id="phoneNumber" name="phoneNumber" value="<%= user.getPhoneNumber() %>" class="w-full p-2 border rounded bg-gray-200" readonly required>
                    <button type="button" onclick="enableInput('phoneNumber')" class="ml-2 bg-gray-500 text-white px-3 py-1 rounded hover:bg-gray-600">Change</button>
                </div>
            </div>
            <div class="mb-4">
                <label for="date" class="block text-gray-700">Date</label>
                <input type="date" id="date" name="date" class="w-full p-2 border rounded" required>
            </div>
            <div class="mb-4">
                <label for="time" class="block text-gray-700">Time</label>
                <input type="time" id="time" name="time" class="w-full p-2 border rounded" required>
            </div>
            <div class="mb-4">
                <label for="reference" class="block text-gray-700">Reference</label>
                <input type="text" id="reference" name="reference" class="w-full p-2 border rounded" required>
            </div>
            <div class="mb-4">
                <label class="block text-gray-700">Select Cars</label>
                <%
                    java.util.LinkedList<Car> cars = user.getCars();
                    for (int i = 0; i < cars.size(); i++) {
                        Car car = cars.get(i);
                %>
                <div class="flex items-center mb-2">
                    <input type="checkbox" id="car-<%= i %>" name="selectedCars" value="<%= i %>" onchange="toggleMileageInput(this, <%= i %>)" class="mr-2">
                    <label for="car-<%= i %>"><%= car.getModel() %> (<%= car.getYear() %>)</label>
                </div>
                <div class="ml-6 mb-2">
                    <label for="mileage-<%= i %>" class="block text-gray-700">Mileage for <%= car.getModel() %></label>
                    <input type="number" id="mileage-<%= i %>" name="mileage-<%= i %>" class="w-full p-2 border rounded" disabled>
                </div>
                <%
                    }
                %>
            </div>
            <div class="mb-4">
                <label for="anythingElse" class="block text-gray-700">Anything Else</label>
                <textarea id="anythingElse" name="anythingElse" class="w-full p-2 border rounded" rows="4"></textarea>
            </div>
            <div class="mb-4">
                <label for="branch" class="block text-gray-700">Branch</label>
                <select id="branch" name="branch" class="w-full p-2 border rounded" required>
                    <option value="Dehiwala">Dehiwala</option>
                    <option value="Nugegoda">Nugegoda</option>
                    <option value="Maharagama">Maharagama</option>
                </select>
            </div>
            <input type="hidden" name="packageName" value="<%= packageName != null ? packageName : "" %>">
            naïve
            <button type="submit" class="w-full bg-blue-500 text-white p-2 rounded hover:bg-blue-600">Submit Booking</button>
        </form>
        <%
            if (packageName != null) {
        %>
        <p class="mt-4 text-center text-gray-700">Selected Package: <%= packageName %></p>
        <%
            }
        %>
    </div>
</div>
</body>
</html>