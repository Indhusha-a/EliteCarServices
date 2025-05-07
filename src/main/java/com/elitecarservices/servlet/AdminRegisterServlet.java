package com.elitecarservices.servlet;

import com.elitecarservices.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.*;

@WebServlet("/adminRegister")
public class AdminRegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String name = request.getParameter("name");
        String idNumber = request.getParameter("idNumber");
        String contactNumber = request.getParameter("contactNumber");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String specialCode = request.getParameter("specialCode");

        // Validate special code
        if (!"ELITE".equals(specialCode)) {
            session.setAttribute("error", "Invalid special code.");
            response.sendRedirect("adminRegister.jsp");
            return;
        }

        // Validate password match
        if (!password.equals(confirmPassword)) {
            session.setAttribute("error", "Passwords do not match.");
            response.sendRedirect("adminRegister.jsp");
            return;
        }

        // Validate email format
        if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            session.setAttribute("error", "Invalid email format.");
            response.sendRedirect("adminRegister.jsp");
            return;
        }

        // Validate contact number
        if (!contactNumber.matches("\\d{10,15}")) {
            session.setAttribute("error", "Contact number must be 10-15 digits.");
            response.sendRedirect("adminRegister.jsp");
            return;
        }

        // Check if email already exists
        String adminsFilePath = getServletContext().getRealPath("/WEB-INF/admin.txt");
        File adminsFile = new File(adminsFilePath);
        if (adminsFile.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(adminsFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] adminData = line.split(",");
                    if (adminData.length > 3 && adminData[3].equals(email)) {
                        session.setAttribute("error", "Email already exists.");
                        response.sendRedirect("adminRegister.jsp");
                        return;
                    }
                }
            }
        }

        // Create new admin
        Admin admin = new Admin(name, idNumber, contactNumber, email, password);

        // Append admin to admin.txt
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(adminsFile, true))) {
            writer.write(admin.getName() + "," + admin.getIdNumber() + "," + admin.getContactNumber() + "," +
                    admin.getEmail() + "," + admin.getPassword());
            writer.newLine();
        } catch (IOException e) {
            session.setAttribute("error", "Error saving admin data: " + e.getMessage());
            response.sendRedirect("adminRegister.jsp");
            return;
        }

        session.setAttribute("message", "Admin registration successful. Please log in.");
        response.sendRedirect("adminLogin.jsp");
    }
}