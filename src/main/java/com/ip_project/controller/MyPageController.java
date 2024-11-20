package com.ip_project.controller;

import com.ip_project.dto.SelfIntroductionDTO;
import com.ip_project.entity.*;
import com.ip_project.repository.MemberRepository;
import com.ip_project.service.*;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.repository.query.Param;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/mypage")
@RequiredArgsConstructor
public class MyPageController {
    private final AIInterviewService interviewService;
    private final SelfBoardService selfBoardService;
    private final SelfIntroductionService selfIntroductionService;
    private final ReviewService reviewService;
    private final InterviewQuestionService interviewQuestionService;
    private final LikeCompanyService likeCompanyService;
    private final MemberRepository memberRepository;

    @GetMapping("/mypage")
    public String myPage(Model model) {
        try {
            // 현재 로그인한 사용자의 username 가져오기
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String username = authentication.getName();

            // 해당 사용자의 면접 목록 가져오기
            selfBoardService.listByUsername(model, username);
            reviewService.listByUsername(model, username);
            interviewQuestionService.listByUsername(model, username);

            return "mypage/mypage";
        } catch (Exception e) {
            // 에러 로깅
            e.printStackTrace();
            model.addAttribute("error", "페이지를 로드하는 중 오류가 발생했습니다.");
            return "error/error";
        }
    }

    @RestController
    @RequestMapping("/api/mypage")
    @RequiredArgsConstructor
    public static class MyPageApiController {
        private final InterviewQuestionService interviewQuestionService;

        @GetMapping("/interview-videos/{selfIdx}")
        public ResponseEntity<List<Map<String, Object>>> getInterviewVideos(@PathVariable Long selfIdx) {
            try {
                List<InterviewPro> questions = interviewQuestionService.getInterviewProBySelfIdx(selfIdx);

                List<Map<String, Object>> videoInfo = questions.stream()
                        .map(q -> {
                            Map<String, Object> info = new HashMap<>();
                            info.put("questionNumber", q.getIproIdx());
                            info.put("question", q.getIproQuestion());
                            info.put("answer", q.getIproAnswer());
                            String videoUrl = String.format("/interview-videos/interview_%d_%d.webm",
                                    selfIdx, q.getIproIdx());
                            info.put("videoUrl", videoUrl);
                            return info;
                        })
                        .collect(Collectors.toList());

                return ResponseEntity.ok(videoInfo);
            } catch (Exception e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
            }
        }
    }

