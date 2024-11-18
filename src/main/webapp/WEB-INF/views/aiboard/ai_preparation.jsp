<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
	<title>Interview Setup</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/static/aiboard/ai_preparation.css">
	<meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<jsp:include page="../navbar.jsp"/>
<!-- Interview Setup Section -->
<div id="setupSection" class="main-content">
	<div class="container-fluid">
		<div class="camera-card d-flex">
			<!-- Left section: Video -->
			<div class="col-7 pe-4">
				<div class="video-section">
					<div class="setup-header">
						<h5>면접 환경 설정</h5>
						<p><sec:authentication property="principal.member.name"/>님 영상 면접을 진행할 자기소개서와 질문을 선택해주세요.</p>
					</div>
					<div class="video-container">
						<!-- Video placeholder -->
					</div>
					<div id="setupVideoError-1" class="video-error" style="display: none;">
						<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
							<circle cx="12" cy="12" r="10"></circle>
							<line x1="12" y1="8" x2="12" y2="12"></line>
							<line x1="12" y1="16" x2="12" y2="16"></line>
						</svg>
						카메라에 접근할 수 없습니다. 카메라 권한을 확인해주세요.
					</div>
				</div>
			</div>
			<!-- Right section: Settings -->
			<div class="col-5">
				<div class="form-section">
					<div class="mb-4">
						<div id="selectedSelfIntroduction">
							<label class="form-label mb-2"><strong>자기소개서</strong></label>
							<input id="coverLetter" readonly class="form-control mb-3" value="-"/>
							<button id="loadModalBtn" class="btn btn-load w-100">
								자기소개서 불러오기
							</button>
						</div>
					</div>
					<button class="btn btn-start w-100" onclick="startInterview()">
						면접 시작하기
					</button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- Question Section -->
<div id="questionSection" class="main-content hidden">
	<div class="container-fluid">
		<div class="camera-card">
			<!-- Left section: Video -->
			<div class="video-column">
				<div class="video-area">
					<div class="question-header">
						<h5>면접 질문</h5>
						<div class="current-question">
							<p class="question-number"><strong>Question 1</strong></p>
							<p class="question-content">회사를 선택한 이유는 무엇인가요?</p>
						</div>
					</div>
					<div class="video-container">
						<!-- Video placeholder -->
						<div id="interviewRecordingIndicator-2" class="recording-indicator" style="display: none;">
							<span class="recording-dot"></span>
							녹화중
						</div>
					</div>
					<div id="interviewVideoError-2" class="video-error" style="display: none;">
						<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
							<circle cx="12" cy="12" r="10"></circle>
							<line x1="12" y1="8" x2="12" y2="12"></line>
							<line x1="12" y1="16" x2="12" y2="16"></line>
						</svg>
						카메라에 접근할 수 없습니다. 카메라 권한을 확인해주세요.
					</div>
					<div class="recording-controls">
						<button id="interviewStartButton" onclick="startRecording()" class="btn-record start">
							<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
								<circle cx="12" cy="12" r="10"></circle>
								<circle cx="12" cy="12" r="3"></circle>
							</svg>
							답변 시작
						</button>
						<button id="interviewStopButton" onclick="stopRecording()" class="btn-record stop" disabled>
							<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
								<rect x="6" y="6" width="12" height="12"></rect>
							</svg>
							답변 종료
						</button>
					</div>
				</div>
			</div>

			<!-- Right section: Transcript -->
			<div class="transcript-column">
				<div class="transcript-section">
					<div class="transcript-header">
						<h6 class="mb-0"><strong>답변 기록</strong></h6>
					</div>
					<div class="transcript-list">
						<div class="transcript-list">
							<div class="transcript-item" data-listener-added="false">
								<p class="transcript-question">Q1. 1번 질문</p>
								<p class="transcript-answer">질문 답변</p>
							</div>
							<div class="transcript-item">
								<p class="transcript-question">Q2. 2번 질문</p>
								<p class="transcript-answer">질문 답변</p>
							</div>
							<div class="transcript-item">
								<p class="transcript-question">Q3.3번 질문</p>
								<p class="transcript-answer">질문 답변</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- Ending Section  -->
