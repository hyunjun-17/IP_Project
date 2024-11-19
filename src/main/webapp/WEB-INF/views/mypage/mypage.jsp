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
    <link rel="stylesheet" href="<c:url value='/resources/static/mypage/mypagemain.css'/>">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body>

<jsp:include page="../navbar.jsp"/>
<div class="mypsidebar-container">
    <div class="main-content">
        <div class="row">
            <div class="col-2">
                <jsp:include page="mypagebar.jsp"/>
            </div>
            <div class="col-10">
                <div class="content-section">
                    <h2 class="page-header">
                        <span class="user-name"><sec:authentication property="principal.member.name"/></span>님의 마이페이지
                    </h2>

                    <div class="status-cards">
                        <div class="status-item">
                            <div>자기소개서</div>
                            <div class="status-number">${fn:length(selfBoards)}</div>
                        </div>
                        <div class="status-item">
                            <div>AI 면접</div>
                            <div class="status-number">${fn:length(interviews)}</div>
                        </div>
                        <div class="status-item">
                            <div>관심 기업</div>
                            <div class="status-number">${fn:length(favoriteCompanies)}</div>
                        </div>
                        <div class="status-item">
                            <div>면접 후기</div>
                            <div class="status-number">${fn:length(reviews)}</div>
                        </div>
                    </div>

                    <div class="card-container">
                        <div class="custom-card">
                            <div class="card-title d-flex justify-content-between">
                                최근 자기소개서
                                <a href="<c:url value='${pageContext.request.contextPath}/mypage/mypageint'/>"
                                   style="text-decoration: none; color:gray;">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </div>
                            <div class="table-responsive">
                                <table class="table custom-table">
                                    <colgroup>
                                        <col style="width: 20%;">
                                        <col style="width: 60%;">
                                        <col style="width: 20%;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>기업명</th>
                                        <th>제목</th>
                                        <th>작성일</th>

                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${selfBoards}" var="selfBoard" varStatus="status">
                                        <c:if test="${status.index < 3}">
                                            <tr>
                                                <td><c:out value="${selfBoard.selfCompany}"/></td>
                                                <td>
                                                    <a href='${pageContext.request.contextPath}/mypage/mypagelist/${selfBoard.selfIdx}'><c:out
                                                            value="${selfBoard.selfTitle}"/></a></td>
                                                <td>${fn:substring(selfBoard.selfDate, 0, 10)}
                                                    <fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${date}"/></td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="custom-card">
                            <div class="card-title d-flex justify-content-between">
                                AI 면접 내역
                                <a href="<c:url value='${pageContext.request.contextPath}/mypage/mypagevidlist'/>"
                                   style="text-decoration: none; color:gray;">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </div>
                            <div class="table-responsive">
                                <table class="table custom-table">
                                    <thead>
                                    <tr>
                                        <th>기업명</th>
                                        <th>지원직무</th>
                                        <th>면접일</th>
                                        <th>질문내역</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${interviews}" var="interview" varStatus="status">
                                        <c:if test="${status.index < 3}">
                                    <tr>
                                        <td><c:out value="${interview.selfCompany}"/></td>
                                        <td><c:out value="${interview.selfPosition}"/></td>
                                        <td>${fn:substring(interview.createdAt, 0, 10)}
                                            <fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${date}"/></td>
                                        <td>
                                            <button onclick="location.href='${pageContext.request.contextPath}/mypage/mypagevid?selfIdx=${interview.selfIdx}'" class="btn btn-outline-success btn-small">보러가기</button>
                                        </td>
                                    </tr>
                                    </c:if>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="card-container">
                        <div class="custom-card">
                            <div class="card-title">관심 기업</div>
                            <div class="table-responsive">
                                <table class="table custom-table">
                                    <thead>
                                    <tr>
                                        <th>기업명</th>
                                        <th>채용상태</th>
                                        <th>기업분석</th>
                                        <th>관리</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="likeCompany" items="${favoriteCompanies}">
                                        <tr>
                                            <!-- 관심 기업명 -->
                                            <td>${likeCompany.company.companyName}</td>

                                            <!-- 채용 상태: 실제 채용 상태 데이터가 있다면 표시, 없으면 대체 텍스트 사용 -->
                                            <td><span class="status-badge status-pending">채용중</span></td>

                                            <!-- 기업 분석 버튼 -->
                                            <td>
                                                <a href="<c:url value='${pageContext.request.contextPath}/company/corp?companyIdx=${likeCompany.company.companyIdx}&corp=${likeCompany.company.companyName}'/>"
                                                   class="btn btn-outline-primary btn-small">기업분석</a>
                                            </td>

                                            <!-- 관심 기업 삭제 버튼 -->
                                            <td>
                                                <form action="/mypage/favorites/remove" method="post" onsubmit="return confirm('정말로 관심 기업에서 삭제하시겠습니까?');">
                                                    <input type="hidden" name="companyIdx" value="${likeCompany.company.companyIdx}">
                                                    <button type="submit" class="btn btn-outline-danger btn-small">삭제</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="custom-card">
                            <div class="card-title">면접 후기</div>
                            <div class="table-responsive">
                                <table class="table custom-table">
                                    <thead>
                                    <tr>
                                        <th>날짜</th>
                                        <th>제목</th>
                                        <th>직무</th>
                                        <th>상태</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <c:forEach var="board" items="${reviews}" varStatus="i">
                                        <td>${board.formattedReviewDate}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/review_board/review_view/${board.reviewIdx}">
                                                    ${board.reviewTitle}
                                            </a>
                                        </td>
                                        <td>${board.reviewPosition}</td>
                                        <td><span class="status-badge status-completed">
                                                ${board.result}
                                        </span></td>
                                    </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>