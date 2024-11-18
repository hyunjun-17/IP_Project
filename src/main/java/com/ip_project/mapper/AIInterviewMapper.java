package com.ip_project.mapper;

import com.ip_project.dto.AIInterviewDTO;
import com.ip_project.dto.AIQuestionDTO;
import com.ip_project.entity.AIInterview;
import com.ip_project.entity.AIQuestion;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class AIInterviewMapper {

    public AIInterview toEntity(AIInterviewDTO dto) {
        if (dto == null) {
            return null;
        }

        return AIInterview.builder()
                .id(dto.getId())
                .username(dto.getUsername())
                .position(dto.getPosition())
                .date(dto.getInterviewDate())
                .url(dto.getVideoUrl())
                .iproIdx(dto.getMemberId())        // memberId를 iproIdx로 사용
                .build();
    }

    public AIInterviewDTO toDto(AIInterview entity) {
        if (entity == null) {
            return null;
        }

        return AIInterviewDTO.builder()
                .id(entity.getId())
                .username(entity.getUsername())
                .position(entity.getPosition())
                .interviewDate(entity.getDate())
                .videoUrl(entity.getUrl())
                .memberId(entity.getIproIdx())        // iproIdx를 memberId로 사용
                .build();
    }

    // questionToEntity와 questionToDto는 그대로 유지
}