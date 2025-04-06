package com.elitecarservices.model;

import java.util.LinkedList;

public class UserLinkedList {
    // List to store all users
    private LinkedList<User> users;

    // Constructor to initialize the empty list
    public UserLinkedList() {
        this.users = new LinkedList<>();
    }

    // Add a new user to the list
    public void addUser(User user) {
        users.add(user);
    }

    // Find a user by their email, return null if not found
    public User findUserByEmail(String email) {
        for (User user : users) {
            if (user.getEmail().equals(email)) {
                return user;
            }
        }
        return null;
    }

    // Check if an email already exists in the list
    public boolean emailExists(String email) {
        for (User user : users) {
            if (user.getEmail().equals(email)) {
                return true;
            }
        }
        return false;
    }

    // Get the entire list of users
    public LinkedList<User> getUsers() {
        return users;
    }
}