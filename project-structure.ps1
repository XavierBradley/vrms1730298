$ErrorActionPreference = "Stop"

# ==========================================================
# vrms1730298 Scaffolder (PowerShell) - RUN FROM PROJECT ROOT
# - Put this file next to build.gradle
# - Run: powershell -ExecutionPolicy Bypass -File project-structure.ps1
# - Creates folders + ALL Java files with correct packages
# - Does NOT overwrite existing files (safe)
# ==========================================================

$base = "src/main/java/com/champsoft/vrms1730298"

function RemoveDefaultvrms1730298ApplicationIfExists() {
    $defaultPath = Join-Path $base "vrms1730298Application.java"

    if (Test-Path $defaultPath) {
        $content = Get-Content $defaultPath -Raw

        # Only delete if it looks like the default Spring Boot main class
        $looksDefault =
            ($content -match 'package\s+com\.champsoft\.vrms1730298\s*;') -and
            ($content -match 'class\s+vrms1730298Application') -and
            ($content -match '@SpringBootApplication') -and
            ($content -match 'SpringApplication\.run\(vrms1730298Application\.class')

        if ($looksDefault) {
            Remove-Item $defaultPath -Force
            Write-Host "🧹 Removed default vrms1730298Application.java at: $defaultPath"
        } else {
            Write-Host "⚠️ Found $defaultPath but did NOT delete (content not recognized as default)."
        }
    }
}

function RemoveApplicationPropertiesIfExists() {
    $path = "src/main/resources/application.properties"

    if (Test-Path $path) {
        $content = Get-Content $path -Raw

        # Consider it removable if empty or looks like default boilerplate
        $looksDefault =
            ($content.Trim().Length -eq 0) -or
            ($content -match 'spring\.application\.name') -or
            ($content -match 'server\.port') -or
            ($content -match 'spring\.profiles\.active')

        if ($looksDefault) {
            Remove-Item $path -Force
            Write-Host "🧹 Removed application.properties (using application.yml instead)"
        } else {
            Write-Host "⚠️ application.properties exists but was NOT removed (custom content detected)"
        }
    }
}

function MkDir($p) {
    New-Item -ItemType Directory -Force -Path $p | Out-Null
}

function WriteFile($path, $content) {
    if (-not (Test-Path $path)) {
        $dir = Split-Path $path
        MkDir $dir
        Set-Content -Path $path -Value $content -Encoding UTF8
    }
}

function EnsureProjectRoot() {
    if (-not (Test-Path "build.gradle")) {
        throw "build.gradle not found. Run this script from the project root (same folder as build.gradle)."
    }
}

EnsureProjectRoot

# ---------------- folders ----------------
MkDir "src/main/resources/db/migration"
MkDir "$base/app"
MkDir "$base/shared/config"
MkDir "$base/shared/web"

$modules = @("cars", "owners", "agents", "registration")
foreach ($m in $modules) {
    MkDir "$base/modules/$m/domain/model"
    MkDir "$base/modules/$m/domain/exception"
    MkDir "$base/modules/$m/application/port/out"
    MkDir "$base/modules/$m/application/service"
    MkDir "$base/modules/$m/application/exception"
    MkDir "$base/modules/$m/infrastructure/persistence"
    MkDir "$base/modules/$m/api/mapper"
    MkDir "$base/modules/$m/api/dto"
}
MkDir "$base/modules/registration/infrastructure/acl"

# ---------------- resources ----------------
RemoveApplicationPropertiesIfExists

WriteFile "src/main/resources/application.yml" @"
spring:
  application:
    name: vrms1730298

# TODO: add datasource, flyway, etc.
"@

WriteFile "src/main/resources/db/migration/V1__init.sql" @"
-- TODO: Flyway init schema (tables for vehicle/owner/agent/registration)
"@

# ==========================================================
# app + shared
# ==========================================================
RemoveDefaultvrms1730298ApplicationIfExists

