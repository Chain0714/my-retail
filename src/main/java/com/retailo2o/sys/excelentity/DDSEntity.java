package com.retailo2o.sys.excelentity;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.metadata.BaseRowModel;
import lombok.Data;

import java.io.Serializable;

@Data
public class DDSEntity extends BaseRowModel implements Serializable {

    @ExcelProperty(value = "规则编码", index = 0)
    private String ruleCode;

    @ExcelProperty(value = "规则名称", index = 1)
    private String ruleName;

    @ExcelProperty(value = "数据应名称", index = 2)
    private String dsType;

    @ExcelProperty(value = "erp表", index = 3)
    private String erpTbl;

    @ExcelProperty(value = "增量全量", index = 5)
    private String dataType;

    @ExcelProperty(value = "中台库", index = 6)
    private String ddsDs;

    @ExcelProperty(value = "小中台表", index = 7)
    private String ddsTbl;

    @ExcelProperty(value = "查询类型", index = 9)
    private String queryType;

    @ExcelProperty(value = "基础标识", index = 10)
    private String base;

    private String method;

    private String clazz;

    @ExcelProperty(value = "时间标识", index = 11)
    private String time;

    @ExcelProperty(value = "effective", index = 12)
    private String effective;

    private String dept;
}
