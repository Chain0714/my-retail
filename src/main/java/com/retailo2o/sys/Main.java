package com.retailo2o.sys;

import com.retailo2o.sys.MyGenerator;
import freemarker.template.TemplateException;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException, TemplateException {
        MyGenerator generator = new MyGenerator();
//        generator.gen(SamDataLog.class);
//        generator.csvGen();
        generator.ddsGen();
    }
}
