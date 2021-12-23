
package com.lee.crm.utils;


public class ServiceFactory {

  private ServiceFactory(){}
  /**
   * 通过目标对象获取代理对象
   * @param target:目标对象
   * @return:代理对象
   */
  public static Object getService(Object target){
    return new TransactionInvocationHandler(target).getProxy();
  }
}