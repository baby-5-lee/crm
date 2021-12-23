package com.lee.crm.workbench.dao;

import com.lee.crm.workbench.domain.ClueRemark;
import com.lee.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {

    int insertList(List<ClueRemark> clueRemarkList);

    Integer countRemark(String[] ids);

    Integer deleteRemarks(String[] ids);

    Integer insertRemark(CustomerRemark customerRemark);

    List<CustomerRemark> listRemarks(String id);

    int updateRemark(CustomerRemark remark);

    int deleteRemark(String id);

}
