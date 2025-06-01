import ballerina/http;
import ballerina/jwt;
import ballerina/log;

public configurable JWTInterceptorConfig jwtInterceptorConfig = ?;

# JWT Interceptor Service
public isolated service class JwtAuthInterceptor {
    *http:RequestInterceptor;

    isolated resource function default [string... path](http:RequestContext ctx, http:Request req)
        returns http:NextService|http:Unauthorized|http:InternalServerError|error? {

        if isUnprotectedPath(path) {
            return ctx.next();
        }

        if req.method == http:OPTIONS {
            return ctx.next();
        }

        string|error authHeader = req.getHeader(HEADER_AUTHORIZATION);
        if authHeader is error {
            log:printError("Authorization header missing");
            return <http:Unauthorized>{body: "Authorization header required"};
        }

        if !authHeader.startsWith(BEARER_PREFIX) {
            return <http:Unauthorized>{body: "Invalid Authorization header format"};
        }

        string jwtToken = authHeader.substring(7);
        jwt:ValidatorConfig validatorConfig = {
            issuer: jwtInterceptorConfig.issuer,
            audience: jwtInterceptorConfig.audience,
            signatureConfig: {
                certFile: jwtInterceptorConfig.certFile
            }
        };

        jwt:Payload|http:Unauthorized|http:InternalServerError payload = validateJwt(jwtToken, validatorConfig);
        if payload is http:Unauthorized|http:InternalServerError {
            return payload;
        }

        ctx.set(HEADER_JWT_PAYLOAD, payload);
        return ctx.next();
    }
}

# JWT Validation Function
#
# + jwtToken - JWT token string to validate  
# + validatorConfig - Configuration for JWT validation
# + return - Returns the validated JWT payload or an error response
public isolated function validateJwt(string jwtToken, jwt:ValidatorConfig validatorConfig)
    returns JwtPayload|http:Unauthorized|http:InternalServerError {

    jwt:Payload|error validationResult = jwt:validate(jwtToken, validatorConfig);
    if validationResult is error {
        log:printError("JWT validation failed", validationResult);
        return <http:Unauthorized>{body: "Invalid token"};
    }

    JwtPayload|error payload = validationResult.cloneWithType(JwtPayload);
    if payload is error {
        log:printError("Invalid JWT payload structure", payload);
        return <http:InternalServerError>{body: "Invalid token format"};
    }

    return payload;
}
