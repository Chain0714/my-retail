package com.retailo2o.smc.service;

import com.retailo2o.smc.entity.${data.modelName};
import net.jplugin.core.das.api.PageCond;
import net.jplugin.core.das.api.PageQueryResult;

import java.util.List;

public interface ${data.modelName}Service {

    PageQueryResult<${data.modelName}> queryPage(${data.modelName} dto, PageCond pageCond);

    long merge(${data.modelName} dto);

    long remove(long id);

    List<${data.modelName}> queryList(${data.modelName} dto);

    ${data.modelName} selectOne(long id);

}
