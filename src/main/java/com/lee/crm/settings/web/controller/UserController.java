package com.lee.crm.settings.web.controller;

import com.lee.crm.settings.domain.User;
import com.lee.crm.settings.service.UserService;
import com.lee.crm.settings.service.impl.UserServiceImpl;
import com.lee.crm.utils.PrintJson;
import com.lee.crm.utils.ServiceFactory;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/settings/user/login.do".equals(path)){
            login(request,response);
        }else if ("/settings/user/getUserList.do".equals(path)){
            getUserList(response);
        }else if ("/settings/user/getCurrentUser.do".equals(path)){
            getCurrentUser(request, response);
        }
    }


    private void login(HttpServletRequest request, HttpServletResponse response) {
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        String ip = request.getRemoteAddr();
        try{
            User user = userService.login(loginAct,loginPwd,ip);
            request.getSession().setAttribute("user",user);
            PrintJson.printJsonFlag(response,true);
        }catch (Exception e){
            String msg = e.getMessage();
            Map<String,Object> map = new HashMap<>(2);
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);
        }
    }

    private void getUserList(HttpServletResponse response) {
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        PrintJson.printJsonObj(response,userList);
    }


    private void getCurrentUser(HttpServletRequest request, HttpServletResponse response) {
        User user = (User) request.getSession().getAttribute("user");
        PrintJson.printJsonObj(response,user);
    }
}
