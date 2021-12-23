package com.lee.crm.settings.domain;

/**
 * @author: Lee
 * @date: 2021/8/3 18:00
 * @description:
 */
public class DicType {
    private String code;
    private String name;
    private String description;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }
}
