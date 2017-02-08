package com.test.grpc.server.rpc;

import com.test.grpc.service.TestRpcServiceGrpc;
import io.grpc.internal.ServerImpl;
import io.grpc.netty.NettyServerBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by liuguanqing on 16/4/13.
 */
@Service
public class TestRpcServiceBootstrap {

    private int port;

    public void setPort(int port) {
        this.port = port;
    }

    private volatile boolean init = false;

    @Autowired
    private TestRpcServiceImpl testRpcService;

    private ServerImpl server;

    public synchronized void start() throws Exception {
        server = NettyServerBuilder.forPort(port).addService(testRpcService).build();
        server.start();
        init = true;
    }

    public boolean isShutdown() {
        if(!init) {
            return false;
        }
        return server.isShutdown();
    }

    public synchronized void shutdown() throws Exception {
        if(!init) {
            return;
        }
        int i = 0;
        while (i < 10) {
            try {
                if(server == null || server.isShutdown()) {
                    break;
                }
                server.shutdown();
                i++;
                Thread.sleep(500);
            } catch (Exception e) {
                //
            }
        }

        if(!server.isShutdown()) {
            server.shutdownNow();
        }
        init = false;
    }

}
