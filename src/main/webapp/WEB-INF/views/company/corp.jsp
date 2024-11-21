
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../header.jsp" %>

<head>
    <title>기업 분석</title>

    <link rel="stylesheet" href="<c:url value='/resources/static/company/corp.css'/>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
</head>
<body>
<jsp:include page="../navbar.jsp"/>

<div  id="corpContent">
    <div class="jumbotron">
        <h1 class="display-4">기업 분석</h1>
        <p class="lead">AI가 분석해주는 SWOT · 최신 동향</p>
        <hr class="my-4">
        <div class="input-group mb-0 w-50 mx-auto">
            <input type="text" class="form-control" placeholder="기업명을 입력하세요" aria-label="Search" name="corp"
                   id="corpInput" required
                   value="${param.corp}"/>
            <button class="btn btn-toolbar btn-dark" id="searchButton" type="button">Search</button>
        </div>
    </div>

    <div class="main-content pt-0">
        <!-- 기업 정보 Section -->
        <section class="container my-5">
            <%--        <h2>기업 정보</h2>--%>
            <div class="card" style="min-width: 1300px;">
                <div class="card-body" style="padding: 0 13px;">
                    <div class="row">
                        <div class="col-md-3 p-3" style="background-color: #f7f7f7;  overflow: hidden; border-radius: 5px;">
                            <a id="infoimg">
                                <img src="<c:url value='/resources/static/img/${board.img}'/>" class="img-fluid" style="min-height: 290px;">
                            </a>
                            <!-- 좋아요 하트 버튼 추가 및 오른쪽 정렬 -->
                            <div class="mt-3 text-end">
                                <button type="button" class="btn btn-outline-danger like-button ${hasLiked ? 'liked' : ''}" id="likeButton" data-company-idx="${board.companyIdx}">
                                    <i class="${hasLiked ? 'bi bi-heart-fill' : 'bi bi-heart'}"></i> <!-- 좋아요 여부에 따라 아이콘 변경 -->
                                </button>
                            </div>
                        </div>
                        <div class="col-md-9 p-4">
                            <table class="table">
                                <tbody>
                                <tr>
                                    <th>기업명:</th>
                                    <td>${board.companyName}</td>
                                </tr>
                                <tr>
                                    <th>기업 형태:</th>
                                    <td>${board.companyType}</td>
                                </tr>
                                <tr>
                                    <%--                                <th>설립일:</th>--%>
                                    <%--                                <td>--%>
                                    <%--                                    ${fn:replace(board.companyHistory, "\\n", "<br>")}--%>
                                    <%--                                </td>--%>
                                    <th>대표자:</th>
                                    <td>${board.companyCeo}</td>
                                </tr>
                                <tr>
                                    <th>사원 수:</th>
                                    <td>${board.companyEmployees}명</td>
                                </tr>
                                <tr>
                                    <th>주소:</th>
                                    <td>${board.companyAddress}</td>
                                </tr>
                                <tr style="border-bottom:white;">
                                    <th>인재상:</th>
                                    <td>
                                        ${fn:replace(board.companyContent, "\\n", "<br>")}
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- SWOT card section -->
        <section class="container my-5">
            <div class="row text-center">
                <!-- Strengths Card -->
                <div class="col-md-3 mb-4">
                    <div class="card swot-card" id="S">
                        <div class="card-body" style="padding: 15px 5px;">
                            <h1 class="swot-letter swot-letter-S">S</h1>
                            <h5 class="card-title">Strengths</h5>
                            <ul class="card-text">
                                <li>${fn:replace(swot.strength, "\\n", "</li><li>")}</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Weaknesses Card -->
                <div class="col-md-3 mb-4">
                    <div class="card swot-card" id="W">
                        <div class="card-body" style="padding: 15px 5px;">
                            <h1 class="swot-letter swot-letter-W">W</h1>
                            <h5 class="card-title">Weaknesses</h5>
                            <ul class="card-text">
                                <li>${fn:replace(swot.weakness, "\\n", "</li><li>")}</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Opportunities Card -->
                <div class="col-md-3 mb-4">
                    <div class="card swot-card" id="O">
                        <div class="card-body" style="padding: 15px 5px;">
                            <h1 class="swot-letter swot-letter-O">O</h1>
                            <h5 class="card-title">Opportunities</h5>
                            <ul class="card-text">
                                <li>${fn:replace(swot.opportunity, "\\n", "</li><li>")}</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Threats Card -->
                <div class="col-md-3 mb-4">
                    <div class="card swot-card" id="T">
                        <div class="card-body" style="padding: 15px 5px;">
                            <h1 class="swot-letter swot-letter-T">T</h1>
                            <h5 class="card-title">Threats</h5>
                            <ul class="card-text">
                                <li>${fn:replace(swot.threat, "\\n", "</li><li>")}</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </section>


        <!-- 기업 최신 동향 Section -->
        <section class="container d-flex flex-column my-5" style="gap:15px">
            <h4><strong>최신 동향 뉴스</strong></h4>
            <table class="news-table">
                <colgroup>
                    <col style="width: 20%;">
                    <col style="width: 70%;">
                    <col style="width: 10%;">
                </colgroup>
                <tbody id="newsTableBody">
                <c:forEach items="${newsList}" var="news">
                    <tr>
                        <td><a href="${news.newsUrl}" target="_blank">
                            <img src="${news.newsImage}" alt="뉴스 이미지"></a></td>
                        <td style="text-align:left">
                            <a href="${news.newsUrl}" target="_blank">
                                <p>${news.newsTitle}</p></a>
                            <span>${news.newsDescription}</span></td>
                        <td><c:out value="${fn:substring(news.newsDate, 0, 10)}" /></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </section>
    </div>
    <%@ include file="../footer.jsp" %>
</div>

<script>
    $(document).ready(function() {
        $('#searchButton').click(function() {
            const corpName = $('#corpInput').val();
            if (corpName) {
                $.ajax({
                    url: '/company/search', // Controller의 새로운 매핑 URL
                    method: 'GET',
                    data: { companyName: corpName },
                    success: function(data) {
                        // AJAX 응답으로 받은 내용을 페이지에 반영
                        $('#corpContent').html(data);
                    },
                    error: function(xhr, status, error) {
                        console.error('기업 조회 실패:', error);
                    }
                });
            } else {
                alert('기업명을 입력하세요.');
            }
        });

        // 좋아요 버튼 클릭 시 관심 기업 등록/해제 AJAX 요청
        $('#likeButton').click(function() {
            const companyIdx = $(this).data('company-idx');
            const csrfToken = $("meta[name='_csrf']").attr("content");
            const csrfHeader = $("meta[name='_csrf_header']").attr("content");

            if (!companyIdx) {
                alert('회사 정보를 찾을 수 없습니다.');
                return;
            }

            fetch('/company/toggle-like', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    [csrfHeader]: csrfToken  // CSRF 토큰을 헤더에 추가
                },
                body: JSON.stringify({ companyIdx: companyIdx })
            })
                .then(response => response.text())
                .then(data => {
                    alert(data);
                    $(this).toggleClass('liked');
                    const icon = $(this).find('i');
                    if ($(this).hasClass('liked')) {
                        icon.removeClass('bi-heart').addClass('bi-heart-fill');
                    } else {
                        icon.removeClass('bi-heart-fill').addClass('bi-heart');
                    }
                })
                .catch(error => console.error('Error:', error));
        });
    });

</script>

</body>
