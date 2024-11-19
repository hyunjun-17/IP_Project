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
    private final S3VideoService s3VideoService;  // S3VideoService 주입 추가
    private final JdbcTemplate jdbcTemplate;

    @Transactional
    public AIInterviewDTO createInterview(AIInterviewDTO dto) {
        AIInterview interview = interviewMapper.toEntity(dto);
        interview.setDate(LocalDateTime.now());
        AIInterview savedInterview = interviewRepository.save(interview);
        return interviewMapper.toDto(savedInterview);
    }

    @Transactional
    public String submitVideoResponse(String username, MultipartFile file, Long selfId, Long iproIdx, Integer questionNumber) {
        try {
            AIInterview interview = interviewRepository.findTopByUsernameOrderByDateDesc(username)
                    .orElseThrow(() -> new EntityNotFoundException("No active interview found for user: " + username));

            String videoUrl = s3VideoService.saveVideo(file, selfId, iproIdx, questionNumber);

            String updateSql = "UPDATE AI_INTERVIEW " +
                    "SET AI_URL = ?, " +
                    "VIDEO_SIZE = ?, " +
                    "VIDEO_FORMAT = ?, " +
                    "IPRO_IDX = ? " +  // IPRO_IDX 추가
                    "WHERE USERNAME = ? " +
                    "AND AI_IDX = ?";

            jdbcTemplate.update(updateSql,
                    videoUrl,
                    file.getSize(),
                    file.getContentType(),
                    iproIdx,    // IPRO_IDX 값 추가
                    username,
                    interview.getId());

            return videoUrl;
        } catch (Exception e) {
            log.error("Failed to upload video", e);
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