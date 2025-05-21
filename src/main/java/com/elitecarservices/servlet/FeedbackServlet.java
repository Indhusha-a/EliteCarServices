package com.elitecarservices.servlet;

import com.elitecarservices.model.Feedback;
import com.elitecarservices.model.User;
import com.elitecarservices.model.Admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.*;
import java.util.ArrayList;
import java.util.Date;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Admin admin = (Admin) session.getAttribute("admin");

        if (user == null && admin == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        if (admin != null) {
            response.sendRedirect("adminDashboard.jsp");
            return;
        }

        // Load feedback from file
        ArrayList<Feedback> feedbackList = loadFeedback(request);
        request.setAttribute("feedbackList", feedbackList);
        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        ArrayList<Feedback> feedbackList = loadFeedback(request);
        String feedbackMessage = null;
        String feedbackError = null;

        if ("submitFeedback".equals(action)) {
            String selectedPackage = request.getParameter("packageName");
            String feedbackText = request.getParameter("feedback");

            if (selectedPackage != null && !selectedPackage.isEmpty() && feedbackText != null && !feedbackText.trim().isEmpty()) {
                String userName = user.getName();
                String email = user.getEmail();
                String date = new Date().toString();
                Feedback newFeedback = new Feedback(userName, email, selectedPackage, feedbackText, date);
                feedbackList.add(newFeedback);

                try {
                    saveFeedback(request, feedbackList);
                    feedbackMessage = "Feedback submitted successfully!";
                } catch (IOException e) {
                    feedbackError = "Error saving feedback to file.";
                }
            } else {
                feedbackError = "Please select a package and enter feedback.";
            }
        } else if ("deleteFeedback".equals(action)) {
            try {
                int index = Integer.parseInt(request.getParameter("feedbackIndex"));
                if (index >= 0 && index < feedbackList.size()) {
                    feedbackList.remove(index);
                    try {
                        saveFeedback(request, feedbackList);
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

        request.setAttribute("feedbackList", feedbackList);
        request.setAttribute("feedbackMessage", feedbackMessage);
        request.setAttribute("feedbackError", feedbackError);
        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }

    private ArrayList<Feedback> loadFeedback(HttpServletRequest request) throws IOException {
        String feedbackFilePath = request.getServletContext().getRealPath("/WEB-INF/feedback.txt");
        ArrayList<Feedback> feedbackList = new ArrayList<>();

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
                        feedbackList.add(new Feedback(userName, email, packageName, feedbackText, date));
                    }
                    lineCount = 0;
                }
            }
        }
        return feedbackList;
    }

    private void saveFeedback(HttpServletRequest request, ArrayList<Feedback> feedbackList) throws IOException {
        String feedbackFilePath = request.getServletContext().getRealPath("/WEB-INF/feedback.txt");
        try (FileWriter writer = new FileWriter(feedbackFilePath)) {
            for (Feedback feedback : feedbackList) {
                writer.write("UserName: " + feedback.getUserName() + "\n");
                writer.write("Email: " + feedback.getEmail() + "\n");
                writer.write("Package: " + feedback.getPackageName() + "\n");
                writer.write("Feedback: " + feedback.getFeedbackText() + "\n");
                writer.write("Date: " + feedback.getDate() + "\n");
            }
        }
    }
}