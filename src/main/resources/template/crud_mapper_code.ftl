package com.retailo2o.smc.mapper;

import com.retailo2o.smc.entity.${data.modelName};
import net.jplugin.core.das.api.PageCond;
import net.jplugin.core.das.mybatis.api.BindMapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@BindMapper <#if data.dsName?default("")?trim?length gt 1>(dataSource = "${data.dsName}")</#if>
public interface ${data.modelName}Mapper {
    List<${data.modelName}> selectPage(@Param("queryDto") ${data.modelName} queryDto, @Param("page") PageCond page);

    List<${data.modelName}> selectList(@Param("queryDto") ${data.modelName} queryDto);

    ${data.modelName} selectOne(@Param("id") long id);

    long insert(@Param("dto") ${data.modelName} dto);

    long update(@Param("dto") ${data.modelName} dto);

    long deleteById(@Param("id") long id);

}
