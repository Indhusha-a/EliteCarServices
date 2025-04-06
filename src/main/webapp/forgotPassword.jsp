<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Elite Car Services - Forgot Password</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<nav class="bg-white p-4 shadow-md">
    <div class="container mx-auto flex justify-between items-center">
        <a href="index.jsp" class="text-3xl font-bold text-gray-800 flex items-center">
            <img src="images/logo.jpg" alt="Elite Car Services Logo" alt="Logo" width="75" height="15">
            <h3> Elite Car Services </h3>
        <div>
            <a href="index.jsp" class="text-blue-500 hover:underline mr-4">Home</a>
            <a href="login.jsp" class="text-blue-500 hover:underline mr-4">Login</a>
            <a href="register.jsp" class="text-blue-500 hover:underline">Register</a>
        </div>
    </div>
</nav>
<div class="container mx-auto p-6 flex justify-center">
    <div class="bg-white p-6 rounded shadow-md w-full max-w-md">
        <h2 class="text-2xl font-bold mb-4 text-center">Forgot Password</h2>
        <%
            String message = (String) session.getAttribute("message");
            if (message != null) {
        %>
        <p class="text-center text-green-500 mb-4"><%= message %></p>
        <%
                session.removeAttribute("message");
            }
        %>
        <form action="forgotPassword" method="post">
            <div class="mb-4">
                <label for="email" class="block text-gray-700">Email</label>
                <input type="email" id="email" name="email" class="w-full p-2 border rounded" required>
            </div>
            <button type="submit" class="w-full bg-blue-500 text-white p-2 rounded hover:bg-blue-600">Submit</button>
        </form>
        <p class="mt-4 text-center">
            <a href="login.jsp" class="text-blue-500 hover:underline">Back to Login</a>
        </p>
    </div>
</div>
</body>
</html>