WriteFile "$base/app/vrms1730298Application.java" @"
package com.champsoft.vrms1730298.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class vrms1730298Application {

    public static void main(String[] args) {
        SpringApplication.run(vrms1730298Application.class, args);
    }
}
"@

WriteFile "$base/shared/config/WebConfig.java" @"
package com.champsoft.vrms1730298.shared.config;

public class WebConfig {
    // TODO: CORS, interceptors, formatters (optional)
}
"@

WriteFile "$base/shared/config/OpenApiConfig.java" @"
package com.champsoft.vrms1730298.shared.config;

public class OpenApiConfig {
    // TODO: Swagger/OpenAPI config (optional)
}
"@

WriteFile "$base/shared/web/ApiErrorResponse.java" @"
package com.champsoft.vrms1730298.shared.web;

public record ApiErrorResponse(String message, String code) { }
"@

WriteFile "$base/shared/web/GlobalExceptionHandler.java" @"
package com.champsoft.vrms1730298.shared.web;

public class GlobalExceptionHandler {
    // TODO: generic fallback only
}
"@

# ==========================================================
# cars
# ==========================================================
WriteFile "$base/modules/cars/domain/model/Vehicle.java" @"
package com.champsoft.vrms1730298.modules.cars.domain.model;

public class Vehicle {
}
"@

WriteFile "$base/modules/cars/domain/model/VehicleId.java" @"
package com.champsoft.vrms1730298.modules.cars.domain.model;

public record VehicleId(String value) { }
"@

WriteFile "$base/modules/cars/domain/model/Vin.java" @"
package com.champsoft.vrms1730298.modules.cars.domain.model;

public record Vin(String value) { }
"@

WriteFile "$base/modules/cars/domain/model/VehicleSpecs.java" @"
package com.champsoft.vrms1730298.modules.cars.domain.model;

public class VehicleSpecs {
}
"@

WriteFile "$base/modules/cars/domain/model/VehicleStatus.java" @"
package com.champsoft.vrms1730298.modules.cars.domain.model;

public enum VehicleStatus {
    DRAFT, ACTIVE, SUSPENDED
}
"@

WriteFile "$base/modules/cars/domain/exception/InvalidVinException.java" @"
package com.champsoft.vrms1730298.modules.cars.domain.exception;

public class InvalidVinException extends RuntimeException {
    public InvalidVinException(String message) { super(message); }
}
"@

WriteFile "$base/modules/cars/domain/exception/InvalidVehicleYearException.java" @"
package com.champsoft.vrms1730298.modules.cars.domain.exception;

public class InvalidVehicleYearException extends RuntimeException {
    public InvalidVehicleYearException(String message) { super(message); }
}
"@

WriteFile "$base/modules/cars/domain/exception/VehicleAlreadyActiveException.java" @"
package com.champsoft.vrms1730298.modules.cars.domain.exception;

public class VehicleAlreadyActiveException extends RuntimeException {
    public VehicleAlreadyActiveException(String message) { super(message); }
}
"@

WriteFile "$base/modules/cars/domain/exception/VehicleNotValidatedException.java" @"
package com.champsoft.vrms1730298.modules.cars.domain.exception;

public class VehicleNotValidatedException extends RuntimeException {
    public VehicleNotValidatedException(String message) { super(message); }
}
"@

WriteFile "$base/modules/cars/application/port/out/VehicleRepositoryPort.java" @"
package com.champsoft.vrms1730298.modules.cars.application.port.out;

public interface VehicleRepositoryPort {
}
"@

WriteFile "$base/modules/cars/application/service/VehicleCrudService.java" @"
package com.champsoft.vrms1730298.modules.cars.application.service;

public class VehicleCrudService {
}
"@

WriteFile "$base/modules/cars/application/service/VehicleEligibilityService.java" @"
package com.champsoft.vrms1730298.modules.cars.application.service;

public class VehicleEligibilityService {
}
"@

WriteFile "$base/modules/cars/application/exception/VehicleNotFoundException.java" @"
package com.champsoft.vrms1730298.modules.cars.application.exception;

