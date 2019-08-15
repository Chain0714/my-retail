package com.retailo2o.smc.service;

import com.retailo2o.smc.entity.${modelName};
import net.jplugin.core.das.api.PageCond;
import net.jplugin.core.das.api.PageQueryResult;

import java.util.List;

public interface ${modelName}Service {
    PageQueryResult<${modelName}> queryPage(${modelName} dto, PageCond pageCond);

    long merge(${modelName} dto);

    long remove(long id);

    List<${modelName}> queryList(${modelName} dto);

    ${modelName} selectOne(long id);

}
