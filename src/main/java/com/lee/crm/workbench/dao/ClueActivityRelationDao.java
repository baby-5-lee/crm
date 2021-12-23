package com.lee.crm.workbench.dao;

import com.lee.crm.workbench.domain.Activity;
import com.lee.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {


    int deleteByIds(String[] ids);


    int insertList(List<ClueActivityRelation> list);

    int deleteRelation(ClueActivityRelation relation);

    int deleteByClueId(String clueId);

    List<ClueActivityRelation> selectByClueId(String clueId);

}