public class VehicleNotFoundException extends RuntimeException {
    public VehicleNotFoundException(String message) { super(message); }
}
"@

WriteFile "$base/modules/cars/application/exception/DuplicateVinException.java" @"
package com.champsoft.vrms1730298.modules.cars.application.exception;

public class DuplicateVinException extends RuntimeException {
    public DuplicateVinException(String message) { super(message); }
}
"@

WriteFile "$base/modules/cars/infrastructure/persistence/VehicleJpaEntity.java" @"
package com.champsoft.vrms1730298.modules.cars.infrastructure.persistence;

public class VehicleJpaEntity {
}
"@

WriteFile "$base/modules/cars/infrastructure/persistence/SpringDataVehicleRepository.java" @"
package com.champsoft.vrms1730298.modules.cars.infrastructure.persistence;

public interface SpringDataVehicleRepository {
}
"@

WriteFile "$base/modules/cars/infrastructure/persistence/JpaVehicleRepositoryAdapter.java" @"
package com.champsoft.vrms1730298.modules.cars.infrastructure.persistence;

public class JpaVehicleRepositoryAdapter {
}
"@

WriteFile "$base/modules/cars/api/VehicleController.java" @"
package com.champsoft.vrms1730298.modules.cars.api;

public class VehicleController {
}
"@

WriteFile "$base/modules/cars/api/VehicleExceptionHandler.java" @"
package com.champsoft.vrms1730298.modules.cars.api;

public class VehicleExceptionHandler {
}
"@

WriteFile "$base/modules/cars/api/mapper/VehicleApiMapper.java" @"
package com.champsoft.vrms1730298.modules.cars.api.mapper;

public class VehicleApiMapper {
}
"@

WriteFile "$base/modules/cars/api/dto/CreateVehicleRequest.java" @"
package com.champsoft.vrms1730298.modules.cars.api.dto;

public record CreateVehicleRequest(String vin) { }
"@

WriteFile "$base/modules/cars/api/dto/UpdateVehicleRequest.java" @"
package com.champsoft.vrms1730298.modules.cars.api.dto;

public record UpdateVehicleRequest(String status) { }
"@

WriteFile "$base/modules/cars/api/dto/VehicleResponse.java" @"
package com.champsoft.vrms1730298.modules.cars.api.dto;

public record VehicleResponse(String id, String vin, String status) { }
"@

# ==========================================================
# owners
# ==========================================================
WriteFile "$base/modules/owners/domain/model/Owner.java" @"
package com.champsoft.vrms1730298.modules.owners.domain.model;

public class Owner {
}
"@

WriteFile "$base/modules/owners/domain/model/OwnerId.java" @"
package com.champsoft.vrms1730298.modules.owners.domain.model;

public record OwnerId(String value) { }
"@

WriteFile "$base/modules/owners/domain/model/FullName.java" @"
package com.champsoft.vrms1730298.modules.owners.domain.model;

public record FullName(String value) { }
"@

WriteFile "$base/modules/owners/domain/model/Address.java" @"
package com.champsoft.vrms1730298.modules.owners.domain.model;

public class Address {
}
"@

WriteFile "$base/modules/owners/domain/model/OwnerStatus.java" @"
package com.champsoft.vrms1730298.modules.owners.domain.model;

public enum OwnerStatus {
    ACTIVE, SUSPENDED
}
"@

WriteFile "$base/modules/owners/domain/exception/InvalidOwnerNameException.java" @"
package com.champsoft.vrms1730298.modules.owners.domain.exception;

public class InvalidOwnerNameException extends RuntimeException {
    public InvalidOwnerNameException(String message) { super(message); }
}
"@

WriteFile "$base/modules/owners/domain/exception/InvalidAddressException.java" @"
package com.champsoft.vrms1730298.modules.owners.domain.exception;

public class InvalidAddressException extends RuntimeException {
    public InvalidAddressException(String message) { super(message); }
}
"@

