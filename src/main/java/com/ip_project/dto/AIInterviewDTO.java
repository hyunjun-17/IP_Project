package com.ip_project.dto;

import com.ip_project.entity.AIInterviewStatus;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AIInterviewDTO {
    private Long id;
    private String username;
    private String position;
    private LocalDateTime interviewDate;
    private String videoUrl;
    private Long selfId;  // 추가
    private Integer iproIdx;  // 추가
    private Long memberId;             // iproIdx 대신 memberId 사용
    private List<AIQuestionDTO> questions;

    public void setStatus(AIInterviewStatus aiInterviewStatus) {
    }
}