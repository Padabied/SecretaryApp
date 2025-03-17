import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.regex.Pattern;

@WebServlet("/addStudent")
public class AddStudentServlet extends HttpServlet {

    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
    private static final String PHONE_REGEX = "^(37529|37533|37525)\\d{7}$";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String fullName = request.getParameter("fullName");
        String groupIdStr = request.getParameter("groupId");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if (fullName == null || fullName.isEmpty() ||
                groupIdStr == null || groupIdStr.isEmpty() ||
                email == null || email.isEmpty() ||
                phone == null || phone.isEmpty()) {

            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Некорректные данные\"}");
            return;
        }

        if (!Pattern.matches(EMAIL_REGEX, email)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Некорректный email\"}");
            return;
        }

        if (!Pattern.matches(PHONE_REGEX, phone)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Некорректный телефон\"}");
            return;
        }

        try {
            int groupId = Integer.parseInt(groupIdStr);

            try (Connection conn = DBConnector.getConnection();
                 PreparedStatement stmt = conn.prepareStatement("INSERT INTO students (full_name, group_id, email, phone) VALUES (?, ?, ?, ?)")) {

                stmt.setString(1, fullName);
                stmt.setInt(2, groupId);
                stmt.setString(3, email);
                stmt.setString(4, phone);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    out.write("{\"success\": \"Студент успешно добавлен\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    out.write("{\"error\": \"Ошибка при добавлении студента\"}");
                }
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Некорректный ID группы\"}");
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"Один из параметров введен неверно\"}");
            e.printStackTrace();
        }
    }
}
