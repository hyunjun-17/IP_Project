<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../header.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>1stage</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/static/aiboard/ai_custominfo.css">
</head>
<body>
<jsp:include page="../navbar.jsp"/>

<div class="jumbotron">
    <h1>AI 면접 준비</h1>
    <p class="lead">나에게 맞는 면접 질문 준비부터 실전 면접 연습까지</p>
    <hr>
    <p class="lead">나의 자기소개서를 기반으로 지원 기업 맞춤 면접 준비를 도와줘요</p>
</div>

<div class="content">


    <h4 class="h-title">1. 자기소개서 선택하기</h4>
    <h5>자기소개서 불러오기 / 작성하기</h5>
    <hr style="width:100%;">

    <div class="container d-flex flex-column align-items-center mt-0" style="width:90%;">
        <div style="width:100%;">
            <div class="question-block">
                <table style="width:100%;">
                    <colgroup>
                        <col style="width: 20%;">
                        <col style="width: 40%;">
                        <col style="width: 30%;">

                    </colgroup>

                    <tr>
                        <td><b><label for="select_company">기업명</label></b>
                            <input id="select_company" class="form-control" name="company-name" readonly
                                   style="width:200px; background-color: #f5f5f5; color: #6c757d; border: 1px solid #ced4da;"/>
                        </td>
                        <td>
                            <b><label for="select_position">지원 직무 </label></b>
                            <input id="select_position" class="form-control" name="job-position" readonly
                                   style="width:200px; background-color: #f5f5f5; color: #6c757d; border: 1px solid #ced4da;"/>
                        </td>
                        <td style="text-align: right;">
                            <button id="loadModalBtn" class="btn btn-dark">자기소개서 불러오기</button>
                        </td>
                    </tr>
                    <tbody id="QnAs">
                    <tr style="border-top:1px solid gray;">
                        <td colspan="3">
                            <label for="select_question"><strong>자기소개서</strong></label><input readonly
                                                                                              id="select_question"
                                                                                              type="text"
                                                                                              class="form-control"
                                                                                              name="select-company"
                                                                                              style="background-color: #f5f5f5; color: #6c757d; border: 1px solid #ced4da;"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <textarea id="select_answer" class="form-control" name="select-answers" rows="6" readonly
                                      style="background-color: #f5f5f5; color: #6c757d; border: 1px solid #ced4da;"></textarea>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 면접질문 생성하기 버튼 컨테이너 수정 -->
        <form id="questionForm" action="${pageContext.request.contextPath}/aiboard/ai_makequestion" method="GET">
            <input type="hidden" id="selfIdxInput" name="selfIdx" value="">
            <button onclick="generateQuestions()" type="button" id="next" class="btn btn-primary">
                면접질문 생성하기
            </button>
        </form>
    </div>

    <!-- 불러오기 모달 창 -->
    <div id="loadModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h5><strong>자기소개서 불러오기</strong></h5>
            <p>면접 질문을 추출할 자기소개서를 선택하세요</p>
            <div id="noSelfBoardMessage" style="display: ${empty selfBoards ? 'block' : 'none'};">
                <div class="card">
                    <div class="card-body d-flex justify-content-center align-items-center" style="height: 100px;">
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
                            <fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${date}"/><br> <!-- 작성일 표시 -->
                            <strong><c:out value="${selfBoard.selfCompany}"/></strong>
                            <strong>${selfBoard.selfPosition}</strong> <br>
                            <span>${selfBoard.selfTitle}</span>
                        </div>
                    </li>
                </c:forEach>
            </ul>
            <button id="openModalBtn" class="btn btn-dark" type="submit" style="width:100%">자기소개서 작성하기</button>
        </div>
    </div>

    <!-- 작성하기 모달 창 -->
    <div id="myModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <form action="${pageContext.request.contextPath}/aiboard/saveIntroduction" method="post"
                  onsubmit="return validateForm()">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div id="questions-container" style="width:95%; padding-left:5%;">
                    <div class="question-block">
                        <table style="width:100%;">
                            <colgroup>
                                <col style="width: 20%;">
                                <col style="width: 70%;">
                            </colgroup>
                            <tr>
                                <td colspan="2" id="self_title"><b><label for="self_title">자기소개서 작성하기</label></b>
                                    <input type="text" class="form-control" name="title"
                                           placeholder="자기소개서 제목을 작성하세요."/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-right:30px"><b>기업명</b>
                                    <select id="companySelect" onchange="updateJobRoles()" class="form-control"
                                            name="company" style="width:200px;">
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
                                </td>
                                <td>
                                    <b>지원 직무</b>
                                    <select id="jobSelect" class="form-control" name="position" style="width:200px;">
                                        <option value="">직무 선택하기</option>
                                    </select>
                                </td>
                            </tr>
                            <tr style="border-top:1px solid gray;">
                                <td colspan="2" style="text-align: right;">
                                    <button id="add-question-button" style="background-color:white">+</button>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" id="first-question-row">
                                    <input type="text" id="question-1" class="form-control" name="questions"
                                           placeholder="문항1. 자기소개서 문항을 작성하세요."/>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <textarea id="coverLetter" class="form-control" rows="7" maxlength="1000"
                                              name="answers" placeholder="여기에 자기소개서를 작성하세요."></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="text-align:right">
                                    <div id="charCount">0자/1000자 (공백포함)</div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <button class="btn btn-dark" type="submit" style="width:100%">저장하기</button>
            </form>
        </div>
    </div>
