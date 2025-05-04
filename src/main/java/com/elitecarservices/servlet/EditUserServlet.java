package com.elitecarservices.servlet;

import com.elitecarservices.model.User;
import com.elitecarservices.model.Car;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

@WebServlet("/EditUserServlet")
public class EditUserServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("admin") == null) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String email = request.getParameter("email");
        File file = new File(getServletContext().getRealPath("/WEB-INF/users.txt"));
        String userData = null;

        if (file.exists()) {
            BufferedReader reader = new BufferedReader(new FileReader(file));
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.contains(email)) {
                    userData = line;
                    break;
                }
            }
            reader.close();
        }

        if (userData != null) {
            request.setAttribute("userData", userData);
            request.getRequestDispatcher("editUser.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("error", "User not found.");
            response.sendRedirect("dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("admin") == null) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String oldEmail = request.getParameter("oldEmail");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
            request.getSession().setAttribute("error", "All fields are required.");
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
                if (line.contains(oldEmail)) {
                    String[] parts = line.split(",");
                    if (parts.length >= 5) {
                        String carData = parts[3];
                        String password = parts[4];
                        updatedUsers.add(name + "," + email + "," + phone + "," + carData + "," + password);
                        userFound = true;
                    }
                } else {
                    updatedUsers.add(line);
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
            request.getSession().setAttribute("message", "User details updated successfully.");
        } else {
            request.getSession().setAttribute("error", "User not found.");
        }

        response.sendRedirect("dashboard.jsp");
    }
}
