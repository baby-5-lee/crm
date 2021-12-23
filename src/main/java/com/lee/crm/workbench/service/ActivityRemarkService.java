package com.lee.crm.workbench.service;

import com.lee.crm.workbench.domain.ActivityRemark;

import java.util.List;

/**
 * @author: Lee
 * @date: 2021/7/31 10:12
 * @description:
 */
public interface ActivityRemarkService {
    List<ActivityRemark> getRemark(String id);

    boolean editRemark(ActivityRemark remark);

    boolean removeRemark(String id);

    boolean saveRemark(ActivityRemark remark);

}
