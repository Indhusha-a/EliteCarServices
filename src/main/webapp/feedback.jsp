<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.elitecarservices.model.User" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<html>
<head>
    <title>Elite Car Services - Feedback</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<%
    User user = (User) session.getAttribute("user");
    com.elitecarservices.model.Admin admin = (com.elitecarservices.model.Admin) session.getAttribute("admin");
    if (user == null && admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (admin != null) {
        response.sendRedirect("adminDashboard.jsp");
        return;
    }

    // Path to feedback.txt in WEB-INF
    String feedbackFilePath = application.getRealPath("/WEB-INF/feedback.txt");
    ArrayList<String[]> feedbackList = new ArrayList<>();

    // Load existing feedback from file
    try (BufferedReader reader = new BufferedReader(new FileReader(feedbackFilePath))) {
        String line;
        String userName = null;
        String email = null;
        String packageName = null;
        String feedbackText = null;
        String date = null;
        int lineCount = 0;
        while ((line = reader.readLine()) != null) {
            if (line.startsWith("UserName: ")) {
                userName = line.substring(10);
                lineCount = 1;
            } else if (line.startsWith("Email: ") && lineCount == 1) {
                email = line.substring(7);
                lineCount = 2;
            } else if (line.startsWith("Package: ") && lineCount == 2) {
                packageName = line.substring(9);
                lineCount = 3;
            } else if (line.startsWith("Feedback: ") && lineCount == 3) {
                feedbackText = line.substring(10);
                lineCount = 4;
            } else if (line.startsWith("Date: ") && lineCount == 4) {
                date = line.substring(6);
                if (userName != null && email != null && packageName != null && feedbackText != null && date != null) {
                    feedbackList.add(new String[]{userName, email, packageName, feedbackText, date});
                }
                lineCount = 0;
            }
        }
    } catch (IOException e) {
        // File may not exist yet; ignore
    }

    // Handle feedback submission
    String feedbackMessage = null;
    String feedbackError = null;
    if ("POST".equalsIgnoreCase(request.getMethod()) && "submitFeedback".equals(request.getParameter("action"))) {
        String selectedPackage = request.getParameter("packageName");
        String feedbackText = request.getParameter("feedback");
        if (selectedPackage != null && !selectedPackage.isEmpty() && feedbackText != null && !feedbackText.trim().isEmpty()) {
            String userName = user.getName();
            String email = user.getEmail();
            String date = new Date().toString();
            String[] newFeedback = new String[]{userName, email, selectedPackage, feedbackText, date};
            feedbackList.add(newFeedback);
            // Append to feedback.txt
            try (FileWriter writer = new FileWriter(feedbackFilePath, true)) {
                writer.write("UserName: " + userName + "\n");
                writer.write("Email: " + email + "\n");
                writer.write("Package: " + selectedPackage + "\n");
                writer.write("Feedback: " + feedbackText + "\n");
                writer.write("Date: " + date + "\n");
                feedbackMessage = "Feedback submitted successfully!";
            } catch (IOException e) {
                feedbackError = "Error saving feedback to file.";
            }
        } else {
            feedbackError = "Please select a package and enter feedback.";
        }
    }

    // Handle feedback deletion
    if ("POST".equalsIgnoreCase(request.getMethod()) && "deleteFeedback".equals(request.getParameter("action"))) {
        int index;
        try {
            index = Integer.parseInt(request.getParameter("feedbackIndex"));
            if (index >= 0 && index < feedbackList.size()) {
                feedbackList.remove(index);
                // Rewrite feedback.txt
                try (FileWriter writer = new FileWriter(feedbackFilePath)) {
                    for (String[] feedback : feedbackList) {
                        writer.write("UserName: " + feedback[0] + "\n");
                        writer.write("Email: " + feedback[1] + "\n");
                        writer.write("Package: " + feedback[2] + "\n");
                        writer.write("Feedback: " + feedback[3] + "\n");
                        writer.write("Date: " + feedback[4] + "\n");
                    }
                    feedbackMessage = "Feedback deleted successfully!";
                } catch (IOException e) {
                    feedbackError = "Error updating feedback file.";
                }
            } else {
                feedbackError = "Invalid feedback index.";
            }
        } catch (NumberFormatException e) {
            feedbackError = "Error deleting feedback.";
        }
    }
%>
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
<div class="container mx-auto p-6">
    <h1 class="text-3xl font-bold mb-6">Submit Feedback</h1>

    <!-- Feedback and Review Management Section -->
    <div class="bg-white p-6 rounded shadow-md mb-6">
        <h2 class="text-xl font-bold mb-4">Feedback and Review Management</h2>
        <!-- Display Feedbacks -->
        <div id="feedback-display" class="mb-4">
            <%
                if (feedbackMessage != null) {
            %>
            <p class="text-green-500 transition-opacity duration-500"><%= feedbackMessage %></p>
            <%
                }
                if (feedbackError != null) {
            %>
            <p class="text-red-500 transition-opacity duration-500"><%= feedbackError %></p>
            <%
                }
                if (feedbackList.isEmpty()) {
            %>
            <p>No feedback available.</p>
            <%
            } else {
                for (int i = 0; i < feedbackList.size(); i++) {
                    String[] feedback = feedbackList.get(i);
            %>
            <div class="border-b border-gray-200 py-2 flex justify-between items-center">
                <div>
                    <p><strong>User:</strong> <%= feedback[0] %> (<%= feedback[1] %>)</p>
                    <p><strong>Package:</strong> <%= feedback[2] %></p>
                    <p><strong>Feedback:</strong> <%= feedback[3] %></p>
                    <p><strong>Date:</strong> <%= feedback[4] %></p>
                </div>
                <form action="feedback.jsp" method="post">
                    <input type="hidden" name="action" value="deleteFeedback">
                    <input type="hidden" name="feedbackIndex" value="<%= i %>">
                    <button type="submit" class="bg-red-500 text-white p-1 rounded hover:bg-red-600">Delete</button>
                </form>
            </div>
            <%
                    }
                }
            %>
        </div>
        <!-- Feedback Form -->
        <form action="feedback.jsp" method="post" onsubmit="downloadFeedbackTxt()">
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

<!-- JavaScript for Feedback Download and Messages -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const feedbackMessages = document.getElementById('feedback-display');

        // Function to download feedback as feedback.txt
        function downloadFeedbackTxt() {
            const userName = '<%= user.getName() %>';
            const email = '<%= user.getEmail() %>';
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

        // Hide messages after 3 seconds
        function hideMessages(container) {
            if (container && container.querySelector('p')) {
                setTimeout(() => {
                    container.querySelector('p').style.opacity = '0';
                    setTimeout(() => {
                        container.querySelector('p').remove();
                    }, 500);
                }, 3000);
            }
        }

        hideMessages(feedbackMessages);
    });
</script>
</body>
</html>