package com.retailo2o.sys;

import com.retailo2o.sys.util.FileUtil;
import com.retailo2o.sys.util.XmlUtil;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import org.dom4j.DocumentException;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MyGenerator {
    private Configuration cfg = new Configuration();

    private void init() throws IOException {
        cfg.setDirectoryForTemplateLoading(new File("src/main/resources/template"));
        cfg.setDefaultEncoding("UTF-8");
        cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
    }

    public void sgGen() throws IOException, TemplateException, DocumentException {
        init();
        //1.设置generatorConfig.xml
        //2.设置DataModel
        DataModel dataModel = new DataModel();
        dataModel.setModelName("BbEleWeigher");
        dataModel.set_modelName("bbEleWeigher");
        dataModel.setDesc("电子秤档案");
        dataModel.setDsName("fresh");
        dataModel.setTblName("bb_ele_weigher");
        String sqlText = "CREATE TABLE `bb_ele_weigher` (\n" +
                "  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',\n" +
                "  `mtenant_id` varchar(20) NOT NULL DEFAULT '' COMMENT '平台租户号',\n" +
                "  `weigher_code` varchar(4) NOT NULL DEFAULT '' COMMENT '电子秤编码',\n" +
                "  `weigher_name` varchar(50) NOT NULL DEFAULT '' COMMENT '电子秤名称',\n" +
                "  `weigher_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '秤类型[0 其他1寺岗2托利多3顶尖]',\n" +
                "  `export_method` tinyint(4) NOT NULL DEFAULT '0' COMMENT '传秤方式[0导出文件1联网]',\n" +
                "  `weigher_model` varchar(50) NOT NULL DEFAULT '' COMMENT '秤型号',\n" +
                "  `ip` varchar(20) NOT NULL DEFAULT '' COMMENT 'IP地址',\n" +
                "  `format_code` varchar(50) NOT NULL DEFAULT '' COMMENT '文件格式',\n" +
                "  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',\n" +
                "  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',\n" +
                "  PRIMARY KEY (`id`),\n" +
                "  UNIQUE KEY `uk_ele_weigher_code` (`mtenant_id`,`weigher_code`)\n" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='电子秤档案';";
        //3.解析
        List<DataModel.Pair> pairs = XmlUtil.parseSqlXml(new File("src/main/resources/com/retailo2o/smc/mapper/" + dataModel.getModelName() + "Mapper.xml"));
        Map<String, String> columnComment = parseColumnCommentMap(sqlText);
        pairs.forEach(o -> o.setComment(columnComment.get(o.getColumn())));
        dataModel.setPairs(pairs);

        Map<String, Object> root = new HashMap<>();
        root.put("data", dataModel);
        //4.ctl
        Template exportTemp = cfg.getTemplate("crud_ctl.ftl");
        Writer exportWriter = new OutputStreamWriter(new FileOutputStream(FileUtil.createFile("src/main/java/com/retailo2o/smc/ctl/", dataModel.getModelName() + "Controller.java")), StandardCharsets.UTF_8);
        exportTemp.process(root, exportWriter);
        exportWriter.close();
        //5.service
        Template serviceTemp = cfg.getTemplate("crud_service.ftl");
        Writer serviceWriter = new OutputStreamWriter(new FileOutputStream(FileUtil.createFile("src/main/java/com/retailo2o/smc/service/", dataModel.getModelName() + "Service.java")), StandardCharsets.UTF_8);
        serviceTemp.process(root, serviceWriter);
        serviceWriter.close();
        // 6.impl
        Template implTemp = cfg.getTemplate("crud_impl.ftl");
        Writer implWriter = new OutputStreamWriter(new FileOutputStream(FileUtil.createFile("src/main/java/com/retailo2o/smc/service/impl/", dataModel.getModelName() + "ServiceImpl.java")), StandardCharsets.UTF_8);
        implTemp.process(root, implWriter);
        implWriter.close();
        //7.mapper code
        Template mapperCodeTemp = cfg.getTemplate("crud_mapper_code.ftl");
        Writer mapperCodeWriter = new OutputStreamWriter(new FileOutputStream(FileUtil.createFile("src/main/java/com/retailo2o/smc/mapper/newer/", dataModel.getModelName() + "Mapper.java")), StandardCharsets.UTF_8);
        mapperCodeTemp.process(root, mapperCodeWriter);
        mapperCodeWriter.close();
        //8.mapper xml
        Template mapperXmlTemp = cfg.getTemplate("crud_mapper_xml.ftl");
        Writer mapperXmlWriter = new OutputStreamWriter(new FileOutputStream(FileUtil.createFile("src/main/resources/com/retailo2o/smc/mapper/newer/", dataModel.getModelName() + "Mapper.xml")), StandardCharsets.UTF_8);
        mapperXmlTemp.process(root, mapperXmlWriter);
        mapperXmlWriter.close();

        Template jsXmlTemp = cfg.getTemplate("crud_js.ftl");
        Writer jsXmlWriter = new OutputStreamWriter(new FileOutputStream(FileUtil.createFile("src/main/resources/com/retailo2o/smc/js/", "index.js")), StandardCharsets.UTF_8);
        jsXmlTemp.process(root, jsXmlWriter);
        jsXmlWriter.close();

        Template vueXmlTemp = cfg.getTemplate("crud_vue.ftl");
        Writer vueXmlWriter = new OutputStreamWriter(new FileOutputStream(FileUtil.createFile("src/main/resources/com/retailo2o/smc/vue/", "index.vue")), StandardCharsets.UTF_8);
        vueXmlTemp.process(root, vueXmlWriter);
        vueXmlWriter.close();
        //9.revert
        //git reset --hard
        //git clean -df
    }

    private static Map<String, String> parseColumnCommentMap(String sqlText) {
        Map<String, String> result = new HashMap<>();
        sqlText = sqlText.replaceAll("\n", "");
        String trim = sqlText.substring(sqlText.indexOf("(") + 1, sqlText.lastIndexOf(")")).trim();
        List<String> split = Arrays.asList(trim.split(","));
        String pattern = "^\\s*`(.+)`.*COMMENT '(.*)'$";
        Pattern r = Pattern.compile(pattern);
        split.forEach(line -> {
            Matcher m = r.matcher(line);
            if (m.find()) {
                result.put(m.group(1), m.group(2));
            }
        });
        return result;
    }
}
