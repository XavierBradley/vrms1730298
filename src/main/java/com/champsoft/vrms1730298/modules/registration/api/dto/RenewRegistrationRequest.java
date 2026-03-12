package com.champsoft.vrms1730298.modules.registration.api.dto;

import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;

public record RenewRegistrationRequest(@NotNull LocalDate newExpiry) {}