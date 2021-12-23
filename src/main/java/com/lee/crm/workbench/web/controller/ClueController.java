package com.lee.crm.workbench.web.controller;
/**
 * @author: Lee
 * @date: 2021/8/3 17:53
 * @description:
 */

import com.lee.crm.settings.domain.User;
import com.lee.crm.settings.service.UserService;
import com.lee.crm.settings.service.impl.UserServiceImpl;
import com.lee.crm.utils.DateTimeUtil;
import com.lee.crm.utils.PrintJson;
import com.lee.crm.utils.ServiceFactory;
import com.lee.crm.utils.UUIDUtil;
import com.lee.crm.workbench.domain.*;
import com.lee.crm.workbench.service.ActivityService;
import com.lee.crm.workbench.service.ClueService;
import com.lee.crm.workbench.service.impl.ActivityServiceImpl;
import com.lee.crm.workbench.service.impl.ClueServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClueController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/workbench/clue/getUserList.do".equals(path)){
            getUserList(response);
        }else if ("/workbench/clue/saveClue.do".equals(path)){
            saveClue(request,response);
        }else if ("/workbench/clue/pageList.do".equals(path)){
            getPageList(request,response);
        }else if ("/workbench/clue/getClue.do".equals(path)){
            getClue(request,response);
        }else if ("/workbench/clue/updateClue.do".equals(path)){
            updateClue(request,response);
        }else if ("/workbench/clue/remove.do".equals(path)){
            removeClue(request,response);
        }else if ("/workbench/clue/showDetail.do".equals(path)){
            showDetail(request,response);
        }else if ("/workbench/clue/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if ("/workbench/clue/editRemark.do".equals(path)){
            editRemark(request,response);
        }else if ("/workbench/clue/removeRemark.do".equals(path)){
            removeRemark(request,response);
        }else if ("/workbench/clue/getActList.do".equals(path)){
            getActList(request,response);
        }else if ("/workbench/clue/relate.do".equals(path)){
            relate(request,response);
        }else if ("/workbench/clue/showAct.do".equals(path)){
            showAct(request,response);
        }else if ("/workbench/clue/removeRelation.do".equals(path)){
            removeRelation(request,response);
        }else if ("/workbench/clue/convert.do".equals(path)){
            convert(request,response);
        }else if ("/workbench/clue/getBoundAct.do".equals(path)){
            getBoundAct(request,response);
        }
    }


    private void getUserList(HttpServletResponse response) {
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        PrintJson.printJsonObj(response,userList);
    }

    private void saveClue(HttpServletRequest request, HttpServletResponse response) {
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String owner = request.getParameter("owner");
        String company = request.getParameter("company");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");
        String createBy = ((User)(request.getSession(false).getAttribute("user"))).getName();
        String createTime = DateTimeUtil.getSysTime();
        String id = UUIDUtil.getUUID();
        Clue clue = new Clue();
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setCreateBy(createBy);
        clue.setCreateTime(createTime);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = clueService.saveClue(clue);
        PrintJson.printJsonFlag(response,success);
    }

    private void getPageList(HttpServletRequest request, HttpServletResponse response) {
        int pageNo = Integer.parseInt(request.getParameter("pageNo"));
        int pageSize = Integer.parseInt(request.getParameter("pageSize"));
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String company = request.getParameter("company");
        String phone = request.getParameter("phone");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        Clue clue = new Clue();
        clue.setFullname(name);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setPhone(phone);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Map<String,Object> map = clueService.getPage(pageNo,pageSize,clue);
        PrintJson.printJsonObj(response,map);
    }
    private void getClue(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Map<String,Object> map = clueService.getClue(id);
        PrintJson.printJsonObj(response,map);
    }

    private void updateClue(HttpServletRequest request, HttpServletResponse response) {
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String owner = request.getParameter("owner");
        String company = request.getParameter("company");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");
        String editBy = ((User)(request.getSession(false).getAttribute("user"))).getName();
        String editTime = DateTimeUtil.getSysTime();
        String id = request.getParameter("id");
        Clue clue = new Clue();
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setEditBy(editBy);
        clue.setEditTime(editTime);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = clueService.updateClue(clue);
        PrintJson.printJsonFlag(response,success);
    }

    private void removeClue(HttpServletRequest request, HttpServletResponse response) {
        String[] ids = request.getParameterValues("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = clueService.removeClue(ids);
        PrintJson.printJsonFlag(response,success);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Map<String,Object> map = clueService.getDetail(id);
        PrintJson.printJsonObj(response,map);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = UUIDUtil.getUUID();
        String noteContent = request.getParameter("noteContent");
        String createBy = ((User)(request.getSession(false).getAttribute("user"))).getName();
        String createTime = DateTimeUtil.getSysTime();
        String flag = "0";
        String clueId = request.getParameter("clueId");
        ClueRemark remark = new ClueRemark();
        remark.setId(id);
        remark.setNoteContent(noteContent);
        remark.setCreateTime(createTime);
        remark.setCreateBy(createBy);
        remark.setEditFlag(flag);
        remark.setClueId(clueId);
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = clueService.saveRemark(remark);
        Map<String,Object> map = new HashMap<>(2);
        map.put("success",success);
        map.put("remark",remark);
        PrintJson.printJsonObj(response,map);
    }

    private void editRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editBy = ((User)(request.getSession(false).getAttribute("user"))).getName();
        String editTime = DateTimeUtil.getSysTime();
        String flag = "1";
        ClueRemark remark = new ClueRemark();
        remark.setId(id);
        remark.setNoteContent(noteContent);
        remark.setEditBy(editBy);
        remark.setEditTime(editTime);
        remark.setEditFlag(flag);
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = clueService.editRemark(remark);
        PrintJson.printJsonFlag(response,success);
    }
    private void removeRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = clueService.removeRemark(id);
        PrintJson.printJsonFlag(response,success);
    }

    private void getActList(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> activityList = activityService.getActList(id,name);
        PrintJson.printJsonObj(response,activityList);
    }

    private void relate(HttpServletRequest request, HttpServletResponse response) {
        String cid = request.getParameter("cid");
        String[] aid = request.getParameterValues("aid");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = clueService.relateActs(cid,aid);
        PrintJson.printJsonFlag(response,success);
    }

    private void showAct(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        List<Activity> activityList = clueService.getActList(id);
        PrintJson.printJsonObj(response,activityList);
    }

    private void removeRelation(HttpServletRequest request, HttpServletResponse response) {
        String clueId = request.getParameter("clueId");
        String activityId = request.getParameter("activityId");
        ClueActivityRelation relation = new ClueActivityRelation();
        relation.setClueId(clueId);
        relation.setActivityId(activityId);
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = clueService.removeRelation(relation);
        PrintJson.printJsonFlag(response,success);
    }

    private void getBoundAct(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        List<Activity> activityList = clueService.getBoundAct(id,name);
        PrintJson.printJsonObj(response,activityList);
    }

    private void convert(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String clueId = request.getParameter("clueId");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        String createBy = ((User)(request.getSession().getAttribute("user"))).getName();
        Tran tran = new Tran();
        tran.setCreateBy(createBy);
        if ("POST".equals(request.getMethod())){
            tran.setMoney(request.getParameter("money"));
            tran.setName(request.getParameter("name"));
            tran.setId(UUIDUtil.getUUID());
            tran.setType("新业务");
            tran.setExpectedDate(request.getParameter("expectedDate"));
            tran.setActivityId(request.getParameter("activityId"));
            tran.setCreateTime(DateTimeUtil.getSysTime());
            tran.setStage(request.getParameter("stage"));
        }
        clueService.clueConvert(clueId,tran);
        response.sendRedirect("index.jsp");
    }
}
