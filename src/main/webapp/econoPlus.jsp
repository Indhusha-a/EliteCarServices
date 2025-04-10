<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.elitecarservices.model.User" %>
<%@ page import="com.elitecarservices.model.Car" %>
<html>
<head>
    <title>Car Service Packages - Econo Plus</title>
    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            line-height: 1.6;
        }
        h1 {
            font-size: 24px;
            color: #333;
        }
        h2 {
            font-size: 20px;
            color: #e30613; /* Red color similar to the image */
            margin-top: 20px;
        }
        h3 {
            font-size: 16px;
            color: #e30613;
            margin-top: 15px;
        }
        p {
            font-size: 14px;
            color: #333;
        }
        ul {
            list-style-type: none;
            padding-left: 0;
        }
        ul li {
            font-size: 14px;
            color: #333;
            margin-bottom: 8px;
            position: relative;
            padding-left: 20px;
        }
        ul li:before {
            content: "✔"; /* Checkmark symbol to mimic the image */
            color: #e30613;
            position: absolute;
            left: 0;
        }
        .order-now-btn {
            display: block;
            width: 150px;
            padding: 10px;
            margin: 20px 0;
            background-color: #e30613;
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
        }
        .order-now-btn:hover {
            background-color: #b50510;
        }
        .content {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
    </style>
</head>
<body class="bg-gray-100">

<!-- Top Navigation Panel -->
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

<!-- Econo Plus Content -->
<div class="content">
    <h1>Car Service Packages – Econo Plus</h1>
    <p>We believe it’s high time we revamp the ordinary lube service that we ourselves developed 30 years ago and we now offer 6 exclusive service packages covering all requirements from the entry level car up to Hybrid and even bespoke European brands while focusing on manufacturer standards throughout.</p>

    <h2>Econo Plus</h2>
    <p>Specifically targeted at all entry-level vehicle range covering the Auto Miraj exclusive 17-point inspection checklist which ensures that your car is mechanically in perfect order to conquer any road condition along with great peace of mind. Furthermore, the package is aimed at making it affordable yet ensuring the best value for money deal in town!</p>

    <h3>Includes:</h3>
    <ul>
        <li>Oil & Filter change along with filter inspection</li>
        <li>Preventive Maintenance</li>
        <li>Wash & Vacuum</li>
        <li>Aubrite Top Gloss Liquid Wax</li>
        <li>Inspection Report – 17 points</li>
    </ul>

    <h3>Value Additions:</h3>
    <ul>
        <li>Battery Test Report</li>
        <li>Scan Report</li>
        <li>Battery Terminal Protector and Door Hinge Treatment</li>
    </ul>

    <a href="#" class="order-now-btn">Order Now</a>
</div>
</body>
</html>