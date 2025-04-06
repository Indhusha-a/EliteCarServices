package com.elitecarservices.servlet;

import com.elitecarservices.model.Car;
import com.elitecarservices.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.*;
import java.util.LinkedList;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String[] carModels = request.getParameterValues("carModel");
        String[] carYears = request.getParameterValues("carYear");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        HttpSession session = request.getSession();

        // Validate password match
        if (!password.equals(confirmPassword)) {
            session.setAttribute("error", "Passwords do not match.");
            response.sendRedirect("register.jsp");
            return;
        }

        // Validate car data
        if (carModels == null || carYears == null || carModels.length != carYears.length) {
            session.setAttribute("error", "Invalid car data. Please provide both model and year for each car.");
            response.sendRedirect("register.jsp");
            return;
        }

        // Validate car years
        LinkedList<Car> cars = new LinkedList<>();
        for (int i = 0; i < carModels.length; i++) {
            try {
                int year = Integer.parseInt(carYears[i]);
                if (year < 1900 || year > 2025) {
                    session.setAttribute("error", "Invalid car year for " + carModels[i] + ". Please enter a year between 1900 and 2025.");
                    response.sendRedirect("register.jsp");
                    return;
                }
                cars.add(new Car(carModels[i], year));
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid car year for " + carModels[i] + ". Please enter a valid number.");
                response.sendRedirect("register.jsp");
                return;
            }
        }

        // Check if email already exists
        String usersFilePath = getServletContext().getRealPath("/WEB-INF/users.txt");
        File usersFile = new File(usersFilePath);
        if (usersFile.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(usersFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] userData = line.split(",");
                    if (userData.length > 1 && userData[1].equals(email)) {
                        session.setAttribute("error", "Email already exists.");
                        response.sendRedirect("register.jsp");
                        return;
                    }
                }
            }
        }

        // Create new user
        User user = new User(name, email, phoneNumber, cars, password);

        // Append user to users.txt
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(usersFile, true))) {
            if (user.getCars() != null && !user.getCars().isEmpty()) {
                StringBuilder carData = new StringBuilder();
                for (int i = 0; i < user.getCars().size(); i++) {
                    carData.append(user.getCars().get(i).toString());
                    if (i < user.getCars().size() - 1) {
                        carData.append(";");
                    }
                }
                writer.write(user.getName() + "," + user.getEmail() + "," + user.getPhoneNumber() + "," +
                        carData.toString() + "," + user.getPassword());
                writer.newLine();
            } else {
                session.setAttribute("error", "No cars added for the user.");
                response.sendRedirect("register.jsp");
                return;
            }
        } catch (IOException e) {
            session.setAttribute("error", "Error saving user data: " + e.getMessage());
            response.sendRedirect("register.jsp");
            return;
        }

        session.setAttribute("message", "Registration successful. Please log in.");
        response.sendRedirect("login.jsp");
    }
}
