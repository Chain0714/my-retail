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
            logger.info("${data.modelName} query list is empty!");
            return new PageQueryResult<>(pageCond, new ArrayList<>());
        }
        return new PageQueryResult<>(pageCond, list);
    }

    @Override
    public List<${data.modelName}> queryList(${data.modelName} dto){
        if (null == dto) {
            logger.info("query List failure,${data.modelName} is null");
            return new ArrayList<>();
        }
        return mapper.selectList(dto);
    }

    @Override
    public long merge(${data.modelName} dto) {
        if (null == dto) {
            logger.info("merge failure,${data.modelName} is null");
            return FAIL_INDEX;
        }
        if (dto.getId() == null) {
            logger.info("begin to insert ${data.modelName}");
            return mapper.insert(dto);
        }
        if (dto.getId() > 0) {
            logger.info("begin to update ${data.modelName}");
            return mapper.update(dto);
        }
        return FAIL_INDEX;
    }

    @Override
    public long remove(long id) {
        return mapper.deleteById(id);
    }

    @Override
    public ${data.modelName} selectOne(long id) {
        return mapper.selectOne(id);
    }
}
