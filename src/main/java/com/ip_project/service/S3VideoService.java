package com.ip_project.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Slf4j
@Service
@RequiredArgsConstructor
public class S3VideoService {

    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    public String saveVideo(MultipartFile file, Long selfId, Long iproIdx) throws IOException {
        try {
            String fileName = String.format("interviews/%d_%d.webm", selfId, iproIdx);
            log.info("Saving video: {} (size: {} bytes)", fileName, file.getSize());

            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentType("video/webm");  // 명시적으로 content type 지정
            metadata.setContentLength(file.getSize());

            PutObjectRequest putObjectRequest = new PutObjectRequest(
                    bucket,
                    fileName,
                    file.getInputStream(),
                    metadata
            );

            amazonS3.putObject(putObjectRequest);
            String url = amazonS3.getUrl(bucket, fileName).toString();
            log.info("Successfully uploaded video to {}", url);

            return url;
        } catch (IOException e) {
            log.error("Failed to save video file to S3: {}", e.getMessage());
            throw new IOException("Could not store video file in S3", e);
        }
    }

    public void deleteVideo(Long selfId, Integer iproIdx) {
        try {
            String fileName = String.format("interviews/%d_%d.webm", selfId, iproIdx);
            amazonS3.deleteObject(bucket, fileName);
            log.info("Successfully deleted video from S3: {}", fileName);
        } catch (Exception e) {
            log.error("Error deleting video from S3", e);
        }
    }
}