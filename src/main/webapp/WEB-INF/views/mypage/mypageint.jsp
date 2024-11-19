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
    <link rel="stylesheet" href="<c:url value='/resources/static/mypage/mypagebar.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/static/mypage/mypageint.css'/>">
    <!-- CSRF 토큰 메타 태그 추가 -->
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
</head>
<body>
<jsp:include page="../navbar.jsp"/>

<div class="mypsidebar-container">
    <jsp:include page="mypagebar.jsp"/>
    <div class="mypsidebar-content">
        <div class="Content-Section">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="page-header">
                    <sec:authentication property="principal.member.name"/>님의 자기소개서 목록
                    <span class="header-badge">(총 ${fn:length(selfBoards)}건)</span>
                </h2>
                <!-- Write Button -->
                <button class="btn btn-primary write-btn" onclick="showSelfIntroModal()">
                    <i class="bi bi-pencil-square me-1"></i> 글쓰기
                </button>

                <!-- Writing Form popup -->
                <div class="modal fade" id="selfIntroModal" tabindex="-1" aria-labelledby="selfIntroModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-xl">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="selfIntroModalLabel">자기소개서 작성</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <form id="selfIntroForm" action="${pageContext.request.contextPath}/mypage/saveIntroduction" method="post" onsubmit="return validateForm()">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <div class="mb-3">
                                        <label for="selfTitle" class="form-label"><b>자기소개서 작성하기</b></label>
                                        <input type="text" class="form-control" id="selfTitle" name="title"
                                               placeholder="자기소개서 제목을 작성하세요."/>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="companySelect" class="form-label"><b>기업명</b></label>
                                            <select id="companySelect" class="form-control" name="company">
                                                <option value="">기업명 선택하기</option>
                                                <option value="Nexon">넥슨</option>
                                                <option value="Kakao">카카오</option>
                                                <option value="Line">라인 플러스</option>
                                                <option value="Carrot">당근마켓</option>
                                                <option value="Naver">네이버</option>
                                                <option value="Delivery">배달의 민족</option>
                                                <option value="NCsoft">NC 소프트</option>
                                                <option value="Netmable">넷마블</option>
                                                <option value="Coupang">쿠팡</option>
                                                <option value="Toss">토스</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="jobSelect" class="form-label"><b>지원 직무</b></label>
                                            <select id="jobSelect" class="form-control" name="position">
                                                <option value="">직무 선택하기</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div id="questions-container">
                                        <div class="question-row mb-3">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <input type="text" class="form-control" name="questions[]"
                                                       placeholder="문항1. 자기소개서 문항을 작성하세요.">
                                                <button type="button" class="btn btn-outline-primary ms-2 add-question">
                                                    <i class="fas fa-plus"></i>
                                                </button>
                                            </div>
                                            <textarea class="form-control answer-textarea" rows="7" maxlength="1000"
                                                      name="answers[]" placeholder="여기에 자기소개서를 작성하세요."></textarea>
                                            <div class="text-end mt-1">
                                                <small class="char-count">0자/1000자 (공백포함)</small>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                                <button type="submit" form="selfIntroForm" class="btn btn-primary">저장하기</button>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <div class="card">
                <div class="card-body">
                    <!-- Search and Filter Section -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="d-flex gap-3">
                            <select class="form-select" style="width: 150px;">
                                <option selected>전체보기</option>
                            </select>
                        </div>
                        <div class="d-flex gap-2">
                            <input type="text" class="form-control" placeholder="기업명을 입력하세요"
                                   style="width: 200px;">
                            <button class="btn btn-primary">검색</button>
                        </div>
                    </div>

                    <!-- Table Section -->
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th scope="col">번호</th>
                                <th scope="col">기업명</th>
                                <th scope="col">직무</th>
                                <th scope="col">제목</th>
                                <th scope="col">작성일</th>
                                <th scope="col">관리</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${selfBoards}" var="selfBoard" varStatus="i">
                                <tr>
                                    <td>${i.index + 1}</td>
                                    <td><c:out value="${selfBoard.selfCompany}"/></td>
                                    <td><c:out value="${selfBoard.selfPosition}"/></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/mypage/mypagelist/${selfBoard.selfIdx}"><c:out
                                                value="${selfBoard.selfTitle}"/></a></td>
                                    <td>${fn:substring(selfBoard.selfDate, 0, 10)} ${fn:substring(selfBoard.selfDate, 11, 16)}
                                        <fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${date}"/></td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-sm btn-outline-primary"
                                                    onclick="location.href='${pageContext.request.contextPath}/mypage/mypagelist/${selfBoard.selfIdx}'">
                                                수정
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger"
                                                    onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/mypage/remove/${selfBoard.selfIdx}'">
                                                삭제
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- Pagination -->
                    <div class="d-flex justify-content-center mt-4">
                        <nav aria-label="Page navigation">
                            <ul class="pagination">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage - 1}" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                </c:if>

                                <c:set var="totalPages" value="${(fn:length(selfBoards) + 4) / 5}"/>
                                <c:forEach var="pageNum" begin="1" end="${totalPages}">
                                    <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?page=${pageNum}">${pageNum}</a>
                                    </li>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage + 1}" aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 스크립트 섹션 -->
    <script>
        // Job roles mapping
        const jobRoles = {
            Nexon: ['게임 프로그래밍', '시스템 엔지니어', '정보 보안', '어플리케이션 엔지니어', '데이터 분석 매니저'],
            Kakao: ['백엔드 개발자(Server)', '백엔드 개발자(Java)', '데이터 엔지니어', 'ML 엔지니어', '시스템 엔지니어', 'NoSQL 엔지니어',
                'CI/CD 개발자', 'DevOps 개발자', '보안 기술지원 엔지니어'],
            Line: ['Line Messenger PM', 'Backend', 'Search/ML Engineer', 'Front-end Engineer', 'Server Engineer'],
            Carrot: ['네트워크/서버/보안', 'Machine Learning', '백엔드-중고거래', '백엔드-커뮤니티', '웹기획(Product Manager)', '웹 개발', 'UI/UX디자인', 'Front-end개발', 'DBA 데이터 관리자'],
            Naver: ['웹서비스/플랫폼 서버개발', '데이터 분석개발 및 엔지니어', '프론트엔드', '백엔드', '안드로이드 개발'],
            Delivery: ['로봇딜리버리플랫폼팀 서버 개발자', '프론트엔드 기술자', '보안 시스템 및 솔루션 운영자', '백엔드 시스템 개발자', 'QA Engineer'],
            NcSoft: ['개발 PM', '서버 프로그래머', '엔진 프로그래머', '게임 보안/안티치트 개발자', '게임 프로그래밍'],
            Netmable: ['서버 프로그래밍', '클라이언트 프로그래머', '플랫폼 백엔드', '플랫폼 프론트엔드', '인프라'],
            Coupang: ['Data Analyst', 'Frontend Platform Engineer', 'Call System Developer', 'QA Manager', 'Security Researcher', 'ML Engineer'],
            Toss: ['Data Analyst', 'Frontend Platform Engineer', 'Call System Developer', 'QA Manager', 'Security Researcher', 'ML Engineer']
        };

        // Modal instance
        let selfIntroModal = null;

        // Initialize when document is ready
        document.addEventListener('DOMContentLoaded', function() {
            selfIntroModal = new bootstrap.Modal(document.getElementById('selfIntroModal'));
            setupEventListeners();
        });

        // Show modal function
        function showSelfIntroModal() {
            selfIntroModal.show();
        }

        // Setup all event listeners
        function setupEventListeners() {
            // Company select change handler
            document.getElementById('companySelect').addEventListener('change', updateJobRoles);

            // Character counter for textareas
            document.addEventListener('input', handleTextareaInput);

            // Add question button handler
            document.addEventListener('click', handleAddQuestion);
        }

        // Update job roles based on selected company
        function updateJobRoles() {
            const companySelect = document.getElementById('companySelect');
            const jobSelect = document.getElementById('jobSelect');
            jobSelect.innerHTML = '<option value="">직무 선택하기</option>';

            const roles = jobRoles[companySelect.value] || [];
            for (let i = 0; i < roles.length; i++) {
                const option = document.createElement('option');
                option.value = roles[i];
                option.textContent = roles[i];
                jobSelect.appendChild(option);
            }
        }

        // Handle textarea input for character counting
        function handleTextareaInput(e) {
            if (e.target.matches('.answer-textarea')) {
                const count = e.target.value.length;
                const countDisplay = e.target.parentElement.querySelector('.char-count');
                if (countDisplay) {
                    countDisplay.textContent = count + '자/1000자 (공백포함)';
                }
            }
        }

        // Handle adding new question
        function handleAddQuestion(e) {
            if (e.target.matches('.add-question') || e.target.closest('.add-question')) {
                e.preventDefault();

                const questionsContainer = document.getElementById('questions-container');
                const questionBlocks = questionsContainer.querySelectorAll('.question-row');
                const newQuestionNumber = questionBlocks.length + 1;

                const newQuestionBlock = document.createElement('div');
                newQuestionBlock.className = 'question-row mb-3';
                newQuestionBlock.innerHTML =
                    '<div class="d-flex justify-content-between align-items-center mb-2">' +
                    '<input type="text" class="form-control" name="questions[]" ' +
                    'placeholder="문항' + newQuestionNumber + '. 자기소개서 문항을 작성하세요.">' +
                    '<button type="button" class="btn btn-outline-primary ms-2 add-question">' +
                    '<i class="fas fa-plus"></i>' +
                    '</button>' +
                    '</div>' +
                    '<textarea class="form-control answer-textarea" rows="7" maxlength="1000" ' +
                    'name="answers[]" placeholder="여기에 자기소개서를 작성하세요."></textarea>' +
                    '<div class="text-end mt-1">' +
                    '<small class="char-count">0자/1000자 (공백포함)</small>' +
                    '</div>';

                questionsContainer.appendChild(newQuestionBlock);
            }
        }

        // Form validation function
        function validateForm() {
            const form = document.getElementById('selfIntroForm');
            const title = form.querySelector("input[name='title']").value.trim();
            const company = form.querySelector("select[name='company']").value;
            const position = form.querySelector("select[name='position']").value;

            if (!title) {
                alert("제목을 입력해주세요.");
                form.querySelector("input[name='title']").focus();
                return false;
            }

            if (!company) {
                alert("기업명을 선택해주세요.");
                form.querySelector("select[name='company']").focus();
                return false;
            }

            if (!position) {
                alert("직무를 선택해주세요.");
                form.querySelector("select[name='position']").focus();
                return false;
            }

            const questions = form.querySelectorAll("input[name='questions[]']");
            const answers = form.querySelectorAll("textarea[name='answers[]']");

            for (let i = 0; i < questions.length; i++) {
                const question = questions[i].value.trim();
                const answer = answers[i].value.trim();

                if (!question) {
                    alert((i + 1) + "번 문항을 입력해주세요.");
                    questions[i].focus();
                    return false;
                }

                if (!answer) {
                    alert((i + 1) + "번 답변을 입력해주세요.");
                    answers[i].focus();
                    return false;
                }
            }

            return true;
        }
    </script>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS (if any) -->
    <script src="<c:url value='/resources/js/selfIntroModal.js'/>"></script>
</body>
</html>
