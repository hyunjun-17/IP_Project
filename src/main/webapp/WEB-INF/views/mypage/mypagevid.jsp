<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../header.jsp" %>
	<title>My Page</title>
	<link rel="stylesheet" href="<c:url value='/resources/static/mypage/mypagevid.css'/>">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<jsp:include page="../navbar.jsp"/>
<!-- Video Toggle Button -->
<button class="video-toggle" aria-label="Toggle Video Section">
	<i class="fas fa-video"></i>
</button>


<<div class="video-section">

	<h4 class="section-title">면접 영상</h4>
	<button class="video-close" aria-label="Close Video Section">
		<i class="fas fa-times"></i>
	</button>
	<div class="video-preview">
		<div class="video-box">
			<video id="interviewVideo" controls>
				<source src="" type="video/mp4">

			</video>
		</div>
	</div>
</div>

<div class="main-content">
	<div class="row">
		<div class="col-2">
			<jsp:include page="mypagebar.jsp"/>
		</div>
		<div class="col-10">
			<div class="mypcontent">
				<h2 class="page-header">면접 영상 내역</h2>
				<div class="row">
					<!-- Questions Section -->
					<div class="col-6">
						<div class="video-questions">
							<h4 class="section-title">면접 질문</h4>
							<c:forEach items="${ipros}" var="ipro" varStatus="status">
							<div class="question-item">
								<button class="question-button">
									<span class="question-number">Q${status.index+1}.</span><c:out value="${ipro.iproQuestion}"/>
								</button>
							</div>
							</c:forEach>
						</div>
					</div>
				</div>

				<!-- Answer Section -->
				<div class="answer-box-info">
					<h4 class="section-title">사용자 답변</h4>
					<div class="answer-box" data-question="0">
						<p>답변을 확인할 질문을 선택해주세요.</p>
					</div>
					<c:forEach items="${ipros}" var="ipro" varStatus="status">
						<div class="answer-box" data-question="${status.index + 1}">
						<p><c:out value="${ipro.iproAnswer}"/></p>
						</div>
					</c:forEach>
					<div class="d-flex justify-content-end">
						<button class="btn btn-primary" onclick="editAnswer()">
							수정하기
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const answerBoxes = document.querySelectorAll('.answer-box');
        const questionButtons = document.querySelectorAll('.question-button');
        const videoToggle = document.querySelector('.video-toggle');
        const videoSection = document.querySelector('.video-section');
        const mainContent = document.querySelector('.main-content');
        const toggleIcon = videoToggle.querySelector('i');
        const videoClose = document.querySelector('.video-close');

        // Show first answer by default
        if (answerBoxes.length > 0) {
            answerBoxes[0].classList.add('active');
            questionButtons[0].classList.add('active');
        }

        // 비디오 섹션 열기
        videoToggle.addEventListener('click', function() {
            videoSection.classList.add('active');
            mainContent.classList.add('video-active');
            videoToggle.style.display = 'none';
        });

        // 비디오 섹션 닫기
        videoClose.addEventListener('click', function() {
            videoSection.classList.remove('active');
            mainContent.classList.remove('video-active');
            videoToggle.style.display = 'flex';  // 토글 버튼 다시 표시
        });

        // Question button click handlers
        questionButtons.forEach(button => {
            button.addEventListener('click', function () {
                // Remove active class from all buttons
                questionButtons.forEach(btn => btn.classList.remove('active'));

                // Add active class to clicked button
                this.classList.add('active');

                // Get question number
                const questionNumber = this.querySelector('.question-number').textContent
                    .replace('Q', '').replace('.', '');


				// Update answer text
				const answerBox = document.querySelector('.answer-box[data-question="' + questionNumber + '"]');

				// Make sure the element exists before trying to get its content
				if (answerBox) {
					// Extract the answer text
					let answerText = answerBox.querySelector('p').textContent;

					// If the answer text is null or empty, set the default message
					if (!answerText || answerText.trim() === '') {
						answerText = '작성한 답변이 없습니다.';  // 답변이 없을 때 표시할 메시지
					}

					// Find the currently active answer box and make it inactive
					answerBoxes.forEach(box => box.classList.remove('active'));

					// Add active class to the corresponding answer box
					answerBox.classList.add('active');

					// Optionally update inner HTML if needed
					answerBox.innerHTML =
							'<p>' + answerText + '</p>';
				}
            });
        });
    });

	function editAnswer(){

	}

	function saveAnswer(){

	}
</script>
</body>
</html>