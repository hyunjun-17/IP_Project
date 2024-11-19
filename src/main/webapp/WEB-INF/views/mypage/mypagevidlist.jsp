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
                    <sec:authentication property="principal.member.name"/>님의 AI 면접 내역
                    <span class="header-badge">(총 ${fn:length(interviews)}건)</span>
                </h2>
            </div>

            <div class="card">
                <div class="card-body">

                    <!-- Table Section -->
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th scope="col">번호</th>
                                <th scope="col">기업명</th>
                                <th scope="col">직무</th>
                                <th scope="col">면접일</th>
                                <th scope="col">질문·답변내역</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${interviews}" var="interview" varStatus="i">
                                <tr>
                                    <td>${i.index + 1}</td>
                                    <td><c:out value="${interview.selfCompany}"/></td>
                                    <td><c:out value="${interview.selfPosition}"/></td>

<%--                                        <a href="${pageContext.request.contextPath}/mypage/mypagelist/${selfBoard.selfIdx}"><c:out--%>
<%--                                                value="${ipro.selfTitle}"/></a></td>--%>
                                    <td>${fn:substring(interview.createdAt, 0, 10)} ${fn:substring(interview.createdAt, 11, 16)}
                                        <fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${date}"/></td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <button onclick="location.href='${pageContext.request.contextPath}/mypage/mypagevid?selfIdx=${interview.selfIdx}'" class="btn btn-outline-success btn-small">보러가기</button>
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



    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS (if any) -->
    <script src="<c:url value='/resources/js/selfIntroModal.js'/>"></script>
</body>
</html>
