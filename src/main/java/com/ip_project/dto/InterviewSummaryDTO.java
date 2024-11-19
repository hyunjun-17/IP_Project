package com.ip_project.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class InterviewSummaryDTO {
    private Long selfIdx;
    private String selfCompany;
    private String selfPosition;
    private LocalDateTime createdAt;
}
