package com.lee.crm.settings.dao;

import com.lee.crm.settings.domain.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author: Lee
 * @date: 2021/7/22 23:52
 * @description:
 */
public interface UserDao {

    User login(User user);

    List<User> getUserList();

    User selectById(String id);

}