WriteFile "$base/modules/owners/domain/exception/OwnerNotEligibleException.java" @"
package com.champsoft.vrms1730298.modules.owners.domain.exception;

public class OwnerNotEligibleException extends RuntimeException {
    public OwnerNotEligibleException(String message) { super(message); }
}
"@

WriteFile "$base/modules/owners/application/port/out/OwnerRepositoryPort.java" @"
package com.champsoft.vrms1730298.modules.owners.application.port.out;

public interface OwnerRepositoryPort {
}
"@

WriteFile "$base/modules/owners/application/service/OwnerCrudService.java" @"
package com.champsoft.vrms1730298.modules.owners.application.service;

public class OwnerCrudService {
}
"@

WriteFile "$base/modules/owners/application/service/OwnerEligibilityService.java" @"
package com.champsoft.vrms1730298.modules.owners.application.service;

public class OwnerEligibilityService {
}
"@

WriteFile "$base/modules/owners/application/exception/OwnerNotFoundException.java" @"
package com.champsoft.vrms1730298.modules.owners.application.exception;

public class OwnerNotFoundException extends RuntimeException {
    public OwnerNotFoundException(String message) { super(message); }
}
"@

WriteFile "$base/modules/owners/application/exception/DuplicateOwnerException.java" @"
package com.champsoft.vrms1730298.modules.owners.application.exception;

public class DuplicateOwnerException extends RuntimeException {
    public DuplicateOwnerException(String message) { super(message); }
}
"@

WriteFile "$base/modules/owners/infrastructure/persistence/OwnerJpaEntity.java" @"
package com.champsoft.vrms1730298.modules.owners.infrastructure.persistence;

public class OwnerJpaEntity {
}
"@

WriteFile "$base/modules/owners/infrastructure/persistence/SpringDataOwnerRepository.java" @"
package com.champsoft.vrms1730298.modules.owners.infrastructure.persistence;

public interface SpringDataOwnerRepository {
}
"@

WriteFile "$base/modules/owners/infrastructure/persistence/JpaOwnerRepositoryAdapter.java" @"
package com.champsoft.vrms1730298.modules.owners.infrastructure.persistence;

public class JpaOwnerRepositoryAdapter {
}
"@

WriteFile "$base/modules/owners/api/OwnerController.java" @"
package com.champsoft.vrms1730298.modules.owners.api;

public class OwnerController {
}
"@

WriteFile "$base/modules/owners/api/OwnerExceptionHandler.java" @"
package com.champsoft.vrms1730298.modules.owners.api;

public class OwnerExceptionHandler {
}
"@

WriteFile "$base/modules/owners/api/mapper/OwnerApiMapper.java" @"
package com.champsoft.vrms1730298.modules.owners.api.mapper;

public class OwnerApiMapper {
}
"@

WriteFile "$base/modules/owners/api/dto/CreateOwnerRequest.java" @"
package com.champsoft.vrms1730298.modules.owners.api.dto;

public record CreateOwnerRequest(String fullName) { }
"@

WriteFile "$base/modules/owners/api/dto/UpdateOwnerRequest.java" @"
package com.champsoft.vrms1730298.modules.owners.api.dto;

public record UpdateOwnerRequest(String status) { }
"@

WriteFile "$base/modules/owners/api/dto/OwnerResponse.java" @"
package com.champsoft.vrms1730298.modules.owners.api.dto;

public record OwnerResponse(String id, String fullName, String status) { }
"@

# ==========================================================
# agents
# ==========================================================
WriteFile "$base/modules/agents/domain/model/Agent.java" @"
package com.champsoft.vrms1730298.modules.agents.domain.model;

public class Agent {
}
"@

WriteFile "$base/modules/agents/domain/model/AgentId.java" @"
package com.champsoft.vrms1730298.modules.agents.domain.model;

public record AgentId(String value) { }
"@

