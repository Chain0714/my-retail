<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.retailo2o.smc.mapper.${data.modelName}Mapper">

    <resultMap id="resultMap" type="com.retailo2o.smc.entity.${data.modelName}">
        <#list data.pairs as p >
            <result column="${p.column}" jdbcType="${p.type}" property="${p.field}"/>
        </#list>
    </resultMap>

    <select id="selectPage" resultMap="resultMap">
        select
        <#list data.pairs as p >
            ${p.column}<#if p_has_next>,</#if>
        </#list>
        from ${data.tblName}
        where 1 = 1
        <#list data.pairs as p >
        <#if p.column != 'id'>
        <if test="queryDto.${p.field} != null">
            and ${p.column} = <#noparse> #{queryDto.</#noparse>${p.field}}
        </if>
        </#if>
        </#list>
        order by id
    </select>

    <select id="selectList" resultMap="resultMap">
        select
        <#list data.pairs as p >
            ${p.column}<#if p_has_next>,</#if>
        </#list>
        from ${data.tblName}
        where 1 = 1
        <#list data.pairs as p >
            <#if p.column = 'id'>
                <if test="queryDto.id != null and queryDto.id >0">
                    and id = <#noparse>#{queryDto.id}</#noparse>
                </if>
            <#else>
                <if test="queryDto.${p.field} != null">
                    and ${p.column} = <#noparse> #{queryDto.</#noparse>${p.field}}
                </if>
            </#if>
        </#list>
        order by id
    </select>

    <select id="selectOne" resultMap="resultMap">
        select
        <#list data.pairs as p >
            ${p.column}<#if p_has_next>,</#if>
        </#list>
        from ${data.tblName}
        where id = <#noparse>#{id}</#noparse>
    </select>

    <insert id="insert" parameterType="com.retailo2o.smc.entity.${data.modelName}">
        insert into ${data.tblName}
        <trim prefix="(" suffix=")" suffixOverrides=",">
            <#list data.pairs as p >
            <#if p.column!="id">
                <if test="dto.${p.field} != null">
                    ${p.column},
                </if>
            </#if>
            </#list>
        </trim>
        <trim prefix="values (" suffix=")" suffixOverrides=",">
            <#list data.pairs as p >
                <#if p.column!="id">
                <if test="dto.${p.field} != null">
                    <#noparse>#{dto.</#noparse>${p.field},jdbcType=${p.type}},
                </if>
                </#if>
            </#list>
        </trim>
    </insert>

    <update id="update" parameterType="com.retailo2o.smc.entity.${data.modelName}">
        update ${data.tblName}
        <set>
            <#list data.pairs as p >
            <#if p.column!="id">
            <if test="dto.${p.field} != null">
                ${p.column} = <#noparse>#{dto.</#noparse>${p.field},jdbcType=${p.type}},
            </if>
            </#if>
            </#list>
        </set>
        where id = <#noparse>#{dto.id,jdbcType=BIGINT}</#noparse>
    </update>

    <delete id="deleteById">
        delete from ${data.tblName}
        where id = <#noparse>#{id}</#noparse>
    </delete>

</mapper>