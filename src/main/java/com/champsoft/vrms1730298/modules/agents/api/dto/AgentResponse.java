package com.champsoft.vrms1730298.modules.agents.api.dto;

public record AgentResponse(
        String id,
        String name,
        String role,
        String status) {}