package com.retailo2o.smc.ctrl;

import com.retailo2o.smc.common.constant.ErrorEnum;
import com.retailo2o.smc.common.ctrl.BaseController;
import com.retailo2o.smc.common.util.JSONUtil;
import com.retailo2o.smc.common.vo.RespJson;
import com.retailo2o.smc.entity.${modelName};
import com.retailo2o.smc.service.${modelName}Service;
import net.jplugin.common.kits.JsonKit;
import net.jplugin.common.kits.StringKit;
import net.jplugin.core.ctx.api.RefRuleService;
import net.jplugin.core.das.api.PageCond;
import net.jplugin.core.das.api.PageQueryResult;
import net.jplugin.core.log.api.Logger;
import net.jplugin.core.log.api.RefLogger;
import net.jplugin.ext.webasic.api.BindController;
import org.apache.commons.collections.CollectionUtils;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@BindController(path = "/${modelName}")
public class ${modelName}Controller extends BaseController {
    @RefLogger
    private Logger logger;

    @RefRuleService
    private ${modelName}Service service;

    public void list() {
        renderHtml("${modelName}/list.ftl");
    }

    public void toAdd() {
        renderHtml("${modelName}/add.ftl");
    }

    public void toEdit() {
        try {
            String idStr = getParamNonNull("param");
            long id = Long.valueOf(idStr);
            if (id <= 0) {
                responseJson(new RespJson(ErrorEnum.ERROR.getErrorCode(), "id为空"));
                return;
            }
            ${modelName} dto = service.selectOne(id);
            if (null == dto) {
                responseJson(new RespJson(ErrorEnum.ERROR.getErrorCode(), "查无数据"));
                return;
            }
            Map<String, Object> map = JSONUtil.objToStringMap(posDownCfgDto);
            renderHtmlByMapParam("${modelName}/add.ftl", map);
        } catch (Exception e) {
            logger.error("toEdit exception", e);
            responseJson(new RespJson(ErrorEnum.ERROR.getErrorCode(), e.getMessage()));
        }
    }

    public void queryPage() {
        try {
            ${modelName} dto = JsonKit.json2Object(getParamNonNull("param"), ${modelName}.class);
            if (null == dto) {
                logger.info("query page list param is null");
                return;
            }
            logger.info("分页查询${modelName}请求参数：{}", dto);
            PageCond page = getBootstrapPage();
            PageQueryResult<${modelName}> result = service.queryPage(dto, page);
            responseJson(new RespJson(result));
        } catch (Exception e) {
            logger.error("query list with page exception", e);
            responseJson(new RespJson(ErrorEnum.ERROR.getErrorCode(), e.getMessage()));
        }
    }

    public void save() {
        try {
            ${modelName} dto = JsonKit.json2Object(getParamNonNull("param"), ${modelName}.class);
            if (null == dto) {
                responseJson(new RespJson(ErrorEnum.ERROR.getErrorCode(), "保存${modelName}参数为空"));
                return;
            }
            long l = service.merge(dto);
            if (l > 0) {
                responseJson(new RespJson(ErrorEnum.SUCCESS));
            } else {
                responseJson(new RespJson(ErrorEnum.ERROR));
            }
        } catch (Exception e) {
            logger.error("save ${modelName} exception", e);
            responseJson(new RespJson(ErrorEnum.ERROR.getErrorCode(), e.getMessage()));
        }
    }

    public void delete() {
        try {
            String idStr = getParamNonNull("param");
            long id = Long.valueOf(idStr);
            if (id <= 0) {
                logger.info("删除${modelName}参数为空");
                responseJson(new RespJson(ErrorEnum.ERROR.getErrorCode(), "id为空"));
                return;
            }
            long result = service.remove(id);
            if (result <= 0) {
                responseJson(new RespJson(ErrorEnum.ERROR));
            } else {
                responseJson(new RespJson(ErrorEnum.SUCCESS));
            }
        } catch (Exception e) {
            logger.error("delete posDownCfg exception", e);
            responseJson(new RespJson(ErrorEnum.ERROR.getErrorCode(), e.getMessage()));
        }
    }
}
