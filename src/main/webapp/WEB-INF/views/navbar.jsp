<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="<c:url value='/resources/static/navbar.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
<nav id="header" class="navbar bg-light">
    <div class="nav-left">
        <a href="${pageContext.request.contextPath}/"><img src="<c:url value='/resources/static/img/he.PNG'/>" id="logo" class="logo" alt="Logo"></a>
        <a class="nav-link" href="${pageContext.request.contextPath}/aiboard/ai_board">AI 면접 준비</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/company/corpmain">기업 분석</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/review_board/review_list">리뷰 게시판</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/notice/noticeboard">면접의 고수<span class="badge">pro</span></a>
    </div>
    <div class="nav-right">
        <div class="nav-right-btn">
            <sec:authorize access="!isAuthenticated()">
                <!-- 비로그인 상태 -->
                <a href="${pageContext.request.contextPath}/member/login">
                    <button class="login-btn">로그인</button>
                </a>
                <a href="${pageContext.request.contextPath}/member/join">
                    <button class="join-btn">회원가입</button>
                </a>
            </sec:authorize>

            <sec:authorize access="isAuthenticated()">
                <!-- 로그인 상태 -->
                <a href="${pageContext.request.contextPath}/mypage/mypage">
                    <button class="mypage-btn">마이페이지</button>
                </a>

                <a href="#"><img src="<c:url value='/resources/static/img/bell.svg'/>" alt="bell" class="bell"></a>
                <a href="#"><img src="<c:url value='/resources/static/img/profile.svg'/>" alt="profile" class="profile"></a>
                <form action="${pageContext.request.contextPath}/member/logout" method="post" class="logout-form">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <button type="submit" class="logout-btn">
                        <img src="<c:url value='/resources/static/img/logout.svg'/>" alt="logout" >
                    </button>
                </form>
            </sec:authorize>
        </div>
    </div>
</nav>
</body>
</html>