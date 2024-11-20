package com.ip_project.service;

import com.ip_project.dto.InterviewSummaryDTO;
import com.ip_project.entity.InterviewPro;
import com.ip_project.repository.InterviewProRepository;
import com.ip_project.repository.SelfBoardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class InterviewQuestionService {
    private final JdbcTemplate jdbcTemplate;
    private final InterviewProRepository interviewProRepository;
    private final SelfBoardRepository selfBoardRepository;

    public List<Map<String, Object>> getQuestionsBySelfIdx(Long selfIdx) {
        String sql = "SELECT IPRO_IDX, IPRO_QUESTION, IPRO_TYPE, IPRO_ANSWER FROM INTERVIEW_PRO WHERE SELF_IDX = ? ORDER BY IPRO_IDX";
        return jdbcTemplate.queryForList(sql, selfIdx);
    }

    public int saveAnswer(Long iproIdx, String iproAnswer) {
        String sql = "UPDATE INTERVIEW_PRO SET IPRO_ANSWER = ? WHERE IPRO_IDX = ?";
        return jdbcTemplate.update(sql, iproAnswer, iproIdx);
    }

    public List<InterviewSummaryDTO> getInterviewSummaryDTO(String username) {
        return interviewProRepository.findInterviewSummaryByUsername(username);
    }

    public void listByUsername(Model model, String username) {
        List<InterviewSummaryDTO> summaries = getInterviewSummaryDTO(username);
        model.addAttribute("interviews", summaries);
    }

    public List<InterviewPro> getInterviewProBySelfIdx(Long selfIdx) {
        return interviewProRepository.findBySelfBoardSelfIdx(selfIdx);
    }
}