<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>IPro</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<c:url value='/resources/static/member/login.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body>
<jsp:include page="../navbar.jsp" />
<div class="login-container">
    <div class="login-box">
        <div class="brand-section">
            <img src="<c:url value='/resources/static/img/white.PNG'/>" alt="lgLogo" class="lglogo">
            <h1 class="login-title">면접의 첫 걸음</h1>
        </div>

        <form action="${pageContext.request.contextPath}/member/login-process" method="POST" class="login-form">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="input-group">
                <i class="fas fa-user"></i>
                <input type="text" name="username" placeholder="아이디를 입력하세요" required>
            </div>

            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="password" placeholder="비밀번호를 입력하세요" required>
            </div>

            <div class="form-options">
                <label class="remember-me">
                    <input type="checkbox" id="remember">
                    <span class="checkmark"></span>
                    아이디 기억하기
                </label>
            </div>

            <button type="submit" class="lglogin-btn">
                로그인
            </button>
        </form>

        <div class="divider">
            <span>또는 소셜 계정으로 로그인</span>
        </div>

        <div class="social-login">
            <a href="${pageContext.request.contextPath}/oauth2/authorization/naver" class="social-btn naver">
                <i class="fas fa-n"></i>
            </a>
            <a href="${pageContext.request.contextPath}/oauth2/authorization/google" class="social-btn google">
                <i class="fab fa-google"></i>
            </a>
            <a href="${pageContext.request.contextPath}/oauth2/authorization/kakao" class="social-btn kakao">
                <i class="fas fa-comment"></i>
            </a>
        </div>

        <div class="footer-links">
            <a href="${pageContext.request.contextPath}/member/findid">아이디 찾기</a>
            <span class="separator">|</span>
            <a href="${pageContext.request.contextPath}/idpw">비밀번호 찾기</a>
            <span class="separator">|</span>
            <a href="${pageContext.request.contextPath}/member/join">회원가입</a>
        </div>
    </div>
</div>

<!-- Recovery Forms -->
<div id="idpw-container" class="idpw-container hidden">
    <div id="id-section" class="idpw-section hidden">
        <h2 class="recovery-title">아이디 찾기</h2>
        <form action="${pageContext.request.contextPath}/member/id_recovery" method="POST">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="input-group">
                <i class="fas fa-envelope"></i>
                <input type="email" name="email" placeholder="이메일을 입력하세요" required>
            </div>
            <button type="submit" class="recovery-btn">아이디 찾기</button>
        </form>
    </div>

    <div id="pw-section" class="idpw-section hidden">
        <h2 class="recovery-title">비밀번호 찾기</h2>
        <form action="${pageContext.request.contextPath}/member/pw_recovery" method="POST">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="input-group">
                <i class="fas fa-user"></i>
                <input type="text" name="username" placeholder="아이디를 입력하세요" required>
            </div>
            <div class="input-group">
                <i class="fas fa-envelope"></i>
                <input type="email" name="email" placeholder="이메일을 입력하세요" required>
            </div>
            <button type="submit" class="recovery-btn">비밀번호 찾기</button>
        </form>
    </div>

    <button id="close-btn" class="close-btn">
        <i class="fas fa-times"></i>
    </button>
</div>

<script>
    const loginContainer = document.querySelector('.login-container');
    const idpwContainer = document.getElementById('idpw-container');
    const closeButton = document.getElementById('close-btn');
    const idSection = document.getElementById('id-section');
    const pwSection = document.getElementById('pw-section');
    const idLink = document.querySelector('.footer-links a:first-child');
    const pwLink = document.querySelector('.footer-links a:nth-child(2)');

    const toggleRecoveryForm = (showId) => {
        idpwContainer.classList.remove('hidden');
        loginContainer.classList.add('hidden');
        idSection.classList.toggle('hidden', !showId);
        pwSection.classList.toggle('hidden', showId);
    };

    idLink.addEventListener('click', (e) => {
        e.preventDefault();
        toggleRecoveryForm(true);
    });

    pwLink.addEventListener('click', (e) => {
        e.preventDefault();
        toggleRecoveryForm(false);
    });

    closeButton.addEventListener('click', () => {
        idpwContainer.classList.add('hidden');
        loginContainer.classList.remove('hidden');
        idSection.classList.add('hidden');
        pwSection.classList.add('hidden');
    });
</script>

</body>
</html>