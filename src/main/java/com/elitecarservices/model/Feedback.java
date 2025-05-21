package com.elitecarservices.model;

public class Feedback implements Serializable {
    private String userName;
    private String email;
    private String packageName;
    private String feedbackText;
    private String date;

    public Feedback(String userName, String email, String packageName, String feedbackText, String date) {
        this.userName = userName;
        this.email = email;
        this.packageName = packageName;
        this.feedbackText = feedbackText;
        this.date = date;
    }

    // Getters and setters
    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    public String getFeedbackText() {
        return feedbackText;
    }

    public void setFeedbackText(String feedbackText) {
        this.feedbackText = feedbackText;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
}