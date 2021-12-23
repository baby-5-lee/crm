package com.lee.crm.utils;

import com.lee.crm.Exception.LoginException;
import org.apache.ibatis.session.SqlSession;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;


public class TransactionInvocationHandler implements InvocationHandler {
  private final Object target;

  public TransactionInvocationHandler(Object target) {
    this.target = target;
  }

  @Override
  public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
    SqlSession sqlSession = null;
    Object result = null;
    try {
      result = method.invoke(target,args);
      sqlSession = MybatisUtil.getSqlSession();
      sqlSession.commit();
    } catch(Exception e) {
      if (sqlSession != null){
        sqlSession.rollback();
      }
      throw e.getCause();
    } finally {
      MybatisUtil.close(sqlSession);
    }
    return result;
  }

  public Object getProxy(){
    return Proxy.newProxyInstance(target.getClass().getClassLoader(), target.getClass().getInterfaces(), this);
  }
}