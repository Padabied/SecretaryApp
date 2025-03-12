

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>adminPage</title>

    <style>
        body {
            background-color: #BDB76B;
            display: flex;
            flex-direction: column;
            align-items: center;
            margin: 0;
            height: 100vh;
        }

        h1 {
            margin: 0;
            padding: 20px 0;
            color: #333;
            text-align: center;
            width: 100%;
        }

        button {
            margin-top: 50px;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            background-color: #4CAF50;
            color: white;
        }
    </style>
</head>
<body>
<h1>Добро пожаловать, Админ!</h1>

<form action="GetBookingsServlet" method="post">
    <button type="submit">Посмотреть бронирования</button>
</form>

</body>
</html>