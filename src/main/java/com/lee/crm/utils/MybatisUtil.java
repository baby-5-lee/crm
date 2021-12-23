package com.lee.crm.utils;


import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;

public class MybatisUtil {

  private MybatisUtil(){}
  private static SqlSessionFactory factory = null;
  static {
    try {
      InputStream in = Resources.getResourceAsStream("mybatis.xml");
      factory = new SqlSessionFactoryBuilder().build(in);
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  private static final ThreadLocal<SqlSession> threadLocal = new ThreadLocal<>();

  public static SqlSession getSqlSession(){
    SqlSession session = threadLocal.get();
    if (session == null){
      session = factory.openSession();
      threadLocal.set(session);
    }
    return session;
  }

  public static SqlSession getSqlSession(boolean type){
    SqlSession session = threadLocal.get();
    if (session == null){
      session = factory.openSession(type);
      threadLocal.set(session);
    }
    return session;
  }

  public static void close(SqlSession sqlSession){
    if (sqlSession != null){
      sqlSession.close();
    }
    threadLocal.remove();
  }
}