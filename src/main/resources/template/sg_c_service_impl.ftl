package com.retailo2o.dds.service.impl;

import com.alibaba.fastjson.JSON;
import com.retailo2o.dds.common.constant.DataSizeTypeEnum;
import com.retailo2o.dds.common.util.CommUtil;
import com.retailo2o.dds.common.util.ReqData;
import com.retailo2o.dds.entity.prepaid.PrePaidCardIdentifier;
import com.retailo2o.dds.mapper.feldlog.B2bFieldLogMapper;
import com.retailo2o.dds.mapper.prepaid.PrePaidCardIdentifierMapper;
import com.retailo2o.dds.service.intf.prepaid.PrePaidService;
import net.jplugin.core.ctx.api.BindRuleService;
import net.jplugin.core.ctx.api.Rule;
import net.jplugin.core.das.mybatis.api.RefMapper;
import net.jplugin.core.log.api.Logger;
import net.jplugin.core.log.api.RefLogger;

import java.util.List;
@BindRuleService
public class ${data.modelName}ServiceImpl implements ${data.modelName}Service {

private static final long FAILED_INDEX = -1;

@RefLogger
private Logger logger;

@RefMapper
private ${data.modelName}Mapper ${data._modelName}Mapper;

@RefMapper
private B2bFieldLogMapper b2bFieldLogMapper;

@Override
@Rule(methodType = Rule.TxType.REQUIRED)
public Long execute(ReqData rd, DataSizeTypeEnum dst) {
    try {
        List<${data.modelName}> list = JSON.parseArray(rd.getData(), ${data.modelName}.class);
        if (null == list || list.size() == 0) {
            return FAILED_INDEX;
        }
        return ${data._modelName}Mapper.saveOrUpdate(list);
        } catch (Exception e) {
            CommUtil.saveFieldLog(rd, e, b2bFieldLogMapper);
            logger.error("error:", e);
            return FAILED_INDEX;
        }
    }
}
