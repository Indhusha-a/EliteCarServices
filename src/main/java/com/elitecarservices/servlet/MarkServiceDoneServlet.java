package com.elitecarservices.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

@WebServlet("/markServiceDone")
public class MarkServiceDoneServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            session.setAttribute("error", "You must be logged in as an admin to perform this action.");
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String bookingReference = request.getParameter("bookingReference");
        if (bookingReference == null || bookingReference.isEmpty()) {
            session.setAttribute("error", "Invalid booking reference.");
            response.sendRedirect("adminDashboard.jsp");
            return;
        }

        String bookingsFilePath = getServletContext().getRealPath("/WEB-INF/bookings.txt");
        ArrayList<String> bookingLines = new ArrayList<>();
        boolean updated = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(bookingsFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] bookingData = line.split(",");
                if (bookingData.length >= 7 && bookingData[6].equals(bookingReference)) {
                    // Append or update status to 'done'
                    if (bookingData.length > 10) {
                        bookingData[10] = "done";
                        line = String.join(",", bookingData);
                    } else {
                        line = line + ",done";
                    }
                    updated = true;
                }
                bookingLines.add(line);
            }
        } catch (IOException e) {
            session.setAttribute("error", "Error reading bookings: " + e.getMessage());
            response.sendRedirect("adminDashboard.jsp");
            return;
        }

        if (!updated) {
            session.setAttribute("error", "Booking not found.");
            response.sendRedirect("adminDashboard.jsp");
            return;
        }

        try (PrintWriter writer = new PrintWriter(new FileWriter(bookingsFilePath))) {
            for (String line : bookingLines) {
                writer.println(line);
            }
        } catch (IOException e) {
            session.setAttribute("error", "Error saving bookings: " + e.getMessage());
            response.sendRedirect("adminDashboard.jsp");
            return;
        }

        response.sendRedirect("adminDashboard.jsp");
    }
}