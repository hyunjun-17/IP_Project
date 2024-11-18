package com.ip_project.controller;

import com.ip_project.dto.AIInterviewDTO;
import com.ip_project.dto.InterviewProDTO;
import com.ip_project.dto.SelfIntroductionDTO;
import com.ip_project.entity.*;
import com.ip_project.repository.MemberRepository;
import com.ip_project.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.*;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.Collections;

@Slf4j
@Controller
@RequestMapping("/aiboard")
@RequiredArgsConstructor
public class AIBoardController {

    private final AIInterviewService interviewService;
    private final SelfIntroductionService selfIntroductionService;
    private final SelfBoardService selfBoardService;
    private final MemberRepository memberRepository;
    private final InterviewQuestionService questionService;
    private final RestTemplate restTemplate;
    private final VideoStorageService videoStorageService;


    private static final String FASTAPI_URL = "http://127.0.0.1:8000/generate-interview";
    private static final String FASTAPI_URL2 = "http://127.0.0.1:8000/feedback-interview";

    // 새로 추가된 답변 저장 메소드
    @PostMapping("/save_answer")
    public ResponseEntity<String> saveAnswer(@RequestBody InterviewProDTO interviewProDTO) {
        Long iproIdx = interviewProDTO.getIproIdx();
        String iproAnswer = interviewProDTO.getIproAnswer();

        if (iproIdx == null || iproAnswer == null || iproAnswer.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Invalid iproIdx or iproAnswer");
        }

        try {
            int rowsAffected = questionService.saveAnswer(iproIdx, iproAnswer);
            if (rowsAffected > 0) {
                return ResponseEntity.ok("답변을 저장하였습니다");
            } else {
                return ResponseEntity.status(500).body("Failed to save answer");
            }
        } catch (Exception e) {
            // 로깅을 추가하는 것이 좋습니다.
            return ResponseEntity.status(500).body("An error occurred while saving the answer");
        }
    }

    @GetMapping("/ai_board")
    public String aiBoard() {
        return "aiboard/ai_board";
    }

    @GetMapping("/ai_custominfo")
    public String aiCustomInfo(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        selfBoardService.listByUsername(model, username);
        return "aiboard/ai_custominfo";
    }

    @PostMapping("/saveIntroduction")
    public String saveIntroduction(@ModelAttribute SelfIntroductionDTO selfIntroDto) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();

        Member member = memberRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Member not found"));

        SelfBoard selfBoard = SelfBoard.builder()
                .selfCompany(selfIntroDto.getCompany())
                .selfTitle(selfIntroDto.getTitle())
                .selfPosition(selfIntroDto.getPosition())
                .selfDate(LocalDateTime.now())
                .member(member)
                .build();

        selfBoardService.save(selfBoard);

        for (int i = 0; i < selfIntroDto.getQuestions().size(); i++) {
            SelfIntroduction selfIntroduction = SelfIntroduction.builder()
                    .introQuestion(selfIntroDto.getQuestions().get(i))
                    .introAnswer(selfIntroDto.getAnswers().get(i))
                    .selfBoard(selfBoard)
                    .build();
            selfIntroductionService.saveSelfIntroduction(selfIntroduction);
        }

