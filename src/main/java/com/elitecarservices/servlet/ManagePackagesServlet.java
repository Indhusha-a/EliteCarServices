package com.elitecarservices.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ManagePackagesServlet")
public class ManagePackagesServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("admin") == null) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String action = request.getParameter("action");
        File file = new File(getServletContext().getRealPath("/WEB-INF/packages.txt"));

        if ("add".equals(action)) {
            String packageName = request.getParameter("packageName");
            String packageDescription = request.getParameter("packageDescription");

            if (packageName == null || packageName.trim().isEmpty() || packageDescription == null || packageDescription.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Package name and description are required.");
                response.sendRedirect("dashboard.jsp");
                return;
            }

            BufferedWriter writer = new BufferedWriter(new FileWriter(file, true));
            writer.write(packageName + "|" + packageDescription);
            writer.newLine();
            writer.close();

            request.getSession().setAttribute("message", "Package added successfully.");
        } else if ("remove".equals(action)) {
            String packageName = request.getParameter("packageName");
            if (packageName == null || packageName.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Invalid package name.");
                response.sendRedirect("dashboard.jsp");
                return;
            }

            List<String> updatedPackages = new ArrayList<>();
            boolean packageFound = false;

            if (file.exists()) {
                BufferedReader reader = new BufferedReader(new FileReader(file));
                String line;
                while ((line = reader.readLine()) != null) {
                    if (!line.startsWith(packageName + "|")) {
                        updatedPackages.add(line);
                    } else {
                        packageFound = true;
                    }
                }
                reader.close();
            }

            if (packageFound) {
                BufferedWriter writer = new BufferedWriter(new FileWriter(file));
                for (String pkg : updatedPackages) {
                    writer.write(pkg);
                    writer.newLine();
                }
                writer.close();
                request.getSession().setAttribute("message", "Package removed successfully.");
            } else {
                request.getSession().setAttribute("error", "Package not found.");
            }
        }

        response.sendRedirect("dashboard.jsp");
    }
}