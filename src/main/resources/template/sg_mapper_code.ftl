package com.retailo2o.dds.mapper;


import com.retailo2o.dds.entity.prepaid.PrePaidCardIdentifier;
import net.jplugin.core.das.mybatis.api.BindMapper;

import java.util.List;

@BindMapper <#if data.dsName?default("")?trim?length gt 1>(dataSource = "${data.dsName}")</#if>
public interface ${data.modelName}Mapper {

    long saveOrUpdate(List<${data.modelName}> list);

    Long ${data._modelName}Count();

    Long deleteALl();
}