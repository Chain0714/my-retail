package com.retailo2o.sys;

import com.alibaba.excel.EasyExcelFactory;
import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.event.AnalysisEventListener;
import com.alibaba.excel.metadata.Sheet;
import com.csvreader.CsvReader;
import com.google.common.collect.Lists;
import com.retailo2o.sys.excelentity.DDSEntity;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;

import java.io.*;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class MyGenerator {
    private static final String MODEL_NAME = "modelName";

    private Configuration cfg = new Configuration();

    private void init() throws IOException {
        cfg.setDirectoryForTemplateLoading(new File("src/main/resources/template"));
        cfg.setDefaultEncoding("UTF-8");
        cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
    }

    public void gen(Class<?> clz) throws IOException, TemplateException {
        init();
        Map<String, Object> root = new HashMap<>();
        root.put(MODEL_NAME, clz.getSimpleName());
        //生成controller代码
        Template ctlTemp = cfg.getTemplate("ctl.ftl");
        Writer ctlWriter = new OutputStreamWriter(new FileOutputStream(new File("src/main/java/com/retailo2o/smc/ctrl/" + clz.getSimpleName() + "Controller.java")));
        ctlTemp.process(root, ctlWriter);
        ctlWriter.close();
        //生成service interface
        Template serviceTemp = cfg.getTemplate("service.ftl");
        Writer serviceWriter = new OutputStreamWriter(new FileOutputStream(new File("src/main/java/com/retailo2o/smc/service/" + clz.getSimpleName() + "Service.java")));
        serviceTemp.process(root, serviceWriter);
        serviceWriter.close();
        //生成service impl
        Template implTemp = cfg.getTemplate("impl.ftl");
        Writer implWriter = new OutputStreamWriter(new FileOutputStream(new File("src/main/java/com/retailo2o/smc/service/impl/" + clz.getSimpleName() + "ServiceImpl.java")));
        implTemp.process(root, implWriter);
        implWriter.close();
    }

    public void csvGen() throws IOException, TemplateException {
        init();
        List<Map<String, Object>> list = new ArrayList<>();
        // 第一参数：读取文件的路径 第二个参数：分隔符（不懂仔细查看引用百度百科的那段话） 第三个参数：字符集
        CsvReader csvReader = new CsvReader("F:/my_project/my-retail/src/main/resources/csv/sf1.csv", ',', Charset.forName("UTF-8"));

        // 如果你的文件没有表头，这行不用执行
        // 这行不要是为了从表头的下一行读，也就是过滤表头
        csvReader.readHeaders();

        // 读取每行的内容
        while (csvReader.readRecord()) {
            Map<String, Object> map = new HashMap<>();
            map.put("rq", csvReader.get("rq"));
            map.put("jjr", csvReader.get("jjr"));
            map.put("lxfs", csvReader.get("lxfs"));
            map.put("mdd", csvReader.get("mdd"));
            map.put("kdddh", csvReader.get("kdddh"));
            map.put("jbr", csvReader.get("jbr"));
            map.put("jjfs", csvReader.get("jjfs"));
            map.put("sjf", csvReader.get("sjf"));
            list.add(map);
        }

        Map<String, Object> root = new HashMap<>();
        root.put("objs", list);
        Template ctlTemp = cfg.getTemplate("word111.ftl");
        Writer ctlWriter = new OutputStreamWriter(new FileOutputStream(new File("src/main/java/com/retailo2o/smc/export/word.xml")));
        ctlTemp.process(root, ctlWriter);
        ctlWriter.close();
    }

    public void ddsGen() throws IOException, TemplateException {
        init();
        FileInputStream fis = new FileInputStream(new File("src/main/resources/csv/dds.xlsx"));
        ExcelListener excelListener = new ExcelListener();
        EasyExcelFactory.readBySax(fis, new Sheet(1, 1, DDSEntity.class), excelListener);
        List<DDSEntity> ddsEntities = excelListener.data;
        ddsEntities = ddsEntities.parallelStream().filter(o -> !"N".equals(o.getEffective())).collect(Collectors.toList());
        ddsEntities.forEach(o -> {
            if (o.getDdsTbl().endsWith("_0000")) {
                o.setDdsTbl(o.getDdsTbl().substring(0, o.getDdsTbl().length() - 5));
                o.setDept("true");
            }
        });
        Map<String, List<DDSEntity>> collect = ddsEntities.parallelStream().collect(Collectors.groupingBy(DDSEntity::getDataType));
        List<DDSEntity> plusEntityList = collect.get("增量");
        List<DDSEntity> result = collect.get("全量").parallelStream().filter(o -> plusEntityList.parallelStream().noneMatch(t -> t.getDdsTbl().equals(o.getDdsTbl()))).collect(Collectors.toList());
        result.addAll(plusEntityList);
        for (DDSEntity entity : result) {
            ddsOutput(entity);
        }
        Template codeTemp = cfg.getTemplate("ddsCode.ftl");
        Writer codeWriter = new OutputStreamWriter(new FileOutputStream(new File("src/main/java/com/retailo2o/smc/export/Code.java")));
        Map<String,Object> results = new HashMap<>();
        results.put("result",result);
        codeTemp.process(results, codeWriter);
        codeWriter.close();
    }

    private void ddsOutput(DDSEntity entity) throws IOException, TemplateException {
        entity.setClazz(entity.getBase() + "Mapper");
        entity.setMethod(entity.getBase().substring(0, 1).toLowerCase() + entity.getBase().substring(1, entity.getBase().length() - 1));
        Template svcTemp = cfg.getTemplate("ddssvc.ftl");
        Template xmlTemp = cfg.getTemplate("ddsxml.ftl");
        Writer svcWriter = new OutputStreamWriter(new FileOutputStream(new File("src/main/java/com/retailo2o/smc/export/" + entity.getBase() + "Mapper.java")));
        svcTemp.process(entity, svcWriter);
        Writer xmlWriter = new OutputStreamWriter(new FileOutputStream(new File("src/main/java/com/retailo2o/smc/export/" + entity.getBase() + "Mapper.xml")));
        xmlTemp.process(entity, xmlWriter);
        svcWriter.close();
        xmlWriter.close();
    }

    private class ExcelListener extends AnalysisEventListener {

        List<DDSEntity> data = Lists.newArrayList();

        @Override
        public void invoke(Object object, AnalysisContext context) {
            DDSEntity goodsDefImportEntity = (DDSEntity) object;
            data.add(goodsDefImportEntity);
        }

        @Override
        public void doAfterAllAnalysed(AnalysisContext context) {
        }
    }
}
