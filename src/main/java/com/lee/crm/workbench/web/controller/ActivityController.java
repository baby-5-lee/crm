package com.lee.crm.workbench.web.controller;
/**
 * @author: Lee
 * @date: 2021/7/24 11:03
 * @description:
 */

import com.lee.crm.settings.domain.User;
import com.lee.crm.settings.service.UserService;
import com.lee.crm.settings.service.impl.UserServiceImpl;
import com.lee.crm.utils.DateTimeUtil;
import com.lee.crm.utils.PrintJson;
import com.lee.crm.utils.ServiceFactory;
import com.lee.crm.utils.UUIDUtil;
import com.lee.crm.workbench.domain.Activity;
import com.lee.crm.workbench.domain.ActivityRemark;
import com.lee.crm.workbench.service.ActivityRemarkService;
import com.lee.crm.workbench.service.ActivityService;
import com.lee.crm.workbench.service.impl.ActivityRemarkServiceImpl;
import com.lee.crm.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/workbench/activity/getUserList.do".equals(path)){
            getUserList(response);
        }else if ("/workbench/activity/save.do".equals(path)){
            saveActivity(request,response);
        }else if ("/workbench/activity/pageList.do".equals(path)){
            getPageList(request,response);
        }else if("/workbench/activity/delete.do".equals(path)){
            deleteActivity(request,response);
        }else if ("/workbench/activity/getActivity.do".equals(path)){
            getActivity(request,response);
        }else if ("/workbench/activity/update.do".equals(path)){
            updateActivity(request,response);
        }else if("/workbench/activity/detail.do".equals(path)){
            doDetail(request,response);
        }else if("/workbench/activity/getRemark.do".equals(path)){
            getRemark(request,response);
        }else if("/workbench/activity/editRemark.do".equals(path)){
            editRemark(request,response);
        }else if("/workbench/activity/removeRemark.do".equals(path)){
            removeRemark(request,response);
        }else if ("/workbench/activity/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }
    }



    private void getUserList(HttpServletResponse response) {
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        PrintJson.printJsonObj(response,userList);
    }

    private void saveActivity(HttpServletRequest request, HttpServletResponse response) {
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User) request.getSession(false).getAttribute("user")).getName();
        Activity act = new Activity();
        act.setId(id);
        act.setOwner(owner);
        act.setName(name);
        act.setStartDate(startDate);
        act.setEndDate(endDate);
        act.setCost(cost);
        act.setDescription(description);
        act.setCreateTime(createTime);
        act.setCreateBy(createBy);
        boolean success = activityService.saveActivity(act);
        PrintJson.printJsonFlag(response,success);

    }

    private void getPageList(HttpServletRequest request, HttpServletResponse response) {
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        int pageNo = Integer.parseInt(request.getParameter("pageNo"));
        int pageSize = Integer.parseInt(request.getParameter("pageSize"));
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        Activity act = new Activity();
        act.setOwner(owner);
        act.setName(name);
        act.setStartDate(startDate);
        act.setEndDate(endDate);
        Map<String,Object> activityMap = activityService.getPageList(pageNo,pageSize,act);
        PrintJson.printJsonObj(response,activityMap);
    }

    private void deleteActivity(HttpServletRequest request, HttpServletResponse response) {
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        String[] ids = request.getParameterValues("id");
        if (ids!=null){
            boolean success = activityService.deleteActivity(ids);
            PrintJson.printJsonFlag(response,success);
        }
    }

    private void getActivity(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Activity act = activityService.getActivity(id);
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        Map<String,Object> map = new HashMap<>(2);
        map.put("userList",userList);
        map.put("activity",act);
        PrintJson.printJsonObj(response,map);
    }

    private void updateActivity(HttpServletRequest request, HttpServletResponse response) {
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User) request.getSession(false).getAttribute("user")).getName();
        Activity act = new Activity();
        act.setId(id);
        act.setOwner(owner);
        act.setName(name);
        act.setStartDate(startDate);
        act.setEndDate(endDate);
        act.setCost(cost);
        act.setDescription(description);
        act.setEditTime(editTime);
        act.setEditBy(editBy);
        boolean success = activityService.updateActivity(act);
        PrintJson.printJsonFlag(response,success);
    }

    private void doDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Activity act = activityService.getActivity(id);
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        User actOwner = userService.getUserById(act.getOwner());
        request.setAttribute("activity",act);
        request.setAttribute("actOwner",actOwner);
        request.getRequestDispatcher("detail.jsp").forward(request,response);
    }

    private void getRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ActivityRemarkService activityRemarkService = (ActivityRemarkService) ServiceFactory.getService(new ActivityRemarkServiceImpl());
        List<ActivityRemark> remark = activityRemarkService.getRemark(id);
        PrintJson.printJsonObj(response,remark);
    }

    private void editRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editBy = ((User)(request.getSession(false).getAttribute("user"))).getName();
        String editTime = DateTimeUtil.getSysTime();
        String flag = "1";
        ActivityRemark remark = new ActivityRemark();
        remark.setId(id);
        remark.setNoteContent(noteContent);
        remark.setEditBy(editBy);
        remark.setEditTime(editTime);
        remark.setEditFlag(flag);
        ActivityRemarkService activityRemarkService = (ActivityRemarkService) ServiceFactory.getService(new ActivityRemarkServiceImpl());
        boolean success = activityRemarkService.editRemark(remark);
        PrintJson.printJsonFlag(response,success);
    }


    private void removeRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ActivityRemarkService activityRemarkService = (ActivityRemarkService) ServiceFactory.getService(new ActivityRemarkServiceImpl());
        boolean success = activityRemarkService.removeRemark(id);
        PrintJson.printJsonFlag(response,success);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = UUIDUtil.getUUID();
        String noteContent = request.getParameter("noteContent");
        String createBy = ((User)(request.getSession(false).getAttribute("user"))).getName();
        String createTime = DateTimeUtil.getSysTime();
        String flag = "0";
        String activityId = request.getParameter("activityId");
        ActivityRemark remark = new ActivityRemark();
        remark.setId(id);
        remark.setNoteContent(noteContent);
        remark.setCreateTime(createTime);
        remark.setCreateBy(createBy);
        remark.setEditFlag(flag);
        remark.setActivityId(activityId);
        ActivityRemarkService activityRemarkService = (ActivityRemarkService) ServiceFactory.getService(new ActivityRemarkServiceImpl());
        boolean success = activityRemarkService.saveRemark(remark);
        Map<String,Object> map = new HashMap<>(2);
        map.put("success",success);
        map.put("remark",remark);
        PrintJson.printJsonObj(response,map);
    }
}
