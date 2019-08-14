package com.retailo2o.sys;

import com.retailo2o.sys.util.XmlUtil;
import freemarker.template.TemplateException;
import org.dom4j.DocumentException;

import java.io.File;
import java.io.IOException;
import java.util.List;

public class Main {
    public static void main(String[] args) throws IOException, TemplateException {
        MyGenerator generator = new MyGenerator();
//        generator.gen(SamDataLog.class);
//        generator.csvGen();
//        generator.ddsGen();
        try {
            List<DataModel.Pair> pairs = XmlUtil.parseSqlXml(new File("src/main/resources/com/retailo2o/smc/mapper/PrePaidCardIdentifierMapper.xml"));
            System.out.println(pairs);
        } catch (DocumentException e) {
            e.printStackTrace();
        }
    }
}
