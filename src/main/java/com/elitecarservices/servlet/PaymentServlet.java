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

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Retrieve form data
        String paymentOption = request.getParameter("paymentOption");
        String paymentReference = request.getParameter("paymentReference");
        String packageName = request.getParameter("packageName");
        String priceStr = request.getParameter("price");
        String invoiceDate = request.getParameter("invoiceDate");
        String bookingReference = request.getParameter("bookingReference");

        // Validate required fields
        if (paymentOption == null || paymentReference == null || paymentReference.isEmpty() ||
                packageName == null || priceStr == null || invoiceDate == null || bookingReference == null) {
            session.setAttribute("error", "Please fill all required fields.");
            response.sendRedirect("Payment.jsp");
            return;
        }

        // Parse price
        int price;
        try {
            price = Integer.parseInt(priceStr);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid price format.");
            response.sendRedirect("Payment.jsp");
            return;
        }

        // Define package details
        String packageDetails;
        switch (packageName) {
            case "Econo Plus":
                packageDetails = "Oil & Filter change with filter inspection;Preventive Maintenance;Wash & Vacuum;" +
                        "Aubrite Top Gloss Liquid Wax;Inspection Report – 17 points;Battery Test Report;" +
                        "Scan Report;Battery Terminal Protector and Door Hinge Treatment";
                break;
            case "Auto Service Plus":
                packageDetails = "Oil & Filter change along with filter inspection;Preventive Maintenance;Wash & Vacuum;" +
                        "Aubrite Top Gloss Liquid Wax;Inspection Report -61 points;Battery Test Report;" +
                        "Scan Report;Battery Terminal Protector and Door Hinge Treatment";
                break;
            case "Euro Total Plus":
                packageDetails = "Oil & Filter change along with filter inspection;Preventive Maintenance;Wash & Vacuum;" +
                        "Aubrite Top Gloss Liquid Wax;Engine Degreaser;UK Standard inspection report -101 points;" +
                        "Battery Test Report;Scan Report;Battery Terminal Protector and Door Hinge Treatment";
                break;
            case "Total Care Plus":
                packageDetails = "Oil & Filter change along with filter inspection;Preventive Maintenance;Wash & Vacuum;" +
                        "Aubrite Carnauba Hand Made Wax;Engine Degreaser;Mini Valet/Leather treatment;" +
                        "UK Standard inspection report -101 points;Battery Test Report;" +
                        "Scan Report;Battery Terminal Protector and Door Hinge Treatment";
                break;
            default:
                packageDetails = "No description available for this package.";
        }

        // Save payment details to payments.txt
        String paymentsFilePath = getServletContext().getRealPath("/WEB-INF/payments.txt");
        try (PrintWriter writer = new PrintWriter(new FileWriter(paymentsFilePath, true))) {
            String paymentLine = String.format("%s,%s,%s,%s,%d,%s,%s,%s,%s,%s",
                    user.getName(), user.getEmail(), user.getPhoneNumber(), packageName, price,
                    paymentOption, paymentReference.replace(",", ";"), invoiceDate,
                    bookingReference.replace(",", ";"), packageDetails.replace(",", ";"));
            writer.println(paymentLine);
        } catch (IOException e) {
            session.setAttribute("error", "Error saving payment details. Please try again.");
            response.sendRedirect("Payment.jsp");
            return;
        }

        // Clear bookingReference from session
        session.removeAttribute("bookingReference");

        // Set success message and redirect to dashboard
        session.setAttribute("message", "Payment details submitted successfully.");
        response.sendRedirect("dashboard.jsp");
    }
}