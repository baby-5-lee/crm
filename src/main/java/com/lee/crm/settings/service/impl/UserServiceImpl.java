package com.lee.crm.settings.service.impl;

import com.lee.crm.Exception.LoginException;
import com.lee.crm.settings.dao.UserDao;
import com.lee.crm.settings.domain.User;
import com.lee.crm.settings.service.UserService;
import com.lee.crm.utils.DateTimeUtil;
import com.lee.crm.utils.MD5Util;
import com.lee.crm.utils.MybatisUtil;

import java.util.List;

public class UserServiceImpl implements UserService {
    UserDao userDao = MybatisUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        User user1 =new User();
        user1.setLoginAct(loginAct);
        user1.setLoginPwd(MD5Util.getMD5(loginPwd));
        User user = userDao.login(user1);
        if (user == null){
            throw new LoginException("用户名或密码错误");
        }else if (!user.getAllowIps().contains(ip)){
            throw new LoginException("ip地址受限");
        }else if (DateTimeUtil.getSysTime().compareTo(user.getExpireTime())>0){
            throw new LoginException("账号已失效");
        }else if ("0".equals(user.getLockState())){
            throw new LoginException("账号已锁定");
        }
        return user;
    }

    @Override
    public List<User> getUserList() {
        return userDao.getUserList();
    }

    @Override
    public User getUserById(String id) {
        return userDao.selectById(id);
    }
}
