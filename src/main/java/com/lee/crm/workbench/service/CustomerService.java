package com.lee.crm.workbench.service;

import com.lee.crm.workbench.domain.Contacts;
import com.lee.crm.workbench.domain.Customer;
import com.lee.crm.workbench.domain.CustomerRemark;
import com.lee.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

/**
 * @author: Lee
 * @date: 2021/9/14 19:22
 * @description:
 */
public interface CustomerService {
    Map<String, Object> getPageMap(int pageNo, int pageSize, Customer customer);

    boolean saveCustomer(Customer customer);

    Customer getCustomer(String id);

    boolean updateCustomer(Customer customer);

    boolean removeCustomers(String[] ids);

    Customer getCustomerDetail(String id);

    boolean saveRemark(CustomerRemark customerRemark);

    List<CustomerRemark> listRemarks(String id);

    boolean updateRemark(CustomerRemark remark);

    boolean removeRemark(String id);

    List<Tran> listTrans(String id);

    List<Contacts> listContacts(String id);

}
