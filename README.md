## 📎 프로젝트: IPro
![image](https://github.com/user-attachments/assets/5c12b00f-8d46-400d-871f-eb9516e8fd36)

### 👀 서비스 소개
**서비스명:** IPro
**설명:** LLM기반 기업과 나를 잇는 면접 AI코칭 서비스 'IPRO'

### 📅 프로젝트 기간
**기간:** 2024년 10월 15일 ~ 2024년 11월 22일 (5주)

### ⭐ 주요 기능
- 예상 면접 질문 추출
- 질문 답변에 대한 피드백 제공
- 온라인 면접 서비스
- 기업 분석 및 최신 동향
- 리뷰 게시판

### ⛏ 기술 스택
| 구분          | 내용 |
|---------------|---------|
| 기본 사용언어     | <img src="https://img.shields.io/badge/Java-007396?style=for-the-badge&logo=java&logoColor=white"/> <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=Python&logoColor=white"/> |
| Frontend 사용언어     |  <img src="https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=HTML5&logoColor=white"/> <img src="https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=CSS3&logoColor=white"/> <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=JavaScript&logoColor=white"/> |
|  Backend 프레임워크     |  <img src="https://img.shields.io/badge/Spring boot-D22128?style=for-the-badge&logo=Spring boot&logoColor=white"/> |
| 라이브러리     | <img src="https://img.shields.io/badge/BootStrap-7952B3?style=for-the-badge&logo=BootStrap&logoColor=white"/> <img src="https://img.shields.io/badge/NewsAPI-%23FF9900.svg?style=for-the-badge&logo=NewsAPI&logoColor=white" > <img src="https://img.shields.io/badge/ChatGPT-FF61F6?style=for-the-badge&logo=ChatGPT&logoColor=white"/> <img src="https://img.shields.io/badge/langchain-31A8FF?style=for-the-badge&logo=langchain&logoColor=white"/> <img src="https://img.shields.io/badge/Oauth2-007CE2?style=for-the-badge&logo=Oauth2&logoColor=white"/>|
| 개발 도구     | <img src="https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=Figma&logoColor=white"/> <img src="https://img.shields.io/badge/Intellij-2C2255?style=for-the-badge&logo=Intellij&logoColor=white"/> <img src="https://img.shields.io/badge/VSCode-007ACC?style=for-the-badge&logo=VisualStudioCode&logoColor=white"/> |
| 서버 환경     | <img src="https://img.shields.io/badge/FastAPI-000000?style=for-the-badge&logo=FastAPI&logoColor=white"/>  |
| 데이터베이스   | <img src="https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=Oracle&logoColor=white"/> <img src="https://img.shields.io/badge/Pinecone-F80000?style=for-the-badge&logo=Pinecone&logoColor=white"/>|
| 협업 도구     | <img src="https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=Git&logoColor=white"/> <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=GitHub&logoColor=white"/> |
| 인프라 구조     |  <img src="https://img.shields.io/badge/Google Cloud-569A31?style=for-the-badge&logo=Google-Cloud&logoColor=white">|

### ⚙ 시스템 아키텍처
![image](https://github.com/user-attachments/assets/79e0c9f3-6933-47da-82a3-f99e5a928185)


### 📌 SW 유스케이스


### 📌 서비스 흐름도


### 📌 ER 다이어그램



### 🖥 화면 구성


### 🤾‍♂️ 트러블슈팅

## 1. 다중 Flask 사용으로 인한 메모리 과다 사용
---
## 원인
스프링과 실행중 Flask를 사용하는 여러 파이썬 기능 실행중 메모리 과다 사용 및 누수 발생
<!--  
## 해결방안

FastApi<p>
장점<p>
FastAPI는 최신 Python 기반 프레임워크로 빠른 성능과 사용하기 쉬운 API로 유명합니다. 비동기 프로그래밍을 지원하므로 실시간 애플리케이션 구축에 적합합니다. 또한 자동 API 문서화 및 유효성 검사를 제공하여 개발자의 시간과 노력을 절약합니다.<p>
단점<p>
FastAPI는 비교적 새로운 프레임워크이며 기존 프레임워크에 비해 커뮤니티 지원 및 리소스가 많지 않을 수 있습니다. 또한 비동기 프로그래밍을 처음 접하는 개발자를 위한 학습 곡선도 있습니다.<p>
활용도<p>
FastAPI는 특히 데이터 집약적인 애플리케이션을 위한 실시간 및 고성능 API 구축에 적합합니다.<p>

Django<p>
장점<p>
Django는 웹 애플리케이션 개발에 널리 사용되는 성숙한 Python 기반 프레임워크입니다. 인증, 관리자 패널 및 ORM과 같은 많은 기본 기능을 제공합니다. 또한 지원 및 리소스를 제공하는 크고 활동적인 커뮤니티가 있습니다.<p>
단점<p>
Django는 복잡할 수 있으며 설정하려면 상당한 구성이 필요합니다. 소규모 프로젝트나 경량 API<p>
축에는 적합하지 않을 수도 있습니다.<p>
활용<p>
Django는 웹 애플리케이션, 특히 콘텐츠 기반 웹사이트, 전자상거래 플랫폼 및 소셜 미디어 플랫폼을 구축하는 데 널리 사용됩니다.<p>

Flask<p>
장점<p>
Flask는 배우고 사용하기 쉬운 경량 Python 기반 프레임워크입니다. 유연성을 제공하고 개발자가 모듈식 및 확장 가능한 방식으로 웹 애플리케이션을 구축할 수 있도록 합니다. 또한 사용자 정의가 가능하고 소규모 프로젝트를 구축하는 데 적합합니다.<p>
단점<p>
Flask는 다른 프레임워크에 비해 기본 제공 기능이 적기 때문에 개발자가 구현하는 데 더 많은 노력과 시간이 필요할 수 있습니다. 또한 대규모 웹 애플리케이션을 구축하는 데 적합하지 않을 수도 있습니다.<p>
-->
## 선택한 해결 방안
FastApi

1. 각 기능이 비동기 식으로 일어나는 사이트인 관계로 Flask 보다 FastAPI에 적합<p>
2. 속도면에서도 약 3배 가까이 빠름<p>

flask 사용시 예상 면접 질문 추출 30초<p>
FastAPI 사용시 예상 면접 질문 추출 12초<p>


<br>
<br>
