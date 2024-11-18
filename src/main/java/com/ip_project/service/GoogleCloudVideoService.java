package com.ip_project.service;

import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

@Slf4j
@Service
public class GoogleCloudVideoService {

    @Value("${gcp.bucket.name}")
    private String bucketName;

    @Value("${gcp.project.id}")
    private String projectId;

    private final Storage storage;

    public GoogleCloudVideoService() {
        this.storage = StorageOptions.newBuilder()
                .setProjectId(projectId)
                .build()
                .getService();
    }

    public String saveVideo(String username, MultipartFile file, Long selfId, Integer questionNumber) throws IOException {
        try {
            // 사용자별 디렉토리 구조 생성
            String fileName = String.format("interviews/%s/%d/question_%d.webm",
                    username, selfId, questionNumber);

            // 파일 메타데이터 설정
            BlobId blobId = BlobId.of(bucketName, fileName);
            BlobInfo blobInfo = BlobInfo.newBuilder(blobId)
                    .setContentType("video/webm")
                    .build();

            // 파일 업로드
            storage.create(blobInfo, file.getBytes());

            // GCS에서 접근 가능한 URL 반환
            String publicUrl = String.format("https://storage.googleapis.com/%s/%s", bucketName, fileName);

            log.info("Video saved successfully to GCS: {}", publicUrl);
            return publicUrl;

        } catch (IOException e) {
            log.error("Failed to save video file to GCS", e);
            throw new IOException("Could not store video file in Google Cloud Storage", e);
        }
    }

    public void deleteVideo(String videoUrl) {
        try {
            // URL에서 파일 경로 추출
            String fileName = videoUrl.replace("https://storage.googleapis.com/" + bucketName + "/", "");
            BlobId blobId = BlobId.of(bucketName, fileName);

            boolean deleted = storage.delete(blobId);
            if (deleted) {
                log.info("Successfully deleted video from GCS: {}", fileName);
            } else {
                log.warn("Video file not found in GCS: {}", fileName);
            }
        } catch (Exception e) {
            log.error("Error deleting video from GCS", e);
        }
    }
}