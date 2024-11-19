<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/static/review_board/review_write.css">
	<title>면접 후기 작성</title>
	<%@ include file="../header.jsp" %>
</head>
<body>
<jsp:include page="../navbar.jsp" />

<!-- Main Content -->
<div class="main-content">
	<div class="container">
		<header class="header">
			<h1>면접 후기 작성</h1>
			<p>여러분의 소중한 면접 경험을 공유해주세요</p>
		</header>

		<form class="form-card" action="/review_board/write" method="post" id="reviewForm">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /
			<div class="metadata-section">
				<div class="metadata-grid">
					<div class="input-group">
						<label class="input-label">시기</label>
						<select class="input-field" name="period" required>
							<option value="">선택해주세요</option>
							<option value="2024년 상반기">2024년 상반기</option>
							<option value="2024년 하반기">2024년 하반기</option>
							<option value="2023년 상반기">2023년 상반기</option>
							<option value="2023년 하반기">2023년 하반기</option>
						</select>
					</div>

					<div class="input-group">
						<label class="input-label">직무</label>
						<input type="text" class="input-field" name="reviewPosition" placeholder="직무명을 입력하세요" required>
					</div>

					<div class="input-group">
						<label class="input-label">회사명</label>
						<input type="text" class="input-field" name="reviewCompany" placeholder="회사명을 입력하세요" required>
					</div>

					<div class="input-group">
						<label class="input-label">합격여부</label>
						<select class="input-field" name="result" required>
							<option value="">선택해주세요</option>
							<option value="결과대기중">결과대기중</option>
							<option value="합격">합격</option>
							<option value="불합격">불합격</option>
						</select>
					</div>
				</div>
			</div>


			<div class="title-section">
				<div class="input-group">
					<label class="input-label">제목</label>
					<input type="text" class="input-field" name="reviewTitle" placeholder="게시글 제목을 입력해주세요" required>
				</div>
			</div>

			<div class="content-section">
				<div class="format-toggle">
					<label class="input-label">작성 형식:</label>
					<button type="button" class="toggle-btn active" data-format="free">자유 양식</button>
					<button type="button" class="toggle-btn" data-format="qa">질문-답변</button>
				</div>

				<input type="hidden" name="formatType" id="formatType" value="free">

				<!-- 자유 양식 섹션 -->
				<div id="free-format">
					<div class="content-group">
						<label class="content-label">면접 분위기나 진행방식은 어떠했습니까?</label>
						<textarea class="content-textarea" name="atmosphere" placeholder="" required></textarea>
					</div>
					<div class="content-group">
						<label class="content-label">면접에서 좋았던 점이나 아쉬웠던 점은 무엇입니까?</label>
						<textarea class="content-textarea" name="sorrow" placeholder="" required></textarea>
					</div>
					<div class="content-group">
						<label class="content-label">면접 합격 팁이나 조언이 있다면?</label>
						<textarea class="content-textarea" name="advice" placeholder="" required></textarea>
					</div>
				</div>

				<!-- 질문-답변 섹션 -->
				<div id="qa-format" style="display: none;">
					<div id="questions-container">
						<div class="question-section">
							<label class="content-label">질문 1</label>
							<input type="text" class="input-field mb-3" name="questions[0].question" placeholder="질문을 입력하세요" required>
							<textarea class="content-textarea" name="questions[0].answer" placeholder="답변을 입력하세요..." required></textarea>
						</div>
					</div>
					<button type="button" class="add-question-btn">질문 추가하기</button>
				</div>

				<div class="form-buttons">
					<button type="button" class="btn btn-cancel">취소</button>
					<button type="submit" class="btn btn-submit">작성완료</button>
				</div>
			</div>
		</form>
	</div>
</div>


<script>
	document.addEventListener('DOMContentLoaded', function() {
		const form = document.getElementById('reviewForm');
		const toggleBtns = document.querySelectorAll('.toggle-btn');
		const freeFormat = document.getElementById('free-format');
		const qaFormat = document.getElementById('qa-format');
		const addQuestionBtn = document.querySelector('.add-question-btn');
		const formatTypeInput = document.getElementById('formatType');
		let questionCounter = 1;  // 1부터 시작


		// Format toggle
		toggleBtns.forEach(btn => {
			btn.addEventListener('click', function() {
				// 모든 버튼의 활성화 클래스 제거
				toggleBtns.forEach(b => b.classList.remove('active'));
				this.classList.add('active'); // 현재 클릭된 버튼 활성화

				const format = this.dataset.format;
				formatTypeInput.value = format;

				// 양식에 따라 섹션 표시 전환
				if (format === 'free') {
					freeFormat.style.display = 'block';
					qaFormat.style.display = 'none';
				} else {
					freeFormat.style.display = 'none';
					qaFormat.style.display = 'block';
				}
			});
		});

		// Add question
		document.querySelector('.add-question-btn').addEventListener('click', function() {
			const questionsContainer = document.getElementById('questions-container');
			const newQuestion = document.createElement('div');
			newQuestion.className = 'question-section';
			newQuestion.innerHTML ="<label class=\"content-label\">질문 " + (questionCounter + 1) + "</label>" +
					"<input type=\"text\" class=\"input-field mb-3\" name=\"questions[" + questionCounter + "].question\" placeholder=\"질문을 입력하세요\" required>" +
					"<textarea class=\"content-textarea\" name=\"questions[" + questionCounter + "].answer\" placeholder=\"답변을 입력하세요...\" required></textarea>";
			questionsContainer.appendChild(newQuestion);
			questionCounter++;
		});

		// Cancel button
		document.querySelector('.btn-cancel').addEventListener('click', function() {
			if (confirm('작성을 취소하시겠습니까? 작성중인 내용은 저장되지 않습니다.')) {
				window.location.href = '/review_board/review_list';  // Redirect to list page
			}
		});

		// 폼 제출 시 형식 타입 확인
		form.addEventListener('submit', function(event) {
			console.log("Submitting form with formatType: " + formatTypeInput.value);  // 제출 전 확인
		});
	});


</script>
</body>
</html>