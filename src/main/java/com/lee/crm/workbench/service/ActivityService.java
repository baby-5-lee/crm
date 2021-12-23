package com.lee.crm.workbench.service;


import com.lee.crm.workbench.domain.Activity;
import com.lee.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

/**
 * @author: Lee
 * @date: 2021/7/24 10:58
 * @description:
 */
public interface ActivityService {

    boolean saveActivity(Activity act);

    Map<String,Object> getPageList(int pageNo, int pageSize, Activity act);

    boolean deleteActivity(String[] ids);

    Activity getActivity(String id);

    boolean updateActivity(Activity act);


    List<Activity> getActList(String id,String name);

}
