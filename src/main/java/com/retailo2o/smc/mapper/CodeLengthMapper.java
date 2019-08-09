package com.retailo2o.smc.mapper;

import com.retailo2o.smc.entity.CodeLength;

public interface CodeLengthMapper {
    int deleteByPrimaryKey(Long id);

    int insert(CodeLength record);

    int insertSelective(CodeLength record);

    CodeLength selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(CodeLength record);

    int updateByPrimaryKey(CodeLength record);
}