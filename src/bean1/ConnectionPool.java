package bean1;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;

public class ConnectionPool {
    // 存放Connection对象的数组，作为连接池
    private ArrayList<Connection> connectionPool = new ArrayList<>();

    // 数据库配置信息
    private static final String DB_URL = "jdbc:mysql://localhost:3306/music0";
    private static final String DB_USER = "root"; // 数据库用户名
    private static final String DB_PASSWORD = "1234"; // 数据库密码
    private static final int POOL_SIZE = 15; // 连接池大小

    // 构造方法，初始化连接池
    public ConnectionPool() {
        try {
            // 加载MySQL驱动
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 创建指定数量的数据库连接
            for (int i = 0; i < POOL_SIZE; i++) {
                Connection connection = createConnection();
                if (connection != null) {
                    connectionPool.add(connection);
                }
            }

            System.out.println("Music数据库连接池初始化完成，共创建 " + connectionPool.size() + " 个连接");

        } catch (ClassNotFoundException e) {
            System.err.println("MySQL驱动加载失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
    // 创建单个数据库连接
    private Connection createConnection() {
        try {
            // 设置连接参数，包括字符编码和时区
            String fullUrl = DB_URL + "?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true&serverTimezone=GMT%2B8";
            return DriverManager.getConnection(fullUrl, DB_USER, DB_PASSWORD);
        } catch (SQLException e) {
            System.err.println("创建数据库连接失败: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    // 从连接池中获取一个连接
    public synchronized Connection getConnection(int i) {
        if (connectionPool.size() > 0) {
            // 从连接池取出一个连接
            return connectionPool.remove(0);
        } else {
            System.out.println("警告: 连接池已耗尽，返回null");
            return null;
        }
    }

    // 将连接释放回连接池
    public synchronized void releaseConnection(Connection connection) {
        if (connection != null) {
            try {
                // 检查连接是否关闭，未关闭则放回连接池
                if (!connection.isClosed()) {
                    connectionPool.add(connection);
                } else {
                    System.out.println("警告: 尝试释放已关闭的连接");
                    // 若连接已关闭，创建一个新连接放入池
                    Connection newConnection = createConnection();
                    if (newConnection != null) {
                        connectionPool.add(newConnection);
                    }
                }
            } catch (SQLException e) {
                System.err.println("检查连接状态失败: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    // 关闭连接池中的所有连接
    public synchronized void closeAllConnections() {
        for (Connection connection : connectionPool) {
            try {
                if (!connection.isClosed()) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("关闭连接失败: " + e.getMessage());
                e.printStackTrace();
            }
        }
        connectionPool.clear();
        System.out.println("连接池已关闭，所有连接已释放");
    }

    // 获取当前连接池大小
    public int getPoolSize() {
        return connectionPool.size();
    }
}