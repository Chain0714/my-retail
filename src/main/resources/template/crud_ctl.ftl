package com.haiziwang.retailsam.controller;

import com.haiziwang.retailsam.constant.ExceptionCodeEnum;
import com.haiziwang.retailsam.framework.base.BaseController;
import net.jplugin.core.ctx.api.RefRuleService;
import net.jplugin.core.das.api.PageCond;
import net.jplugin.core.das.api.PageQueryResult;
import net.jplugin.core.log.api.Logger;
import net.jplugin.core.log.api.RefLogger;
import net.jplugin.ext.webasic.api.BindController;


@BindController(path = "/${data._modelName}")
public class ${data.modelName}Controller extends BaseController {

    private static final long FAIL_INDEX = -1;

    private static final String ID = "id";


    @RefLogger
    private Logger logger;

    @RefRuleService
    private ${data.modelName}Service ${data._modelName}Service;

    public void queryPage() {
        PageCond page = this.getPage();
        ${data.modelName} req = this.getBody(${data.modelName}.class);
        PageQueryResult<${data.modelName}> list = this.${data._modelName}Service.queryPage(req, page);
        buildSuccessResponse(list);
    }

    public void saveOrUpdate() {
        ${data.modelName} req = this.getBody(${data.modelName}.class);
        if (null == req) {
            logger.error("save or update ${data.modelName} error:request is null");
            buildFailResponse(ExceptionCodeEnum.PARA_NULL);
            return;
        }
        long result = this.${data._modelName}Service.merge(req);
        if (FAIL_INDEX == result) {
            buildFailResponse(ExceptionCodeEnum.ERROR);
            return;
        }
        buildSuccessResponse(ExceptionCodeEnum.SUCCESS);
    }

    public void queryList() {
        ${data.modelName} req = this.getBody(${data.modelName}.class);
        List<${data.modelName}> ${data._modelName}List;
        try {
            ${data._modelName}List = ${data._modelName}Service.queryList(req);
        } catch (Exception e) {
            buildFailResponse(ExceptionCodeEnum.ERROR);
            logger.error("queryList ${data._modelName} error:",e);
            return;
        }
        buildSuccessResponse(${data._modelName}List);
    }

    public void remove() {
        String id = getParamNonNull(ID);
        if (StringKit.isEmpty(id)) {
            buildFailResponse(ExceptionCodeEnum.ERROR);
            return;
        }
        try {
            ${data._modelName}Service.remove(Long.valueOf(id));
        } catch (NumberFormatException e) {
            buildFailResponse(ExceptionCodeEnum.ERROR);
            logger.error("queryList ${data._modelName} error:",e);
            return;
        }
            buildSuccessResponse(ExceptionCodeEnum.SUCCESS);
        }
}
