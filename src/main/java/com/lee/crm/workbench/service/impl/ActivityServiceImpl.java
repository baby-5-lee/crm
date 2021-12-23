package com.lee.crm.workbench.service.impl;

import com.github.pagehelper.PageHelper;
import com.lee.crm.utils.MybatisUtil;
import com.lee.crm.workbench.dao.ActivityDao;
import com.lee.crm.workbench.dao.ActivityRemarkDao;
import com.lee.crm.workbench.domain.Activity;
import com.lee.crm.workbench.domain.ActivityRemark;
import com.lee.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * @author: Lee
 * @date: 2021/7/24 11:00
 * @description:
 */
public class ActivityServiceImpl implements ActivityService {
    ActivityDao activityDao = MybatisUtil.getSqlSession().getMapper(ActivityDao.class);

    ActivityRemarkDao activityRemarkDao = MybatisUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    @Override
    public boolean saveActivity(Activity act) {
        return activityDao.insertActivity(act) == 1;
    }

    @Override
    public Map<String,Object> getPageList(int pageNo, int pageSize, Activity act) {

        Map<String,Object> map = new HashMap<>(2);
        map.put("total",activityDao.selectNum(act));
        PageHelper.startPage(pageNo,pageSize);
        map.put("dataList",activityDao.selectPageList(act));
        return map;
    }

    @Override
    public boolean deleteActivity(String[] ids) {
        int remarkNum = activityRemarkDao.deleteRemark(ids);
        int activityNum = activityDao.deleteActivity(ids);

        return activityNum == ids.length;
    }

    @Override
    public Activity getActivity(String id) {
        return activityDao.getActById(id);
    }

    @Override
    public boolean updateActivity(Activity act) {
        return activityDao.updateActivity(act)==1;
    }

    @Override
    public List<Activity> getActList(String id, String name) {
        List<Activity> actList = activityDao.selectActList(id,name);
        return actList;
    }

}
