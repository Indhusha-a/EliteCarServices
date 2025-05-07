package com.elitecarservices.servlet;

import com.elitecarservices.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/serviceHistory")
public class ServiceHistoryServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Retrieve form data
        String date = request.getParameter("date");
        String mileage = request.getParameter("mileage");
        String vehicle = request.getParameter("vehicle");
        String service = request.getParameter("service");

        // Validate required fields
        if (date == null || date.isEmpty() || mileage == null || mileage.isEmpty() ||
                vehicle == null || vehicle.isEmpty() || service == null || service.isEmpty()) {
            session.setAttribute("error", "Please fill all required fields.");
            response.sendRedirect("dashboard.jsp");
            return;
        }

        // Save to bookings.txt in compatible format
        String bookingsFilePath = getServletContext().getRealPath("/WEB-INF/bookings.txt");
        try (PrintWriter writer = new PrintWriter(new FileWriter(bookingsFilePath, true))) {
            String bookingLine = String.format("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,pending",
                    user.getName(), user.getEmail(), user.getPhoneNumber(), "N/A",
                    date, "00:00", "N/A", service, vehicle + ":" + mileage, "");
            writer.println(bookingLine);
        } catch (IOException e) {
            session.setAttribute("error", "Error saving service history. Please try again.");
            response.sendRedirect("dashboard.jsp");
            return;
        }

        // Set success message and redirect
        session.setAttribute("message", "Service history added successfully.");
        response.sendRedirect("dashboard.jsp");
    }
}