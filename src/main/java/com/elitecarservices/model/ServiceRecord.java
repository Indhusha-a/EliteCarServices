package com.elitecarservices.model;

public class ServiceRecord {
    private String date;
    private String mileage;
    private String vehicle;
    private String service;

    public ServiceRecord(String date, String mileage, String vehicle, String service) {
        this.date = date;
        this.mileage = mileage;
        this.vehicle = vehicle;
        this.service = service;
    }

    public String getDate() {
        return date;
    }

    public String getMileage() {
        return mileage;
    }

    public String getVehicle() {
        return vehicle;
    }

    public String getService() {
        return service;
    }
}