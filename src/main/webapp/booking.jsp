
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Bookings</title>
    <style>
        body {
            background-color: #2e8b57;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 20px;
            color: white;
            font-family: Arial, sans-serif;
        }

        .room-selection {
            margin: 20px;
        }

        .room-selection button {
            padding: 10px 20px;
            margin: 10px;
            background-color: #4CAF50;
            border: none;
            color: white;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .room-selection button:hover {
            background-color: #45a049;
        }

        .form-container {
            margin-top: 20px;
            display: none;
            flex-direction: column;
            align-items: center;
        }

        .ok-button {
            margin-top: 10px;
            padding: 5px 10px;
            background-color: #4CAF50;
            border: none;
            color: white;
            cursor: pointer;
            border-radius: 5px;
        }

        .ok-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
<h1>Выберите номер для бронирования</h1>

<!-- Контейнер для кнопок номеров -->
<div class="room-selection">
    <% for (int i = 1; i <= 5; i++) { %>
    <button class="room-btn" data-index="<%= i - 1 %>">Номер <%= i %></button>
    <% } %>
</div>

<!-- Контейнер для всех форм -->
<div class="forms-container">
    <% for (int i = 1; i <= 5; i++) { %>
    <form action = "/BookRoomServlet" method = "post" class="form-container" id="form-<%= i %>">
        <input type="hidden" name="room" value="<%= i %>">
        <label>Выберите дату для номера <%= i %>:</label>
        <input type="date" name="date">
        <input type="submit" class="ok-button" value="ОК">
    </form>
    <% } %>
</div>

<script>
    // Показать форму при нажатии на кнопку номера
    document.querySelectorAll('.room-btn').forEach(button => {
        button.addEventListener('click', () => {
            const index = button.getAttribute('data-index');
            document.querySelectorAll('.form-container').forEach((form, formIndex) => {
                form.style.display = formIndex == index ? 'flex' : 'none';
            });
        });
    });
</script>
</body>
</html>












