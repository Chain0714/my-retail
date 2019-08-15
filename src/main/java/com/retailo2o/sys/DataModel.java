package com.retailo2o.sys;

import lombok.Data;

import java.util.List;

/**
 * @author dell
 */
@Data
public class DataModel {
    private String modelName;
    private String _modelName;
    private String typeCode;
    private String desc;

    private String dsName;
    private String tblName;
    private String timer;
    private List<Pair> pairs;

    private String topic;


    @Data
    public static class Pair {
        private int order;
        private String field;
        private String column;
        private String type;
    }
}
