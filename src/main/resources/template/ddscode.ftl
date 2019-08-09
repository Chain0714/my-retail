<#list result as entity>
import com.retailo2o.dds.mapper.assist.${entity.base}Mapper;

</#list>
**************************************************************************************************
<#list result as entity>
@RefMapper
private ${entity.base}Mapper ${entity.method}Mapper;

</#list>
*************************************************************************************************
<#list result as entity>
else if("${entity.queryType}".equals(type)){//${entity.ruleName}
    Long k = ${entity.method}Mapper.${entity.method}Count(map);
    return k==null?0L:k;
}
</#list>