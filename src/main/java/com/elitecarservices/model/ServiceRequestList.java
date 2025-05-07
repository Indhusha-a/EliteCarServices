package com.elitecarservices.model;

import java.util.LinkedList;

public class ServiceRequestList {
    private LinkedList<ServiceRequest> requests;

    public ServiceRequestList() {
        requests = new LinkedList<>();
    }

    public void addRequest(ServiceRequest request) {
        requests.add(request);
    }

    public LinkedList<ServiceRequest> getRequests() {
        return requests;
    }

    public void sortByDate() {
        int n = requests.size();
        for (int i = 0; i < n - 1; i++) {
            int minIndex = i;
            for (int j = i + 1; j < n; j++) {
                if (requests.get(j).getDate().compareTo(requests.get(minIndex).getDate()) < 0) {
                    minIndex = j;
                }
            }
            if (minIndex != i) {
                ServiceRequest temp = requests.get(i);
                requests.set(i, requests.get(minIndex));
                requests.set(minIndex, temp);
            }
        }
    }
}