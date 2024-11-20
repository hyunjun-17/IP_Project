package com.ip_project.dto;

import com.ip_project.entity.InterviewPro;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class SelfIntroductionDTO {
    private Long idx;  // 자기소개서 ID
    private LocalDateTime date;  // 작성일자
    private String company;  // 회사명
    private String title;  // 제목
    private String position;  // 직무
    private List<String> questions;  // 질문 목록
    private List<String> answers;  // 답변 목록
    private List<String> iproQuestions;  // AI 면접 예상 질문 목록
    private List<String> iproAnswers;
    private List<InterviewPro> iproList;
    private String username;
}