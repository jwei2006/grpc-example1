package com.test.grpc.service.client.pool;

/**
 * Created by liuguanqing on 16/4/23.
 */
public class PoolConfig {

    public String host;
    public int port;
    public int keepAlive = 72;//单位秒
    public int maxRequest;
    public int maxActive = 8;
}
