import com.google.gson.Gson;

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

@WebServlet(name = "TeachersByDisciplineCodeServlet", value = "/teachersByDisciplineCode")
public class TeachersByDisciplineCodeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String disciplineCode = request.getParameter("disciplineCode");

        if (disciplineCode == null || disciplineCode.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Missing discipline code\"}");
            return;
        }
        List<String> teachers = new ArrayList<>();

        try (Connection conn = DBConnector.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL GetTeachersByDisciplineCode(?)}")) {
            stmt.setString(1, disciplineCode);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                teachers.add(rs.getString("full_name"));
            }
            String json = new Gson().toJson(teachers);
            out.write(json);
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"Database error\"}");
            e.printStackTrace();
        }
    }
}
