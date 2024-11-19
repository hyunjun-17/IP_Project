package com.ip_project.repository;

import java.util.Optional;
import java.util.List;

import com.ip_project.entity.AIInterview;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface AIInterviewRepository extends JpaRepository<AIInterview, Long> {
    List<AIInterview> findByUsername(String username);

    @Query(value = "SELECT * FROM (" +
            "  SELECT * FROM ai_interview " +
            "  WHERE username = ? " +
            "  ORDER BY ai_date DESC" +
            ") WHERE ROWNUM = 1", nativeQuery = true)
    Optional<AIInterview> findTopByUsernameOrderByDateDesc(String username);
}