<div id="endingSection" class="Ending hidden">
	<div class="container d-flex justify-content-center align-items-center vh-100">
		<div class="col center-text text-center">
			<Strong><p> 수고하셨습니다</p>
				<p>모든 답변이 완료 되었습니다.</p></Strong>
			<div class="endingbtn">
				<button class="btn btn-dark w-25 mt-3">면접 종료</button>
			</div>
		</div>
	</div>
</div>

<!-- 불러오기 모달 창 -->
<div id="loadModal" class="modal">
	<div class="modal-content">
		<span class="close">&times;</span>
		<h5><strong>자기소개서 불러오기</strong></h5>
		<p>영상 면접을 진행할 자기소개서를 선택하세요</p>
		<div id="noSelfBoardMessage" style="display: ${empty selfBoards ? 'block' : 'none'};">
			<div class="card">
				<div class="card-body d-flex justify-content-center align-items-center"
					 style="height: 100px;border: 1px solid #616161;border-radius: 8px;">
					<p class="mb-0">저장한 자기소개서 내역이 없습니다.</p>
				</div>
			</div>
		</div>
		<ul style="list-style: none; padding: 0;">
			<c:forEach items="${selfBoards}" var="selfBoard">
				<li onclick="loadSelfIntroduction(${selfBoard.selfIdx})"
					class="btn btn-outline-dark mb-2 text-start" style="width: 100%;">
					<div>
						<small>${fn:substring(selfBoard.selfDate, 0, 10)} ${fn:substring(selfBoard.selfDate, 11, 16)}</small>
						<fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${date}"/><br>
						<strong><c:out value="${selfBoard.selfCompany}"/></strong>
						<strong>${selfBoard.selfPosition}</strong><br>
						<span>${selfBoard.selfTitle}</span>
					</div>
				</li>
			</c:forEach>
		</ul>
	</div>
</div>

