package com.champsoft.vrms1730298.modules.registration.application.port.out;

public interface VehicleEligibilityPort {
    boolean isEligible(String vehicleId);
}