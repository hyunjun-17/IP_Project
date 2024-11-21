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


<%-- 비디오 섹션 --%>
<div class="video-section">
    <h4 class="section-title">면접 영상</h4>
    <button class="video-close" aria-label="Close Video Section">
        <i class="fas fa-times"></i>
    </button>
    <div class="video-preview">
        <div class="video-box">
            <video id="interviewVideo" controls>
                <source src="" type="video/webm">
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
                    <%-- 질문 목록 부분 수정 --%>
                    <div class="col-6">
                        <div class="video-questions">
                            <h4 class="section-title">면접 질문</h4>
                            <c:forEach items="${ipros}" var="ipro" varStatus="status">
                                <div class="question-item">
                                    <button type="button"
                                            class="question-button"
                                            data-ipro-idx="${ipro.iproIdx}"
                                            data-question-number="${status.index + 1}"
                                            onclick="console.log('button ipro: ${ipro.iproIdx}')">
                                        <span class="question-number">Q${status.index + 1}.</span>
                                        <c:out value="${ipro.iproQuestion}"/>
                                    </button>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Answer Section -->
                <div class="answer-box-info">
                    <h4 class="section-title">사용자 답변</h4>
                    <c:forEach items="${ipros}" var="ipro" varStatus="status">
                        <div class="answer-box" data-question="${status.index + 1}">
                            <p><c:out value="${ipro.iproAnswer}" default="작성된 답변이 없습니다."/></p>
                        </div>
                    </c:forEach>
                    <div class="d-flex justify-content-end">
                        <button class="btn btn-primary" onclick="editAnswer()">수정하기</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        // DOM 요소
        const answerBoxes = document.querySelectorAll('.answer-box');
        const questionButtons = document.querySelectorAll('.video-questions .question-button');
        const videoToggle = document.querySelector('.video-toggle');
        const videoSection = document.querySelector('.video-section');
        const mainContent = document.querySelector('.main-content');
        const videoClose = document.querySelector('.video-close');
        const video = document.getElementById('interviewVideo');

        // 상수
        const s3BaseUrl = "https://iproproject.s3.ap-southeast-2.amazonaws.com/interviews/";
        const selfIdx = ${selfIdx};

        // 디버깅: 모든 버튼의 ipro_idx 확인
        questionButtons.forEach((btn, index) => {
            const iproIdx = btn.getAttribute('data-ipro-idx');
            const questionNumber = btn.getAttribute('data-question-number');
            console.log('Button data:', {
                index: index,
                iproIdx: iproIdx,
                questionNumber: questionNumber,
                buttonText: btn.textContent.trim()
            });
        });

        // 비디오 로드 함수
        // 비디오 로드 함수
        function loadVideo(button) {
            const iproIdx = button.getAttribute('data-ipro-idx');
            console.log('Load video triggered for:', {
                iproIdx: iproIdx,
                buttonHTML: button.outerHTML,
                selfIdx: selfIdx
            });

            if (!iproIdx) {
                console.error('No iproIdx found for button', button);
                return;
            }

            try {
                // URL 구성 수정 - 템플릿 리터럴에서 변수 참조 방식 변경
                const videoUrl = s3BaseUrl + selfIdx + '_' + iproIdx + '.webm';
                // 또는
                // const videoUrl = `${s3BaseUrl}${selfIdx}_${iproIdx}.webm`;

                console.log('Attempting to load video:', videoUrl);

                // 비디오 소스 초기화 및 설정
                video.pause();
                video.currentTime = 0;
                video.src = videoUrl;
                video.load();

                // UI 업데이트
                videoSection.classList.add('active');
                mainContent.classList.add('video-active');
                videoToggle.style.display = 'none';

                // URL 확인용 로그
                console.log('Final video URL:', video.src);
            } catch (error) {
                console.error('Error loading video:', error);
            }
        }

        // 질문 버튼 클릭 핸들러
        questionButtons.forEach((button) => {
            button.addEventListener('click', function () {
                const iproIdx = this.getAttribute('data-ipro-idx');
                console.log('Button clicked - iproIdx:', iproIdx);
                const questionNumber = this.getAttribute('data-question-number');

                console.log('Button clicked:', {
                    iproIdx: iproIdx,
                    questionNumber: questionNumber,
                    buttonText: this.textContent.trim(),
                    buttonData: this.dataset
                });

                // 버튼 상태 업데이트
                questionButtons.forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');

                // 답변 업데이트
                const answerBox = document.querySelector(`.answer-box[data-question="${questionNumber}"]`);
                if (answerBox) {
                    answerBoxes.forEach(box => box.classList.remove('active'));
                    answerBox.classList.add('active');
                }

                // 비디오 로드
                loadVideo(this);
            });
        });

        // 비디오 이벤트 핸들러들
        video.addEventListener('error', function (e) {
            const activeButton = document.querySelector('.question-button.active');
            console.error('Video error details:', {
                error: video.error,
                errorCode: video.error ? video.error.code : null,
                errorMessage: video.error ? video.error.message : null,
                currentSrc: video.currentSrc,
                activeButtonIproIdx: activeButton?.getAttribute('data-ipro-idx'),
                networkState: video.networkState,
                readyState: video.readyState
            });
        });

        video.addEventListener('loadeddata', function () {
            console.log('Video loaded successfully:', {
                src: video.currentSrc,
                duration: video.duration,
                readyState: video.readyState
            });
        });

        // 비디오 섹션 컨트롤러
        videoToggle.addEventListener('click', function () {
            videoSection.classList.add('active');
            mainContent.classList.add('video-active');
            this.style.display = 'none';
        });

        videoClose.addEventListener('click', function () {
            videoSection.classList.remove('active');
            mainContent.classList.remove('video-active');
            videoToggle.style.display = 'flex';
            video.pause();
        });

        // 초기 상태 설정
        if (questionButtons.length > 0) {
            console.log('Setting up initial state');
            const firstButton = questionButtons[0];
            const firstIproIdx = firstButton.getAttribute('data-ipro-idx');

            if (firstIproIdx) {
                console.log('First button data:', {
                    iproIdx: firstIproIdx,
                    questionNumber: firstButton.getAttribute('data-question-number')
                });
            }
        }
    });


    function editAnswer() {

    }

    function saveAnswer() {

    }
</script>
</body>
</html>