package com.champsoft.vrms1730298.modules.owners.api;

import com.champsoft.vrms1730298.modules.owners.application.exception.DuplicateOwnerException;
import com.champsoft.vrms1730298.modules.owners.application.exception.OwnerNotFoundException;
import com.champsoft.vrms1730298.modules.owners.domain.exception.InvalidAddressException;
import com.champsoft.vrms1730298.modules.owners.domain.exception.InvalidOwnerNameException;
import com.champsoft.vrms1730298.shared.web.ApiErrorResponse;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;

@RestControllerAdvice(assignableTypes = OwnerController.class)
public class OwnerExceptionHandler {

    @ExceptionHandler(OwnerNotFoundException.class)
    public ResponseEntity<ApiErrorResponse> notFound(OwnerNotFoundException ex, HttpServletRequest req) {
        return build(HttpStatus.NOT_FOUND, ex, req);
    }

    @ExceptionHandler(DuplicateOwnerException.class)
    public ResponseEntity<ApiErrorResponse> conflict(DuplicateOwnerException ex, HttpServletRequest req) {
        return build(HttpStatus.CONFLICT, ex, req);
    }

    @ExceptionHandler({
            InvalidOwnerNameException.class,
            InvalidAddressException.class,
            IllegalArgumentException.class
    })
    public ResponseEntity<ApiErrorResponse> badRequest(RuntimeException ex, HttpServletRequest req) {
        return build(HttpStatus.BAD_REQUEST, ex, req);
    }

    private ResponseEntity<ApiErrorResponse> build(HttpStatus status, Exception ex, HttpServletRequest req) {
        var body = new ApiErrorResponse(
                Instant.now(),
                status.value(),
                status.getReasonPhrase(),
                ex.getMessage(),
                req.getRequestURI()
        );
        return ResponseEntity.status(status).body(body);
    }
}