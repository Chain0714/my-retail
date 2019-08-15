package com.retailo2o.sys;

public class Main {
    public static void main(String[] args) {
        MyGenerator generator = new MyGenerator();
        try {
            generator.sgGen();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
