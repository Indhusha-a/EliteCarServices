package com.elitecarservices.model;

public class Admin {
    private String name;
    private String idNumber;
    private String contactNumber;
    private String email;
    private String password;

    public Admin(String name, String idNumber, String contactNumber, String email, String password) {
        this.name = name;
        this.idNumber = idNumber;
        this.contactNumber = contactNumber;
        this.email = email;
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIdNumber() {
        return idNumber;
    }

    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}