<script>
	// 질문 추출 페이지에서 넘어 올 때 바로 자기소개서 로드
	window.addEventListener('DOMContentLoaded', (event) => {
		const urlParams = new URLSearchParams(window.location.search);
		const selfIdx = urlParams.get('selfIdx');

		if (selfIdx) {
			loadSelfIntroduction(selfIdx);
		}
	});

	document.addEventListener('DOMContentLoaded', function () {
		// 모달 창 관련 요소
		const loadModal = document.getElementById("loadModal");
		const loadModalBtn = document.getElementById("loadModalBtn");
		const loadCloseBtn = loadModal.querySelector(".close");


		// 모달 열기
		loadModalBtn.onclick = function () {
			loadModal.style.display = "block";
		};

		// 모달 닫기
		loadCloseBtn.onclick = function () {
			loadModal.style.display = "none";
		};

		// 모달 외부 클릭시 닫기
		window.onclick = function (event) {
			if (event.target == loadModal) {
				loadModal.style.display = "none";
			}
		};
	});


	// 전역 변수로 선택된 자기소개서의 position을 저장
	let selectedPosition = '';
	let username = '';
	let selfId = '';
	let iproAnswers = '';

	function loadSelfIntroduction(selfIdx) {
		selfId = selfIdx;
		$.ajax({
			url: `${pageContext.request.contextPath}/aiboard/loadSelfIntroduction/` + selfIdx,
			method: 'GET',
			dataType: 'json',
			success: function (data) {
				username = data.username;
				const company = data.company;
				const position = data.position;
				const title = data.title;
				const iproQuestions = data.iproQuestions;
				iproAnswers = data.iproAnswers;

				// iproAnswers가 배열인지 확인하고, 배열이 아니라면 빈 배열로 설정
				if (!Array.isArray(iproAnswers)) {
					iproAnswers = [];
					console.warn('iproAnswers는 배열이 아니므로 빈 배열로 설정되었습니다.');
				}

				console.log('로드된 iproAnswers:', iproAnswers); // 디버깅용 로그

				selectedPosition = position;

				const resultDiv = document.getElementById('selectedSelfIntroduction');
				resultDiv.innerHTML = '<strong>자기소개서</strong>' +
						'<div class="form-control mb-3"><span>' + company + '</span>' +
						'<span> / ' + position + '</span></div>';


				// 질문 테이블 생성
				const tableDiv = document.createElement('div');
				tableDiv.className = 'table-responsive mt-3';

				let tableHtml = '<table class="table">' +
						'<colgroup>' +
						'<col style="width: 5%">' +
						'<col style="width: 85%">' +
						'<col style="width: 10%">' +
						'</colgroup>' +
						'<thead>' +
						'<tr style="border:transparent;"><th colspan="3"><strong>예상질문</strong></th></tr>'+
						'</thead>' +
						'<tbody>';

				if (iproQuestions && iproQuestions.length > 0) {
					iproQuestions.forEach((question, i) => {
						tableHtml += '<tr>' +
								'<td>' + (i + 1) + '</td>' +
								'<td>' + question + '</td>' +
								'<td>' +
								'<input class="form-check-input" type="checkbox" ' +
								'value="' + question + '" ' +
								'id="question' + i + '" ' +
								'name="selectedQuestions">' +
								'</td>' +
								'</tr>';
					});
				} else {
					const defaultQuestions = [
						"1분 자기소개 해주세요.",
						"이 회사를 선택한 이유는 무엇인가요?",
						"직무와 관련된 경험을 설명해주세요.",
						"본인의 강점과 약점은 무엇인가요?",
						"향후 커리어 계획이 무엇인가요?",
						"본인만의 차별화된 역량을 설명해주세요."
					];
					tableHtml += '<tr><td colspan="3" style="color:gray;">추출된 질문이 없어 기본 질문으로 대체됩니다.</td></tr>'

					defaultQuestions.forEach((question, i) => {
						tableHtml +=
								'<tr>' +
								'<td>' + (i + 1) + '</td>' +
								'<td>' + question + '</td>' +
								'<td>' +
								'<input class="form-check-input" type="checkbox" ' +
								'value="' + question + '" ' +
								'id="question' + i + '" ' +
								'name="selectedQuestions">' +
								'</td>' +
								'</tr>';
					});
				}

				tableHtml += '</tbody></table>';
				tableDiv.innerHTML = tableHtml;
				resultDiv.appendChild(tableDiv);
				resultDiv.style.display = 'block';
				loadModal.style.display = "none";

				// 체크박스 이벤트 리스너 추가
				const checkboxes = document.querySelectorAll('input[name="selectedQuestions"]');
				checkboxes.forEach(checkbox => {
					checkbox.addEventListener('change', function () {
						const checked = document.querySelectorAll('input[name="selectedQuestions"]:checked');
						if (checked.length > 6) {
							this.checked = false;
							alert('최대 6개의 질문만 선택할 수 있습니다.');
						}
					});
				});
			},
			error: function (xhr, status, error) {
				console.error('자기소개서 불러오기 오류:', error);
				alert('자기소개서를 불러오는데 실패했습니다.');
			}
		});
	}


	//  인터뷰 시작 끝 --------------------------------------------------
	async function startInterview() {
		try {
			// Keep all existing code
			const selfIntroDiv = document.getElementById('selectedSelfIntroduction');
			const formControl = selfIntroDiv.querySelector('.form-control');

			if (!formControl || formControl.textContent.trim() === '-') {
				alert('자기소개서를 선택해주세요.');
				return;
			}
			// iproAnswers가 존재하는지 확인하고, 없다면 빈 배열로 초기화
			const answers = Array.isArray(iproAnswers) ? iproAnswers : [];
			console.log('현재 iproAnswers:', answers); // 디버깅용 로그


			// 체크된 질문들을 선택하고, 해당 인덱스의 답변도 함께 저장
			const selectedQuestions = Array.from(document.querySelectorAll('input[name="selectedQuestions"]:checked'))
					.map((checkbox, index) => {
						// checkbox의 id에서 원래 질문의 인덱스를 추출 (예: "question0" -> 0)
						const originalIndex = parseInt(checkbox.id.replace('question', ''));
						console.log('선택된 질문 인덱스:', originalIndex); // 디버깅용 로그


						return {
							content: checkbox.value,
							orderNumber: index + 1,
							answer: iproAnswers[originalIndex] || '' // 해당 인덱스의 답변 추가
						};
					});
			console.log('최종 선택된 질문과 답변:', selectedQuestions); // 디버깅용 로그
			if (selectedQuestions.length === 0) {
				alert('최소 1개의 질문을 선택해주세요.');
				return;
			}
			if (selectedQuestions.length > 6) {
				alert('최대 6개의 질문만 선택할 수 있습니다.');
				return;
			}

			// API 요청 데이터에 선택된 답변들도 포함
			const requestData = {
				username: null,
				position: selectedPosition,
				questions: selectedQuestions,
				interviewDate: new Date().toISOString(),
				videoStatus: null,
				videoUrl: null,
				memberId: null
			};

			const response = await fetch('/aiboard/api/interview', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify(requestData)
			});

			if (!response.ok) {
				const errorText = await response.text();
				console.error('Server response:', errorText);
				throw new Error('면접 시작에 실패했습니다. Status: ' + response.status);
			}

			const data = await response.json();
			currentInterviewId = data.id;
			console.log('Interview started with ID:', currentInterviewId);

			updateTranscriptList(selectedQuestions);

			document.getElementById('setupSection').classList.add('hidden');
			document.getElementById('questionSection').classList.remove('hidden');

			const questionHeader = document.querySelector('.question-header');
			questionHeader.innerHTML = '<h5>면접 질문</h5>' +
					'<div class="current-question">' +
					'<p class="question-number"><strong>Question 1</strong></p>' +
					'<p class="question-content">' + selectedQuestions[0].content + '</p>' +
					'</div>';

			await startVideoRecording();

		} catch (error) {
			console.error('Interview start error:', error);
			alert(error.message);
		}
	}


	function setupTranscriptItemListeners() {
		const transcriptItems = document.querySelectorAll('.transcript-item');

		transcriptItems.forEach(item => {
			item.addEventListener('click', function() {
				transcriptItems.forEach(otherItem => {
					if (otherItem !== item) {
						otherItem.classList.remove('expanded');
					}
				});

				// Toggle expanded class on clicked item
				item.classList.toggle('expanded');

				// 클릭한 질문으로 current-question 업데이트
				const questionNumber = item.getAttribute('data-question-number');
				updateCurrentQuestion(parseInt(questionNumber));
			});
		});
	}

	document.addEventListener('DOMContentLoaded', setupTranscriptItemListeners);

	function updateCurrentQuestion(questionNumber) {
		const transcriptItems = document.querySelectorAll('.transcript-item');
		const targetItem = transcriptItems[questionNumber - 1];

		if (targetItem) {
			const questionContent = targetItem.querySelector('.transcript-question').textContent;
			// "Q1. " 부분을 제거하고 실제 질문 내용만 추출
			const actualQuestion = questionContent.substring(questionContent.indexOf('. ') + 2);

			const currentQuestionDiv = document.querySelector('.current-question');
			if (currentQuestionDiv) {
				currentQuestionDiv.querySelector('.question-number strong').textContent = 'Question ' +questionNumber;
				currentQuestionDiv.querySelector('.question-content').textContent = actualQuestion;
			}
		}
	}

	function updateTranscriptList(selectedQuestions) {
		const transcriptList = document.querySelector('.transcript-list');
		const tableHtml = '<div class="table-responsive"><table class="table"><tbody>' +
				selectedQuestions.map((question, index) =>
						'<tr class="transcript-item" data-question-number="' + (index + 1) + '" data-listener-added="false">' +
						'<td>' +
						'<p class="transcript-question">Q' + (index + 1) + '. ' + question.content + '</p>' +
						'<p class="transcript-answer">' + (question.answer || '') + '</p>' +
						'</td>' +
						'</tr>'
				).join('') +
				'</tbody></table></div>';

		transcriptList.innerHTML = tableHtml;
		setupTranscriptItemListeners();
	}


	function updateTranscriptAnswer(questionNumber, answer) {
		const transcriptItems = document.querySelectorAll('.transcript-item');
		if (transcriptItems[questionNumber - 1]) {
			const answerElement = transcriptItems[questionNumber - 1].querySelector('.transcript-answer');
			if (answerElement) {
				answerElement.textContent = answer;
			}
		}
	}

	// 답변 열고 닫는 기능
	document.addEventListener('DOMContentLoaded', function() {
		const transcriptItems = document.querySelectorAll('.transcript-item');

		transcriptItems.forEach(item => {
			item.addEventListener('click', function() {
				// If this item is already expanded, collapse it
				if (this.classList.contains('expanded')) {
					this.classList.remove('expanded');
					return;
				}

				// Collapse any other expanded items
				const expandedItems = document.querySelectorAll('.transcript-item.expanded');
				expandedItems.forEach(expandedItem => {
					if (expandedItem !== this) {
						expandedItem.classList.remove('expanded');
					}
				});

				// Expand this item
				this.classList.add('expanded');

				// 클릭한 질문으로 current-question 업데이트
				const questionNumber = this.getAttribute('data-question-number');
				updateCurrentQuestion(parseInt(questionNumber));
			});
		});
	});





	// -------------------------------------------- 카메라 관련 설정 ---------------------------------------------------------
	let currentInterviewId = null;
	let mediaRecorder;
	let recordedChunks = [];


	// 페이지 로드 시 카메라 초기화
	document.addEventListener('DOMContentLoaded', initializeCamera);

	async function initializeCamera() {
		try {
			// 먼저 카메라 권한 상태 확인
			const permissions = await navigator.permissions.query({name: 'camera'});
			if (permissions.state === 'denied') {
				throw new Error('카메라 권한이 거부되었습니다. 브라우저 설정에서 카메라 권한을 허용해주세요.');
			}

			const stream = await navigator.mediaDevices.getUserMedia({
				video: {
					width: {ideal: 1280},
					height: {ideal: 720}
				},
				audio: false
			});

			const videoContainer = document.querySelector('.video-container');
			if (!videoContainer) {
				throw new Error('비디오 컨테이너를 찾을 수 없습니다.');
			}

			const videoElement = document.createElement('video');
			videoElement.srcObject = stream;
			videoElement.autoplay = true;
			videoElement.playsInline = true;
			videoElement.muted = true;
			videoElement.style.width = '100%';
			videoElement.style.height = '100%';

			videoContainer.innerHTML = '';
			videoContainer.appendChild(videoElement);
			document.getElementById('setupVideoError-1').style.display = 'none';

		} catch (error) {
			handleCameraError(error, 'setup');
		}
	}


	function handleCameraError(error, section = 'setup') {
		console.error('Camera error:', error);
		const errorId = section === 'setup' ? 'setupVideoError-1' : 'interviewVideoError-2';
		const videoError = document.getElementById(errorId);

		if (videoError) {
			if (error.name === 'NotAllowedError' || error.name === 'PermissionDeniedError') {
				videoError.textContent = '카메라 권한이 거부되었습니다. 브라우저 설정에서 카메라 권한을 허용해주세요.';
			} else if (error.name === 'NotFoundError') {
				videoError.textContent = '카메라를 찾을 수 없습니다. 카메라가 연결되어 있는지 확인해주세요.';
			} else {
				videoError.textContent = '카메라 접근에 실패했습니다: ' + error.message;
			}
			videoError.style.display = 'block';
		}
	}


	// --------------------- 녹화 시작, 저장, 업로드하고 끝 -----------------------------------------------------------
	async function startVideoRecording() {
		try {
			const stream = await navigator.mediaDevices.getUserMedia({
				video: true,
				audio: true
			});

			const videoElement = document.createElement('video');
			videoElement.srcObject = stream;
			videoElement.autoplay = true;
			videoElement.playsInline = true;
			videoElement.style.width = '100%';
			videoElement.style.height = '100%';

			const container = document.querySelector('#questionSection .video-container');
			container.innerHTML = '';
			container.appendChild(videoElement);

			mediaRecorder = new MediaRecorder(stream, {
				mimeType: 'video/webm;codecs=vp8,opus'
			});

			mediaRecorder.ondataavailable = (event) => {
				if (event.data && event.data.size > 0) {
					recordedChunks.push(event.data);
				}
			};

			console.log('MediaRecorder 설정 완료');

		} catch (error) {
			console.error('카메라 설정 오류:', error);
			handleCameraError(error, 'question');
			throw error;
		}
	}

	async function finishInterview() {
		try {
			if (!mediaRecorder || mediaRecorder.state !== 'recording') {
				throw new Error('녹화가 진행 중이지 않습니다.');
			}

			await new Promise((resolve, reject) => {
				mediaRecorder.onstop = async () => {
					try {
						const token = document.querySelector("meta[name='_csrf']").content;
						const header = document.querySelector("meta[name='_csrf_header']").content;

						const blob = new Blob(recordedChunks, {type: 'video/webm'});
						const formData = new FormData();
						formData.append('video', blob);

						const response = await fetch(`/aiboard/api/interview/${currentInterviewId}/video`, {
							method: 'POST',
							headers: {
								[header]: token
							},
							body: formData
						});

						if (!response.ok) {
							throw new Error('비디오 제출에 실패했습니다.');
						}

						resolve();
					} catch (error) {
						reject(error);
					}
				};
				mediaRecorder.stop();
			});

			// 화면 전환
			document.getElementById('questionSection').classList.add('hidden');
			document.getElementById('endingSection').classList.remove('hidden');
			document.body.style.overflow = "hidden";

		} catch (error) {
			console.error('Interview finish error:', error);
			alert('Error: ' + error.message);
		} finally {
			cleanupVideoResources();
		}
	}


	function cleanupVideoResources() {
		// 모든 비디오 스트림 정지
		const videoElements = document.querySelectorAll('video');
		videoElements.forEach(video => {
			if (video.srcObject) {
				video.srcObject.getTracks().forEach(track => track.stop());
				video.srcObject = null;
			}
		});

		// MediaRecorder 정리
		if (mediaRecorder && mediaRecorder.state !== 'inactive') {
			mediaRecorder.stop();
		}

		// 녹화 표시기 숨기기
		const setupIndicator = document.getElementById('setupRecordingIndicator-1');
		const interviewIndicator = document.getElementById('interviewRecordingIndicator-2');

		if (setupIndicator) setupIndicator.style.display = 'none';
		if (interviewIndicator) interviewIndicator.style.display = 'none';
	}

	let isRecording = false;

	function startRecording() {
		try {
			if (!currentInterviewId) {
				throw new Error('면접 ID가 설정되지 않았습니다.');
			}

			const startButton = document.getElementById('interviewStartButton');
			const stopButton = document.getElementById('interviewStopButton');
			const videoContainer = document.querySelector('#questionSection .video-container');
			let recordingIndicator = document.getElementById('interviewRecordingIndicator-2');

			// Create recording indicator if it doesn't exist
			if (!recordingIndicator && videoContainer) {
				const newRecordingIndicator = document.createElement('div');
				newRecordingIndicator.id = 'interviewRecordingIndicator-2';
				newRecordingIndicator.className = 'recording-indicator';
				newRecordingIndicator.style.display = 'none';
				newRecordingIndicator.innerHTML =
						'<span class="recording-dot"></span>' +
						'녹화중';
				videoContainer.appendChild(newRecordingIndicator);
				recordingIndicator = newRecordingIndicator;
			}

			if (!mediaRecorder || mediaRecorder.state === 'recording') {
				throw new Error('MediaRecorder가 준비되지 않았거나 이미 녹화 중입니다.');
			}

			recordedChunks = [];

			if (startButton) startButton.disabled = true;
			if (stopButton) stopButton.disabled = false;
			if (recordingIndicator) recordingIndicator.style.display = 'flex';

			mediaRecorder.start();
			isRecording = true;
			console.log('녹화가 시작되었습니다. Interview ID:', currentInterviewId);

		} catch (error) {
			console.error('녹화 시작 오류:', error);
			alert('녹화 시작 중 오류가 발생했습니다.: ' + error.message);
		}
	}

	async function saveRecording() {
		try {
			if (!currentInterviewId) {
				console.error('Current interview ID:', currentInterviewId);
				throw new Error('면접 ID를 찾을 수 없습니다.');
			}

			if (recordedChunks.length === 0) {
				throw new Error('녹화된 데이터가 없습니다.');
			}

			const blob = new Blob(recordedChunks, { type: 'video/webm' });
			const currentQuestionNumber = parseInt(
					document.querySelector('.current-question .question-number strong')
							.textContent.split(' ')[1]
			);

			// FormData 구성
			const formData = new FormData();
			const fileName = `${currentInterviewId}_${currentQuestionNumber}.webm`;
			const videoFile = new File([blob], fileName, { type: 'video/webm' });

			formData.append('video', videoFile);
			formData.append('questionNumber', currentQuestionNumber.toString());

			console.log('Uploading video:', {
				interviewId: currentInterviewId,
				questionNumber: currentQuestionNumber,
				fileName: fileName,
				fileSize: blob.size,
				fileType: blob.type
			});

			const response = await fetch(`/aiboard/api/interview/${currentInterviewId}/video`, {
				method: 'POST',
				body: formData
			});

			if (!response.ok) {
				const errorText = await response.text();
				console.error('Server response:', errorText);
				throw new Error(`서버 응답 오류: ${response.status} - ${errorText}`);
			}

			const result = await response.json();
			console.log('Upload successful:', result);

			updateTranscriptAnswer(currentQuestionNumber, "답변이 녹화되었습니다.");

			const totalQuestions = document.querySelectorAll('.transcript-item').length;
			if (currentQuestionNumber < totalQuestions) {
				updateCurrentQuestion(currentQuestionNumber + 1);
			} else {
				await finishInterview();
			}

			recordedChunks = [];

		} catch (error) {
			console.error('저장 오류:', error);
			alert('녹화 파일 저장 중 오류가 발생했습니다: ' + error.message);
		}
	}

	function stopRecording() {
		try {
			if (!isRecording || !mediaRecorder) {
				console.error('녹화 중이 아닙니다.');
				return;
			}

			const startButton = document.getElementById('interviewStartButton');
			const stopButton = document.getElementById('interviewStopButton');
			const recordingIndicator = document.getElementById('interviewRecordingIndicator-2');

			// Update UI
			if (startButton) startButton.disabled = false;
			if (stopButton) stopButton.disabled = true;
			if (recordingIndicator) recordingIndicator.style.display = 'none';

			mediaRecorder.ondataavailable = async (event) => {
				if (event.data && event.data.size > 0) {
					recordedChunks.push(event.data);

					try {
						// ID 체크 및 로깅
						console.log('Current Interview ID before upload:', currentInterviewId);

						if (!currentInterviewId) {
							console.error('No interview ID available');
							throw new Error('면접 ID를 찾을 수 없습니다');
						}

						const blob = new Blob(recordedChunks, { type: 'video/webm' });
						const currentQuestionNumber = parseInt(
								document.querySelector('.current-question .question-number strong')
										.textContent.split(' ')[1]
						);

						// 디버깅용 로그
						console.log('Preparing video upload:', {
							interviewId: currentInterviewId,
							questionNumber: currentQuestionNumber,
							blobSize: blob.size
						});

						const formData = new FormData();
						// 파일명에 interviewId와 questionNumber 포함
						const videoFile = new File(
								[blob],
								`interview_${currentInterviewId}_q${currentQuestionNumber}.webm`,
								{ type: 'video/webm' }
						);
						formData.append('video', videoFile);
						formData.append('questionNumber', currentQuestionNumber.toString());

						// URL 구성 (앞뒤 슬래시 정규화)
						const baseUrl = `/aiboard/api/interview/${currentInterviewId}/video`;
						const url = baseUrl.replace(/\+/g, '/');
						console.log('Upload URL:', url);

						const response = await fetch(url, {
							method: 'POST',
							body: formData
						});

						console.log('Response status:', response.status);

						if (!response.ok) {
							const errorText = await response.text();
							console.error('Server error response:', errorText);
							throw new Error(`서버 응답 오류: ${response.status} - ${errorText}`);
						}

						const result = await response.json();
						console.log('Upload successful:', result);

						updateTranscriptAnswer(currentQuestionNumber, "답변이 녹화되었습니다.");

						const totalQuestions = document.querySelectorAll('.transcript-item').length;
						if (currentQuestionNumber < totalQuestions) {
							updateCurrentQuestion(currentQuestionNumber + 1);
						} else {
							await finishInterview();
						}

					} catch (error) {
						console.error('Error saving recording:', error);
						alert('녹화 파일 저장 중 오류가 발생했습니다: ' + error.message);
					}
				}
			};

			mediaRecorder.stop();
			isRecording = false;
			console.log('녹화가 중지되었습니다.');

		} catch (error) {
			console.error('녹화 중지 오류:', error);
			alert('녹화 중지 중 오류가 발생했습니다.');
		}
	}



	async function uploadRecording() {
		try {
			if (recordedChunks.length === 0) {
				throw new Error('녹화된 데이터가 없습니다.');
			}

			const blob = new Blob(recordedChunks, {type: 'video/webm'});
			const formData = new FormData();
			formData.append('video', blob);

			// Spring Security CSRF 토큰
			const token = document.querySelector("meta[name='_csrf']").content;
			const header = document.querySelector("meta[name='_csrf_header']").content;

			const response = await fetch('/aiboard/api/interview/video', {
				method: 'POST',
				headers: {
					[header]: token
				},
				body: formData
			});

			if (!response.ok) {
				throw new Error('서버 응답 오류: ' + response.status);
			}

			console.log('업로드 완료');

		} catch (error) {
			console.error('업로드 오류:', error);
			alert('녹화 파일 업로드 중 오류가 발생했습니다.');
		}
	}

</script>

</body>
</html>