<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Naver Login Success</title>
</head>
<body>
    <h2>Naver Login Success</h2>
    <p id="token-result" th:text="'토큰: ' + ${token}"></p>
    <p id="username-result" th:text="'username: ' + ${username}"></p>
    <p id="name-result" th:text="'name: ' + ${name}"></p>
    <p id="email-result" th:text="'email: ' + ${email}"></p>
    <p id="phone-number-result" th:text="'phone_number: ' + ${phone_number}"></p>
    <p id="gender-result" th:text="'gender: ' + ${gender}"></p>
    <p id="birth-date-result" th:text="'birthDate: ' + ${birthDate}"></p>
    <p id="error-message" style="color:red;"></p>

    <div id="token-container" th:data-token="${token}" th:data-username="${username}"
         th:data-name="${name}" th:data-email="${email}"
         th:data-phone-number="${phoneNumber}" th:data-gender="${gender}"
         th:data-birth-date="${birthDate}"></div>

    <script>
        function handleNaverLogin() {
            const container = document.getElementById('token-container');
            const urlParams = new URLSearchParams(window.location.search);
            const code = urlParams.get('code');
            
            console.log('Extracted code:', code);

            const token = container.dataset.token;
            const username = container.dataset.username;
            const name = container.dataset.name;
            const email = container.dataset.email;
            const phoneNumber = container.dataset.phoneNumber;
            const gender = container.dataset.gender;
            const birthDate = container.dataset.birthDate;

            if (!code) {
                document.getElementById('error-message').innerText = '코드가 유효하지 않습니다.';
                return; 
            }

            // 코드 검증 요청
            fetch(`/oauth2/success?code=${code}&username=${username}&name=${name}&email=${email}&phone_number=${phoneNumber}&gender=${gender}&birthDate=${birthDate}`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => {
                // 사용자 존재 여부 판단
                if (!response.ok) {
                    throw new Error('Failed to load /oauth2/success');
                }
                return response.text();
            })
            .then(data => {
                console.log('Received data:', data);
                loadHomePage(token);
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('error-message').innerText = '코드 검증 실패: ' + error.message;
            });
        }

        function loadHomePage(token) {
            fetch('/', {
                method: 'GET',
                headers: {
                    'Authorization': 'Bearer ' + token,
                    'Content-Type': 'application/json'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to load home page');
                }
                return response.text();
            })
            .then(data => {
                document.body.innerHTML = data; // 서버에서 받은 HTML로 업데이트
                window.location.href = '/';
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('error-message').innerText = '홈 페이지 로드 실패: ' + error.message;
            });
        }

        window.onload = handleNaverLogin;
    </script>
</body>
</html>
