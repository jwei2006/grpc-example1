package com.test.grpc.server.dao;

import org.apache.ibatis.session.SqlSession;

public abstract class BaseDao {

    protected SqlSession sqlSession;

    public void setSqlSession(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }
}
