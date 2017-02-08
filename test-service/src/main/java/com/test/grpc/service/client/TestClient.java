package com.test.grpc.service.client;

import com.test.grpc.service.TestRpcServiceGrpc;
import com.test.grpc.service.model.TestModel;
import io.grpc.ManagedChannel;
import io.grpc.netty.NettyChannelBuilder;

import java.util.concurrent.TimeUnit;

/**
 * Created by liuguanqing on 16/4/21.
 */
public class TestClient {

    private final TestRpcServiceGrpc.TestRpcServiceBlockingStub client;

    public TestClient(String host,int port) {
        ManagedChannel channel =  NettyChannelBuilder.forAddress(host, port).usePlaintext(true).build();
        client = TestRpcServiceGrpc.newBlockingStub(channel).withDeadlineAfter(60000, TimeUnit.MILLISECONDS);
    }

    public String sayHello(String name,Integer id) {
        TestModel.TestRequest request = TestModel.TestRequest.newBuilder().setId(id).setName(name).build();
        TestModel.TestResponse response = client.sayHello(request);
        return response.getMessage();
    }
    
    public static void main(String[] args) {
    	TestClient client = new TestClient("localhost", 50010);
    	String re = client.sayHello("asdf", 123);
    	System.out.println(re);
	}
}
