package com.lee.crm.workbench.dao;

import com.lee.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerDao {

    int insertCustomer(Customer customer);

    String selectIdByName(String name);

    List<Customer> selectAllCustomers(Customer customer);

    Integer selectTotal(Customer customer);

    Customer selectById(String id);

    int updateCustomer(Customer customer);

    int deleteCustomers(String[] ids);

    Customer getDetailById(String id);

}
