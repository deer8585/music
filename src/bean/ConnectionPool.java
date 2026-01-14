package bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

public class ConnectionPool {
    private static ConnectionPool instance;
    private BlockingQueue<Connection> pool;
    private int initialSize = 15;
    private int maxSize = 30;
    private boolean isShutdown = false;

    private String url = "jdbc:mysql://localhost:3306/music0?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true&serverTimezone=GMT%2B8";
    private String username = "root";
    private String password = "1234";

    private ConnectionPool() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            pool = new ArrayBlockingQueue<>(maxSize);
            initConnections();
        } catch (Exception e) {
            throw new RuntimeException("连接池初始化失败", e);
        }
    }

    public static synchronized ConnectionPool getInstance() {
        if (instance == null) {
            instance = new ConnectionPool();
        }
        return instance;
    }

    private void initConnections() {
        for (int i = 0; i < initialSize; i++) {
            pool.offer(createConnection());
        }
    }

    private Connection createConnection() {
        try {
            return DriverManager.getConnection(url, username, password);
        } catch (SQLException e) {
            throw new RuntimeException("创建数据库连接失败", e);
        }
    }

    // 获取连接
    public Connection getConnection(long timeoutMillis) throws InterruptedException {
        if (isShutdown) {
            throw new IllegalStateException("连接池已关闭");
        }

        synchronized (pool) {
            long startTime = System.currentTimeMillis();
            long remainingTime = timeoutMillis;
            while (pool.isEmpty() && remainingTime > 0) {
                // 等待连接可用，设置等待时间
                pool.wait(remainingTime);
                // 重新计算剩余时间
                remainingTime = timeoutMillis - (System.currentTimeMillis() - startTime);
            }
            if (pool.isEmpty()) {
                throw new RuntimeException("获取连接超时");
            }
            Connection conn = pool.take();
            try {
                if (conn.isValid(2000)) {
                    return conn;
                } else {
                    // 连接无效，关闭并创建新连接
                    closeConnection(conn);
                    return createConnection();
                }
            } catch (SQLException e) {
                // 连接异常，关闭并创建新连接
                closeConnection(conn);
                return createConnection();
            }
        }
    }

    public void releaseConnection(Connection conn) {
        if (conn == null || isShutdown) {
            return;
        }

        try {
            if (!conn.isClosed() && !conn.getAutoCommit()) {
                conn.rollback();
                conn.setAutoCommit(true);
            }
            pool.offer(conn);
            synchronized (pool) {
                // 唤醒等待连接的线程
                pool.notifyAll();
            }
        } catch (SQLException e) {
            closeConnection(conn);
            pool.offer(createConnection());
        }
    }

    private void closeConnection(Connection conn) {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public synchronized void shutdown() {
        if (isShutdown) {
            return;
        }

        isShutdown = true;
        for (Connection conn : pool) {
            closeConnection(conn);
        }
        pool.clear();
    }
}
