package com.retailo2o.smc.service.impl;

import com.retailo2o.smc.entity.${data.modelName};
import com.retailo2o.smc.mapper.${data.modelName}Mapper;
import com.retailo2o.smc.service.${data.modelName}Service;
import net.jplugin.core.ctx.api.BindRuleService;
import net.jplugin.core.das.api.PageCond;
import net.jplugin.core.das.api.PageQueryResult;
import net.jplugin.core.das.mybatis.api.RefMapper;
import net.jplugin.core.log.api.Logger;
import net.jplugin.core.log.api.RefLogger;
import org.apache.commons.collections.CollectionUtils;

import java.util.ArrayList;
import java.util.List;

@BindRuleService
public class ${data.modelName}ServiceImpl implements ${data.modelName}Service {
    @RefLogger
    private Logger logger;

    @RefMapper
    private ${data.modelName}Mapper mapper;

    private static final long FAIL_INDEX = -1;

    @Override
    public PageQueryResult<${data.modelName}> queryPage(${data.modelName} dto, PageCond pageCond) {
        List<${data.modelName}> list = mapper.selectPage(dto, pageCond);
        if (CollectionUtils.isEmpty(list)) {
            logger.info("${data.modelName}列表查询为空");
            return new PageQueryResult<>(pageCond, new ArrayList<>());
        }
        return new PageQueryResult<>(pageCond, list);
    }

    @Override
    public long merge(${data.modelName} dto) {
        if (null == dto) {
            logger.info("merge failure,${data.modelName} is null");
            return FAIL_INDEX;
        }
        if (dto.getId() == 0) {
            logger.info("开始新增${data.modelName}");
            return mapper.insertSelective(dto);
        }
        if (dto.getId() > 0) {
            logger.info("开始更新${data.modelName}");
            return mapper.updateByPrimaryKey(dto);
        }
        return FAIL_INDEX;
    }

    @Override
    public long remove(long id) {
        return mapper.deleteByPrimaryKey(id);
    }

    @Override
    public ${data.modelName} selectOne(long id) {
        return mapper.selectByPrimaryKey(id);
    }
}
