package com.lee.crm.workbench.dao;

import com.lee.crm.workbench.domain.ActivityRemark;

import java.util.List;

/**
 * @author: Lee
 * @date: 2021/7/24 16:17
 * @description:
 */
public interface ActivityRemarkDao {
    int deleteRemark(String[] ids);

    List<ActivityRemark> getRemark(String id);

    int updateRemark(ActivityRemark remark);

    int deleteById(String id);

    int insertRemark(ActivityRemark remark);

}
