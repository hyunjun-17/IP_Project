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

    <link rel="stylesheet" href="<c:url value='/resources/static/mypage/mypagelist.css'/>">
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
</head>
<body>
<jsp:include page="../navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar - col-2 -->
        <div class="col-md-2">
            <jsp:include page="mypagebar.jsp"/>
        </div>

        <!-- Main Content - col-10 -->
        <div class="col-md-10">
            <div class="Content-Section">
                <!-- Header -->
                <div class="page-header-container">
                    <h2 class="page-header">
                        자기소개서 상세보기
                        <span class="page-count">(1/3)</span>
                    </h2>
                    <a href="#" class="video-btn">
                        <i data-lucide="video" class="icon"></i>
                        화상면접 보기
                    </a>
                </div>

                <div class="card">
                    <div class="card-body">
                        <div class="title-section">
                            <p><input readonly id="title" type="text" value="${selfIntroduction.title}"/></p>
                        </div>
                        <!-- Info Section -->
                        <div class="info-section">
                            <div class="info-item">
                                <span class="info-label">직무</span>
                                <input readonly class="info-value" value="${selfIntroduction.position}"/>
                            </div>
                            <div class="info-divider"></div>
                            <div class="info-item">
                                <span class="info-label">기업</span>
                                    <input readonly class="info-value" value="${selfIntroduction.company}"/>
                            </div>
                        </div>

                        <c:forEach var="i" begin="0" end="${fn:length(selfIntroduction.questions)-1}">
                        <!-- Content -->
                        <div class="content-box" >
                                <span class="info-label">문항${i+1}</span>
                                <input class="question-input" value="${selfIntroduction.questions[i]}"readonly/>
                                
                            <textarea class="answer-input" readonly cols="150" rows="3">${selfIntroduction.answers[i]}</textarea>
                        </div>
                            
                        </c:forEach>
                        <!-- Meta Information -->
                        <div class="meta-info">
                            <span class="date">${fn:substring(selfIntroduction.date, 0, 10)} ${fn:substring(selfIntroduction.date, 11, 16)}
                                <fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${date}"/></span>
                        </div>
                    </div>
                </div>

                <!-- Navigation Buttons -->
                <div class="navigation-buttons">
                    <button class="nav-btn prev-btn" onclick="location.href='${pageContext.request.contextPath}/mypage/mypageint'">
                        <i data-lucide="chevron-left" class="icon"></i>
                        이전
                    </button>
                    <div class="action-buttons">
                        <button class="action-btn edit-btn" onclick="editIntroduction()">
                            <i data-lucide="edit-2" class="icon"></i>
                            수정하기
                        </button>
                        <button class="btn btn-outline-danger delete-btn action-btn" style="border: 1px solid #da3544;" onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/mypage/remove/${selfIntroduction.idx}'">
                            <i data-lucide="trash-2" class="icon"></i>
                            삭제하기
                        </button>
                        <button class="action-btn save-btn" style="display:none;" onclick="updateIntroduction(${selfIntroduction.idx})">
                            <i data-lucide="save" class="icon"></i>
                            저장하기
                        </button>
                    </div>
                    <button class="nav-btn next-btn">
                        다음
                        <i data-lucide="chevron-right" class="icon"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Initialize Lucide icons
    lucide.createIcons();

    function editIntroduction() {
            var titleInput = document.getElementById('title');
            titleInput.removeAttribute('readonly');
            titleInput.classList.add('form-control');

            // 기존 CSS 스타일을 덮어쓰는 인라인 스타일 추가
            titleInput.style.fontSize = '1.3rem';
            titleInput.style.fontWeight = 'inherit';  // 기존 font-size 제거
            titleInput.style.color = 'inherit'; // 기존 color 제거
            titleInput.style.border = '1px solid #ced4da'; // border 스타일 추가 (form-control 스타일)
            titleInput.style.padding = '10px';

            // 모든 info-value 입력 필드 수정 가능하도록 설정
            var infoInputs = document.querySelectorAll('.info-value');
            infoInputs.forEach(function(input) {
                input.removeAttribute('readonly');
                input.classList.add('form-control'); // "form-control" 클래스 추가
                input.style.border = '1px solid #ced4da'; // border 스타일 추가
                input.style.fontWeight = 'inherit'; // border 스타일 추가
                input.style.backgroundColor = 'white';
            });

            // 모든 question-input 및 answer-input 입력 필드 수정 가능하도록 설정
            var questionInputs = document.querySelectorAll('.question-input');
            questionInputs.forEach(function(input) {
                input.removeAttribute('readonly');
                input.classList.add('form-control'); // "form-control" 클래스 추가
                input.style.border = '1px solid #ced4da'; // border 스타일 추가
                input.style.backgroundColor = 'white';
            });

            var answerInputs = document.querySelectorAll('.answer-input');
            answerInputs.forEach(function(input) {
                input.removeAttribute('readonly');
                input.classList.add('form-control'); // "form-control" 클래스 추가
                input.style.border = '1px solid #ced4da'; // border 스타일 추가
                input.style.padding = '10px'; // 패딩 추가
                input.style.backgroundColor = 'white';

                // 레이블 숨기기
                var label = input.parentNode.querySelector('.info-label'); // 수정된 부분
                if (label) {
                    label.style.display = 'none'; // 레이블을 보이지 않게 설정
                }
            });


            // 첫 번째 form-control 요소에 포커스 이동
            if (questionInputs.length > 0) {
                questionInputs[0].focus(); // 첫 번째 질문 입력 필드에 포커스
            }

            // 수정하기 버튼 숨기기
            $('.edit-btn').hide();
            // 삭제하기 버튼 숨기기
            $('.delete-btn').hide();
            // 저장하기 버튼 보이기
            $('.save-btn').show();
        }


    function updateIntroduction() {
        // CSRF 토큰 가져오기
        const token = $("meta[name='_csrf']").attr("content");
        const header = $("meta[name='_csrf_header']").attr("content");

        // 기존 데이터 수집 코드
        const questions = [];
        const answers = [];
        $('.question-input').each(function() {
            questions.push($(this).val());
        });
        $('.answer-input').each(function() {
            answers.push($(this).val());
        });

        const title = $('#title').val();
        const company = $('.info-item').eq(1).find('.info-value').val();
        const position = $('.info-item').eq(0).find('.info-value').val();

        const selfIntroductionDTO = {
            idx: ${selfIntroduction.idx},
            title: title,
            company: company,
            position: position,
            questions: questions,
            answers: answers
        };

        // AJAX 요청에 CSRF 토큰 추가
        $.ajax({
            url: '${pageContext.request.contextPath}/mypage/updateIntroduction',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(selfIntroductionDTO),
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token);  // CSRF 토큰 설정
            },
            success: function(response) {
                alert('수정 완료!');
                location.reload();
            },
            error: function(xhr, status, error) {
                alert('수정 실패: ' + error);
            }
        });
    }
</script>
</body>
</html>