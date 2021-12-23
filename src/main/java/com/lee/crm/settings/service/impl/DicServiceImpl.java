package com.lee.crm.settings.service.impl;

import com.lee.crm.settings.dao.DicTypeDao;
import com.lee.crm.settings.dao.DicValueDao;
import com.lee.crm.settings.domain.DicValue;
import com.lee.crm.settings.service.DicService;
import com.lee.crm.utils.MybatisUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author: Lee
 * @date: 2021/8/3 18:18
 * @description:
 */
public class DicServiceImpl implements DicService {
    private DicTypeDao dicTypeDao = MybatisUtil.getSqlSession().getMapper(DicTypeDao.class);
    private DicValueDao dicValueDao = MybatisUtil.getSqlSession().getMapper(DicValueDao.class);

    @Override
    public Map<String, List<DicValue>> getDicMap() {
        List<String> codes = dicTypeDao.selectDicCode();
        Map<String, List<DicValue>> map = new HashMap<>(10);
        for (String code:codes) {
            List<DicValue> dicValueList = dicValueDao.selectByCode(code);
            map.put(code,dicValueList);
        }
        return map;
    }
}
