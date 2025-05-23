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
            /* Full height */
            height: 100%;
            /* Center and scale the image nicely */
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
            /* Smooth transition for background image */
            transition: background-image 1s ease-in-out;
        }
    </style>
</head>
<body class="bg flex items-center justify-center min-h-screen">
<div class="text-center bg-black bg-opacity-50 p-6 rounded-lg">
    <h1 class="text-4xl font-bold mb-6 text-white">Welcome to Elite Car Services</h1>
    <div class="space-x-4">
        <a href="login.jsp" class="bg-blue-500 text-white px-6 py-3 rounded hover:bg-blue-600">Login</a>
        <a href="register.jsp" class="bg-green-500 text-white px-6 py-3 rounded hover:bg-green-600">Register</a>
        <a href="adminRegister.jsp" class="bg-purple-500 text-white px-6 py-3 rounded hover:bg-purple-600">Admin Register</a>
        <a href="contact.jsp" class="bg-gray-500 text-white px-6 py-3 rounded hover:bg-gray-600">Contact Support</a>
    </div>
</div>

<script>
    // Array of four background images
    const images = [
        "url('images/car3.jpeg')",
        "url('images/car1.png')",
        "url('images/car2.jpg')",
        "url('images/car4.jpg')"
    ];

    let currentIndex = 0;
    const body = document.querySelector('.bg');

    // Function to change the background image
    function changeBackground() {
        currentIndex = (currentIndex + 1) % images.length; // Cycle through images
        body.style.backgroundImage = images[currentIndex];
    }

    // Set the initial background image
    body.style.backgroundImage = images[currentIndex];

    // Change image every 5 seconds (5000 milliseconds)
    setInterval(changeBackground, 5000);
</script>
</body>
</html>