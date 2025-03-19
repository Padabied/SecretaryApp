import com.google.gson.Gson;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/studentsByGroup")
public class StudentByGroupServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(LoginServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String groupNumber = request.getParameter("groupNumber");
        //System.out.println("group number = " + groupNumber);
        if (groupNumber == null || groupNumber.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Missing group number\"}");
            logger.warn("Missing group number");
            return;
        }

        List<String> students = new ArrayList<>();
        try (Connection conn = DBConnector.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL GetStudentsByGroup(?)}")) {
            stmt.setString(1, groupNumber);
            ResultSet rs = stmt.executeQuery();


            while (rs.next()) {
                students.add(rs.getString("full_name"));
            }

            String json = new Gson().toJson(students);
            out.write(json);
            logger.info("SUCCESS student by group show");
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"Database error\"}");
            logger.error("SQL exception throw");
        }
    }
}
