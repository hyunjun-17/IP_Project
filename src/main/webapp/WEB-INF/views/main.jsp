<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>IPro</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<c:url value='/resources/static/main.css'/>">

</head>

<body>
<jsp:include page="navbar.jsp"/>

<!-- Hero Section -->
<section class="hero-section">
    <div class="hero-content">
        <h1>기업과 나를 잇는 면접 코칭 AI <br>면접 질문 준비부터 실전 면접 연습까지</h1>
        <p>최고의 면접을 위한<br>가장 똑똑한 방법, IPro</p>
	    <button class="start-button"><a href="${pageContext.request.contextPath}/aiboard/ai_board">지금 시작해보세요!</a></button>
    </div>
</section>

<!-- Chat Section -->
<section class="chat-section">
	<h2>이런 고민을 하고 계시다면<br>지금 IP:PRO와 함께해 보세요!</h2>
	<div class="chat-bubbles">
		<div class="message-container left">
			<div class="profile-icon">
				<i class="fas fa-user"></i>
			</div>
			<div class="chat-bubble left">"면접 준비는 해야 하는데 어디서부터 시작해야 할지 모르겠어요."</div>
		</div>
		<div class="message-container right">
			<div class="profile-icon">
				<i class="fas fa-headset"></i>
			</div>
			<div class="chat-bubble right">"잘 준비하고 있는 건지, 부족한 부분은 무엇인지 알려드릴께요!"</div>
		</div>
		<div class="message-container left">
			<div class="profile-icon">
				<i class="fas fa-user"></i>
			</div>
			<div class="chat-bubble left">"실전에서 내가 어떤 모습으로 보일지 알게 되었어요!!"</div>
		</div>
	</div>
</section>

<!-- Center Section -->
<section class="center-section">
    <div class="center-content">
        <div class="text-content">
            <span class="question-tag">어떻게 진행되나요?</span>
            <h2 class="main-heading">
                기업 직무 경험 <br>
                세가지 종류의 예상 면접 질문 제공 <br>
                IPro의 피드백을 바탕으로 면접준비를 함께 해 보세요!
            </h2>
            <p class="sub-text">
                다양한 기업 정보를 가지고 있는 AI피드백으로<br>
                면접 준비에 도움이 필요한 모든 분들에게 경험에 기반한 노하우를 공유해 드립니다.
            </p>
        </div>

        <!-- Side-by-side feature section -->
        <div class="feature-row">
            <div class="feature-illustration">
                <img src="/resources/static/img/ai-robot.svg" alt="AI Robot illustration">
            </div>
            <div class="feature-text">
                <span class="feature-tag">다양한 피드백 & 프로그램</span>
                <h3>IPro에서 준비한<br>분야별, 업종별 다양한 피드백과<br>프로그램을 살펴보세요!</h3>
            </div>
        </div>
    </div>
</section>


<!-- Container 5 -->
<div class="container5">
    <!-- Title Section -->
    <div class="title-section">
        <h2 class="main-title">최고의 면접을 위한</h2>
        <h2 class="main-title">가장 똑똑한 방법, IPro</h2>
        <div class="underline"></div>
    </div>

    <!-- Feature Grid -->
    <div class="feature-grid">
        <div class="feature-item">
            <h3>완벽한 면접을 위해</h3>
            <p>바로바로 체크해서 피드백</p>
        </div>
        <div class="feature-item">
            <h3>형식적인 평가 시스템이 아닌,</h3>
            <p>구직자의 성장을 위해</p>
        </div>
        <div class="feature-item">
            <h3>실제 면접 후기와</h3>
            <p>기업 완벽분석을 통해 만든 데이터</p>
        </div>
    </div>

    <div class="main-img-box-grid">
        <div class="main-img-box">
            <img src="<c:url value='/resources/static/img/mainintroimg4.svg' />"
                 alt="Feature illustration 1" class="main-box-img">
        </div>
        <div class="main-img-box">
            <img src="<c:url value='/resources/static/img/mainintroimg5.svg' />"
                 alt="Feature illustration 2" class="main-box-img">
        </div>
        <div class="main-img-box">
            <img src="<c:url value='/resources/static/img/mainintroimg6.svg' />"
                 alt="Feature illustration 3" class="main-box-img">
        </div>
    </div>
</div>
</div>

<jsp:include page="footer.jsp"/>
</body>
</html>