package com.ip_project.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.ip_project.entity.ReviewBoard;
import com.ip_project.service.ReviewBoardService;

import java.util.List;

@Controller
@RequestMapping("/review_board")
public class ReviewBoardController {

    @Autowired
    private ReviewBoardService service;

    @GetMapping("/list")
    public String list(Model model, @RequestParam(defaultValue = "1") int page) {
        int pageSize = 15; // 한 페이지당 게시글 수
        int totalCount = service.getTotalCount(); // 전체 게시글 수
        int totalPages = (int) Math.ceil((double) totalCount / pageSize); // 전체 페이지 수

        // 현재 페이지 그룹의 시작과 끝 페이지 계산
        int pageGroupSize = 10; // 페이지 그룹 크기
        int currentGroup = (int) Math.ceil((double) page / pageGroupSize);
        int groupStart = (currentGroup - 1) * pageGroupSize + 1;
        int groupEnd = Math.min(currentGroup * pageGroupSize, totalPages);

        List<ReviewBoard> list = service.getListByPage(page, pageSize);

        model.addAttribute("list", list);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("groupStart", groupStart);
        model.addAttribute("groupEnd", groupEnd);
        model.addAttribute("pageGroupSize", pageGroupSize);

        return "review_board/list";
    }

    @GetMapping("/get")
    @ResponseBody
    public ReviewBoard get(@RequestParam Long idx) {
        return service.get(idx);
    }

    @PostMapping("/register")
    public String register(@ModelAttribute ReviewBoard vo) {
        service.register(vo);
        return "redirect:list";
    }

    @PostMapping("/remove")
    public String remove(@RequestParam Long idx) {
        service.remove(idx);
        return "redirect:list";
    }
}