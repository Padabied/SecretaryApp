import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "GetBookingsServlet", value = "/GetBookingsServlet")
public class GetBookingsServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(GetBookingsServlet.class);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try (Connection connection = DBConnector.getConnection()) {
            String getBookings = "SELECT * FROM bookings";
            try (PreparedStatement checkStmt = connection.prepareStatement(getBookings)) {
                ResultSet set = checkStmt.executeQuery();

                // Создаем HTML-страницу с результатами и кнопкой
                StringBuilder output = new StringBuilder();
                output.append("<!DOCTYPE html>");
                output.append("<html lang='ru'>");
                output.append("<head>");
                output.append("<meta charset='UTF-8'>");
                output.append("<title>Список бронирований</title>");
                output.append("<style>");
                output.append("body { background-color: #BDB76B; font-family: Arial, sans-serif; display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100vh; margin: 0; }");
                output.append("table { width: 50%; margin: 20px auto; border-collapse: collapse; }");
                output.append("th, td { border: 2px solid #000000; padding: 8px; text-align: center; }");
                output.append("th { background-color: #BDB76B; }");
                output.append(".ok_button { background-color: #4CAF50; color: white; border: none; padding: 10px 20px; font-size: 16px; cursor: pointer; border-radius: 5px; margin-top: 20px; }");
                output.append(".ok_button:hover { background-color: #45a049; }");
                output.append("</style>");
                output.append("</head>");
                output.append("<body>");
                output.append("<h2>Список забронированных номеров</h2>");
                output.append("<table>");
                output.append("<tr><th>Номер</th><th>Дата бронирования</th></tr>");

                while (set.next()) {
                    int roomId = set.getInt("room_id");
                    Date bookingDate = set.getDate("booking_date");


                    output.append("<tr>");
                    output.append("<td>").append("Номер ").append(roomId).append("</td>");
                    output.append("<td>").append("забронирован на дату ").append(bookingDate).append("</td>");
                    output.append("</tr>");
                }

                output.append("</table>");

                output.append("<form action='adminPage.jsp' method='get'>");
                output.append("<button type='submit' class='ok_button'>ОК</button>");
                output.append("</form>");

                output.append("</body>");
                output.append("</html>");

                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().write(output.toString());
                logger.info("Get reserving table");
            }
        } catch (SQLException e) {
            logger.error("Database connection error: ", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Ошибка подключения к базе данных");
        }
    }
}

