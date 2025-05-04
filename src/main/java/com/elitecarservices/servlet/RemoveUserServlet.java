package com.elitecarservices.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/RemoveUserServlet")
public class RemoveUserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("admin") == null) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Invalid email.");
            response.sendRedirect("dashboard.jsp");
            return;
        }

        File file = new File(getServletContext().getRealPath("/WEB-INF/users.txt"));
        List<String> updatedUsers = new ArrayList<>();
        boolean userFound = false;

        if (file.exists()) {
            BufferedReader reader = new BufferedReader(new FileReader(file));
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.contains(email)) {
                    updatedUsers.add(line);
                } else {
                    userFound = true;
                }
            }
            reader.close();
        }

        if (userFound) {
            BufferedWriter writer = new BufferedWriter(new FileWriter(file));
            for (String user : updatedUsers) {
                writer.write(user);
                writer.newLine();
            }
            writer.close();
            request.getSession().setAttribute("message", "User removed successfully.");
        } else {
            request.getSession().setAttribute("error", "User not found.");
        }

        response.sendRedirect("dashboard.jsp");
    }
}
