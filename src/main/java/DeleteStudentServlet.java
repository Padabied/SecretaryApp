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

@WebServlet("/deleteStudent")
public class DeleteStudentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String studentIdStr = request.getParameter("studentId");

        if (studentIdStr == null || studentIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Некорректные данные\"}");
            return;
        }

        try {
            int studentId = Integer.parseInt(studentIdStr);

            try (Connection conn = DBConnector.getConnection();
                 PreparedStatement stmt = conn.prepareStatement("DELETE FROM students WHERE id = ?")) {

                stmt.setInt(1, studentId);

                int rowsDeleted = stmt.executeUpdate();
                if (rowsDeleted > 0) {
                    out.write("{\"success\": \"Студент успешно удалён\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    //System.out.println("ничего не удалено из БД");
                    out.write("{\"error\": \"Некорректные данные\"}");
                }
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            //System.out.println("number format");
            out.write("{\"error\": \"Некорректные данные\"}");
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            //System.out.println("sxl exception");
            out.write("{\"error\": \"Ошибка базы данных\"}");
            e.printStackTrace();
        }
    }
}
