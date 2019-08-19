<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.retailo2o.dds.mapper.${data.modelName}Mapper">

    <insert id="saveOrUpdate">
        insert into ${data.tblName}
        (
        <#list data.pairs as p >
            ${p.column}<#if p_has_next>,</#if>
        </#list>
        )
        values
        <foreach collection="list" item="instObj" index="index" separator=",">
            (
            <#list data.pairs as p >
                <#noparse>#{instObj.</#noparse>${p.field},jdbcType=${p.type}<#if p_has_next>},</#if>
            </#list>
            )
        </foreach>
        ON DUPLICATE KEY UPDATE
        <#list data.pairs as p >
            ${p.column} = VALUES(${p.column})<#if p_has_next>,</#if>
        </#list>
    </insert>

    <delete id="deleteAll">
        delete from ${data.tblName}
    </delete>

    <select id="${data._modelName}Count" resultType="java.lang.Long">
        SELECT COUNT(*) FROM
        ${data.tblName}
        <#if data.timer?default("")?trim?length gt 1>
            <if test="map.startTime != null and map.endTime != null">
            AND ${data.timer} BETWEEN <#noparse>#{map.startTime} AND #{map.endTime}</#noparse>
        </if>
        </#if>
    </select>

</mapper>