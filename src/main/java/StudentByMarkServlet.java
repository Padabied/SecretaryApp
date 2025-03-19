import com.google.gson.Gson;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/studentsByMark")
public class StudentByMarkServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(LoginServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String markStr = request.getParameter("mark");
        String disciplineCode = request.getParameter("disciplineCode");

        if (markStr == null || markStr.isEmpty() || disciplineCode == null || disciplineCode.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Missing mark or discipline code\"}");
            logger.warn("Missing discipline code");
            return;
        }

        try {
            int mark = Integer.parseInt(markStr);
            List<String> students = new ArrayList<>();

            try (Connection conn = DBConnector.getConnection();
                 CallableStatement stmt = conn.prepareCall("{CALL GetStudentsByGradeAndDiscipline(?, ?)}")) {

                stmt.setInt(1, mark);
                stmt.setString(2, disciplineCode);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    students.add(rs.getString("full_name") + ": " + rs.getInt("mark"));
                }

                String json = new Gson().toJson(students);
                out.write(json);
                logger.info("SUCCESS student by mark show");
            } catch (SQLException e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.write("{\"error\": \"Database error\"}");
                logger.error("SQL exception throw ", e);
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Invalid mark format\"}");
            logger.error("Invalid mark format ", e);
        }
    }
}
