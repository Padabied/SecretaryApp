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

@WebServlet(name = "InvitedToMeetingServlet", value = "/invitedToMeetingServlet")
public class InvitedToMeetingServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String meetingDate = request.getParameter("meetingDate");

        if (meetingDate == null || meetingDate.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Missing meeting date\"}");
            return;
        }
        List<String> teachers = new ArrayList<>();

        try (Connection conn = DBConnector.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL GetTeachersByMeetingDate(?)}")) {
            stmt.setString(1, meetingDate);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                teachers.add(rs.getString("full_name") + ": " + rs.getString("phone"));
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
