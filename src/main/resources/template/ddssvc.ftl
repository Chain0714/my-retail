package com.retailo2o.dds.mapper.assist;

import java.util.Map;

import net.jplugin.core.das.mybatis.api.BindMapper;

/**
规则编码：${ruleCode}
规则名称：${ruleName}
**/
@BindMapper(dataSource = "${ddsDs}")
public interface ${clazz} {
    Long ${method}Count(Map<String, String> map);
}