WriteFile "$base/modules/agents/domain/model/Role.java" @"
package com.champsoft.vrms1730298.modules.agents.domain.model;

public record Role(String value) { }
"@

WriteFile "$base/modules/agents/domain/model/AgentStatus.java" @"
package com.champsoft.vrms1730298.modules.agents.domain.model;

public enum AgentStatus {
    ACTIVE, SUSPENDED
}
"@

WriteFile "$base/modules/agents/domain/exception/InvalidRoleException.java" @"
package com.champsoft.vrms1730298.modules.agents.domain.exception;

public class InvalidRoleException extends RuntimeException {
    public InvalidRoleException(String message) { super(message); }
}
"@

WriteFile "$base/modules/agents/domain/exception/AgentNotEligibleException.java" @"
package com.champsoft.vrms1730298.modules.agents.domain.exception;

public class AgentNotEligibleException extends RuntimeException {
    public AgentNotEligibleException(String message) { super(message); }
}
"@

WriteFile "$base/modules/agents/application/port/out/AgentRepositoryPort.java" @"
package com.champsoft.vrms1730298.modules.agents.application.port.out;

public interface AgentRepositoryPort {
}
"@

WriteFile "$base/modules/agents/application/service/AgentCrudService.java" @"
package com.champsoft.vrms1730298.modules.agents.application.service;

public class AgentCrudService {
}
"@

WriteFile "$base/modules/agents/application/service/AgentEligibilityService.java" @"
package com.champsoft.vrms1730298.modules.agents.application.service;

public class AgentEligibilityService {
}
"@

WriteFile "$base/modules/agents/application/exception/AgentNotFoundException.java" @"
package com.champsoft.vrms1730298.modules.agents.application.exception;

public class AgentNotFoundException extends RuntimeException {
    public AgentNotFoundException(String message) { super(message); }
}
"@

WriteFile "$base/modules/agents/application/exception/DuplicateAgentException.java" @"
package com.champsoft.vrms1730298.modules.agents.application.exception;

public class DuplicateAgentException extends RuntimeException {
    public DuplicateAgentException(String message) { super(message); }
}
"@

WriteFile "$base/modules/agents/infrastructure/persistence/AgentJpaEntity.java" @"
package com.champsoft.vrms1730298.modules.agents.infrastructure.persistence;

public class AgentJpaEntity {
}
"@

WriteFile "$base/modules/agents/infrastructure/persistence/SpringDataAgentRepository.java" @"
package com.champsoft.vrms1730298.modules.agents.infrastructure.persistence;

public interface SpringDataAgentRepository {
}
"@

WriteFile "$base/modules/agents/infrastructure/persistence/JpaAgentRepositoryAdapter.java" @"
package com.champsoft.vrms1730298.modules.agents.infrastructure.persistence;

public class JpaAgentRepositoryAdapter {
}
"@

WriteFile "$base/modules/agents/api/AgentController.java" @"
package com.champsoft.vrms1730298.modules.agents.api;

public class AgentController {
}
"@

WriteFile "$base/modules/agents/api/AgentExceptionHandler.java" @"
package com.champsoft.vrms1730298.modules.agents.api;

public class AgentExceptionHandler {
}
"@

WriteFile "$base/modules/agents/api/mapper/AgentApiMapper.java" @"
package com.champsoft.vrms1730298.modules.agents.api.mapper;

public class AgentApiMapper {
}
"@

WriteFile "$base/modules/agents/api/dto/CreateAgentRequest.java" @"
package com.champsoft.vrms1730298.modules.agents.api.dto;

public record CreateAgentRequest(String role) { }
"@

WriteFile "$base/modules/agents/api/dto/UpdateAgentRequest.java" @"
package com.champsoft.vrms1730298.modules.agents.api.dto;

public record UpdateAgentRequest(String status) { }
"@

WriteFile "$base/modules/agents/api/dto/AgentResponse.java" @"
package com.champsoft.vrms1730298.modules.agents.api.dto;

public record AgentResponse(String id, String role, String status) { }
"@

