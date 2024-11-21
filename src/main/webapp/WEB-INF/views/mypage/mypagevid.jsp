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
    <meta name="selfIdx" content="${selfIdx}">
    <link rel="stylesheet" href="<c:url value='/resources/static/mypage/mypagevid.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<jsp:include page="../navbar.jsp"/>

<div class="main-content">
    <div class="row">
        <div class="col-2">
            <jsp:include page="mypagebar.jsp"/>
        </div>
        <div class="col-10">
            <div class="mypcontent">
                <h2 class="page-header">면접 영상 내역</h2>
                <div class="row">
                    <div class="col-6">
                        <div class="video-container">
                            <!-- Video player -->
                            <div class="video-box" style="display: none;">
                                <video id="interviewVideo" controls>
                                    <source src="" type="video/webm">
                                </video>
                                <button class="back-to-questions" aria-label="Back to Questions">
                                    <i class="fas fa-arrow-left"></i> 질문 목록으로
                                </button>
                            </div>

                            <!-- Questions section -->
                            <div class="video-questions">
                                <h4 class="section-title">면접 질문</h4>
                                <c:forEach items="${ipros}" var="ipro" varStatus="status">
                                    <div class="question-item">
                                        <button type="button"
                                                class="question-button"
                                                data-ipro-idx="${ipro.iproIdx}"
                                                data-question-number="${status.index + 1}">
                                            <span class="question-number">Q${status.index + 1}.</span>
                                            <c:out value="${ipro.iproQuestion}"/>
                                        </button>
                                    </div>
                                </c:forEach>
                            </div>
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
        // DOM Elements
        const answerBoxes = document.querySelectorAll('.answer-box');
        const questionButtons = document.querySelectorAll('.video-questions .question-button');
        const videoBox = document.querySelector('.video-box');
        const videoQuestions = document.querySelector('.video-questions');
        const video = document.getElementById('interviewVideo');
        const backButton = document.querySelector('.back-to-questions');

        // Constants
        const s3BaseUrl = "https://iproproject.s3.ap-southeast-2.amazonaws.com/interviews/";
        const selfIdx = document.querySelector('meta[name="selfIdx"]').content; // Add this meta tag in JSP

        /**
         * Load and display video for the selected question
         * @param {HTMLElement} button - The clicked question button
         */
        function loadVideo(button) {
            const iproIdx = button.getAttribute('data-ipro-idx');

            if (!iproIdx) {
                console.error('No iproIdx found for button', button);
                return;
            }

            try {
                const videoUrl = s3BaseUrl + selfIdx + '_' + iproIdx + '.webm';
                console.log('Attempting to load video:', videoUrl);

                // Remove previous error handler
                video.removeEventListener('error', handleVideoError);

                // Error handling function
                function handleVideoError(e) {
                    console.error('Video load failed:', {
                        error: video.error,
                        errorCode: video.error ? video.error.code : null,
                        errorMessage: video.error ? video.error.message : null
                    });
                    showQuestions();
                }

                // Add new error handler
                video.addEventListener('error', handleVideoError);

                // Reset and load video
                video.pause();
                video.currentTime = 0;
                video.src = videoUrl;
                video.load();

                // Handle successful video load
                video.addEventListener('loadeddata', function onLoadedData() {
                    showVideo();
                    video.removeEventListener('loadeddata', onLoadedData);
                });

            } catch (error) {
                console.error('Error in loadVideo:', error);
                showQuestions();
            }
        }

        /**
         * Show video and hide questions
         */
        function showVideo() {
            videoQuestions.style.display = 'none';
            videoBox.style.display = 'block';
            video.play();
        }

        /**
         * Show questions and hide video
         */
        function showQuestions() {
            videoBox.style.display = 'none';
            videoQuestions.style.display = 'block';
        }

        /**
         * Update answer display for selected question
         * @param {string} questionNumber - The selected question number
         */
        function updateAnswerDisplay(questionNumber) {
            answerBoxes.forEach(box => {
                box.style.display = 'none';
                if (box.getAttribute('data-question') === questionNumber) {
                    box.style.display = 'block';
                }
            });
        }

        /**
         * Update active question button state
         * @param {HTMLElement} activeButton - The clicked button
         */
        function updateActiveQuestion(activeButton) {
            questionButtons.forEach(btn => btn.classList.remove('active'));
            activeButton.classList.add('active');
        }

        // Event Listeners
        questionButtons.forEach((button) => {
            button.addEventListener('click', function () {
                const questionNumber = this.getAttribute('data-question-number');

                loadVideo(this);
                updateAnswerDisplay(questionNumber);
                updateActiveQuestion(this);
            });
        });

        backButton.addEventListener('click', function() {
            video.pause();
            showQuestions();
        });

        // Initialize
        showQuestions();
    });

    // Edit answer functionality (to be implemented)
    function editAnswer() {
        // Implementation for edit functionality
    }
</script>
</body>
</html>