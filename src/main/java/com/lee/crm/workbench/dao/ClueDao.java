package com.lee.crm.workbench.dao;

import com.lee.crm.workbench.domain.Clue;

import java.util.List;

public interface ClueDao {


    int insertClue(Clue clue);

    int selectTotal(Clue clue);

    List<Clue> selectPageList(Clue clue);

    Clue selectById(String id);

    int updateClue(Clue clue);

    int deleteByIds(String[] ids);

    Clue selectClue(String id);

    int deleteById(String clueId);

}
