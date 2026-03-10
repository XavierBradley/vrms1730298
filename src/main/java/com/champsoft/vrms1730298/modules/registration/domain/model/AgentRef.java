package com.champsoft.vrms1730298.modules.registration.domain.model;

public record AgentRef(String value) {
    public AgentRef {
        if (value == null) throw new IllegalArgumentException("agentId is required");
        value = value.trim();
        if (value.isEmpty()) throw new IllegalArgumentException("agentId is required");
    }
}