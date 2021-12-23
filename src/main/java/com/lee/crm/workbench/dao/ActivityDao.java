package com.lee.crm.workbench.dao;


import com.lee.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author: Lee
 * @date: 2021/7/24 9:45
 * @description:
 */
public interface ActivityDao {

    int insertActivity(Activity act);

    List<Activity> selectPageList(Activity act);

    Integer selectNum(Activity act);

    int deleteActivity(String[] ids);

    Activity getActById(String id);

    int updateActivity(Activity act);

    List<Activity> selectActivity(String id);

    List<Activity> selectActList(@Param("id") String id, @Param("name") String name);

    List<Activity> selectBoundActivity(@Param("id") String id, @Param("name") String name);

}
