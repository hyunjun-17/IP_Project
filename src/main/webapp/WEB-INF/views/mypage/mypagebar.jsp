<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Side Navigation</title>
  <!-- Font Awesome -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="<c:url value='/resources/static/mypage/mypagebar.css'/>">
</head>
<body>
<!-- Sidebar -->
<div class="mypsidebar">
  <div class="sidebar-title">My IP</div>
  <ul class="sidebar-menu">
    <li>
      <a href="<c:url value='${pageContext.request.contextPath}/mypage/mypage'/>">
        <i class="fas fa-home"></i>
        <span>마이홈</span>
      </a>
    </li>
    <li>
      <a href="<c:url value='${pageContext.request.contextPath}/mypage/myprofile'/>">
        <i class="fas fa-briefcase"></i>
        <span>회원정보이력</span>
      </a>
    </li>
    <li>
      <a href="<c:url value='${pageContext.request.contextPath}/mypage/mypageint'/>">
        <i class="fas fa-file-alt"></i>
        <span>자기소개서 내역</span>
      </a>
    </li>

    <li>
      <a href="<c:url value='${pageContext.request.contextPath}/mypage/mypagevidlist'/>">
        <i class="fas fa-microchip"></i>
        <span>AI 면접 내역</span>
      </a>
    </li>
    </ul>

  <div class="sidebar-divider"></div>
  <div class="sidebar-title">관심 기업</div>
  <ul class="list-group">
  <c:forEach var="likeCompany" items="${favoriteCompanies}">
    <li class="list-group-item" style="border:none; padding: 0 0 10px;">
      <a href="<c:url value='${pageContext.request.contextPath}/company/corp?companyIdx=${likeCompany.company.companyIdx}&corp=${likeCompany.company.companyName}'/>" style="text-decoration: none; color:inherit;">
        <div class="company-icon">
          <c:choose>
            <c:when test="${fn:contains(likeCompany.company.companyName, 'toss') || fn:contains(likeCompany.company.companyName, '토스')}">
              <i class="fas fa-wallet toss-icon"></i>
            </c:when>
            <c:when test="${fn:contains(likeCompany.company.companyName, 'naver') || fn:contains(likeCompany.company.companyName, '네이버')}">
              <i class="fas fa-n naver-icon"></i>
            </c:when>
            <c:when test="${fn:contains(likeCompany.company.companyName, '배달의 민족 (우아한 형제들)') || fn:contains(likeCompany.company.companyName, '우아한형제들')}">
              <i class="fas fa-motorcycle baemin-icon"></i>
            </c:when>
            <c:when test="${fn:contains(likeCompany.company.companyName, 'nexon') || fn:contains(likeCompany.company.companyName, '넥슨')}">
              <i class="fas fa-gamepad nexon-icon"></i>
            </c:when>
            <c:when test="${fn:contains(likeCompany.company.companyName, 'kakao') || fn:contains(likeCompany.company.companyName, '카카오')}">
              <i class="fas fa-comments kakao-icon"></i>
            </c:when>
            <c:when test="${fn:contains(likeCompany.company.companyName, '당근마켓')}">
              <i class="fas fa-carrot carrot-icon"></i>
            </c:when>
            <c:when test="${fn:contains(likeCompany.company.companyName, 'netmarble') || fn:contains(likeCompany.company.companyName, '넷마블')}">
              <i class="fas fa-puzzle-piece netmarble-icon"></i>
            </c:when>
            <c:when test="${fn:contains(likeCompany.company.companyName, 'coupang') || fn:contains(likeCompany.company.companyName, '쿠팡')}">
              <i class="fas fa-box coupang-icon"></i>
            </c:when>
            <c:when test="${fn:contains(likeCompany.company.companyName, 'ncsoft') || fn:contains(likeCompany.company.companyName, '엔씨소프트')}">
              <i class="fas fa-ghost ncsoft-icon"></i>
            </c:when>
            <c:when test="${fn:contains(likeCompany.company.companyName, 'line') || fn:contains(likeCompany.company.companyName, '라인')}">
              <i class="fas fa-message line-icon"></i>
            </c:when>
            <c:otherwise>
              <i class="fas fa-building"></i>
            </c:otherwise>
          </c:choose>
          <span class="company-name" style="padding:10px">${likeCompany.company.companyName}</span>
        </div>
      </a>
    </li>
  </c:forEach>
  </ul>
</div>
</body>
</html>