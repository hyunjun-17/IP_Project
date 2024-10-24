package com.ip_project.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "MEMBER_SEQ")
    @SequenceGenerator(name = "MEMBER_SEQ", sequenceName = "MEMBER_SEQ", allocationSize = 1)
    private Long idx;

    private String username;
    private String password;
    private String name;
    private String email;
    private String phone;
    private String join_date;

    @Builder
    public Member(String username, String password, String name, String email, String phone, String join_date) {
        this.username = username;
        this.password = password;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.join_date = join_date;
    }
}