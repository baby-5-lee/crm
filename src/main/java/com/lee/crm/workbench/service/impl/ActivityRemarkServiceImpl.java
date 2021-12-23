package com.lee.crm.workbench.service.impl;

import com.lee.crm.utils.MybatisUtil;
import com.lee.crm.workbench.dao.ActivityRemarkDao;
import com.lee.crm.workbench.domain.ActivityRemark;
import com.lee.crm.workbench.service.ActivityRemarkService;

import java.util.List;

/**
 * @author: Lee
 * @date: 2021/7/31 10:13
 * @description:
 */
public class ActivityRemarkServiceImpl implements ActivityRemarkService{
    ActivityRemarkDao activityRemarkDao = MybatisUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    @Override
    public List<ActivityRemark> getRemark(String id) {
        return activityRemarkDao.getRemark(id);
    }

    @Override
    public boolean editRemark(ActivityRemark remark) {
        return activityRemarkDao.updateRemark(remark)==1;
    }

    @Override
    public boolean removeRemark(String id) {
        return activityRemarkDao.deleteById(id) == 1;
    }

    @Override
    public boolean saveRemark(ActivityRemark remark) {
        return activityRemarkDao.insertRemark(remark)==1;
    }
}
