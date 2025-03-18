<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>teachers</title>
    <style>
        /* Стили для растягивания фоновой картинки на весь экран */
        body, html {
            height: 100%;
            margin: 0;
            font-family: Arial, sans-serif;
        }

        .background {
            background-image: url('${pageContext.request.contextPath}/resources/teachers.jpg');
            background-size: cover;
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
        .inputStyle {
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

        .inputStyle input, .inputStyle button {
            margin: 5px 0;
            height: 50px;
        }
        /* Модальное окно */
        #modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5); /* затемнение фона */
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        #modal-content {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            max-width: 400px;
            width: 100%;
            text-align: center;
        }

        #modal ul {
            list-style-type: none;
            padding: 0;
        }

        #modal li {
            margin: 5px 0;
        }

        #ok-button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            margin-top: 20px;
        }

        #close-button {
            font-size: 1.5em;
            position: absolute;
            top: 10px;
            right: 10px;
        }

    </style>
</head>
<body>
<div class="background">
    <!-- Навигационная панель -->
    <div class="navbar">
        <button onclick="window.location.href='/secretary'">main</button>
        <button onclick="showPopup('publicationsPopup')">publications</button>
        <button onclick="showPopup('teachersPopup')">teachers</button>
        <button onclick="showPopup('invitedToMeetingPopup')">meetings</button>
    </div>

    <!-- Всплывающее окно для поиска по группе -->
    <div id="publicationsPopup" class="inputStyle">
        <input type="text" id="teacherName" placeholder="Enter teacher name">
        <button onclick="getPublicationsByTeacherName()">OK</button>
        <button onclick="hidePopup('publicationsPopup')">Cancel</button>
        <div id="publicationsResult"></div>
    </div>

    <!-- Всплывающее окно для поиска учителей, ведущих дисциплину -->
    <div id="teachersPopup" class="inputStyle">
        <input type="text" id="disciplineCode" placeholder="Enter discipline code">
        <button onclick="getTeachersByDisciplineCode()">OK</button>
        <button onclick="hidePopup('teachersPopup')">Cancel</button>
        <div id="teachersResult"></div>
    </div>

    <div id="invitedToMeetingPopup" class="inputStyle">
        <input type="text" id="meetingDate" placeholder="Enter date (YYYY-MM-DD)">
        <button onclick="getInvitedToMeetingByDate()">OK</button>
        <button onclick="hidePopup('invitedToMeetingPopup')">Cancel</button>
        <div id="invitedResult"></div>
    </div>

    <!-- Модальное окно -->
    <div id="modal" style="display: none;">
        <div id="modal-content">
            <span id="close-button" style="cursor: pointer;">&times;</span>
            <h2>Результат поиска</h2>
            <ul id="result-list"></ul>
            <button id="ok-button">ОК</button>
        </div>
    </div>
</div>

<script>
    function showPopup(id) {
        document.getElementById(id).style.display = 'block';
    }

    function hidePopup(id) {
        document.getElementById(id).style.display = 'none';
    }

    function getPublicationsByTeacherName() {
        const teacherName = document.getElementById('teacherName').value;
        if (!teacherName) {
            alert("Введите имя автора публикации!");
            return;
        }
        fetch("/publicationsByTeacher?teacherName=" + encodeURIComponent(teacherName))
            .then(response => {
                if (!response.ok) {
                    throw new Error("Ошибка при получении данных");
                }
                return response.json();
            })
            .then(data => {
                const modal = document.getElementById('modal');
                const publicationsList = document.getElementById('result-list');
                const closeButton = document.getElementById('close-button');
                const okButton = document.getElementById('ok-button');

                publicationsList.innerHTML = "";

                if (data.length === 0) {
                    publicationsList.innerHTML = "<li>Публикации не найдены</li>";
                } else {
                    data.forEach(publication => {
                        const listItem = document.createElement("li");
                        listItem.innerHTML = publication.replace(/\n/g, "<br>");
                        publicationsList.appendChild(listItem);
                    });
                }

                // Показываем модальное окно
                modal.style.display = "flex";

                // Закрытие модального окна
                closeButton.onclick = () => modal.style.display = "none";
                okButton.onclick = () => modal.style.display = "none";
            })
            .catch(error => {
                console.error("Ошибка:", error);
                alert("Ошибка при загрузке данных.");
            });
    }

    function getTeachersByDisciplineCode() {
        const disciplineCode = document.getElementById('disciplineCode').value;
        if (!disciplineCode) {
            alert("Введите код дисциплины!");
            return;
        }
        fetch("/teachersByDisciplineCode?disciplineCode=" + encodeURIComponent(disciplineCode))
            .then(response => {
                if (!response.ok) {
                    throw new Error("Ошибка при получении данных");
                }
                return response.json();
            })
            .then(data => {
                const modal = document.getElementById('modal');
                const teachersList = document.getElementById('result-list');
                const closeButton = document.getElementById('close-button');
                const okButton = document.getElementById('ok-button');

                teachersList.innerHTML = "";

                if (data.length === 0) {
                    teachersList.innerHTML = "<li>Преподаватели не найдены. Проверьте код дисциплины.</li>";
                } else {
                    data.forEach(teacher => {
                        const listItem = document.createElement("li");
                        listItem.innerHTML = teacher.replace(/\n/g, "<br>");
                        teachersList.appendChild(listItem);
                    });
                }

                // Показываем модальное окно
                modal.style.display = "flex";

                // Закрытие модального окна
                closeButton.onclick = () => modal.style.display = "none";
                okButton.onclick = () => modal.style.display = "none";
            })
            .catch(error => {
                console.error("Ошибка:", error);
                alert("Ошибка при загрузке данных.");
            });
    }

    function getInvitedToMeetingByDate() {
        const meetingDate = document.getElementById('meetingDate').value;
        if (!meetingDate) {
            alert("Введите дату заседания!");
            return;
        }
        fetch("/invitedToMeetingServlet?meetingDate=" + encodeURIComponent(meetingDate))
            .then(response => {
                if (!response.ok) {
                    throw new Error("Ошибка при получении данных");
                }
                return response.json();
            })
            .then(data => {
                const modal = document.getElementById('modal');
                const teachersList = document.getElementById('result-list');
                const closeButton = document.getElementById('close-button');
                const okButton = document.getElementById('ok-button');

                teachersList.innerHTML = "";

                if (data.length === 0) {
                    teachersList.innerHTML = "<li>Преподаватели не найдены. Проверьте дату заседания.</li>";
                } else {
                    data.forEach(teacher => {
                        const listItem = document.createElement("li");
                        listItem.innerHTML = teacher.replace(/\n/g, "<br>");
                        teachersList.appendChild(listItem);
                    });
                }

                // Показываем модальное окно
                modal.style.display = "flex";

                // Закрытие модального окна
                closeButton.onclick = () => modal.style.display = "none";
                okButton.onclick = () => modal.style.display = "none";
            })
            .catch(error => {
                console.error("Ошибка:", error);
                alert("Ошибка при загрузке данных.");
            });
    }
</script>
</body>
</html>
