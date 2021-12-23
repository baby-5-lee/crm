package com.lee.crm.workbench.web.controller;

import com.lee.crm.settings.domain.User;
import com.lee.crm.utils.DateTimeUtil;
import com.lee.crm.utils.PrintJson;
import com.lee.crm.utils.ServiceFactory;
import com.lee.crm.utils.UUIDUtil;
import com.lee.crm.workbench.domain.*;
import com.lee.crm.workbench.service.ClueService;
import com.lee.crm.workbench.service.CustomerService;
import com.lee.crm.workbench.service.impl.ClueServiceImpl;
import com.lee.crm.workbench.service.impl.CustomerServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * @author: Lee
 * @date: 2021/9/14 19:06
 * @description:
 */
public class CustomerController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/workbench/customer/pageList.do".equals(path)){
            getPageList(request,response);
        }else if ("/workbench/customer/saveCustomer.do".equals(path)){
            saveCustomer(request,response);
        }else if ("/workbench/customer/getCustomer.do".equals(path)){
            getCustomer(request,response);
        }else if ("/workbench/customer/updateCustomer.do".equals(path)){
            updateCustomer(request,response);
        }else if ("/workbench/customer/removeCustomers.do".equals(path)){
            removeCustomers(request,response);
        }else if ("/workbench/customer/getCustomerDetail.do".equals(path)){
            getCustomerDetail(request,response);
        }else if ("/workbench/customer/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if ("/workbench/customer/listRemarks.do".equals(path)){
            listRemarks(request,response);
        }else if ("/workbench/customer/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }else if ("/workbench/customer/removeRemark.do".equals(path)){
            removeRemark(request,response);
        }else if ("/workbench/customer/listTrans.do".equals(path)){
            listTrans(request,response);
        }else if ("/workbench/customer/showContacts.do".equals(path)){
            showContacts(request,response);
        }
    }



    private void getPageList(HttpServletRequest request, HttpServletResponse response) {
        int pageNo = Integer.parseInt(request.getParameter("pageNo"));
        int pageSize = Integer.parseInt(request.getParameter("pageSize"));
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String website = request.getParameter("website");
        String phone = request.getParameter("phone");
        Customer customer = new Customer();
        customer.setOwner(owner);
        customer.setName(name);
        customer.setWebsite(website);
        customer.setPhone(phone);
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Map<String,Object> map = customerService.getPageMap(pageNo,pageSize,customer);
        PrintJson.printJsonObj(response,map);
    }

    private void saveCustomer(HttpServletRequest request, HttpServletResponse response) {
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String website = request.getParameter("website");
        String phone = request.getParameter("phone");
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String description = request.getParameter("description");
        String address = request.getParameter("address");
        Customer customer = new Customer();
        customer.setId(id);
        customer.setOwner(owner);
        customer.setName(name);
        customer.setWebsite(website);
        customer.setPhone(phone);
        customer.setCreateBy(createBy);
        customer.setCreateTime(createTime);
        customer.setContactSummary(contactSummary);
        customer.setNextContactTime(nextContactTime);
        customer.setDescription(description);
        customer.setAddress(address);
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean success = customerService.saveCustomer(customer);
        PrintJson.printJsonFlag(response,success);
    }


    private void getCustomer(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Customer customer = customerService.getCustomer(id);
        PrintJson.printJsonObj(response,customer);
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String website = request.getParameter("website");
        String phone = request.getParameter("phone");
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String description = request.getParameter("description");
        String address = request.getParameter("address");
        Customer customer = new Customer();
        customer.setId(id);
        customer.setOwner(owner);
        customer.setName(name);
        customer.setWebsite(website);
        customer.setPhone(phone);
        customer.setEditBy(editBy);
        customer.setEditTime(editTime);
        customer.setContactSummary(contactSummary);
        customer.setNextContactTime(nextContactTime);
        customer.setDescription(description);
        customer.setAddress(address);
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean success = customerService.updateCustomer(customer);
        PrintJson.printJsonFlag(response,success);
    }

    private void removeCustomers(HttpServletRequest request, HttpServletResponse response) {
        String[] ids = request.getParameterValues("id");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean success = customerService.removeCustomers(ids);
        PrintJson.printJsonFlag(response,success);
    }

    private void getCustomerDetail(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Customer customer = customerService.getCustomerDetail(id);
        PrintJson.printJsonObj(response,customer);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = UUIDUtil.getUUID();
        String noteContent = request.getParameter("noteContent");
        String customerId = request.getParameter("customerId");
        String createBy = ((User)(request.getSession().getAttribute("user"))).getName();
        String createTime = DateTimeUtil.getSysTime();
        String editFlag = "0";
        CustomerRemark customerRemark = new CustomerRemark();
        customerRemark.setId(id);
        customerRemark.setNoteContent(noteContent);
        customerRemark.setCreateTime(createTime);
        customerRemark.setCreateBy(createBy);
        customerRemark.setEditFlag(editFlag);
        customerRemark.setCustomerId(customerId);
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean success = customerService.saveRemark(customerRemark);
        PrintJson.printJsonFlag(response,success);
    }

    private void listRemarks(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<CustomerRemark> remarkList = customerService.listRemarks(id);
        PrintJson.printJsonObj(response,remarkList);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editBy = ((User)(request.getSession().getAttribute("user"))).getName();
        String editTime = DateTimeUtil.getSysTime();
        String flag = "1";
        CustomerRemark remark = new CustomerRemark();
        remark.setId(id);
        remark.setNoteContent(noteContent);
        remark.setEditBy(editBy);
        remark.setEditTime(editTime);
        remark.setEditFlag(flag);
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean success = customerService.updateRemark(remark);
        PrintJson.printJsonFlag(response,success);
    }

    private void removeRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean success = customerService.removeRemark(id);
        PrintJson.printJsonFlag(response,success);
    }

    private void listTrans(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<Tran> trans = customerService.listTrans(id);
        PrintJson.printJsonObj(response,trans);
    }

    private void showContacts(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        CustomerService customerService = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<Contacts> contacts = customerService.listContacts(id);
        PrintJson.printJsonObj(response,contacts);
    }
}
