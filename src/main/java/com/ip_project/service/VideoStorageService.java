package com.ip_project.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Slf4j
@Service
public class VideoStorageService {

    @Value("${video.storage.path:${user.home}/interview_videos}")
    private String storageLocation;

    public String saveVideo(String username, MultipartFile file, Long selfId, Integer questionNumber) throws IOException {
        try {
            // 기본 저장 디렉토리 생성
            Path storageDir = Paths.get(storageLocation);
            if (!Files.exists(storageDir)) {
                Files.createDirectories(storageDir);
            }

            // 사용자별 디렉토리 생성
            Path userDir = storageDir.resolve(username);
            if (!Files.exists(userDir)) {
                Files.createDirectories(userDir);
            }

            // 파일명: self_idx_questionNumber.webm
            String fileName = String.format("%d_%d.webm", selfId, questionNumber);
            Path destinationFile = userDir.resolve(fileName);

            // 파일 저장
            Files.copy(file.getInputStream(), destinationFile);

            log.info("Video saved successfully: {}", destinationFile);
            return username + "/" + fileName;

        } catch (IOException e) {
            log.error("Failed to save video file", e);
            throw new IOException("Could not store video file", e);
        }
    }
}