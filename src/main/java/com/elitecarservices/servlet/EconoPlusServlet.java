package com.elitecarservices.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/econoplus")
public class EconoPlusServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String packageName = request.getParameter("packageName");

        // Store package name in session
        if (packageName != null && !packageName.isEmpty()) {
            session.setAttribute("packageName", packageName);
        }

        // Forward to booking.jsp
        request.getRequestDispatcher("booking.jsp").forward(request, response);
    }
}