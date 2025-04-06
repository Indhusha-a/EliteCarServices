package com.elitecarservices.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        HttpSession session = request.getSession();

        // Check if the email exists in users.txt
        String usersFilePath = getServletContext().getRealPath("/WEB-INF/users.txt");
        boolean emailExists = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(usersFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userData = line.split(",");
                if (userData.length > 1 && userData[1].equals(email)) {
                    emailExists = true;
                    break;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Set a message based on whether the email was found
        if (emailExists) {
            session.setAttribute("message", "A password reset link has been sent to your email.");
        } else {
            session.setAttribute("message", "Email not found. Please register or try a different email.");
        }

        // Redirect back to forgotPassword.jsp to display the message
        response.sendRedirect("forgotPassword.jsp");
    }
}