package com.lee.crm.workbench.dao;

import com.lee.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {

    int insertContacts(Contacts contacts);

    List<Contacts> listContactsByCustomerId(String id);

}
