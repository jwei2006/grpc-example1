package com.test.grpc.service.client.pool;

import io.grpc.ManagedChannel;
import io.grpc.stub.AbstractStub;

/**
 * Created by liuguanqing on 16/4/23.
 */
public abstract class GrpcStubCreator<B extends AbstractStub,F extends AbstractStub> {

    public B createBlockingStub(ManagedChannel channel) {
        throw new UnsupportedOperationException("createBlockClient is unsupported!");
    }

    public F createFutureStub(ManagedChannel channel) {
        throw new UnsupportedOperationException("createFutureClient is unsupported!");
    }
}
