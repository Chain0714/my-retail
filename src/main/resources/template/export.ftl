package com.retailo2o.dds.export;

import com.alibaba.fastjson.JSON;
import com.retailo2o.dds.common.constant.BusinessTypeEnum;
import com.retailo2o.dds.common.constant.DataSizeTypeEnum;
import com.retailo2o.dds.common.util.CommUtil;
import com.retailo2o.dds.common.util.ReqData;
import com.retailo2o.dds.common.util.TmqUtil;
import net.jplugin.core.kernel.api.ctx.ThreadLocalContextManager;
import net.jplugin.core.log.api.Logger;
import net.jplugin.core.log.api.RefLogger;
import net.jplugin.core.rclient.api.RemoteExecuteException;
import net.jplugin.ext.webasic.api.BindServiceExport;

@BindServiceExport(path = "/${data._modelName}")
public class ${data.modelName}Export {

    @RefLogger
    private Logger logger;

    private static final String TOPIC = "sg-dds-porm";

    /**
    * 单品活动清单
    */
    public void saveGoodsProm() {
        try {
            String jsonData = ThreadLocalContextManager.getRequestInfo().getContent().getJsonContent();
            ReqData rd = JSON.parseObject(jsonData, ReqData.class);
            if (CommUtil.valKey(rd)) {
                TmqUtil.sendMQData(jsonData, TOPIC, BusinessTypeEnum.${data.typeCode}, DataSizeTypeEnum.All);
                logger.debug("添加${data.desc}TMQ队列成功！");
            } else {
                logger.error(Thread.currentThread().getStackTrace()[1].getMethodName() + ":{}->{}", "接口签名验证", "失败");
                throw new RemoteExecuteException("接口签名验证失败！");
            }
        } catch (RemoteExecuteException e) {
            throw e;
        } catch (Exception e) {
            String error = "Service Exception Stack";
            logger.error(error + e.getMessage(), e);
            throw new RemoteExecuteException("系统内部错误");
        }
    }
}
