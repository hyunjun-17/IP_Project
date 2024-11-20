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
	<meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
</head>
<body>
<jsp:include page="../navbar.jsp"/>
<!-- Video Toggle Button -->
<button class="video-toggle" aria-label="Toggle Video Section">
	<i class="fas fa-video"></i>
</button>

<div class="video-section">
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
	document.addEventListener('DOMContentLoaded', function() {
		// DOM 요소 선택
		const video = document.getElementById('interviewVideo');
		const questionButtons = document.querySelectorAll('.question-button');
		const answerBoxes = document.querySelectorAll('.answer-box');
		const videoSection = document.querySelector('.video-section');
		const mainContent = document.querySelector('.main-content');
		const videoClose = document.querySelector('.video-close');

		// URL 파라미터와 CSRF 토큰 가져오기
		const urlParams = new URLSearchParams(window.location.search);
		const selfIdx = urlParams.get('selfIdx');
		const csrfToken = document.querySelector("meta[name='_csrf']")?.content;
		const csrfHeader = document.querySelector("meta[name='_csrf_header']")?.content;

		// 전역 변수 설정
		let videoData = null;
		let currentQuestionId = null;

		/**
		 * 서버에서 비디오 데이터 로드
		 * - 면접 영상과 질문 데이터를 가져옴
		 * - 성공시 질문 버튼 설정 함수 호출
		 */
		async function loadVideoData() {
			try {
				const response = await fetch(`/mypage/interview-videos/${selfIdx}`, {
					headers: {
						[csrfHeader]: csrfToken
					}
				});

				if (!response.ok) {
					throw new Error('Failed to load video data');
				}

				videoData = await response.json();
				setupQuestionButtons();
				setupInitialQuestion();
			} catch (error) {
				console.error('Error loading video data:', error);
				showErrorMessage('데이터를 불러오는데 실패했습니다.');
			}
		}

		/**
		 * 질문 버튼 설정
		 * - 각 질문별 비디오 버튼 생성
		 * - 클릭 이벤트 핸들러 등록
		 */
		function setupQuestionButtons() {
			questionButtons.forEach((button, index) => {
				const videoInfo = videoData[index];
				if (!videoInfo) return;

				// 질문 내용 생성
				const questionContent = document.createElement('div');
				questionContent.className = 'question-content';
				questionContent.innerHTML = `
                <span class="question-number">Q${videoInfo.questionNumber}.</span>
                ${videoInfo.question}
            `;

				// 비디오가 있는 경우에만 비디오 버튼 생성
				if (videoInfo.videoUrl) {
					const videoButton = document.createElement('button');
					videoButton.className = 'video-button';
					videoButton.innerHTML = '<i class="fas fa-video"></i>';
					videoButton.addEventListener('click', (e) => {
						e.stopPropagation(); // 버블링 방지
						openVideo(videoInfo.videoUrl);
					});
					button.appendChild(videoButton);
				}

				// 질문 클릭 이벤트 등록
				button.addEventListener('click', () => handleQuestionClick(videoInfo, button));
			});
		}

		/**
		 * 질문 버튼 클릭 처리
		 * - 활성화 상태 변경
		 * - 답변 표시
		 * - 비디오 로드
		 */
		function handleQuestionClick(videoInfo, button) {
			if (!videoInfo) return;

			// 활성화 상태 업데이트
			questionButtons.forEach(btn => btn.classList.remove('active'));
			answerBoxes.forEach(box => box.classList.remove('active'));
			button.classList.add('active');
			currentQuestionId = videoInfo.questionNumber;

			// 답변 박스 업데이트
			updateAnswerBox(videoInfo);

			// 비디오가 있는 경우 로드
			if (videoInfo.videoUrl) {
				loadVideo(videoInfo.videoUrl);
			}
		}

		/**
		 * 답변 박스 내용 업데이트
		 * - 답변 텍스트 표시
		 * - 수정 버튼 추가
		 */
		function updateAnswerBox(videoInfo) {
			const answerBoxInfo = document.querySelector('.answer-box-info');
			answerBoxInfo.innerHTML = `
            <h4 class="section-title">사용자 답변</h4>
            <div class="answer-box active">
                <p>${videoInfo.answer || '답변이 없습니다.'}</p>
                <div class="answer-actions">
                    <button onclick="editAnswer(${videoInfo.questionNumber})" class="edit-btn">
                        수정
                    </button>
                </div>
            </div>
        `;
		}

		/**
		 * 비디오 섹션 열기
		 * - 비디오 로드
		 * - 섹션 표시
		 */
		function openVideo(videoUrl) {
			video.src = videoUrl;
			video.load();
			videoSection.classList.add('active');
			mainContent.classList.add('video-active');
		}

		/**
		 * 비디오 로드
		 * - 새로운 비디오 URL 설정
		 */
		function loadVideo(videoUrl) {
			video.src = videoUrl;
			video.load();
		}

		// 비디오 섹션 닫기 이벤트
		videoClose.addEventListener('click', function() {
			videoSection.classList.remove('active');
			mainContent.classList.remove('video-active');
			video.pause();
		});

		/**
		 * 에러 메시지 표시
		 */
		function showErrorMessage(message) {
			const errorDiv = document.createElement('div');
			errorDiv.className = 'error-message';
			errorDiv.textContent = message;
			document.querySelector('.video-questions').prepend(errorDiv);
		}

		// 비디오 에러 처리
		video.addEventListener('error', function(e) {
			console.error('Video error:', e);
			showErrorMessage('영상을 불러오는데 실패했습니다.');
		});

		/**
		 * URL 파라미터로 초기 질문 설정
		 * - URL에 questionId가 있는 경우 해당 질문 활성화
		 */
		function setupInitialQuestion() {
			const initialQuestionId = urlParams.get('questionId');
			if (initialQuestionId && videoData) {
				const questionButton = document.querySelector(`[data-question="${initialQuestionId}"]`);
				if (questionButton) {
					questionButton.click();
				}
			}
		}

		/**
		 * 답변 수정 모드 활성화
		 * - 텍스트 영역으로 변환
		 * - 저장/취소 버튼 표시
		 */
		window.editAnswer = function(questionId) {
			const answerBox = document.querySelector('.answer-box.active');
			if (!answerBox) return;

			const currentAnswer = answerBox.querySelector('p').textContent;
			answerBox.innerHTML = `
            <textarea class="answer-edit" rows="4">${currentAnswer}</textarea>
            <div class="answer-actions">
                <button onclick="saveAnswer(${questionId})" class="save-btn">저장</button>
                <button onclick="cancelEdit(${questionId})" class="cancel-btn">취소</button>
            </div>
        `;
		};

		/**
		 * 답변 저장
		 * - 서버에 답변 전송
		 * - 성공시 UI 업데이트
		 */
		window.saveAnswer = async function(questionId) {
			const textarea = document.querySelector('.answer-edit');
			if (!textarea) return;

			try {
				const response = await fetch(`/mypage/interview-answer/${selfIdx}/${questionId}`, {
					method: 'POST',
					headers: {
						'Content-Type': 'application/json',
						[csrfHeader]: csrfToken
					},
					body: JSON.stringify({ answer: textarea.value })
				});

				if (!response.ok) throw new Error('Failed to save answer');

				// 로컬 데이터와 UI 업데이트
				const questionData = videoData.find(q => q.questionNumber === questionId);
				if (questionData) {
					questionData.answer = textarea.value;
					updateAnswerBox(questionData);
				}
			} catch (error) {
				console.error('Error saving answer:', error);
				showErrorMessage('답변 저장에 실패했습니다.');
			}
		};

		/**
		 * 답변 수정 취소
		 * - 원래 답변으로 되돌리기
		 */
		window.cancelEdit = function(questionId) {
			const questionData = videoData.find(q => q.questionNumber === questionId);
			if (questionData) {
				updateAnswerBox(questionData);
			}
		};

		// 초기화
		loadVideoData();
	});

	function editAnswer(){

	}

	function saveAnswer(){

	}
</script>
</body>
</html>