        return "redirect:/aiboard/ai_custominfo";
    }

    @GetMapping("/loadSelfIntroduction/{idx}")
    @ResponseBody
    public ResponseEntity<SelfIntroductionDTO> loadSelfIntroduction(@PathVariable("idx") Long idx) {
        try {
            // SelfBoard 조회
            SelfBoard selfBoard = selfBoardService.findById(idx);
            if (selfBoard == null) {
                return ResponseEntity.notFound().build();
            }

            // SelfIntroductionDTO 생성
            SelfIntroductionDTO dto = selfIntroductionService.getSelfIntroductions(selfBoard);

            // IPRO_QUESTION 및 IPRO_ANSWER 조회
            List<Map<String, Object>> iproData = questionService.getQuestionsBySelfIdx(idx);
            if (iproData != null && !iproData.isEmpty()) {
                List<String> questions = iproData.stream()
                        .map(q -> (String) q.get("IPRO_QUESTION"))
                        .collect(Collectors.toList());
                List<String> answers = iproData.stream()
                        .map(a -> (String) a.get("IPRO_ANSWER"))
                        .collect(Collectors.toList());
                dto.setIproQuestions(questions);
                dto.setIproAnswers(answers);
            }

            return ResponseEntity.ok(dto);
        } catch (Exception e) {
            log.error("Error loading self introduction", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/ai_makequestion")
    public String aiMakeQuestion(@RequestParam(name = "selfIdx", required = true) Long selfIdx, Model model) {
        log.info("Starting interview question generation for selfIdx: {}", selfIdx);
        try {
            // 로그인된 사용자 정보에서 USERNAME 가져오기
            String username = SecurityContextHolder.getContext().getAuthentication().getName();
            log.info("Generating questions for username: {}", username);

            // FastAPI 서버로 요청을 보내서 새로운 질문 생성
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("self_idx", selfIdx);
            requestBody.put("username", username); // USERNAME 추가username); // USERNAME 추가

            // FastAPI 호출
            ResponseEntity<Map> response = restTemplate.postForEntity(
                    FASTAPI_URL,
                    requestBody,
                    Map.class
            );

            if (response.getStatusCode() == HttpStatus.OK) {
                // 새로 생성된 질문 조회
                List<Map<String, Object>> questions = questionService.getQuestionsBySelfIdx(selfIdx);
                if (questions != null && !questions.isEmpty()) {
                    model.addAttribute("questions", questions);
                    return "aiboard/ai_makequestion";
                }
            }

            // 질문 생성 실패 시
            log.error("Failed to generate questions for selfIdx: {}", selfIdx);
            model.addAttribute("error", "질문 생성에 실패했습니다.");
            return "redirect:/aiboard/ai_custominfo";

        } catch (Exception e) {
            log.error("Error in aiMakeQuestion for selfIdx: {}", selfIdx, e);
            model.addAttribute("error", "오류가 발생했습니다.");
            return "redirect:/aiboard/ai_custominfo";
        }
    }

    @PostMapping("/ai_feedback")
    @ResponseBody
    public ResponseEntity<String> aiFeedback(@RequestBody Map<String, Object> requestBody) {
        try {
            String question = (String) requestBody.get("question");
            String answer = (String) requestBody.get("answer");
            Long selfIdx = Long.valueOf(requestBody.get("self_idx").toString());
            String isJobQuestion = (String) requestBody.get("isJobQuestion");

            // HTTP 헤더 설정 수정
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON_UTF8);  // UTF-8 명시적 설정
            headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON_UTF8));

            // RestTemplate 설정 추가 (Bean 설정으로 이동하는 것을 권장)
            restTemplate.getMessageConverters()
                    .add(0, new StringHttpMessageConverter(StandardCharsets.UTF_8));

            // FastAPI 서버로 요청을 보낼 데이터 구성
            Map<String, Object> feedbackRequest = new HashMap<>();
            feedbackRequest.put("question", question);
            feedbackRequest.put("answer", answer);
            feedbackRequest.put("self_idx", selfIdx);
            feedbackRequest.put("isJobQuestion", isJobQuestion);

            // HttpEntity 객체 생성
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(feedbackRequest, headers);

            // exchange() 대신 postForEntity() 사용
            ResponseEntity<Map> response = restTemplate.postForEntity(
                    FASTAPI_URL2,
                    new HttpEntity<>(feedbackRequest, headers),
                    Map.class
            );

            // 응답 로깅
            log.debug("Request Headers: " + headers);
            log.debug("Request Body: " + feedbackRequest);
            log.debug("Response Status: " + response.getStatusCode());
            log.debug("Response Headers: " + response.getHeaders());
            log.debug("Response Body: " + response.getBody());

            // 응답 상태 확인
            if (response.getStatusCode() != HttpStatus.OK) {
                log.error("FastAPI 응답 상태 코드: " + response.getStatusCode());
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
            }

            Map<String, Object> responseBody = response.getBody();
            if (responseBody == null) {
                log.error("FastAPI 응답 본문이 null입니다.");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
            }

            String feedback = (String) responseBody.get("feedback");
            return ResponseEntity.ok(feedback);
        } catch (Exception e) {
            log.error("피드백 처리 오류", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/ai_question")
    public String aiQuestion(@RequestParam(name="selfIdx", required = false) Long selfIdx, Model model) {
        try {
            // selfIdx가 있는 경우 해당 selfIdx의 질문을 가져옵니다.
            if (selfIdx != null) {
                List<Map<String, Object>> questions = questionService.getQuestionsBySelfIdx(selfIdx);
                model.addAttribute("questions", questions);
                model.addAttribute("selfIdx", selfIdx);
            } else {
                model.addAttribute("message", "selfIdx가 지정되지 않았습니다.");
            }
            return "aiboard/ai_question";
        } catch (Exception e) {
            log.error("Error loading questions for aiQuestion", e);
            model.addAttribute("error", "오류가 발생했습니다.");
            return "aiboard/ai_question";
        }
    }

    @GetMapping("/ai_check")
    public String aiCheck(@RequestParam(name="selfIdx", required = false) Long selfIdx, Model model) {
        try {
            if (selfIdx != null) {
                List<Map<String, Object>> questions = questionService.getQuestionsBySelfIdx(selfIdx);
                System.out.println("Loaded questions: " + questions); // 임시로 콘솔에 출력
                model.addAttribute("questions", questions);
                model.addAttribute("selfIdx", selfIdx);
            } else {
                model.addAttribute("message", "selfIdx가 지정되지 않았습니다.");
            }
            return "aiboard/ai_check";
        } catch (Exception e) {
            e.printStackTrace(); // 예외 스택 트레이스 출력
            model.addAttribute("error", "오류가 발생했습니다.");
            return "aiboard/ai_check";
        }
    }

    @GetMapping("/ai_preparation")
    public String showInterviewPrep(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        model.addAttribute("member", Map.of("name", username));
        selfBoardService.listByUsername(model, username);
        return "aiboard/ai_preparation";
    }

    @PostMapping("/api/interview")
    @ResponseBody
    public ResponseEntity<AIInterviewDTO> startInterview(@RequestBody AIInterviewDTO requestDto) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            requestDto.setUsername(auth.getName());
            requestDto.setStatus(AIInterviewStatus.CREATED);
            requestDto.setInterviewDate(LocalDateTime.now());

            AIInterviewDTO createdInterview = interviewService.createInterview(requestDto);
            return ResponseEntity.ok(createdInterview);
        } catch (Exception e) {
            log.error("Error starting interview", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/api/interview/{username}/video")
    @ResponseBody
    public ResponseEntity<Map<String, String>> submitVideo(
            @PathVariable String username,
            @RequestParam("video") MultipartFile file,
            @RequestParam("questionNumber") Integer questionNumber,
            Authentication authentication) {
        try {
            // 현재 로그인한 사용자와 요청된 username이 일치하는지 확인
            if (!authentication.getName().equals(username)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(Map.of("error", "Unauthorized access"));
            }

            // 비디오 업로드 처리
            String videoUrl = interviewService.submitVideoResponse(username, file, questionNumber);

            return ResponseEntity.ok(Map.of(
                    "url", videoUrl,
                    "status", "success",
                    "message", "Video uploaded successfully"
            ));
        } catch (Exception e) {
            log.error("Error uploading video for user: " + username, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/api/virtual/interview")
    @ResponseBody
    public ResponseEntity<AIInterviewDTO> startVirtualInterview(@RequestBody AIInterviewDTO requestDto) {
        try {
            if (requestDto.getQuestions() == null ||
                    requestDto.getQuestions().size() < 1 ||
                    requestDto.getQuestions().size() > 6) {
                return ResponseEntity.badRequest().build();
            }

            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            requestDto.setUsername(auth.getName());
            requestDto.setStatus(AIInterviewStatus.CREATED);
            requestDto.setInterviewDate(LocalDateTime.now());

            AIInterviewDTO createdInterview = interviewService.createInterview(requestDto);
            return ResponseEntity.ok(createdInterview);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}