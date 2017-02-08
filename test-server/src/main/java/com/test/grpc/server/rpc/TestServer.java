package com.test.grpc.server.rpc;

import java.io.IOException;

import com.test.grpc.service.TestRpcServiceGrpc;

import io.grpc.Server;
import io.grpc.ServerBuilder;
import io.grpc.internal.ServerImpl;
import io.grpc.netty.NettyServerBuilder;

/**
 * Created by liuguanqing on 16/4/21.
 */
public class TestServer {

    /*public static void main(String[] args) throws Exception{

        ServerImpl server = NettyServerBuilder.forPort(50010).addService(new TestRpcServiceImpl()).build();
        server.start();
        server.awaitTermination();//阻塞直到退出
    }*/
    
    
    
    
    private Server server;
    private int port = 50010;

    private void start() throws IOException {
      /* The port on which the server should run */
      
      server = ServerBuilder.forPort(port)
          .addService(new TestRpcServiceImpl())
          .build()
          .start();
      System.out.println("Server started, listening on " + port);
      Runtime.getRuntime().addShutdownHook(new Thread() {
        @Override
        public void run() {
          // Use stderr here since the logger may have been reset by its JVM shutdown hook.
          System.err.println("*** shutting down gRPC server since JVM is shutting down");
          TestServer.this.stop();
          System.err.println("*** server shut down");
        }
      });
    }

    private void stop() {
      if (server != null) {
        server.shutdown();
      }
    }

    /**
     * Await termination on the main thread since the grpc library uses daemon threads.
     */
    private void blockUntilShutdown() throws InterruptedException {
      if (server != null) {
        server.awaitTermination();
      }
    }

    /**
     * Main launches the server from the command line.
     */
    public static void main(String[] args) throws IOException, InterruptedException {
      final TestServer server = new TestServer();
      server.start();
      server.blockUntilShutdown();
    }
}
