<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="com.retailo2o.dds.mapper.assist.${clazz}">

    <select id="${method}Count" resultType="java.lang.Long" parameterType="java.util.Map">
        SELECT COUNT(*) FROM
        ${ddsTbl}<#if dept?default("")?trim?length gt 1>_<#noparse>#{deptCode}</#noparse></#if>
        <#if time?default("")?trim?length gt 1>
        WHERE
        1 = 1
        <if test="startTime != null and endTime != null">
        AND ${time} BETWEEN<#noparse> #{startTime} AND #{endTime}</#noparse>
        </if>
        </#if>
    </select>

</mapper>