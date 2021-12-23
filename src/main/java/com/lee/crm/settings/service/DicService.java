package com.lee.crm.settings.service;

import com.lee.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

/**
 * @author: Lee
 * @date: 2021/8/3 18:18
 * @description:
 */
public interface DicService {
    Map<String, List<DicValue>> getDicMap();
}
