package com.champsoft.vrms1730298.modules.agents.infrastructure.persistence;


import jakarta.persistence.*;

@Entity
@Table(name = "agents")
public class AgentJpaEntity {
    @Id
    public String id;

    @Column(nullable = false)
    public String name;

    @Column(nullable = false)
    public String role;

    @Column(nullable = false)
    public String status;
}
