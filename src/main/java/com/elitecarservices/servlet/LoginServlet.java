package com.elitecarservices.servlet;

import com.elitecarservices.model.Car;
import com.elitecarservices.model.User;

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
import java.util.LinkedList;
import java.util.List;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    public void init() throws ServletException {
        // Initialization if needed
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        if (action != null) {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                session.setAttribute("error", "Please log in to perform this action.");
                response.sendRedirect("login.jsp");
                return;
            }

            // Handle adding a car
            if ("addCar".equals(action)) {
                String carModel = request.getParameter("carModel");
                String carYearStr = request.getParameter("carYear");
                if (carModel == null || carModel.trim().isEmpty()) {
                    session.setAttribute("error", "Car model cannot be empty.");
                } else if (carYearStr == null || carYearStr.trim().isEmpty()) {
                    session.setAttribute("error", "Car year cannot be empty.");
                } else {
                    try {
                        int carYear = Integer.parseInt(carYearStr);
                        if (carYear < 1900 || carYear > 2026) {
                            session.setAttribute("error", "Car year must be between 1900 and 2026.");
                        } else {
                            Car newCar = new Car(carModel.trim(), carYear);
                            user.getCars().add(newCar);
                            updateUsersFile(request, user, user.getEmail());
                            session.setAttribute("message", "Car added successfully!");
                        }
                    } catch (NumberFormatException e) {
                        session.setAttribute("error", "Invalid car year. Please enter a valid number.");
                    }
                }
                response.sendRedirect("dashboard.jsp");
                return;
            }

            // Handle deleting a car
            if ("deleteCar".equals(action)) {
                String carIndexStr = request.getParameter("carIndex");
                try {
                    int carIndex = Integer.parseInt(carIndexStr);
                    if (carIndex >= 0 && carIndex < user.getCars().size()) {
                        user.getCars().remove(carIndex);
                        updateUsersFile(request, user, user.getEmail());
                        session.setAttribute("message", "Car deleted successfully!");
                    } else {
                        session.setAttribute("error", "Invalid car selection.");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("error", "Invalid car selection.");
                }
                response.sendRedirect("dashboard.jsp");
                return;
            }

            // Handle updating email and phone
            if ("updateProfile".equals(action)) {
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String originalEmail = user.getEmail();
                if (email == null || !email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
                    session.setAttribute("error", "Invalid email format.");
                } else if (phone == null || !phone.matches("\\d{10,15}")) {
                    session.setAttribute("error", "Phone number must be 10-15 digits.");
                } else if (!email.equals(originalEmail) && isEmailTaken(request, email)) {
                    session.setAttribute("error", "Email is already in use by another user.");
                } else {
                    user.setEmail(email.trim());
                    user.setPhoneNumber(phone.trim());
                    updateUsersFile(request, user, originalEmail);
                    session.setAttribute("message", "Profile updated successfully!");
                }
                response.sendRedirect("dashboard.jsp");
                return;
            }
        }

        // Handle login
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Read users from users.txt
        String usersFilePath = getServletContext().getRealPath("/WEB-INF/users.txt");
        User user = null;

        try (BufferedReader reader = new BufferedReader(new FileReader(usersFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userData = line.split(",");
                if (userData.length < 5) continue;
                if (userData[1].equals(email) && userData[userData.length - 1].equals(password)) {
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
                    user = new User(userData[0], userData[1], userData[2], cars, userData[userData.length - 1]);
                    break;
                }
            }
        }

        if (user != null) {
            session.setAttribute("user", user);
            // Check if admin is logged in
            if (session.getAttribute("admin") != null) {
                response.sendRedirect("adminDashboard.jsp");
            } else {
                response.sendRedirect("dashboard.jsp");
            }
        } else {
            session.setAttribute("error", "Invalid email or password.");
            response.sendRedirect("login.jsp");
        }
    }

    private void updateUsersFile(HttpServletRequest request, User updatedUser, String originalEmail) throws IOException {
        String usersFilePath = request.getServletContext().getRealPath("/WEB-INF/users.txt");
        List<String> lines = new LinkedList<>();
        boolean userFound = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(usersFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userData = line.split(",");
                if (userData.length >= 5 && userData[1].equals(originalEmail)) {
                    StringBuilder carsStr = new StringBuilder();
                    for (Car car : updatedUser.getCars()) {
                        if (carsStr.length() > 0) carsStr.append(";");
                        carsStr.append(car.getModel()).append(":").append(car.getYear());
                    }
                    lines.add(String.join(",", updatedUser.getName(), updatedUser.getEmail(),
                            updatedUser.getPhoneNumber(), carsStr.toString(), updatedUser.getPassword()));
                    userFound = true;
                } else {
                    lines.add(line);
                }
            }
        }

        if (!userFound) {
            throw new IOException("User with email " + originalEmail + " not found in users.txt");
        }

        try (FileWriter writer = new FileWriter(usersFilePath)) {
            for (String line : lines) {
                writer.write(line + "\n");
            }
        }
    }

    private boolean isEmailTaken(HttpServletRequest request, String email) throws IOException {
        String usersFilePath = request.getServletContext().getRealPath("/WEB-INF/users.txt");
        try (BufferedReader reader = new BufferedReader(new FileReader(usersFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userData = line.split(",");
                if (userData.length >= 5 && userData[1].equals(email)) {
                    return true;
                }
            }
        }
        return false;
    }
}