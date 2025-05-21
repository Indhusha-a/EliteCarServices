<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.elitecarservices.model.User" %>
<%@ page import="com.elitecarservices.model.Feedback" %>
<%@ page import="java.util.ArrayList" %>
<html>
<head>
    <title>Elite Car Services - Feedback</title>
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
    </style>
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
<div class="container mx-auto p-6">
    <h1 class="text-3xl font-bold mb-6 animate-fadeInRight-1">Submit Feedback</h1>
    <div class="bg-white p-6 rounded shadow-md mb-6 animate-fadeInRight-2">
        <h2 class="text-xl font-bold mb-4">Feedback and Review Management</h2>
        <div id="feedback-display" class="mb-4">
            <%
                String feedbackMessage = (String) request.getAttribute("feedbackMessage");
                String feedbackError = (String) request.getAttribute("feedbackError");
                if (feedbackMessage != null) {
            %>
            <p class="text-green-500 transition-opacity duration-500"><%= feedbackMessage %></p>
            <% } %>
            <% if (feedbackError != null) { %>
            <p class="text-red-500 transition-opacity duration-500"><%= feedbackError %></p>
            <% } %>
            <%
                ArrayList<Feedback> feedbackList = (ArrayList<Feedback>) request.getAttribute("feedbackList");
                if (feedbackList == null || feedbackList.isEmpty()) {
            %>
            <p>No feedback available.</p>
            <% } else {
                for (int i = 0; i < feedbackList.size(); i++) {
                    Feedback feedback = feedbackList.get(i);
            %>
            <div class="border-b border-gray-200 py-2 flex justify-between items-center">
                <div>
                    <p><strong>User:</strong> <%= feedback.getUserName() != null ? feedback.getUserName() : "Unknown" %> (<%= feedback.getEmail() != null ? feedback.getEmail() : "N/A" %>)</p>
                    <p><strong>Package:</strong> <%= feedback.getPackageName() != null ? feedback.getPackageName() : "N/A" %></p>
                    <p><strong>Feedback:</strong> <%= feedback.getFeedbackText() != null ? feedback.getFeedbackText() : "N/A" %></p>
                    <p><strong>Date:</strong> <%= feedback.getDate() != null ? feedback.getDate() : "N/A" %></p>
                </div>
                <form action="FeedbackServlet" method="post">
                    <input type="hidden" name="action" value="deleteFeedback">
                    <input type="hidden" name="feedbackIndex" value="<%= i %>">
                    <button type="submit" class="bg-red-500 text-white p-1 rounded hover:bg-red-600">Delete</button>
                </form>
            </div>
            <% } } %>
        </div>
        <form action="FeedbackServlet" method="post" onsubmit="downloadFeedbackTxt()">
            <input type="hidden" name="action" value="submitFeedback">
            <div class="mb-4">
                <label for="packageName" class="block text-gray-700">Select Package</label>
                <select id="packageName" name="packageName" class="w-full p-2 border rounded" required>
                    <option value="" disabled selected>Select a package</option>
                    <option value="Econo Plus">Econo Plus</option>
                    <option value="Auto Service Plus">Auto Service Plus</option>
                    <option value="Euro Total Plus">Euro Total Plus</option>
                    <option value="Total Care Plus">Total Care Plus</option>
                </select>
            </div>
            <div class="mb-4">
                <label for="feedback" class="block text-gray-700">Your Feedback</label>
                <textarea id="feedback" name="feedback" class="w-full p-2 border rounded" rows="4" required></textarea>
            </div>
            <button type="submit" class="bg-green-500 text-white p-2 rounded hover:bg-green-600">Submit Feedback</button>
        </form>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const feedbackMessages = document.getElementById('feedback-display');
        function downloadFeedbackTxt() {
            const userName = '<%= ((User) session.getAttribute("user")).getName() %>';
            const email = '<%= ((User) session.getAttribute("user")).getEmail() %>';
            const packageName = document.getElementById('packageName').value;
            const feedback = document.getElementById('feedback').value;
            const date = new Date().toString();
            const content = `UserName: ${userName}\nEmail: ${email}\nPackage: ${packageName}\nFeedback: ${feedback}\nDate: ${date}`;
            const blob = new Blob([content], { type: 'text/plain' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'feedback.txt';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        }
        function hideMessages(container) {
            const messages = container.querySelectorAll('p.text-green-500, p.text-red-500');
            if (messages.length > 0) {
                setTimeout(() => {
                    messages.forEach(message => {
                        message.style.opacity = '0';
                        setTimeout(() => message.remove(), 500);
                    });
                }, 3000);
            }
        }
        hideMessages(feedbackMessages);
    });
</script>
</body>
</html>