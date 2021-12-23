package com.lee.crm.workbench.dao;

import com.lee.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    int deleteByIds(String[] ids);

    List<ClueRemark> selectByClue(String id);

    int insertRemark(ClueRemark remark);

    int updateRemark(ClueRemark remark);

    int deleteById(String id);

    int deleteByClueId(String clueId);

}
