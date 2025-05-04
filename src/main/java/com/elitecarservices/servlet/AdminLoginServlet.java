package com.elitecarservices.servlet;

import com.elitecarservices.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

@WebServlet("/adminLogin")
public class AdminLoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Read admins from admin.txt
        String adminsFilePath = getServletContext().getRealPath("/WEB-INF/admin.txt");
        Admin admin = null;

        try (BufferedReader reader = new BufferedReader(new FileReader(adminsFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] adminData = line.split(",");
                if (adminData.length < 5) continue; // Skip malformed lines
                if (adminData[3].equals(email) && adminData[4].equals(password)) {
                    admin = new Admin(adminData[0], adminData[1], adminData[2], adminData[3], adminData[4]);
                    break;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (admin != null) {
            session.setAttribute("admin", admin);
            response.sendRedirect("dashboard.jsp");
        } else {
            session.setAttribute("error", "Invalid admin email or password.");
            response.sendRedirect("adminLogin.jsp");
        }
    }
}