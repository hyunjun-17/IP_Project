package com.ip_project.service;

import com.ip_project.dto.AIInterviewDTO;
import com.ip_project.entity.AIInterview;
import com.ip_project.mapper.AIInterviewMapper;
import com.ip_project.repository.AIInterviewRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class AIInterviewService {
    private final AIInterviewRepository interviewRepository;
    private final AIInterviewMapper interviewMapper;
    private final VideoStorageService videoStorageService; // 새로운 GCS 서비스
    private final JdbcTemplate jdbcTemplate;


    @Transactional
    public AIInterviewDTO createInterview(AIInterviewDTO dto) {
        AIInterview interview = interviewMapper.toEntity(dto);
        // status를 String으로 직접 설정
        interview.setVideoStatus("CREATED");
        interview.setDate(LocalDateTime.now());

        AIInterview savedInterview = interviewRepository.save(interview);
        return interviewMapper.toDto(savedInterview);
    }

    @Transactional
    public String submitVideoResponse(String username, MultipartFile file, Integer questionNumber) {
        try {
            // 해당 사용자의 가장 최근 인터뷰 찾기
            AIInterview interview = interviewRepository.findTopByUsernameOrderByDateDesc(username)
                    .orElseThrow(() -> new EntityNotFoundException("No active interview found for user: " + username));

            // GCS에 비디오 저장
            String videoUrl = videoStorageService.storeVideo(file, interview.getId(), questionNumber);

            // AI_INTERVIEW 테이블의 URL 업데이트
            String updateSql = "UPDATE AI_INTERVIEW " +
                    "SET AI_URL = ?, " +
                    "VIDEO_STATUS = ?, " +
                    "VIDEO_SIZE = ?, " +
                    "VIDEO_FORMAT = ? " +
                    "WHERE USERNAME = ? " +
                    "AND AI_IDX = ?";

            jdbcTemplate.update(updateSql,
                    videoUrl,
                    "SUBMITTED",
                    file.getSize(),
                    file.getContentType(),
                    username,
                    interview.getId());

            log.info("Successfully uploaded video for user {} question {}", username, questionNumber);

            return videoUrl;
        } catch (Exception e) {
            log.error("Failed to upload video for user {} question {}", username, questionNumber, e);
            throw new RuntimeException("Failed to upload video: " + e.getMessage(), e);
        }
    }

    @Transactional(readOnly = true)
    public String getVideoUrl(Long interviewId, Integer questionNumber) {
        String sql = "SELECT AI_URL FROM AI_INTERVIEW WHERE AI_IDX = TO_NUMBER(?)";

        try {
            return jdbcTemplate.queryForObject(sql,
                    String.class,
                    String.valueOf(interviewId)
            );
        } catch (Exception e) {
            log.error("Failed to get video URL for interview {} question {}", interviewId, questionNumber, e);
            return null;
        }
    }

    @Transactional(readOnly = true)
    public List<AIInterviewDTO> getInterviewsByUsername(String username) {
        return interviewRepository.findByUsername(username).stream()
                .map(interviewMapper::toDto)
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteInterview(Long id) {
        if (!interviewRepository.existsById(id)) {
            throw new EntityNotFoundException("Interview not found with id: " + id);
        }
        interviewRepository.deleteById(id);
    }



}