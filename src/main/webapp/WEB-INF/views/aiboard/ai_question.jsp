<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../header.jsp" %>
<html>
<head>
    <title>2 stage</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/static/aiboard/ai_question.css">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
</head>
<body>
<jsp:include page="../navbar.jsp"/>
<div class="jumbotron">
    <h1>AI 면접 준비</h1>
    <p class="lead">나에게 맞는 면접 질문부터 실전 연습까지</p>
    <hr>
    <p class="lead">나의 자기소개서를 기반으로 지원 기업 맞춤 면접 준비를 도와줘요</p>
</div>
<div class="content">
    <h4 class="h-title"> 2. 질문 답변하기 </h4>

    <p><h5>기업질문 > 직무질문 > 경험질문</h5></p>
    <hr style="width:100%; margin:0">

    <section class="container2">
        <div class="sidenav sn text-left">
            <div class="well">
                <table style="width:150px;">
                    <colgroup>
                        <col style="width:50%">
                        <col style="width:50%">
                    </colgroup>
                    <tr>
                        <th colspan="2"> 기업/직무</th>
                    </tr>
                    <tr>
                        <td><a href="#" onclick="showQuestion(0)">질문1</a></td>
                        <td><span id="state1">미작성</span></td>
                    </tr>
                    <tr>
                        <td><a href="#" onclick="showQuestion(1)">질문2</a></td>
                        <td><span id="state2">미작성</span></td>
                    </tr>
                    <tr>
                        <td><a href="#" onclick="showQuestion(2)">질문3</a></td>
                        <td><span id="state3">미작성</span></td>
                    </tr>
                </table>
                <hr>
                <table style="width:150px;">
                    <colgroup>
                        <col style="width:50%">
                        <col style="width:50%">
                    </colgroup>
                    <tr>
                        <th colspan="2">자기소개서</th>
                    </tr>
                    <tr>
                        <td><a href="#" onclick="showQuestion(3)">질문4</a></td>
                        <td><span id="state4">미작성</span></td>
                    </tr>
                    <tr>
                        <td><a href="#" onclick="showQuestion(4)">질문5</a></td>
                        <td><span id="state5">미작성</span></td>
                    </tr>
                    <tr>
                    <td><a href="#" onclick="showQuestion(5)">질문6</a></td>
                    <td><span id="state6">미작성</span></td>
                </tr>
                </table>
            </div>
        </div>


        <div class="box">
            <div class="well text-left" style="font-size: 20px;">
                <span  id="question-content" style="font-size:20px; font-weight:bold">${questions[0].IPRO_QUESTION} </span>
            </div>

            <div class="answer-box well text-left">
                <form>
                    <table style="width:100%">
                        <tr class="form-group" >
                            <td colspan="2"><textarea class="form-control" rows="9" id="answer" placeholder="답변을 입력하세요"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td id="charCount">0자/1000자(공백포함)</td>
                        <td style="text-align:right;">
                            <div class="buttons">
                            <button type="button" id="save-answer" class="btn btn-dark">답변 저장하기</button>
                            <button type="button" id="feedback-btn" class="btn btn-dark">AI 피드백 받기</button>
                            </div>
                        </td>
                        </tr> <!-- 글자 수를 표시할 영역 -->
                    </table>
                </form>
            </div>

        </div>


        <div class="box2">
            <div class="well text-left" style="font-size: 20px;">
                <p style="font-size:21px; font-weight:bold">AI 피드백</p>
            </div>

            <div class="answer-box well text-left">
                <div class="feedback-header">답변 피드백</div>
                <div class="panel" style="max-height: 500px; background-color: white; border: 1px solid #dedede;">
                    <p>이곳에 표시될 내용입니다. 클릭 시 이 내용이 보이거나 숨겨집니다.</p>
                </div>