</div>


</div>


<script>
    const jobRoles = {
        Nexon: ['게임 프로그래밍', '시스템 엔지니어', '정보 보안', '시스템 엔지니어', '어플리케이션 엔지니어', '데이터 분석 매니저'],
        Kakao: ['백엔드 개발자(Server)', '백엔드 개발자(Java)', '데이터 엔지니어', 'ML 엔지니어', '시스템 엔지니어', 'NoSQL 엔지니어',
            'CI/CD 개발자', 'DevOps 개발자', '보안 기술지원 엔지니어'],
        Line: ['Line Messenger PM', 'Backend', 'Search/ML Engineer', 'Front-end Engineer', 'Server Engineer'],
        Carrot: ['네트워크/서버/보안', 'Machine LEarning', '백엔드-중고거래', '백엔드-커뮤니티', '웹기획(Product Manager)', '웹 개발', 'UI/UX디자인', 'Front-end개발', 'DBA 데이터 관리자'],
        Naver: ['웹서비스/플랫폼 서버개발', '데이터 분석개발 및 엔지니어', '프론트엔드', '백엔드', '안드로이드 개발'],
        Delivery: ['로봇딜리버리플랫폼팀 서버 개발자', '프론트엔드 기술자', '보안 시스템 및 솔루션 운영자', '백엔드 시스템 개발자', 'QA Engineer'],
        NcSoft: ['개발 PM', '서버 프로그래머', '엔진 프로그래머', '게임 보안/안티치트 개발자', '게임 프로그래밍'],
        Netmable: ['서버 프로그래밍', '클라이언트 프로그래머', '플랫폼 백엔드', '플랫폼 프론트엔드', '인프라'],
        Coupang: ['Data Analyst', 'Frontend Platform Engineer', 'Call System Developer', 'QA Manager', 'Security Researcher', 'ML Engineer'],
        Toss: ['Data Analyst', 'Frontend Platform Engineer', 'Call System Developer', 'QA Manager', 'Security Researcher', 'ML Engineer']
    };
    0

    function updateJobRoles() {
        const companySelect = document.getElementById('companySelect');
        const jobSelect = document.getElementById('jobSelect');
        const selectedCompany = companySelect.value;

        // 직무 선택 박스 초기화
        jobSelect.innerHTML = '<option value="">직무 선택하기</option>';

        // 선택된 기업에 해당하는 직무 추가
        if (selectedCompany in jobRoles) {
            jobRoles[selectedCompany].forEach(role => {
                const option = document.createElement('option');
                option.value = role;
                option.textContent = role;
                jobSelect.appendChild(option);
            });
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        const storedSelfIdx = localStorage.getItem('currentSelfIdx');
        console.log("Stored selfIdx on page load:", storedSelfIdx);
        // 모달 창 요소 가져오기
        var loadModal = document.getElementById("loadModal");
        var modal = document.getElementById("myModal");

        // 모달 열기 버튼 요소 가져오기
        var loadModalBtn = document.getElementById("loadModalBtn")
        var openModalBtn = document.getElementById("openModalBtn");

        // 각 모달의 닫기 버튼 요소 가져오기
        var loadCloseBtn = loadModal.querySelector(".close");
        var myCloseBtn = modal.querySelector(".close");

        // 페이지 로드 시 loadModal 표시
        window.onload = function () {
            if (loadModal.style.display !== "block") {
                loadModal.style.display = "block";
            }
        };

        // "자기소개서 불러오기" 버튼을 클릭하면 모달을 보여줍니다
        loadModalBtn.onclick = function () {
            loadModal.style.display = "block";
        };

        // "자기소개서 작성하기" 버튼을 클릭하면 모달을 보여줍니다
        openModalBtn.onclick = function () {
            modal.style.display = "block";
        }

        // 각 모달의 닫기 버튼 클릭 시 해당 모달을 닫음
        loadCloseBtn.onclick = function () {
            loadModal.style.display = "none";
        };
        myCloseBtn.onclick = function () {
            modal.style.display = "none";
        }

        // 모달 바깥을 클릭하면 해당 모달을 닫음
        window.onclick = function (event) {
            if (event.target == loadModal) {
                loadModal.style.display = "none";
            } else if (event.target == modal) {
                modal.style.display = "none";
            }
        };

        const container = document.getElementById('questions-container');
        const addButton = document.getElementById('add-question-button');
        let questionCounter = 1;

        // 원래 있는 coverLetter 텍스트 영역과 글자 수 카운터 가져오기
        const originalCoverLetter = document.getElementById("coverLetter");
        const originalCharCount = document.getElementById("charCount");

        // 원래 있는 coverLetter에 글자 수 세기 기능 추가
        originalCoverLetter.addEventListener('input', function () {
            const currentLength = this.value.length;
            const maxLength = this.getAttribute('maxlength') || 1000;
            originalCharCount.textContent = currentLength + '자/' + maxLength + '자 (공백포함)';
        });

        addButton.addEventListener('click', function (event) {
            event.preventDefault(); // 기본 제출 동작을 막음
            questionCounter++;

            // 새로운 div 생성
            const newQuestionBlock = document.createElement('div');
            newQuestionBlock.className = 'question-block';

            // 새로운 테이블 생성
            const newTable = document.createElement('table');
            newTable.style.width = '100%';

            // 테이블 내용 생성
            newTable.innerHTML =
                '<tr style="border-top:1px solid gray;">' +
                '<td style="width: 30%;"></td>' +
                '<td colspan="2" style="text-align: right;">' +
                '<button class="remove-button mr-3" style="background-color: white; margin-right: 5px;width: 25px;">-</button>' +
                '<button class="add-question-button" style="background-color: white; margin-right: 5px;width: 25px;">+</button>' +
                '</td>' +
                '</tr>' +
                '<tr>' +
                '<td colspan="2">' +
                '<input type="text" class="form-control" name="questions" ' +
                'placeholder="문항' + questionCounter + '. 자기소개서 문항을 작성하세요." />' +
                '</td>' +
                '</tr>' +
                '<tr>' +
                '<td colspan="2">' +
                '<textarea class="form-control coverLetter" rows="7" maxlength="1000" ' +
                'placeholder="여기에 자기소개서를 작성하세요." name="answers"></textarea>' +
                '</td>' +
                '</tr>' +
                '<tr>' +
                '<td colspan="2" style="text-align:right">' +
                '<div class="charCount">0자/1000자 (공백포함)</div>' +
                '</td>' +
                '</tr>';

            newQuestionBlock.appendChild(newTable);
            container.appendChild(newQuestionBlock);

            // 입력된 문자 수 세기
            const coverLetter = document.getElementById("coverLetter");
            const charCount = document.getElementById("charCount");

            const currentLength = this.value ? this.value.length : 0;

            coverLetter.addEventListener('input', function () {
                charCount.textContent = currentLength + '자/1000자 (공백 포함)';
            });

            // 새로 추가된 textarea에 대한 글자 수 카운터 이벤트 리스너
            const newTextarea = newQuestionBlock.querySelector('.coverLetter');
            const newCharCount = newQuestionBlock.querySelector('.charCount');

            newTextarea.addEventListener('input', function () {
                const currentLength = this.value ? this.value.length : 0;
                const maxLength = this.getAttribute('maxlength') || 1000;
                newCharCount.textContent = currentLength + '자/' + maxLength + '자 (공백포함)';
            });

            // 삭제 버튼 이벤트 리스너
            const removeButton = newQuestionBlock.querySelector('.remove-button');
            removeButton.addEventListener('click', function () {
                newQuestionBlock.remove();
            });

            // 새로운 추가 버튼 이벤트 리스너
            const newAddButton = newQuestionBlock.querySelector('.add-question-button');
            newAddButton.addEventListener('click', function (event) {
                event.preventDefault();
                addButton.click(); // 기존 추가 버튼의 클릭 이벤트를 재사용
            });
        });
    });

    // 폼 유효성 검사 함수
    function validateForm() {
        const title = document.querySelector("input[name='title']").value;
        const company = document.getElementById("companySelect").value;
        const position = document.getElementById("jobSelect").value;
        const question = document.querySelector("input[name='questions']").value;
        const answer = document.querySelector("textarea[name='answers']").value;

        if (!title || !company || !position || !question || !answer) {
            alert("모든 필드를 채워주세요.");
            return false;
        }
        return true;
    }

    document.getElementById('closeModal').onclick = function () {
        // 모달을 숨기도록 설정
        document.getElementById('modal').style.display = 'none';
    };

    function loadSelfIntroduction(selfIdx) {
        // 현재 선택된 self_idx를 localStorage에 저장할 때 문자열로 변환
        localStorage.setItem('currentSelfIdx', selfIdx.toString());

        $.ajax({
            url: 'http://localhost:8081/aiboard/loadSelfIntroduction/' + selfIdx,
            method: 'GET',
            dataType: 'json',
            success: function (data) {
                // 기존 코드는 그대로 유지
                document.getElementById("select_company").value = data.company;
                document.getElementById("select_position").value = data.position;

                const questionsAndAnswers = document.getElementById('QnAs');
                questionsAndAnswers.innerHTML = '';

                const questionsLength = data.questions.length;
                const answersLength = data.answers.length;

                for (let i = 0; i < Math.min(questionsLength, answersLength); i++) {
                    const question = data.questions[i];
                    const answer = data.answers[i];

                    // 질문 행 추가
                    const questionRow = document.createElement('tr');
                    questionRow.style.borderTop = '1px solid gray';
                    questionRow.innerHTML = '<td colspan="3">' +
                        '<label for="select_question_' + i + '"><strong>자기소개서 문항 ' + (i + 1) + '</strong></label>' +
                        '<input readonly id="select_question_' + i + '" type="text" class="form-control" name="select-question-' + i + '" value="' + question + '" style="background-color: #f5f5f5; color: #6c757d; border: 1px solid #ced4da;" />' +
                        '</td>';
                    questionsAndAnswers.appendChild(questionRow);

                    // 답변 행 추가
                    const answerRow = document.createElement('tr');
                    answerRow.innerHTML = '<td colspan="3">' +
                        '<textarea id="select_answer_' + i + '" class="form-control" name="select-answer-' + i + '" rows="5" readonly style="background-color: #f5f5f5; color: #6c757d; border: 1px solid #ced4da;">' + answer + '</textarea>' +
                        '</td>';
                    questionsAndAnswers.appendChild(answerRow);
                }

                // 모달 닫기
                loadModal.style.display = "none";

                // 디버깅용 출력
                console.log("Stored selfIdx:", localStorage.getItem('currentSelfIdx'));
            },
            error: function (xhr, status, error) {
                console.error('Error fetching self-introduction:', error);
            }
        });
    }


    function generateQuestions() {
    const selectedSelfIdx = localStorage.getItem('currentSelfIdx');
    if (!selectedSelfIdx) {
        alert('자기소개서를 먼저 선택해주세요.');
        return;
    }

    // 로딩 표시 추가
    const loadingDiv = document.createElement('div');
    loadingDiv.id = 'loadingIndicator';
    loadingDiv.className = 'text-center mt-3';
    loadingDiv.innerHTML = `
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
        <p>질문을 생성하는 중입니다...</p>
    `;
    document.querySelector('#questionForm').appendChild(loadingDiv);

    // form의 hidden input에 selfIdx 설정
    document.getElementById('selfIdxInput').value = selectedSelfIdx;

    try {
        // form 제출
        document.getElementById('questionForm').submit();
    } catch (error) {
        console.error('Error:', error);
        alert('질문 생성 중 오류가 발생했습니다.');
    } finally {
        // 2초 후 로딩 표시 제거
        setTimeout(() => {
            const loadingIndicator = document.getElementById('loadingIndicator');
            if (loadingIndicator) {
                loadingIndicator.remove();
            }
        }, 20000);
    }
}
</script>

<jsp:include page="../footer.jsp"/>

</body>
</html>