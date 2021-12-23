package com.lee.crm.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateTimeUtil {

	private DateTimeUtil(){}
	
	public static String getSysTime(){
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		Date date = new Date();

		return sdf.format(date);
		
	}
	
}
