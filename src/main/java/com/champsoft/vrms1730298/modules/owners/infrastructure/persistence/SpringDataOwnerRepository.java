package com.champsoft.vrms1730298.modules.owners.infrastructure.persistence;

import org.springframework.data.jpa.repository.JpaRepository;

public interface SpringDataOwnerRepository extends JpaRepository<OwnerJpaEntity, String> {
    boolean existsByFullNameIgnoreCase(String fullName);
}