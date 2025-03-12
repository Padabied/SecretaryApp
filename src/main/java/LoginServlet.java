import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;


/**
 * Servlet for authorization
 * Checks if user with such name and password exists in DB
 */
@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(LoginServlet.class);

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {
            Connection connection = DBConnector.getConnection();
            String username = req.getParameter("username");
            String password = req.getParameter("password");

            String sql = "SELECT * FROM users WHERE login = ? AND password = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            statement.setString(2, password);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                // Успешная авторизация
                HttpSession session = req.getSession();
                session.setAttribute("user", username);
                logger.info("User {} logged in successfully", username);

                resp.sendRedirect("main.jsp");
//                //логика админа или юзера
//                String role = resultSet.getString("role");
//                if (role.equals("USER")) resp.sendRedirect("booking.jsp");
//                else if (role.equals("ADMIN")) resp.sendRedirect("adminPage.jsp");
//                else logger.error("Error of Role");

            } else {
                // Неудачная авторизация
                logger.warn("Failed login attempt for user: {}", username);
                resp.setContentType("text/html;charset=UTF-8");

                try (PrintWriter out = resp.getWriter()) {
                    out.println("<html>");
                    out.println("<head>");
                    out.println("<script type='text/javascript'>");
                    out.println("alert('Неверный логин или пароль. Повторите попытку');");
                    out.println("window.location.href = 'Login.jsp';");
                    out.println("</script>");
                    out.println("</head>");
                    out.println("<body></body>");
                    out.println("</html>");
                } catch (IOException e) {
                    logger.error("Error writing response: ", e);
                }
            }
        }
        catch (SQLException e) {
            logger.error("Database connection error: ", e);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Ошибка подключения к базе данных");
        }
    }
}
