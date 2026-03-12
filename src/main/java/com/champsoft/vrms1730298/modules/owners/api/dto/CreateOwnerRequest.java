package com.champsoft.vrms1730298.modules.owners.api.dto;

import jakarta.validation.constraints.NotBlank;

public record CreateOwnerRequest(
        @NotBlank String fullName,
        String address) {}