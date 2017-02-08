package com.test.grpc.server.web.controller;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by liuguanqing on 15/4/10.
 */
public class BaseController {


    /**
     * 获取客户端的实际IP
     * @param request
     * @return
     */
    public String getClientIP(HttpServletRequest request) {
        String ip = request.getHeader("x-forwarded-for");
        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");

        }
        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    /**
     * 获取请求的path路径：比如“/user/test.jhtml”返回“/user”.
     * @param request
     * @return
     */
    protected String getRequestPath(HttpServletRequest request) {
        String servletPath = request.getServletPath();
        int index = servletPath.lastIndexOf("/");
        if(index == 0) {
            return "/";
        }
        return servletPath.substring(0,index);
    }
}
