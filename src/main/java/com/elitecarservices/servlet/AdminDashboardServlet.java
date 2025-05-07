package com.elitecarservices.servlet;

import com.elitecarservices.model.User;
import com.elitecarservices.model.Car;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.*;
import java.util.LinkedList;
import java.util.List;

@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        com.elitecarservices.model.Admin admin = (com.elitecarservices.model.Admin) session.getAttribute("admin");
        if (admin == null) {
            session.setAttribute("error", "You must be logged in as an admin to perform this action.");
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String action = request.getParameter("action");
        String usersFilePath = request.getServletContext().getRealPath("/WEB-INF/users.txt");

        if ("updateUser".equals(action)) {
            String originalEmail = request.getParameter("userEmail");
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");

            // Validate inputs
            if (name == null || name.trim().isEmpty()) {
                session.setAttribute("error", "Name cannot be empty.");
                response.sendRedirect("adminDashboard.jsp");
                return;
            }
            if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
                session.setAttribute("error", "Invalid email format.");
                response.sendRedirect("adminDashboard.jsp");
                return;
            }
            if (!phoneNumber.matches("\\d{10,15}")) {
                session.setAttribute("error", "Phone number must be 10-15 digits.");
                response.sendRedirect("adminDashboard.jsp");
                return;
            }

            // Check if new email is taken (excluding the current user)
            if (!email.equals(originalEmail)) {
                try (BufferedReader reader = new BufferedReader(new FileReader(usersFilePath))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        String[] userData = line.split(",");
                        if (userData.length >= 5 && userData[1].equals(email)) {
                            session.setAttribute("error", "Email is already in use.");
                            response.sendRedirect("adminDashboard.jsp");
                            return;
                        }
                    }
                }
            }

            // Update user in users.txt
            List<String> lines = new LinkedList<>();
            boolean userFound = false;

            try (BufferedReader reader = new BufferedReader(new FileReader(usersFilePath))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] userData = line.split(",");
                    if (userData.length >= 5 && userData[1].equals(originalEmail)) {
                        userFound = true;
                        lines.add(String.join(",", name, email, phoneNumber, userData[3], userData[4]));
                    } else {
                        lines.add(line);
                    }
                }
            }

            if (userFound) {
                try (FileWriter writer = new FileWriter(usersFilePath)) {
                    for (String line : lines) {
                        writer.write(line + "\n");
                    }
                }
                session.setAttribute("message", "User updated successfully!");
            } else {
                session.setAttribute("error", "User not found.");
            }
            response.sendRedirect("adminDashboard.jsp");
            return;
        }

        if ("deleteUser".equals(action)) {
            String userEmail = request.getParameter("userEmail");
            List<String> lines = new LinkedList<>();
            boolean userFound = false;

            try (BufferedReader reader = new BufferedReader(new FileReader(usersFilePath))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] userData = line.split(",");
                    if (userData.length >= 5 && userData[1].equals(userEmail)) {
                        userFound = true;
                        continue; // Skip the user to delete
                    }
                    lines.add(line);
                }
            }

            if (userFound) {
                try (FileWriter writer = new FileWriter(usersFilePath)) {
                    for (String line : lines) {
                        writer.write(line + "\n");
                    }
                }
                session.setAttribute("message", "User deleted successfully!");
            } else {
                session.setAttribute("error", "User not found.");
            }
            response.sendRedirect("adminDashboard.jsp");
            return;
        }

        if ("deleteCar".equals(action)) {
            String userEmail = request.getParameter("userEmail");
            String carIndexStr = request.getParameter("carIndex");
            List<String> lines = new LinkedList<>();
            boolean userFound = false;

            try {
                int carIndex = Integer.parseInt(carIndexStr);
                try (BufferedReader reader = new BufferedReader(new FileReader(usersFilePath))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        String[] userData = line.split(",");
                        if (userData.length >= 5 && userData[1].equals(userEmail)) {
                            userFound = true;
                            LinkedList<Car> cars = new LinkedList<>();
                            String[] carData = userData[3].split(";");
                            for (String car : carData) {
                                if (car.trim().isEmpty()) continue;
                                String[] carDetails = car.split(":");
                                if (carDetails.length == 2) {
                                    try {
                                        cars.add(new Car(carDetails[0], Integer.parseInt(carDetails[1])));
                                    } catch (NumberFormatException e) {
                                        // Skip invalid car entries
                                    }
                                }
                            }
                            if (carIndex >= 0 && carIndex < cars.size()) {
                                cars.remove(carIndex);
                                StringBuilder carsStr = new StringBuilder();
                                for (Car car : cars) {
                                    if (carsStr.length() > 0) carsStr.append(";");
                                    carsStr.append(car.getModel()).append(":").append(car.getYear());
                                }
                                lines.add(String.join(",", userData[0], userData[1], userData[2], carsStr.toString(), userData[4]));
                            } else {
                                lines.add(line);
                            }
                        } else {
                            lines.add(line);
                        }
                    }
                }

                if (userFound) {
                    try (FileWriter writer = new FileWriter(usersFilePath)) {
                        for (String line : lines) {
                            writer.write(line + "\n");
                        }
                    }
                    session.setAttribute("message", "Car deleted successfully!");
                } else {
                    session.setAttribute("error", "User or car not found.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid car selection.");
            }
            response.sendRedirect("adminDashboard.jsp");
            return;
        }

        response.sendRedirect("adminDashboard.jsp");
    }
}