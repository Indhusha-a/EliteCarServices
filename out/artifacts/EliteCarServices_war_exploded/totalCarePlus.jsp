<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.elitecarservices.model.User" %>
<%@ page import="com.elitecarservices.model.Car" %>
<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Elite Car Services - Total Care Plus Package</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Emoji Styles from the Original Reference -->
    <style type="text/css">
        img.wp-smiley, img.emoji {
            display: inline !important;
            border: none !important;
            box-shadow: none !important;
            height: 1em !important;
            width: 1em !important;
            margin: 0 0.07em !important;
            vertical-align: -0.1em !important;
            background: none !important;
            padding: 0 !important;
        }

    </style>
    <!-- Custom Styles for the Service Package Section -->
    <style type="text/css">
        .service-package {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin: 20px 0;
        }
        .container {
            align-items: center;
            justify-content: center
        }
        .service-image {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            margin: 20px 0;
        }
        h5 {
            color: #e30613;
        }
        p {
            font-size: 18px; /* Updated for consistency */
            color: #333;
        }
        ul {
            list-style-type: none;
            padding-left: 0;
        }
        ul li {
            font-size: 18px; /* Increased for better readability */
            color: #333;
            margin-bottom: 10px;
            position: relative;
            padding-left: 25px;
        }
        ul li:before {
            content: "✔";
            color: #e30613;
            position: absolute;
            left: 0;
            font-size: 18px;
            line-height: 1;
        }
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            line-height: 1.6;
        }
    </style>
</head>
<body class="bg-gray-100">
<!-- JSP Authentication Check -->
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!-- Navigation Bar (Using Tailwind CSS) -->
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
<div class="container mx-auto px-4 py-6">
    <!-- Header Section -->
    <header class="text-center mb-6">
        <h1 class="text-4xl font-bold text-gray-800">Car Vehicle Service Packages - Total Care Plus</h1>
    </header>

    <!-- Service Package Section -->
    <section class="service-package">
        <h2 class="text-4xl font-semibold text-blue-600 mb-4">Total Care Plus Package</h2>
        <p class="text-gray-700 leading-relaxed">
            We thrive in reinstating the automotive standards & hereby the package consists of a 139 point inspection checklist while ensuring not only mechanical but also the cosmetic exterior and the interior as well to look fresh and new. Our dedicated team will make your vehicle look fresh inside out in no time in line with manufacturer standards.
        </p>
        <!-- Placeholder for the image -->
        <div class="container" >
            <img src="images/package4.png" alt="Econo Plus Package" class="service-image" width="450" height="450">

        </div>

        <br>
        <hr>
        <h5 class="text-2xl font-bold text-red-800">Includes:</h5>
        <hr>
        <br>
        <ul>
            <li>Oil & Filter change along with filter inspection</li>
            <li>Preventive Maintenance</li>
            <li>Wash & Vacuum</li>
            <li>Aubrite Carnauba Hand Made Wax</li>
            <li>Engine Degreaser</li>
            <li>Mini Valet/Leather treatment</li>
            <li>UK Standard inspection report -101 points</li>
        </ul>

        <br>
        <hr>
        <h5 class="text-2xl font-bold text-red-800">Value Additions:</h5>
        <hr>
        <br>
        <ul>
            <li>Battery Test Report</li>
            <li>Scan Report</li>
            <li>Battery Terminal Protector and Door Hinge Treatment</li>
        </ul>
        <!-- Button Group -->
        <div class="flex space-x-4 mt-4">
            <a href="booking.jsp" class="inline-block bg-blue-600 text-white px-6 py-3 rounded-md font-semibold hover:bg-blue-700 transition" aria-label="Book the Econo Plus Package now">Book Now</a>
            <a href="dashboard.jsp" class="inline-block bg-green-600 text-white px-6 py-3 rounded-md font-semibold hover:bg-green-700 transition" aria-label="Go back to the dashboard">Back</a>
        </div>
    </section>
</div>

<!-- Footer -->
<footer class="bg-gray-800 text-white text-center py-4 mt-6">
    <p>© <%= new java.util.Date().getYear() + 1900 %> Elite Car Services - Sri Lanka’s Largest and Best Auto Service Network</p>
</footer>
</body>
</html>