package com.champsoft.vrms1730298.modules.registration.domain.exception;

public class ExpiryDateMustBeFutureException extends RuntimeException {
    public ExpiryDateMustBeFutureException(String message) { super(message); }
}
