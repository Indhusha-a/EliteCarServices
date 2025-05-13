<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.elitecarservices.model.User" %>
<%@ page import="com.elitecarservices.model.Car" %>
<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Elite Car Services - Econo Plus Package</title>
    <script src="https://cdn.tailwindcss.com"></script>
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
        .service-package {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin: 20px 0;
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
            font-size: 18px;
            color: #333;
        }
        ul {
            list-style-type: none;
            padding-left: 0;
        }
        ul li {
            font-size: 18px;
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
        @keyframes fadeInRight {
            from { opacity: 0; transform: translateX(30px); }
            to { opacity: 1; transform: translateX(0); }
        }
        .animate-fadeInRight {
            animation: fadeInRight 1.2s ease-out 0.3s forwards;
        }
    </style>
</head>
<body class="bg-blue-100">
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
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
<div class="container mx-auto px-4 py-6">
    <header class="text-center mb-6 animate-fadeInRight">
        <h1 class="text-4xl font-bold text-gray-800">Car Vehicle Service Packages - Econo Plus</h1>
    </header>
    <section class="service-package animate-fadeInRight">
        <h2 class="text-4xl font-semibold text-blue-600 mb-4">Econo Plus Package</h2>
        <p class="text-gray-700 leading-relaxed">
            We believe it's high time to revamp the ordinary lube service that we pioneered 30 years ago.
            The Econo Plus package offers a comprehensive service for your vehicle, ensuring it runs smoothly
            with top-notch care and attention to detail. 🚗
        </p>
        <img src="images/package1.png" alt="Econo Plus Package" class="service-image" width="450" height="450">
        <br>
        <hr>
        <h5 class="text-2xl font-bold text-red-800">Includes:</h5>
        <hr>
        <br>
        <ul>
            <li>Oil & Filter change along with filter inspection</li>
            <li>Preventive Maintenance</li>
            <li>Wash & Vacuum</li>
            <li>Aubrite Top Gloss Liquid Wax</li>
            <li>Inspection Report – 17 points</li>
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
        <div class="flex space-x-4 mt-4">
            <form action="econoplus" method="post">
                <input type="hidden" name="packageName" value="Econo Plus">
                <button type="submit" class="inline-block bg-blue-600 text-white px-6 py-3 rounded-md font-semibold hover:bg-blue-700 transition" aria-label="Book the Econo Plus Package now">Book Now</button>
            </form>
            <a href="dashboard.jsp" class="inline-block bg-green-600 text-white px-6 py-3 rounded-md font-semibold hover:bg-green-700 transition" aria-label="Go back to the dashboard">Back</a>
        </div>
    </section>
</div>
<footer class="bg-gray-800 text-white text-center py-4 mt-6">
    <p>© <%= new java.util.Date().getYear() + 1900 %> Elite Car Services - Sri Lanka’s Largest and Best Auto Service Network</p>
</footer>
</body>
</html>