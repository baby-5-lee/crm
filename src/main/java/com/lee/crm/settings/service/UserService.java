package com.lee.crm.settings.service;

import com.lee.crm.Exception.LoginException;
import com.lee.crm.settings.domain.User;

import java.util.List;

public interface UserService {

    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();

    User getUserById(String id);

}
