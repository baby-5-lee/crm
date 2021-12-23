package com.lee.crm.web.filter; /**
 * @author: Lee
 * @date: 2021/7/23 20:39
 * @description:
 */

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws ServletException, IOException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession();
        if (session.getAttribute("user") != null || "/crm/settings/user/login.do".equals(req.getRequestURI())){
            chain.doFilter(request, response);
        }else {
            resp.sendRedirect(req.getContextPath()+"/login.html");
        }

    }
}
