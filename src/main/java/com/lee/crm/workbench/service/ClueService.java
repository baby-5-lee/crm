package com.lee.crm.workbench.service;

import com.lee.crm.workbench.domain.*;

import java.util.List;
import java.util.Map;

/**
 * @author: Lee
 * @date: 2021/8/3 17:46
 * @description:
 */
public interface ClueService {

    boolean saveClue(Clue clue);

    Map<String, Object> getPage(int pageNo, int pageSize, Clue clue);

    Map<String, Object> getClue(String id);

    boolean updateClue(Clue clue);

    boolean removeClue(String[] ids);

    Map<String, Object> getDetail(String id);

    boolean saveRemark(ClueRemark remark);

    boolean editRemark(ClueRemark remark);

    boolean removeRemark(String id);

    boolean relateActs(String cid, String[] aids);

    List<Activity> getActList(String id);

    boolean removeRelation(ClueActivityRelation relation);

    boolean clueConvert(String clueId, Tran tran);

    List<Activity> getBoundAct(String id, String name);

}
