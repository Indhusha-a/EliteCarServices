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
import java.io.IOException;
import java.util.LinkedList;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        // Handle adding a car
        if ("addCar".equals(action)) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                String carModel = request.getParameter("carModel");
                String carYearStr = request.getParameter("carYear");
                try {
                    int carYear = Integer.parseInt(carYearStr);
                    Car newCar = new Car(carModel, carYear);
                    user.getCars().add(newCar);
                    // Note: This only updates the in-memory user object; you'll need to persist to users.txt if required
                } catch (NumberFormatException e) {
                    session.setAttribute("error", "Invalid car year. Please enter a valid number.");
                }
            }
            response.sendRedirect("dashboard.jsp");
            return;
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
                if (userData.length < 5) continue; // Skip malformed lines
                if (userData[1].equals(email) && userData[userData.length - 1].equals(password)) {
                    LinkedList<Car> cars = new LinkedList<>();
                    String[] carData = userData[3].split(";");
                    for (String car : carData) {
                        String[] carDetails = car.split(":");
                        if (carDetails.length == 2) {
                            cars.add(new Car(carDetails[0], Integer.parseInt(carDetails[1])));
                        }
                    }
                    user = new User(userData[0], userData[1], userData[2], cars, userData[userData.length - 1]);
                    break;
                }
            }
        }

        if (user != null) {
            session.setAttribute("user", user);
            response.sendRedirect("dashboard.jsp");
        } else {
            session.setAttribute("error", "Invalid email or password.");
            response.sendRedirect("login.jsp");
        }
    }
}