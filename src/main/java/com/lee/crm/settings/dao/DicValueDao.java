package com.lee.crm.settings.dao;

import com.lee.crm.settings.domain.DicValue;

import java.util.List;

/**
 * @author: Lee
 * @date: 2021/8/3 18:14
 * @description:
 */
public interface DicValueDao {
    List<DicValue> selectByCode(String code);

}
