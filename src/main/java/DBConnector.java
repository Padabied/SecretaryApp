
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.Connection;
import java.sql.SQLException;


/**
 * Class implements connection-pool to connect to DB
 *
 */
public class DBConnector {

    private static HikariDataSource dataSource;
    private static final Logger logger = LogManager.getLogger(LoginServlet.class);

    static {
        try {
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl("jdbc:mysql://localhost:3306/secretary");
            config.setUsername("root");
            config.setPassword("Hetfield123!");
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");
            config.setMaximumPoolSize(10);
            config.setIdleTimeout(60000);

            dataSource = new HikariDataSource(config);
            System.out.println("Успешно подключено к БД");
            logger.info("DB starts successfully");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Ошибка подключения к БД");
            logger.error("DB start FAILED");
        }
    }

    public static
    Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public static void close() {
        if (dataSource != null) {
            dataSource.close();
        }
    }
}
