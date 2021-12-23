package com.lee.crm.web.listener;
/**
 * @author: Lee
 * @date: 2021/8/4 9:53
 * @description:
 */

import com.lee.crm.settings.domain.DicValue;
import com.lee.crm.settings.service.DicService;
import com.lee.crm.settings.service.impl.DicServiceImpl;
import com.lee.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.List;
import java.util.Map;

public class SysInitListener implements ServletContextListener {


    @Override
    public void contextInitialized(ServletContextEvent sce) {
        DicService dicService = (DicService) ServiceFactory.getService(new DicServiceImpl());
        Map<String, List<DicValue>> map = dicService.getDicMap();
        ServletContext application = sce.getServletContext();
        for(String key: map.keySet()){
            application.setAttribute(key,map.get(key));
        }
    }

}
