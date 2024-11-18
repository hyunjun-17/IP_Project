package com.ip_project.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "AI_INTERVIEW")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AIInterview {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "AI_INTERVIEW_SEQ")
    @SequenceGenerator(name = "AI_INTERVIEW_SEQ", sequenceName = "AI_INTERVIEW_SEQ", allocationSize = 1)
    @Column(name = "AI_IDX", precision = 10)
    private Long id;

    @Column(name = "AI_POSITION", length = 30)
    private String position;

    @Column(name = "AI_QUESTION", length = 1000)
    private String question;

    @Column(name = "AI_URL", length = 300)
    private String url;

    @Column(name = "AI_DATE")
    private LocalDateTime date;

    @Column(name = "VIDEO_DURATION", precision = 10)
    private Long videoDuration;

    @Column(name = "VIDEO_SIZE", precision = 20)
    private Long videoSize;

    @Column(name = "VIDEO_FORMAT", length = 300)
    private String videoFormat;

    @Column(name = "IPRO_IDX", precision = 10)
    private Long iproIdx;

    @Column(name = "USERNAME", length = 30)
    private String username;

    @Builder.Default  // List 초기화를 위해 추가
    @OneToMany(mappedBy = "interview", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<AIQuestion> questions = new ArrayList<>();
}