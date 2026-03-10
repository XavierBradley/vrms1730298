package com.champsoft.vrms1730298.modules.cars.api;

import com.champsoft.vrms1730298.modules.cars.application.exception.DuplicateVinException;
import com.champsoft.vrms1730298.modules.cars.application.exception.VehicleNotFoundException;
import com.champsoft.vrms1730298.modules.cars.domain.exception.InvalidVehicleYearException;
import com.champsoft.vrms1730298.modules.cars.domain.exception.InvalidVinException;
import com.champsoft.vrms1730298.modules.cars.domain.exception.VehicleAlreadyActiveException;
import com.champsoft.vrms1730298.modules.cars.domain.exception.VehicleNotValidatedException;
import com.champsoft.vrms1730298.shared.web.ApiErrorResponse;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import java.time.Instant;

@RestControllerAdvice(assignableTypes = VehicleController.class)
public class VehicleExceptionHandler {
    @ExceptionHandler(VehicleNotFoundException.class)
    public ResponseEntity<ApiErrorResponse> notFound(VehicleNotFoundException ex, HttpServletRequest req) {
        return build(HttpStatus.NOT_FOUND, ex, req);
    }

    @ExceptionHandler(DuplicateVinException.class)
    public ResponseEntity<ApiErrorResponse> conflict(DuplicateVinException ex, HttpServletRequest req) {
        return build(HttpStatus.CONFLICT, ex, req);
    }

    @ExceptionHandler({
            InvalidVinException.class,
            InvalidVehicleYearException.class,
            VehicleAlreadyActiveException.class,
            VehicleNotValidatedException.class,
            IllegalArgumentException.class
    })
    public ResponseEntity<ApiErrorResponse> badRequest(RuntimeException ex, HttpServletRequest req) {
        return build(HttpStatus.BAD_REQUEST, ex, req);
    }

    @ExceptionHandler(org.springframework.web.bind.MethodArgumentNotValidException.class)

    public ResponseEntity<ApiErrorResponse>
    badRequest(org.springframework.web.bind.MethodArgumentNotValidException ex,
               HttpServletRequest req) {
        String message = ex.getBindingResult().getFieldErrors().stream()
                .findFirst()
                .map(err -> err.getField() + " " + err.getDefaultMessage())
                .orElse("Validation failed");
        return build(HttpStatus.BAD_REQUEST, new IllegalArgumentException(message), req);
    }

    private ResponseEntity<ApiErrorResponse> build(HttpStatus status, Exception ex, HttpServletRequest req)
    {
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