<%--                <button class="accordion" style="background-color: #242222; color: white;">피드백 적용 답변</button>--%>
<%--                <div class="panel" style="max-height: 500px; background-color: white; border: 1px solid #dedede;">--%>
<%--                    <p>다른 내용을 여기에 표시할 수 있습니다. 여러 개의 아코디언을 만들 수 있습니다.</p>--%>
<%--                    <div class="buttons">--%>
<%--                        <button class="btn btn-warning" style="margin:10px;">AI 피드백 적용</button>--%>
<%--                    </div>--%>
<%--                </div>--%>
            </div>
        </div>


        <script>
            // AI 피드백 받기 버튼을 클릭했을 때 box2를 부드럽게 나타내기
            document.getElementById('feedback-btn').addEventListener('click', function () {
                var feedbackBox = document.querySelector('.box2');
                var container = document.querySelector('.container2'); // container를 여기서 정의

                // 항상 보이게만 하고 숨기지는 않음
                if (!feedbackBox.classList.contains('show')) {
                    feedbackBox.classList.add('show');
                    container.classList.add('centered');
                }
            });

            function updateQuestionState(index, state) {
                questionStates[index] = state; // 0: 미작성, 1: 작성 중, 2: 작성 완료
                const stateElement = document.getElementById("state" + (index + 1));
                if (stateElement) {
                    stateElement.textContent = state === 2 ? "작성 완료" : "미작성";
                }
            }

            // textarea와 글자 수 표시하는 div 요소
            const answer = document.getElementById("answer");
            const charCount = document.getElementById("charCount");

            // 답변 저장 버튼의 활성화 여부 관리
            const saveButton = document.getElementById("save-answer");

            // textarea의 입력 이벤트를 감지하여 글자 수 계산
            answer.addEventListener("input", function () {
                const currentLength = answer.value ? answer.value.length : 0; // 현재 입력된 글자 수 (null 체크)
                const maxLength = answer.getAttribute("maxlength") || 1000; // 최대 글자 수 가져오기 (기본값 1000)
                charCount.textContent = currentLength + '자/' + maxLength + '자';

                // 글자 수가 있을 때만 저장 버튼 활성화
                saveButton.disabled = currentLength === 0;

                // 작성 중 상태로 업데이트
                if (currentLength > 0) {
                    updateQuestionState(currentIndex, 1);
                }
            });

            // 답변 저장 시 상태를 '작성 완료'로 업데이트
            saveButton.addEventListener("click", function () {
                updateQuestionState(currentIndex, 2);
            });
        </script>

    </section>

    <div class="d-flex flex-column align-items-end" style="width:100%;">
        <div class="bottom-buttons">
            <button onclick="previousQuestion()" type="submit" id="previous" class="btn btn-primary"> 이전 질문</button>
            <button onclick="nextQuestion()" id="next"
                    class="btn btn-primary"> 다음 질문
            </button>
        </div>
        <br>
        <div class="progress w-100 mb-5">
            <div class="progress-bar bar" style="width:16.6%; margin-right:5px;">
                Question 1
            </div>
            <div class="progress-bar bar" style="width:0%; margin:0 5px;">
                Question 2
            </div>
            <div class="progress-bar bar" style="width:0%; margin:0 5px;">
                Question 3
            </div>
            <div class="progress-bar bar" style="width:0%; margin:0 5px;">
                Question 4
            </div>
            <div class="progress-bar bar" style="width:0%; margin:0 5px;">
                Question 5
            </div>
            <div class="progress-bar bar" style="width:0; margin-left:5px;">
                Question 6
            </div>
        </div>
    </div>

</div>

