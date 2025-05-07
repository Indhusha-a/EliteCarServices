package com.elitecarservices.model;

import java.util.LinkedList;

public class ServiceHistory {
    private LinkedList<ServiceRecord> records;

    public ServiceHistory() {
        records = new LinkedList<>();
    }

    public void addRecord(ServiceRecord record) {
        records.add(record);
    }

    public LinkedList<ServiceRecord> getRecords() {
        return records;
    }

    public void sortByDate() {
        // Selection Sort
        int n = records.size();
        for (int i = 0; i < n - 1; i++) {
            int minIndex = i;
            for (int j = i + 1; j < n; j++) {
                if (records.get(j).getDate().compareTo(records.get(minIndex).getDate()) < 0) {
                    minIndex = j;
                }
            }
            if (minIndex != i) {
                ServiceRecord temp = records.get(i);
                records.set(i, records.get(minIndex));
                records.set(minIndex, temp);
            }
        }
    }
}