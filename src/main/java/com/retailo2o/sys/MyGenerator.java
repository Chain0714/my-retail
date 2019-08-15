package com.retailo2o.sys;

import com.retailo2o.sys.util.FileUtil;
import com.retailo2o.sys.util.XmlUtil;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import org.dom4j.DocumentException;

import java.io.*;
import java.util.HashMap;
import java.util.Map;

public class MyGenerator {
    private static final String MODEL_NAME = "modelName";

    private Configuration cfg = new Configuration();

    private void init() throws IOException {
        cfg.setDirectoryForTemplateLoading(new File("src/main/resources/template"));
        cfg.setDefaultEncoding("UTF-8");
        cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
    }

    public void sgGen() throws IOException, TemplateException, DocumentException {
        init();
        //1.首先执行mybatis generator plugin
        //2.设置DataModel
        DataModel dataModel = new DataModel();
        dataModel.setModelName("SubCode");
        dataModel.set_modelName("subCode");
        dataModel.setTypeCode("SubCode");
        dataModel.setDesc("子码属性");
        dataModel.setDsName("");
        dataModel.setTblName("tbsubcode");
        dataModel.setTimer("");
        dataModel.setTopic("");
        //3.解析
        dataModel.setPairs(XmlUtil.parseSqlXml(new File("src/main/resources/com/retailo2o/smc/mapper/" + dataModel.getModelName() + "Mapper.xml")));
        Map<String, Object> root = new HashMap<>();
        root.put("data", dataModel);
        //4.export
        Template exportTemp = cfg.getTemplate("export.ftl");
        Writer exportWriter = new OutputStreamWriter(new FileOutputStream(FileUtil.createFile("src/main/java/com/retailo2o/smc/export/", dataModel.getModelName() + "Export.java")));
        exportTemp.process(root, exportWriter);
        exportWriter.close();
        //5.service
        Template serviceTemp = cfg.getTemplate("sg_c_service.ftl");
        Writer serviceWriter = new OutputStreamWriter(new FileOutputStream(FileUtil.createFile("src/main/java/com/retailo2o/smc/service/", dataModel.getModelName() + "Service.java")));
        serviceTemp.process(root, serviceWriter);
        serviceWriter.close();
        // 6.impl
        Template implTemp = cfg.getTemplate("sg_c_service_impl.ftl");
        Writer implWriter = new OutputStreamWriter(new FileOutputStream(FileUtil.createFile("src/main/java/com/retailo2o/smc/service/impl/", dataModel.getModelName() + "ServiceImpl.java")));
        implTemp.process(root, implWriter);
        implWriter.close();
        //7.mapper code
        Template mapperCodeTemp = cfg.getTemplate("sg_mapper_code.ftl");
        Writer mapperCodeWriter = new OutputStreamWriter(new FileOutputStream(FileUtil.createFile("src/main/java/com/retailo2o/smc/mapper/newer/", dataModel.getModelName() + "Mapper.java")));
        mapperCodeTemp.process(root, mapperCodeWriter);
        mapperCodeWriter.close();
        //8.mapper xml
        Template mapperXmlTemp = cfg.getTemplate("sg_mapper_xml.ftl");
        Writer mapperXmlWriter = new OutputStreamWriter(new FileOutputStream(FileUtil.createFile("src/main/resources/com/retailo2o/smc/mapper/newer/", dataModel.getModelName() + "Mapper.xml")));
        mapperXmlTemp.process(root, mapperXmlWriter);
        mapperXmlWriter.close();
        //9.revert
        //git reset --hard
        //git clean -df
    }
}
