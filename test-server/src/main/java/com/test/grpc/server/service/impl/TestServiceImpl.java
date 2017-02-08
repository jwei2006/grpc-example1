package com.test.grpc.server.service.impl;

import com.test.grpc.server.service.TestService;
import org.springframework.stereotype.Service;

/**
 * Created by liuguanqing on 16/4/13.
 */
@Service("testService")
public class TestServiceImpl implements TestService {

    @Override
    public String sayHello(String name, Integer id) {
    	System.out.println("--------------------------------");
        return name + id;
    }
}
