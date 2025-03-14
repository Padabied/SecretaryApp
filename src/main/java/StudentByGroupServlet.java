import com.google.gson.Gson;
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
            return;
        }

        List<String> students = new ArrayList<>();
        try (Connection conn = DBConnector.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL GetStudentsByGroup(?)}")) {
            //System.out.println("Подключение к БД успешно");
            stmt.setString(1, groupNumber);
            ResultSet rs = stmt.executeQuery();
            //System.out.println("RS существует");


            while (rs.next()) {
                //System.out.println(rs.getString("full_name"));
                students.add(rs.getString("full_name"));
            }

            String json = new Gson().toJson(students);
            //System.out.println("json создан");
            out.write(json);
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"Database error\"}");
            e.printStackTrace();
        }
    }
}
