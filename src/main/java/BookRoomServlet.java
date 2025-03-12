import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


/**
 * Servlet for booking room in case of correct authorization
 * Uses log4j for logging
 */
@WebServlet(name = "BookRoomServlet", value = "/BookRoomServlet")
public class BookRoomServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(LoginServlet.class);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection connection = DBConnector.getConnection()) {

            String roomId = request.getParameter("room");
            String bookingDate = request.getParameter("date");

            if (roomId == null || bookingDate == null || roomId.isEmpty() || bookingDate.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Некорректные данные бронирования.");
                logger.error("Incorrect reserving data");
                return;
            }

            String checkBookingQuery = "SELECT * FROM bookings WHERE room_id = ? AND booking_date = ?";
            try (PreparedStatement checkStmt = connection.prepareStatement(checkBookingQuery)) {
                checkStmt.setString(1, roomId);
                checkStmt.setString(2, bookingDate);

                try (ResultSet resultSet = checkStmt.executeQuery()) {
                    if (!resultSet.next()) {
                        String insertBookingQuery = "INSERT INTO bookings (room_id, booking_date) VALUES (?, ?)";
                        try (PreparedStatement insertStmt = connection.prepareStatement(insertBookingQuery)) {
                            insertStmt.setString(1, roomId);
                            insertStmt.setString(2, bookingDate);
                            insertStmt.executeUpdate();
                        }
                        displayMessage(response, "Номер " + roomId + " успешно забронирован на дату " + bookingDate, null);
                        logger.info("successfully reserved");
                    } else {
                        displayMessage(response, "К сожалению, на выбранную дату номер уже занят.", "booking.jsp");
                        logger.info("room is not free yet");
                    }
                }
            }
        } catch (SQLException e) {
            logger.error("Database connection error: ", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Ошибка подключения к базе данных");
        }
    }

    /**
     * Shows page with results of reserving room
     * @param response
     * @param message shows results of reserving. It can be success or fail.
     * @param redirectPage - page to redirect after clicking OK button
     * @throws IOException
     */
    private void displayMessage(HttpServletResponse response, String message, String redirectPage) throws IOException {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<html><body style='text-align: center; padding-top: 20px;'>");
        out.println("<h2>" + message + "</h2>");

        // Добавляем кнопку "ОК", которая перенаправляет на booking.jsp или на указанную страницу
        String redirectUrl = redirectPage != null ? redirectPage : "booking.jsp";
        out.println("<button onclick=\"window.location.href='" + redirectUrl + "'\" " +
                "style='padding: 10px 20px; margin-top: 20px; background-color: #4CAF50; border: none; color: white; " +
                "cursor: pointer; border-radius: 5px;'>ОК</button>");

        out.println("</body></html>");
        out.flush();
    }
}
