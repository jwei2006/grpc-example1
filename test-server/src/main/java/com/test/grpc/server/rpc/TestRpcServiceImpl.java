package com.test.grpc.server.rpc;

import com.test.grpc.server.service.TestService;
import com.test.grpc.service.TestRpcServiceGrpc;
import com.test.grpc.service.model.TestModel;
import io.grpc.stub.StreamObserver;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by liuguanqing on 16/4/13.
 */
@Service
public class TestRpcServiceImpl extends TestRpcServiceGrpc.TestRpcServiceImplBase {

    @Autowired
    private TestService testService;

    @Override
    public void sayHello(TestModel.TestRequest request, StreamObserver<TestModel.TestResponse> responseObserver) {
    	System.out.println("111111111111");
        String result = new com.test.grpc.server.service.impl.TestServiceImpl().sayHello(request.getName(),request.getId());
        TestModel.TestResponse response = TestModel.TestResponse.newBuilder().setMessage(result).build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }
}
