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
        <button onclick="deleteStudent()">OK</button>
        <button onclick="hidePopup('deleteStudentPopup')">Cancel</button>
    </div>
</div>

<!-- Модальное окно -->
<div id="modal" style="display: none;">
    <div id="modal-content">
        <span id="close-button" style="cursor: pointer;">&times;</span>
        <h2>Список студентов</h2>
        <ul id="student-list"></ul>
        <button id="ok-button">ОК</button>
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

    function findStudentsByGroup() {
        const groupNumber = document.getElementById('groupNumber').value;
        if (!groupNumber) {
            alert("Введите номер группы!");
            return;
        }

        fetch("/studentsByGroup?groupNumber=" + encodeURIComponent(groupNumber))
            .then(response => {
                if (!response.ok) {
                    throw new Error("Ошибка при получении данных");
                }
                return response.json();
            })
            .then(data => {
                const modal = document.getElementById('modal');
                const studentList = document.getElementById('student-list');
                const closeButton = document.getElementById('close-button');
                const okButton = document.getElementById('ok-button');

                studentList.innerHTML = ""; // очищаем список перед добавлением новых данных

                if (data.length === 0) {
                    studentList.innerHTML = "<li>Студенты не найдены.</li>";
                } else {
                    data.forEach(student => {
                        const listItem = document.createElement("li");
                        listItem.textContent = student;
                        studentList.appendChild(listItem);
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

    // Функция для поиска студентов по оценке и дисциплине
    function findStudentsByMark() {
        const mark = document.getElementById('mark').value;
        const disciplineCode = document.getElementById('disciplineCode').value;

        if (!mark || !disciplineCode) {
            alert("Введите оценку и код дисциплины!");
            return;
        }

        fetch("/studentsByMark?mark=" + encodeURIComponent(mark) + "&disciplineCode=" + encodeURIComponent(disciplineCode))
            .then(response => {
                if (!response.ok) {
                    throw new Error("Ошибка при получении данных");
                }
                return response.json();
            })
            .then(data => {
                const modal = document.getElementById('modal');
                const studentList = document.getElementById('student-list');
                const closeButton = document.getElementById('close-button');
                const okButton = document.getElementById('ok-button');

                studentList.innerHTML = "";

                if (data.length === 0) {
                    studentList.innerHTML = "<li>Студенты не найдены.</li>";
                } else {
                    data.forEach(student => {
                        const listItem = document.createElement("li");
                        listItem.textContent = student;
                        studentList.appendChild(listItem);
                    });
                }

                modal.style.display = "flex";

                closeButton.onclick = () => modal.style.display = "none";
                okButton.onclick = () => modal.style.display = "none";
            })
            .catch(error => {
                console.error("Ошибка:", error);
                alert("Ошибка при загрузке данных.");
            });
    }


    // Функция для добавления студента
    function addStudent() {
        const fullName = document.getElementById('fullName').value.trim();
        const groupId = document.getElementById('groupId').value.trim();
        const email = document.getElementById('email').value.trim();
        const phone = document.getElementById('phone').value.trim();

        if (!fullName || !groupId || !email || !phone) {
            alert("Некорректные данные");
            return;
        }

        fetch("/addStudent", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: new URLSearchParams({
                fullName: fullName,
                groupId: groupId,
                email: email,
                phone: phone
            })
        })
            .then(response => response.json())
            .then(data => {
                if (data.error) {
                    alert(data.error);
                } else {
                    alert("Студент успешно добавлен");
                }
            })
            .catch(error => {
                console.error("Ошибка:", error);
                alert("Ошибка при добавлении студента.");
            });
    }


    // Функция для удаления студента
    function deleteStudent() {
        const studentId = document.getElementById('studentId').value.trim();

        if (!studentId) {
            alert("Некорректные данные");
            return;
        }

        fetch("/deleteStudent", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: new URLSearchParams({ studentId: studentId })
        })
            .then(response => response.json())
            .then(data => {
                if (data.error) {
                    alert(data.error);
                } else {
                    alert("Студент успешно удалён");
                }
            })
            .catch(error => {
                console.error("Ошибка:", error);
                alert("Ошибка при удалении студента.");
            });
    }

</script>
</body>
</html>