# ==========================================================
# registration
# ==========================================================
WriteFile "$base/modules/registration/domain/model/Registration.java" @"
package com.champsoft.vrms1730298.modules.registration.domain.model;

public class Registration {
}
"@

WriteFile "$base/modules/registration/domain/model/RegistrationId.java" @"
package com.champsoft.vrms1730298.modules.registration.domain.model;

public record RegistrationId(String value) { }
"@

WriteFile "$base/modules/registration/domain/model/VehicleRef.java" @"
package com.champsoft.vrms1730298.modules.registration.domain.model;

public record VehicleRef(String vehicleId) { }
"@

WriteFile "$base/modules/registration/domain/model/OwnerRef.java" @"
package com.champsoft.vrms1730298.modules.registration.domain.model;

public record OwnerRef(String ownerId) { }
"@

WriteFile "$base/modules/registration/domain/model/AgentRef.java" @"
package com.champsoft.vrms1730298.modules.registration.domain.model;

public record AgentRef(String agentId) { }
"@

WriteFile "$base/modules/registration/domain/model/PlateNumber.java" @"
package com.champsoft.vrms1730298.modules.registration.domain.model;

public record PlateNumber(String value) { }
"@

WriteFile "$base/modules/registration/domain/model/ExpiryDate.java" @"
package com.champsoft.vrms1730298.modules.registration.domain.model;

import java.time.LocalDate;

public record ExpiryDate(LocalDate value) { }
"@

WriteFile "$base/modules/registration/domain/model/RegistrationStatus.java" @"
package com.champsoft.vrms1730298.modules.registration.domain.model;

public enum RegistrationStatus {
    DRAFT, ACTIVE, CANCELLED, EXPIRED
}
"@

WriteFile "$base/modules/registration/domain/exception/InvalidPlateException.java" @"
package com.champsoft.vrms1730298.modules.registration.domain.exception;

public class InvalidPlateException extends RuntimeException {
    public InvalidPlateException(String message) { super(message); }
}
"@

WriteFile "$base/modules/registration/domain/exception/ExpiryDateMustBeFutureException.java" @"
package com.champsoft.vrms1730298.modules.registration.domain.exception;

public class ExpiryDateMustBeFutureException extends RuntimeException {
    public ExpiryDateMustBeFutureException(String message) { super(message); }
}
"@

WriteFile "$base/modules/registration/domain/exception/RegistrationNotActiveException.java" @"
package com.champsoft.vrms1730298.modules.registration.domain.exception;

public class RegistrationNotActiveException extends RuntimeException {
    public RegistrationNotActiveException(String message) { super(message); }
}
"@

WriteFile "$base/modules/registration/application/port/out/VehicleEligibilityPort.java" @"
package com.champsoft.vrms1730298.modules.registration.application.port.out;

public interface VehicleEligibilityPort {
}
"@

WriteFile "$base/modules/registration/application/port/out/OwnerEligibilityPort.java" @"
package com.champsoft.vrms1730298.modules.registration.application.port.out;

public interface OwnerEligibilityPort {
}
"@

WriteFile "$base/modules/registration/application/port/out/AgentEligibilityPort.java" @"
package com.champsoft.vrms1730298.modules.registration.application.port.out;

public interface AgentEligibilityPort {
}
"@

WriteFile "$base/modules/registration/application/port/out/RegistrationRepositoryPort.java" @"
package com.champsoft.vrms1730298.modules.registration.application.port.out;

public interface RegistrationRepositoryPort {
}
"@

WriteFile "$base/modules/registration/application/service/RegistrationCrudService.java" @"
package com.champsoft.vrms1730298.modules.registration.application.service;

public class RegistrationCrudService {
}
"@

WriteFile "$base/modules/registration/application/service/RegistrationOrchestrator.java" @"
package com.champsoft.vrms1730298.modules.registration.application.service;

public class RegistrationOrchestrator {
}
"@