<script>
    // 각 질문에 대한 답변을 저장할 객체
    const answers = {};
    // 각 질문의 상태를 저장할 배열 (0: 미작성, 1: 작성중, 2: 작성 완료)
    const questionStates = [0, 0, 0, 0, 0, 0];

    // 서버에서 전달된 questions 데이터를 JavaScript 배열로 변환
    const questions = [
        <c:forEach var="question" items="${questions}">
        {
            "idx":"${question.IPRO_IDX}",
            "question": "${question.IPRO_QUESTION}",
            "type": "${question.IPRO_TYPE}"
        }
        <c:if test="${!fn:contains(question, 'last')}">,</c:if>
        </c:forEach>
    ];


    // 현재 질문 인덱스
    let currentIndex = 0;

    // 페이지 초기화 시 첫 번째 질문 표시
    document.addEventListener("DOMContentLoaded", () => {
        showQuestion(currentIndex);
        const feedbackBox = document.querySelector('.box2');
        if (feedbackBox) {
            feedbackBox.classList.remove('show');
        }

    });

    // 질문 표시 함수
    function showQuestion(index) {
        currentIndex = index;
        // 질문 번호와 내용을 줄바꿈과 함께 표시
        document.getElementById("question-content").innerHTML = '<span class="q-title">질문 ' + (index + 1) + '</span><br>' + questions[currentIndex].question;
        document.getElementById("answer").value = answers[currentIndex] || ''; // 이전에 작성한 답변이 있으면 불러오기
        const answer = document.getElementById("answer");
        const saveButton = document.getElementById("save-answer");

        const feedbackBox = document.querySelector('.box2');
        const container = document.querySelector('.container2');
        const feedbackPanel = document.querySelector('.panel');

        // 답변 로드 후 버튼 상태 업데이트
        saveButton.disabled = !answer.value.trim();

        // box2 숨기기
        feedbackBox.classList.remove('show');
        container.classList.remove('centered');
        feedbackPanel.innerHTML = "<p>이곳에 피드백이 표시됩니다. 잠시만 기다려주세요.</p>";


        // 해당 질문에 대한 피드백이 있는 경우에만 표시
        if (feedbacks[currentIndex]) {
            feedbackBox.classList.add('show');
            container.classList.add('centered');
            feedbackPanel.innerHTML = "<div class='feedback-content'> <div class='feedback-text'>" + feedbacks[currentIndex] + "</div> </div>";
        }
        // progress bar 업데이트
        updateProgressBar();

        // 사이드바 상태 업데이트
        updateSidebar();

        // 마지막 질문일 경우 '답변 완료' 버튼으로 변경하고 이벤트 핸들러도 변경
        const nextButton = document.getElementById("next");
        if (currentIndex === questions.length - 1) {
            nextButton.textContent = "답변 완료";
            nextButton.onclick = goToCheckPage;  // 답변 확인 페이지로 이동하는 함수 연결
        } else {
            nextButton.textContent = "다음 질문";
            nextButton.onclick = nextQuestion;   // 다음 질문으로 이동하는 함수 연결
        }

    }

    // progress bar 업데이트 함수
    function updateProgressBar() {
        const progressBarElements = document.getElementsByClassName('progress-bar');

        for (let i = 0; i < progressBarElements.length; i++) {
            if (i < currentIndex) {
                progressBarElements[i].style.width = '16.6%'; // 완료된 질문은 일정 비율
            } else if (i === currentIndex) {
                progressBarElements[i].style.width = `16.6%`; //
            } else {
                progressBarElements[i].style.width = '0%'; // 아직 완료되지 않은 질문은 0%
            }
        }
    }

    // 사이드바 상태 업데이트 함수
    function updateSidebar() {
        const stateTexts = ["미작성", "작성중", "작성 완료"];

        questionStates.forEach((state, index) => {
            const stateElement = document.getElementById("state" + (index + 1)); // id 값으로 상태 표시 요소 선택
            stateElement.textContent = stateTexts[state]; // 상태 텍스트 업데이트

        });
    }

    // 답변을 저장하고 상태 업데이트
    document.getElementById("answer").addEventListener("input", function() {
        answers[currentIndex] = this.value; // 현재 질문에 대한 답변 저장

        // 답변이 입력되면 '작성중' 상태로 변경
        if (this.value.trim()) {
            questionStates[currentIndex] = 1; // 작성중
        } else {
            questionStates[currentIndex] = 0; // 미작성
        }

        // 사이드바 상태 업데이트
        updateSidebar();

    });

    // 이전 질문 버튼 클릭 시
    function previousQuestion() {
        // // 현재 답변을 작성 완료로 처리
        // if (answers[currentIndex]?.trim()) {
        //     questionStates[currentIndex] = 2; // 작성 완료 상태로 변경
        // }

        if (currentIndex > 0) {
            currentIndex--;
            showQuestion(currentIndex);
        } else {
            // 첫 번째 질문일 경우 알림 메시지 표시
            alert("이전 질문이 없습니다.");

        }
    }


    // 다음 질문 버튼 클릭 시
    function nextQuestion() {
        // 미작성 상태일 경우, 확인 메시지 띄우기
        if (!answers[currentIndex]?.trim()) {
            const confirmation = confirm("미작성된 채로 다음으로 넘어가시겠습니까?");
            if (!confirmation) {
                return; // 사용자가 '취소'를 선택하면 넘어가지 않음
            }
        }

        // 현재 답변을 작성 완료로 처리
        // if (answers[currentIndex]?.trim()) {
        //     questionStates[currentIndex] = 2; // 작성 완료 상태로 변경
        // }

        if (currentIndex < questions.length - 1) {
            currentIndex++;
            showQuestion(currentIndex);
        }else{
            goToCheckPage();
            // 첫 번째 질문일 경우 질문 확인하기 페이지로 돌아감
        }
    }
    // 답변 확인하기 페이지로 이동하는 함수
    function goToCheckPage() {
        location.href = "<%= request.getContextPath() %>/aiboard/ai_check?selfIdx=${param.selfIdx}";
    }



    // 각 질문에 대한 피드백을 저장할 객체
    const feedbacks = {};
    // AI 피드백 받기 버튼 클릭 시 ------------------------------------------------------------------
    document.getElementById('feedback-btn').addEventListener('click', function () {
        const answer = document.getElementById('answer').value;
        const feedbackBox = document.querySelector('.box2'); // 피드백 박스
        const container = document.querySelector('.container2'); // 피드백 컨테이너

        // 답변이 비어있는지 확인
        if (!answer.trim()) {
            alert("답변을 작성해주세요.");

            // 답변을 작성하지 않은 상태에서 box2를 숨기기
            feedbackBox.classList.remove('show'); // box2 숨기기
            container.classList.remove('centered'); // box2 위치 조정 제거
            return; // 피드백 요청을 중지
        }

        // 작성된 답변과 selfIdx 값 추출
        const fullQuestion = document.getElementById('question-content').textContent;
        const question = fullQuestion.replace(/^질문\d+\.\s*/, '');
        const selfIdx = "${param.selfIdx}";  // JSP에서 selfIdx 값 추출 (컨트롤러에서 전달된 값)
        const isJobQuestion = questions[currentIndex].type; // 직무 질문 여부

        // ajax 요청 보내기
        $.ajax({
            type: "POST",  // 요청 방식
            url: "/aiboard/ai_feedback",  // 컨트롤러의 엔드포인트
            contentType: "application/json",
            data: JSON.stringify({
                question: question,
                answer: answer,
                self_idx: selfIdx,  // selfIdx 값도 함께 보내기
                isJobQuestion: isJobQuestion  // 기업/직무 여부
            }),
            success: function(response) {
                // 서버에서 응답이 성공적으로 오면 처리
                console.log("피드백 받기 성공:", response);
                // 피드백을 'feedbacks' 객체에 저장
                feedbacks[currentIndex] = response;  // 현재 질문에 대한 피드백 저장

                // 응답받은 피드백을 'AI 피드백' 영역에 표시
                const feedbackPanel = document.querySelector('.panel');
                const formattedResponse = response
                    .split('\n')
                    .map(line => line.trim())
                    .join('<br>');

                feedbackPanel.innerHTML =
                    "<div class='feedback-content'> <div class='feedback-text' style='white-space: pre-line; line-height: 1.6;'>" + formattedResponse + "</div></div>";


                feedbackBox.classList.add('show');
                container.classList.add('centered');
            },
            error: function(xhr, status, error) {
                        // 오류 발생 시 처리
                        console.error("피드백 받기 실패:" + error);
                        console.error("상태 코드:", xhr.status);
                        console.error("응답 텍스트:", xhr.responseText);
                        alert("AI 피드백 요청에 실패했습니다.");
                    }
                });
            });

    document.getElementById('save-answer').addEventListener('click', function () {
        // 현재 질문의 iproIdx와 사용자가 입력한 답변을 가져오기
        const currentQuestion = questions[currentIndex];
        const iproIdx = currentQuestion.idx;
        const answer = document.getElementById('answer').value.trim();

        if (!answer) {
            alert("답변을 입력해주세요.");
            return;
        }

        // AJAX 요청 보내기 (Fetch API 사용)
        fetch("<%= request.getContextPath() %>/aiboard/save_answer", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": document.querySelector("meta[name='_csrf']").getAttribute("content") // CSRF 토큰 추가
            },
            body: JSON.stringify({
                iproIdx: iproIdx,
                iproAnswer: answer
            })
        })
            .then(response => response.text())
            .then(data => {
                alert(data); // 사용자에게 저장 결과 알림
                // 상태 업데이트 (작성 완료 상태로 변경)
                questionStates[currentIndex] = 2;
                updateSidebar();
            })
            .catch(error => {
                console.error("Error saving answer:", error);
                alert("답변 저장에 실패했습니다.");
            });
    });
</script>




<!-- HTML -->
<%@ include file="../footer.jsp" %>

</body>
</html>
