package com.elitecarservices.model;

import java.util.LinkedList;

public class UserLinkedList {
    private LinkedList<User> users;

    public UserLinkedList() {
        this.users = new LinkedList<>();
    }

    public void addUser(User user) {
        users.add(user);
    }

    public User findUserByEmail(String email) {
        for (User user : users) {
            if (user.getEmail().equals(email)) {
                return user;
            }
        }
        return null;
    }

    public boolean emailExists(String email) {
        for (User user : users) {
            if (user.getEmail().equals(email)) {
                return true;
            }
        }
        return false;
    }
}