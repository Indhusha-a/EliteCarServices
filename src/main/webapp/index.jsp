<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Elite Car Services - Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body, html {
            height: 100%;
            margin: 0;
        }

        .bg {
            /* The image used */
            background-image: url("images/car3.jpeg");

            /* Full height */
            height: 100%;

            /* Center and scale the image nicely */
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
        }
    </style>
</head>
<body class="bg flex items-center justify-center min-h-screen">
<div class="text-center bg-black bg-opacity-50 p-6 rounded-lg">
    <h1 class="text-4xl font-bold mb-6 text-white">Welcome to Elite Car Services</h1>
    <div class="space-x-4">
        <a href="login.jsp" class="bg-blue-500 text-white px-6 py-3 rounded hover:bg-blue-600">Login</a>
        <a href="register.jsp" class="bg-green-500 text-white px-6 py-3 rounded hover:bg-green-600">Register</a>
        <a href="contact.jsp" class="bg-gray-500 text-white px-6 py-3 rounded hover:bg-gray-600">Contact Support</a>
    </div>
</div>
</body>
</html>