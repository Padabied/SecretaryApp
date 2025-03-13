<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>students</title>
    <style>
        /* Стили для растягивания фоновой картинки на весь экран */
        body, html {
            height: 100%;
            margin: 0;
            font-family: Arial, sans-serif;
        }

        .background {
            background-image: url('${pageContext.request.contextPath}/resources/students.jpg');
            background-size: cover;
            /*background-position: center;*/
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

        /* Стили для всплывающих окон */
        .byGroup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            /*background-color: white;*/
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
            z-index: 1000;
            width: 280px;
            height: 70px;
        }

        .byGroup input, .byGroup button {
            margin: 5px 0;
            height: 50px;
        }

        .byMark {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            /*background-color: white;*/
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
            z-index: 1000;
            width: 300px;
            height: 150px;
        }

        .byMark input, .byMark button {
            margin: 5px 0;
            height: 50px;
        }

        .addStudent {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            /*background-color: white;*/
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
            z-index: 1000;
            width: 300px;
            height: 280px;
        }

        .addStudent input, .addStudent button {
            margin: 5px 0;
            height: 50px;
        }

    </style>
</head>
<body>
<div class="background">
    <!-- Навигационная панель -->
    <div class="navbar">
        <button onclick="window.location.href='/secretary'">main</button>
        <button onclick="showPopup('byGroupPopup')">by group</button>
        <button onclick="showPopup('byMarkPopup')">by mark</button>
        <button onclick="showPopup('addStudentPopup')">add student</button>
        <button onclick="showPopup('deleteStudentPopup')">delete student</button>
    </div>

    <!-- Всплывающее окно для поиска по группе -->
    <div id="byGroupPopup" class="byGroup">
        <input type="text" id="groupNumber" placeholder="Enter group number">
        <button onclick="findStudentsByGroup()">OK</button>
        <button onclick="hidePopup('byGroupPopup')">Cancel</button>
        <div id="groupResult"></div>
    </div>

    <!-- Всплывающее окно для поиска по оценке и дисциплине -->
    <div id="byMarkPopup" class="byMark">
        <input type="text" id="mark" placeholder="Enter minimum mark">
        <input type="text" id="disciplineCode" placeholder="Enter discipline code">
        <button onclick="findStudentsByMark()">OK</button>
        <button onclick="hidePopup('byMarkPopup')">Cancel</button>
        <div id="markResult"></div>
    </div>

    <!-- Всплывающее окно для добавления студента -->
    <div id="addStudentPopup" class="addStudent">
        <input type="text" id="fullName" placeholder="Full Name">
        <input type="text" id="groupId" placeholder="Group ID">
        <input type="text" id="email" placeholder="Email">
        <input type="text" id="phone" placeholder="Phone">
        <button onclick="addStudent()">OK</button>
        <button onclick="hidePopup('addStudentPopup')">Cancel</button>
    </div>

    <!-- Всплывающее окно для удаления студента -->
    <div id="deleteStudentPopup" class="byGroup">
        <input type="text" id="studentId" placeholder="Enter student ID">
        <button onclick="confirmDeleteStudent()">OK</button>
        <button onclick="hidePopup('deleteStudentPopup')">Cancel</button>
        <div id="deleteConfirmation" style="display: none;">
            <p>Студент <span id="studentName"></span> группа <span id="studentGroup"></span> будет удален. Продолжить?</p>
            <button onclick="deleteStudent()">Да</button>
            <button onclick="hidePopup('deleteStudentPopup')">Нет</button>
        </div>
    </div>
</div>

<script>
    // Функции для управления всплывающими окнами
    function showPopup(id) {
        document.getElementById(id).style.display = 'block';
    }

    function hidePopup(id) {
        document.getElementById(id).style.display = 'none';
    }

    // Функция для поиска студентов по группе
    function findStudentsByGroup() {
        const groupNumber = document.getElementById('groupNumber').value;
        // Здесь будет вызов сервлета для поиска студентов
    }

    // Функция для поиска студентов по оценке и дисциплине
    function findStudentsByMark() {
        const mark = document.getElementById('mark').value;
        const disciplineCode = document.getElementById('disciplineCode').value;
        // Здесь будет вызов сервлета для поиска студентов
    }

    // Функция для добавления студента
    function addStudent() {
        const fullName = document.getElementById('fullName').value;
        const groupId = document.getElementById('groupId').value;
        const email = document.getElementById('email').value;
        const phone = document.getElementById('phone').value;
        // Здесь будет вызов сервлета для добавления студента
    }

    // Функция для подтверждения удаления студента
    function confirmDeleteStudent() {
        const studentId = document.getElementById('studentId').value;
        // Здесь будет вызов сервлета для получения данных о студенте
        document.getElementById('studentName').innerText = "Имя студента";
        document.getElementById('studentGroup').innerText = "Группа студента";
        document.getElementById('deleteConfirmation').style.display = 'block';
    }

    // Функция для удаления студента
    function deleteStudent() {
        const studentId = document.getElementById('studentId').value;
        // Здесь будет вызов сервлета для удаления студента
    }
</script>
</body>
</html>