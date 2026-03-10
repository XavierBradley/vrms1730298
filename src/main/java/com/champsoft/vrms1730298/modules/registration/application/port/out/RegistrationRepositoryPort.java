package com.champsoft.vrms1730298.modules.registration.application.port.out;

import com.champsoft.vrms1730298.modules.registration.domain.model.Registration;
import com.champsoft.vrms1730298.modules.registration.domain.model.RegistrationId;

import java.util.List;
import java.util.Optional;

public interface RegistrationRepositoryPort {
    Registration save(Registration reg);
    Optional<Registration> findById(RegistrationId id);
    Optional<Registration> findByPlate(String plate);
    boolean existsByPlate(String plate);
    List<Registration> findAll();
    void deleteById(RegistrationId id);
}