WriteFile "$base/modules/registration/application/exception/PlateAlreadyTakenException.java" @"
package com.champsoft.vrms1730298.modules.registration.application.exception;

public class PlateAlreadyTakenException extends RuntimeException {
    public PlateAlreadyTakenException(String message) { super(message); }
}
"@

WriteFile "$base/modules/registration/application/exception/RegistrationNotFoundException.java" @"
package com.champsoft.vrms1730298.modules.registration.application.exception;

public class RegistrationNotFoundException extends RuntimeException {
    public RegistrationNotFoundException(String message) { super(message); }
}
"@

WriteFile "$base/modules/registration/application/exception/CrossContextValidationException.java" @"
package com.champsoft.vrms1730298.modules.registration.application.exception;

public class CrossContextValidationException extends RuntimeException {
    public CrossContextValidationException(String message) { super(message); }
}
"@

WriteFile "$base/modules/registration/infrastructure/persistence/RegistrationJpaEntity.java" @"
package com.champsoft.vrms1730298.modules.registration.infrastructure.persistence;

public class RegistrationJpaEntity {
}
"@

WriteFile "$base/modules/registration/infrastructure/persistence/SpringDataRegistrationRepository.java" @"
package com.champsoft.vrms1730298.modules.registration.infrastructure.persistence;

public interface SpringDataRegistrationRepository {
}
"@

WriteFile "$base/modules/registration/infrastructure/persistence/JpaRegistrationRepositoryAdapter.java" @"
package com.champsoft.vrms1730298.modules.registration.infrastructure.persistence;

public class JpaRegistrationRepositoryAdapter {
}
"@

WriteFile "$base/modules/registration/infrastructure/acl/VehicleEligibilityAdapter.java" @"
package com.champsoft.vrms1730298.modules.registration.infrastructure.acl;

public class VehicleEligibilityAdapter {
}
"@

WriteFile "$base/modules/registration/infrastructure/acl/OwnerEligibilityAdapter.java" @"
package com.champsoft.vrms1730298.modules.registration.infrastructure.acl;

public class OwnerEligibilityAdapter {
}
"@

WriteFile "$base/modules/registration/infrastructure/acl/AgentEligibilityAdapter.java" @"
package com.champsoft.vrms1730298.modules.registration.infrastructure.acl;

public class AgentEligibilityAdapter {
}
"@

WriteFile "$base/modules/registration/api/RegistrationController.java" @"
package com.champsoft.vrms1730298.modules.registration.api;

public class RegistrationController {
}
"@

WriteFile "$base/modules/registration/api/RegistrationExceptionHandler.java" @"
package com.champsoft.vrms1730298.modules.registration.api;

public class RegistrationExceptionHandler {
}
"@

WriteFile "$base/modules/registration/api/mapper/RegistrationApiMapper.java" @"
package com.champsoft.vrms1730298.modules.registration.api.mapper;

public class RegistrationApiMapper {
}
"@

WriteFile "$base/modules/registration/api/dto/RegisterVehicleRequest.java" @"
package com.champsoft.vrms1730298.modules.registration.api.dto;

public record RegisterVehicleRequest(String vehicleId, String ownerId, String agentId) { }
"@

WriteFile "$base/modules/registration/api/dto/RenewRegistrationRequest.java" @"
package com.champsoft.vrms1730298.modules.registration.api.dto;

public record RenewRegistrationRequest(String registrationId) { }
"@

WriteFile "$base/modules/registration/api/dto/CancelRegistrationRequest.java" @"
package com.champsoft.vrms1730298.modules.registration.api.dto;

public record CancelRegistrationRequest(String registrationId) { }
"@

WriteFile "$base/modules/registration/api/dto/RegistrationResponse.java" @"
package com.champsoft.vrms1730298.modules.registration.api.dto;

public record RegistrationResponse(String id, String plateNumber, String status) { }
"@

Write-Host ""
Write-Host "✅ vrms1730298 project structure generated successfully"
Write-Host ""