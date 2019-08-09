package com.retailo2o.smc.entity;

import java.util.Date;

public class CodeLength {
    private Long id;

    private String mtenantId;

    private Integer categorytype;

    private String categoryitemcode;

    private String categorycodelength;

    private Date createTime;

    private Date updateTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMtenantId() {
        return mtenantId;
    }

    public void setMtenantId(String mtenantId) {
        this.mtenantId = mtenantId == null ? null : mtenantId.trim();
    }

    public Integer getCategorytype() {
        return categorytype;
    }

    public void setCategorytype(Integer categorytype) {
        this.categorytype = categorytype;
    }

    public String getCategoryitemcode() {
        return categoryitemcode;
    }

    public void setCategoryitemcode(String categoryitemcode) {
        this.categoryitemcode = categoryitemcode == null ? null : categoryitemcode.trim();
    }

    public String getCategorycodelength() {
        return categorycodelength;
    }

    public void setCategorycodelength(String categorycodelength) {
        this.categorycodelength = categorycodelength == null ? null : categorycodelength.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
}