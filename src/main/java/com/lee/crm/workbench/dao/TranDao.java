package com.lee.crm.workbench.dao;

import com.lee.crm.workbench.domain.Tran;

import java.util.List;

public interface TranDao {

    int insertTran(Tran tran);

    List<Tran> listTransByCustomerId(String id);

}
