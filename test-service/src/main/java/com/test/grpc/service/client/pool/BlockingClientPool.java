package com.test.grpc.service.client.pool;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import io.grpc.stub.AbstractStub;
import org.apache.commons.pool.BasePoolableObjectFactory;
import org.apache.commons.pool.impl.GenericObjectPool;

import javax.annotation.Nonnull;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Created by liuguanqing on 16/4/19.
 * only for blockingStub
 * 考虑到grpc底层通道的多路复用能力、断链自动连接能力等，
 * 我们可以抛弃本例中的这种阻塞式的Pool
 * 基于本人对GRPC原理尚未全部了解，先暂且保守设计
 */

/**
 * 我们简单认为，当每个channel的任意一个stub上请求超过maxRequest、或者keepAlive达到阀值
 * 就应该能被closed，并重建channel。
 * 我们在应用中，已经遇到channel空闲一段时候后，再次请求，将会莫名的抛出异常的问题
 * @param <T>
 * @see com.test.grpc.service.client.pool.GrpcClientPool
 */
@Deprecated
public class BlockingClientPool<T extends AbstractStub> {
    private GrpcStubCreator creator;
    private GenericObjectPool pool;

    private PoolConfig poolConfig;

    private final Map<Object,ClientChannelBundle> holder = new ConcurrentHashMap<>();

    public BlockingClientPool(PoolConfig poolConfig, @Nonnull GrpcStubCreator creator) {
        this.creator = creator;
        this.poolConfig = poolConfig;
        //Config setting
        GenericObjectPool.Config config = new GenericObjectPool.Config();
        config.maxActive = poolConfig.maxActive;
        config.minIdle = 1;

        if(poolConfig.keepAlive  > 0) {
            config.minEvictableIdleTimeMillis = poolConfig.keepAlive;
        }

        config.testOnBorrow = true;
        config.testOnReturn = true;

        ChannelPoolFactory factory = new ChannelPoolFactory();
        pool = new GenericObjectPool(factory,config);
    }

    public T get() {
        try {
            ClientChannelBundle<T> bundle = (ClientChannelBundle) pool.borrowObject();
            bundle.request();
            return bundle.client;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void close() throws Exception{
        holder.clear();
        pool.close();
    }

    public void release(T client) {
        if(client == null) {
            return;
        }
        ClientChannelBundle bundle = holder.get(client);
        if (bundle != null) {
            try {
                pool.returnObject(bundle);
            } catch (Exception e) {
                //
            }
        }
    }

    class ChannelPoolFactory extends BasePoolableObjectFactory {

        private Random random = new Random();
        @Override
        public Object makeObject() throws Exception {
            ClientChannelBundle bundle = new ClientChannelBundle();
            ManagedChannel channel =  ManagedChannelBuilder.forAddress(poolConfig.host,poolConfig.port).usePlaintext(true).build();
            bundle.channel = channel;
            bundle.client = creator.createBlockingStub(channel);

            //如果限定了请求数，则开启keepAlive控制
            if(poolConfig.keepAlive != -1) {
                int addition = poolConfig.keepAlive - random.nextInt(poolConfig.keepAlive / 10);
                bundle.deadline = System.currentTimeMillis() + addition;
            }

            holder.put(bundle.client,bundle);
            return bundle;
        }

        public void destroyObject(ClientChannelBundle bundle) throws Exception  {
            if(bundle == null) {
                return;
            }
            holder.remove(bundle.client);
            ManagedChannel channel = bundle.channel;
            holder.remove(bundle.client);
            channel.shutdown();
        }

        public boolean validateObject(ClientChannelBundle bundle) {
            if(bundle == null) {
                return false;
            }
            ManagedChannel channel = bundle.channel;
            if(channel.isShutdown() || channel.isTerminated() || bundle.isExpired()) {
                return false;
            }

            return true;
        }
    }

    class ClientChannelBundle<T> {
        T client;
        ManagedChannel channel;
        AtomicInteger requested = new AtomicInteger(0);
        long deadline = -1;

        public void request() {
            if(poolConfig.maxRequest != -1) {
                requested.incrementAndGet();
            }
        }

        /**
         *
         * @return true 如果已经请求的次数达到maxRequest或者deadline到期则
         */
        public boolean isExpired() {
            int maxRequest = poolConfig.maxRequest;
            if(maxRequest != -1) {
                return requested.get() > maxRequest ? true : false;
            }
            int keepAlive = poolConfig.keepAlive;
            if(keepAlive != -1) {
                return System.currentTimeMillis() > deadline ? true : false;
            }
            return false;
        }
    }

}
