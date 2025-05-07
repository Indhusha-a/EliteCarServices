package com.elitecarservices.model;

public class ServiceRequest {
    private String date;
    private String time;
    private String car;
    private String mileage;
    private String service;
    private String branch;
    private String paymentType;
    private String bookingReference;
    private String status;

    public ServiceRequest(String date, String time, String car, String mileage, String service,
                          String branch, String paymentType, String bookingReference, String status) {
        this.date = date;
        this.time = time;
        this.car = car;
        this.mileage = mileage;
        this.service = service;
        this.branch = branch;
        this.paymentType = paymentType;
        this.bookingReference = bookingReference;
        this.status = status;
    }

    public String getDate() {
        return date;
    }

    public String getTime() {
        return time;
    }

    public String getCar() {
        return car;
    }

    public String getMileage() {
        return mileage;
    }

    public String getService() {
        return service;
    }

    public String getBranch() {
        return branch;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public String getBookingReference() {
        return bookingReference;
    }

    public String getStatus() {
        return status;
    }
}