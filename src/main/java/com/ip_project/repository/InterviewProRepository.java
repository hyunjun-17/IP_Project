package com.ip_project.repository;


import com.ip_project.dto.InterviewSummaryDTO;
import com.ip_project.entity.InterviewPro;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface InterviewProRepository extends JpaRepository<InterviewPro, Long> {
    List<InterviewPro> findByMemberUsername(String username);

    @Query("""
    SELECT new com.ip_project.dto.InterviewSummaryDTO(
        sb.selfIdx, sb.selfCompany, sb.selfPosition, MAX(ip.createdAt)
    )
    FROM InterviewPro ip
    JOIN ip.selfBoard sb
    WHERE ip.member.username = :username
    GROUP BY sb.selfIdx, sb.selfCompany, sb.selfPosition
    ORDER BY MAX(ip.createdAt) DESC
""")

    List<InterviewSummaryDTO> findInterviewSummaryByUsername(@Param("username") String username);

    List<InterviewPro> findBySelfBoardSelfIdx(Long selfIdx);
}
