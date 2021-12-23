package com.lee.crm.workbench.dao;

import com.lee.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ContactsActivityRelationDao {

    int insertList(List<ClueActivityRelation> clueActivityRelationList);

}