    @GetMapping("/interview-videos/{selfIdx}")
    public ResponseEntity<List<Map<String, Object>>> getInterviewVideos(@PathVariable Long selfIdx) {
        try {
            List<InterviewPro> questions = interviewQuestionService.getInterviewProBySelfIdx(selfIdx);

            List<Map<String, Object>> videoInfo = questions.stream()
                    .map(q -> {
                        Map<String, Object> info = new HashMap<>();
                        info.put("questionNumber", q.getIproIdx());
                        info.put("question", q.getIproQuestion());
                        info.put("answer", q.getIproAnswer());

                        // S3 URL 생성
                        String videoUrl = String.format("https://iproproject.s3.ap-southeast-2.amazonaws.com/interviews/%d_%d.webm",
                                selfIdx, q.getIproIdx());
                        info.put("videoUrl", videoUrl);

                        return info;
                    })
                    .collect(Collectors.toList());

            return ResponseEntity.ok(videoInfo);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/mypagevidlist")
    public String myPagevidlist(Model model) {
        // 현재 로그인한 사용자의 username 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();

        interviewQuestionService.listByUsername(model, username);
        return "mypage/mypagevidlist";
    }

    @PostMapping("/updateIntroduction")
    public ResponseEntity<?> updateIntroduction(@RequestBody SelfIntroductionDTO selfIntroDto) {
        SelfBoard selfBoard = selfBoardService.findById(selfIntroDto.getIdx());

        // SelfBoard 필드 업데이트 (제목, 회사, 직무, 작성일)
        selfBoard.setSelfCompany(selfIntroDto.getCompany());
        selfBoard.setSelfTitle(selfIntroDto.getTitle());
        selfBoard.setSelfPosition(selfIntroDto.getPosition());
        selfBoard.setSelfDate(LocalDateTime.now()); // 현재 날짜로 설정
        // SelfBoard 저장
        selfBoardService.save(selfBoard);

        // SelfIntroduction 객체 업데이트
        List<SelfIntroduction> existingIntroductions = selfIntroductionService.findBySelfBoard(selfBoard);

        for (int i = 0; i < selfIntroDto.getQuestions().size(); i++) {
            // 기존 질문이 있는 경우 업데이트
            if (i < existingIntroductions.size()) {
                SelfIntroduction selfIntroduction = existingIntroductions.get(i);
                selfIntroduction.setIntroQuestion(selfIntroDto.getQuestions().get(i));
                selfIntroduction.setIntroAnswer(selfIntroDto.getAnswers().get(i));

                selfIntroductionService.saveSelfIntroduction(selfIntroduction); // 업데이트 후 저장
            } else {
                // 추가를 허용하지 않으므로 이 부분은 삭제합니다.
                // 새로 생성하는 로직은 필요 없음
            }
        }
        return ResponseEntity.ok().build();
    }

    @GetMapping("/mypageint")
    public String myPageIntroduction(Model model) {
        // 현재 사용자 인증 객체에서 username 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName(); // 현재 사용자의 username
        selfBoardService.listByUsername(model, username);
        return "mypage/mypageint";
    }

    @GetMapping("/mypagevid")
    public String myPageInterview(@RequestParam("selfIdx") Long selfIdx, Model model) {
        // selfIdx를 통해 데이터를 조회
        List<InterviewPro> interviewProList = interviewQuestionService.getInterviewProBySelfIdx(selfIdx);

        // 조회한 데이터를 모델에 추가
        model.addAttribute("ipros", interviewProList);
        model.addAttribute("selfIdx", selfIdx);  // selfIdx 추가

        // S3 기본 URL 추가
        model.addAttribute("s3BaseUrl", "https://iproproject.s3.ap-southeast-2.amazonaws.com/interviews/");

        return "mypage/mypagevid";
    }

    @GetMapping("/myprofile")
    public String myPageMember(Model model) {
        return "mypage/myprofile";
    }

    @GetMapping("/mypagelist/{idx}")
    public ModelAndView myPageList(@PathVariable("idx") Long idx) {
        ModelAndView modelAndView = new ModelAndView();
        try {
            SelfBoard selfBoard = selfBoardService.findById(idx);
            if (selfBoard == null) {
                modelAndView.setViewName("error/404");
                return modelAndView;
            }
            SelfIntroductionDTO dto = selfIntroductionService.getSelfIntroductions(selfBoard);
            // 모델에 데이터 추가 후 페이지 설정
            modelAndView.addObject("selfIntroduction", dto);
            modelAndView.setViewName("mypage/mypagelist"); // 이동할 페이지 이름 설정
            return modelAndView;
        } catch (Exception e) {
            modelAndView.setViewName("error/500");
        }
        return modelAndView;
    }

    @GetMapping("/remove/{idx}")
    public String remove(@PathVariable("idx") Long idx) {
        SelfBoard selfBoard = selfBoardService.findById(idx);
        if (selfBoard == null) {
            // 해당 데이터가 없을 때의 처리
            throw new EntityNotFoundException("SelfBoard with ID " + idx + " not found.");
        }
        selfIntroductionService.deleteSelfIntroduction(selfBoard);
        selfBoardService.deleteById(idx);
        return "redirect:/mypage/mypageint";
    }

    // 관심 기업 목록을 모든 요청에 모델에 추가
    @ModelAttribute("favoriteCompanies")
    public List<LikeCompany> addFavoriteCompaniesToModel() {
        // 현재 로그인한 사용자의 username 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();

        // 해당 사용자의 관심 기업 목록 가져오기
        return likeCompanyService.getFavoriteCompanies(username);
    }


    @PostMapping("/favorites/remove")
    public String removeFavoriteCompany(@RequestParam("companyIdx") Long companyIdx) {
        // 현재 로그인한 사용자의 username 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();

        likeCompanyService.removeFavoriteCompany(username, companyIdx);

        return "redirect:/mypage/mypage";
    }

    //자소서 저장
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

        return "redirect:/mypage/mypageint";
    }
}