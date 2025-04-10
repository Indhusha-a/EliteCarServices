<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Elite Car Services - Euro Total Plus</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<nav class="bg-white p-4 shadow-md">
    <div class="container mx-auto flex justify-between items-center">
        <a href="index.jsp" class="text-3xl font-bold text-gray-800 flex items-center">
            <img src="images/logo.jpg" alt="Elite Car Services Logo" width="75" height="15">
            <h3> Elite Car Services </h3>
        </a>
        <div>
            <a href="dashboard.jsp" class="text-blue-500 hover:underline mr-4">Dashboard</a>
            <a href="logout" class="text-blue-500 hover:underline">Logout</a>
        </div>
    </div>
</nav>
<div class="container mx-auto p-6">
    <div class="bg-white p-6 rounded shadow-md">
        <h2 class="text-2xl font-bold mb-4 text-center">Euro Total Plus</h2>
        <p class="text-gray-700 mb-6">Bringing European quality to the automotive service segment according to Euro manufacturer specs. Mechanical and cosmetic exterior and interior services to give your car a fresh look according to manufacturer standards.</p>
        <div class="text-center">
            <button class="bg-blue-500 text-white p-3 rounded hover:bg-blue-600">Order Now</button>
        </div>
    </div>
</div>
</body>
</html>