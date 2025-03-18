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

@WebServlet(name = "PublicationsByTeacherServlet", value = "/publicationsByTeacher")
public class PublicationsByTeacherServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String teacherName = request.getParameter("teacherName");

        if (teacherName == null || teacherName.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Missing teacher name\"}");
            return;
        }
        List<String> publications = new ArrayList<>();

        try (Connection conn = DBConnector.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL GetPublicationsByTeacherName(?)}")) {
            stmt.setString(1, teacherName);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                publications.add(String.format("Title: %s\nType: %s\nYear: %s\nPublisher: %s\n",
                        rs.getString("title"),
                        rs.getString("type"),
                        rs.getString("year"),
                        rs.getString("Publisher")));
            }

            String json = new Gson().toJson(publications);
            out.write(json);
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"Database error\"}");
            e.printStackTrace();
        }
    }
}
