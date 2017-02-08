package com.test.grpc.service.client.pool;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import io.grpc.stub.AbstractStub;

import javax.annotation.Nonnull;

/**
 * Created by liuguanqing on 16/4/23.
 */
public class GrpcClientPool<B extends AbstractStub,F extends AbstractStub> {

    protected PoolConfig poolConfig;

    private GrpcStubCreator<B,F> creator;

    private final Linked<B> blockingStubs = new Linked();

    private final Linked<F> futureStubs = new Linked<>();

    private volatile boolean closed = false;

    public GrpcClientPool(@Nonnull PoolConfig poolConfig, @Nonnull GrpcStubCreator<B, F> creator) {
        this.creator = creator;
        this.poolConfig = poolConfig;
        if(poolConfig.maxActive <= 0) {
            throw new IllegalArgumentException("maxActive should be a number that greater than 0!");
        }
        for(int i = 0; i< poolConfig.maxActive; i++) {
            ManagedChannel channel =  ManagedChannelBuilder.forAddress(poolConfig.host, poolConfig.port).usePlaintext(true).build();
            blockingStubs.add(creator.createBlockingStub(channel));
            futureStubs.add(creator.createFutureStub(channel));
        }
    }

    /**
     * 获取一个blockingStub
     * @return
     */
    public B getBlockingStub() {
        if(closed) {
            throw new IllegalStateException("Pool has been closed,cant be used anymore!");
        }
        //信号量补充操作
        if (blockingStubs.size < poolConfig.maxActive) {
            synchronized (blockingStubs) {
                while (true) {
                    if (blockingStubs.size < poolConfig.maxActive) {
                        ManagedChannel channel = ManagedChannelBuilder.forAddress(poolConfig.host, poolConfig.port).usePlaintext(true).build();
                        blockingStubs.add(creator.createBlockingStub(channel));
                    }else {
                        break;
                    }
                }
            }
        }
        Node<B> node = blockingStubs.next();
        return node.value;
    }

    /**
     * 获取一个futureStub
     * @return
     */
    public F getFutureStub() {
        if(closed) {
            throw new IllegalStateException("Pool has been closed,cant be used anymore!");
        }

        if (futureStubs.size < poolConfig.maxActive) {
            synchronized (futureStubs) {
                while (true) {
                    if (futureStubs.size < poolConfig.maxActive) {
                        ManagedChannel channel = ManagedChannelBuilder.forAddress(poolConfig.host, poolConfig.port).usePlaintext(true).build();
                        futureStubs.add(creator.createFutureStub(channel));
                    }else {
                        break;
                    }
                }
            }
        }

        Node<F> node =  futureStubs.next();
        return node.value;
    }

    /**
     * 关闭对象池，同时关闭所有的底层channel，此后pool将不可用
     */
    public synchronized void close() {
        if(closed) {
            return;
        }

        blockingStubs.clear();
        futureStubs.clear();
        closed = true;

    }

    //单向循环链表
    class Linked<T extends AbstractStub> {
        Node<T> header;
        Node<T> current;
        int size = 0;

        synchronized Node<T> next() {
            if(current == null) {
                return null;
            }
            current = current.next;
            ManagedChannel channel = (ManagedChannel)current.value.getChannel();
            if(channel.isShutdown() || channel.isTerminated()) {
                //移除节点
                remove(current);
                //补充增加一个新的节点
                return null;
            }
            return current;
        }

        synchronized void remove(Node<T> node) {
            //单向链表中移除节点算法
            Node<T> next = node.next;
            if(next != node) {
                node.value = next.value;
                node.next = next.next;
                next.next = null;
                size--;
            }else {
                header = null;
                current = null;
                size = 0;
            }
        }

        Node<T> current() {
            return current;
        }

        int size() {
            if(header == null) {
                return 0;
            }

            Node<T> item = header.next;
            int i = 1;
            while (true) {
                if(item == header) {
                    break;
                }
                item = item.next;
                i++;
            }
            return i;
        }

        synchronized void add(T value) {
            Node<T> node = new Node(value);
            if(header == null) {
                header = node;
                current = header;
            }
            Node n = header.next;
            node.next = n;
            header.next = node;
            size++;

        }

        /**
         * clear container and close all!
         */
        synchronized void clear() {
            if(header == null) {
                return;
            }
            current = header.next;
            while (true) {
                ManagedChannel channel = (ManagedChannel)current.value.getChannel();
                channel.shutdown();
                if(current == header) {
                    break;
                }
                current = current.next;
            }
            header = null;
            current = header;
        }
    }

    class Node<T> {
        Node next;
        T value;
        Node(T value) {
            this.value = value;
        }
    }
}
