package com.elitecarservices.model;

import java.util.LinkedList;

public class User {
    private String name;
    private String email;
    private String phoneNumber;
    private LinkedList<Car> cars;
    private String password;

    public User(String name, String email, String phoneNumber, LinkedList<Car> cars, String password) {
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.cars = cars;
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public LinkedList<Car> getCars() {
        return cars;
    }

    public void setCars(LinkedList<Car> cars) {
        this.cars = cars;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}