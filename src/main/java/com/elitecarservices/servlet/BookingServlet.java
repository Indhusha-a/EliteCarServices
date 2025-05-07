package com.elitecarservices.servlet;

import com.elitecarservices.model.User;
import com.elitecarservices.model.Car;
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
import java.io.PrintWriter;
import java.util.LinkedList;
import java.util.ArrayList;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
    private static final String[] VALID_PACKAGES = {"Econo Plus", "Auto Service Plus", "Euro Total Plus", "Total Care Plus"};

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Retrieve form data
        String name = request.getParameter("name");
        String phoneNumber = request.getParameter("phoneNumber");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String reference = request.getParameter("reference");
        String[] selectedCarIndices = request.getParameterValues("selectedCars");
        String anythingElse = request.getParameter("anythingElse");
        String branch = request.getParameter("branch");
        String packageName = request.getParameter("packageName");

        // Use user data as fallback if name or phoneNumber is null
        if (name == null || name.isEmpty()) {
            name = user.getName();
        }
        if (phoneNumber == null || phoneNumber.isEmpty()) {
            phoneNumber = user.getPhoneNumber();
        }

        // Validate required fields
        if (date == null || date.isEmpty() || time == null || time.isEmpty() ||
                reference == null || reference.isEmpty() || branch == null || branch.isEmpty()) {
            session.setAttribute("error", "Please fill all required fields.");
            session.setAttribute("packageName", packageName);
            response.sendRedirect("booking.jsp");
            return;
        }
        if (selectedCarIndices == null || selectedCarIndices.length == 0) {
            session.setAttribute("error", "Please select at least one car.");
            session.setAttribute("packageName", packageName);
            response.sendRedirect("booking.jsp");
            return;
        }
        if (packageName == null || packageName.isEmpty() || !isValidPackage(packageName)) {
            session.setAttribute("error", "Invalid or no package selected.");
            response.sendRedirect("selectPackage.jsp");
            return;
        }

        // Update user object in session
        user.setName(name);
        user.setPhoneNumber(phoneNumber);
        session.setAttribute("user", user);

        // Update users.txt
        String usersFilePath = getServletContext().getRealPath("/WEB-INF/users.txt");
        ArrayList<String> userLines = new ArrayList<>();
        boolean userUpdated = false;
        try (BufferedReader reader = new BufferedReader(new FileReader(usersFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userData = line.split(",");
                if (userData.length >= 5 && userData[1].equals(user.getEmail())) {
                    StringBuilder carsStr = new StringBuilder();
                    LinkedList<Car> cars = user.getCars();
                    for (int i = 0; i < cars.size(); i++) {
                        Car car = cars.get(i);
                        carsStr.append(car.getModel()).append(":").append(car.getYear());
                        if (i < cars.size() - 1) {
                            carsStr.append(";");
                        }
                    }
                    line = String.format("%s,%s,%s,%s,%s",
                            name, user.getEmail(), phoneNumber, carsStr.toString(), user.getPassword());
                    userUpdated = true;
                }
                userLines.add(line);
            }
        } catch (IOException e) {
            session.setAttribute("error", "Error reading user data. Please try again.");
            session.setAttribute("packageName", packageName);
            response.sendRedirect("booking.jsp");
            return;
        }

        try (PrintWriter writer = new PrintWriter(new FileWriter(usersFilePath))) {
            for (String line : userLines) {
                writer.println(line);
            }
        } catch (IOException e) {
            session.setAttribute("error", "Error saving user data. Please try again.");
            session.setAttribute("packageName", packageName);
            response.sendRedirect("booking.jsp");
            return;
        }

        if (!userUpdated) {
            session.setAttribute("error", "User not found in database. Please try again.");
            session.setAttribute("packageName", packageName);
            response.sendRedirect("booking.jsp");
            return;
        }

        // Build car details with mileage for booking
        StringBuilder carDetails = new StringBuilder();
        LinkedList<Car> cars = user.getCars();
        boolean firstCar = true;
        for (String indexStr : selectedCarIndices) {
            try {
                int index = Integer.parseInt(indexStr);
                if (index >= 0 && index < cars.size()) {
                    Car car = cars.get(index);
                    String mileage = request.getParameter("mileage-" + index);
                    if (mileage == null || mileage.isEmpty()) {
                        session.setAttribute("error", "Please provide mileage for all selected cars.");
                        session.setAttribute("packageName", packageName);
                        response.sendRedirect("booking.jsp");
                        return;
                    }
                    if (!firstCar) {
                        carDetails.append(";");
                    }
                    carDetails.append(car.getModel()).append(":").append(car.getYear()).append(":").append(mileage);
                    firstCar = false;
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid car selection.");
                session.setAttribute("packageName", packageName);
                response.sendRedirect("booking.jsp");
                return;
            }
        }

        // Save booking details to bookings.txt
        String bookingsFilePath = getServletContext().getRealPath("/WEB-INF/bookings.txt");
        try (PrintWriter writer = new PrintWriter(new FileWriter(bookingsFilePath, true))) {
            String bookingLine = String.format("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,pending",
                    name, user.getEmail(), phoneNumber, branch, date, time,
                    reference, packageName, carDetails.toString(),
                    anythingElse != null ? anythingElse.replace(",", ";") : "");
            writer.println(bookingLine);
        } catch (IOException e) {
            session.setAttribute("error", "Error saving booking. Please try again.");
            session.setAttribute("packageName", packageName);
            response.sendRedirect("booking.jsp");
            return;
        }

        // Store booking reference and packageName in session for Payment.jsp
        session.setAttribute("bookingReference", reference);
        session.setAttribute("packageName", packageName);

        // Redirect to Payment.jsp
        response.sendRedirect("Payment.jsp");
    }

    private boolean isValidPackage(String packageName) {
        for (String validPackage : VALID_PACKAGES) {
            if (validPackage.equals(packageName)) {
                return true;
            }
        }
        return false;
    }
}