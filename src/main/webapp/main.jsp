<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>secretary</title>
    <style>
        /* Стили для растягивания фоновой картинки на весь экран */
        body, html {
            height: 100%;
            margin: 0;
            font-family: Arial, sans-serif;
        }

        .background {
            background-image: url('${pageContext.request.contextPath}/resources/main.jpg');
            background-size: cover;
            background-position: center;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            align-items: center;
        }

        /* Стили для навигационной панели */
        .navbar {
            width: 100%;
            display: flex;
            justify-content: space-around;
            padding: 20px 0;
            background-color: rgba(0, 0, 0, 0.5); /* Полупрозрачный фон для панели */
        }

        .navbar button {
            background-color: transparent; /* Прозрачный фон */
            border: none;
            color: white; /* Белый цвет текста */
            font-size: 22px; /* Размер шрифта */
            font-weight: bold; /* Толстый шрифт */
            cursor: pointer;
            padding: 10px 20px;
            transition: background-color 0.3s ease; /* Плавное изменение цвета при наведении */
        }

        .navbar button:hover {
            background-color: rgba(255, 255, 255, 0.2); /* Легкое затемнение при наведении */
        }
    </style>
</head>
<body>
<div class="background">
    <!-- Навигационная панель -->
    <div class="navbar">
        <button onclick="window.location.href='students.jsp'">students</button>
        <button onclick="window.location.href='teachers.jsp'">teachers</button>
        <button onclick="window.location.href='meetings.jsp'">meetings</button>
    </div>
</div>
</body>
</html>