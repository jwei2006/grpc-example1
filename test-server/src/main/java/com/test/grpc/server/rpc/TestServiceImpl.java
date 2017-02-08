package com.test.grpc.server.rpc;

import com.test.grpc.service.TestRpcServiceGrpc;
import com.test.grpc.service.model.TestModel;
import io.grpc.stub.StreamObserver;
import org.springframework.stereotype.Service;

/**
 * Created by liuguanqing on 16/4/13.
 */
@Service
public class TestServiceImpl extends TestRpcServiceGrpc.TestRpcServiceImplBase {

    @Override
    public void sayHello(TestModel.TestRequest request, StreamObserver<TestModel.TestResponse> responseObserver) {
        String result = request.getName() + request.getId();
        TestModel.TestResponse response = TestModel.TestResponse.newBuilder().setMessage(result).build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }
}
