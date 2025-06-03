import ballerina/http;
import ballerina/jwt;
import ballerina/log;

public configurable JWTInterceptorConfig jwtInterceptorConfig = ?;

# Handle JWT generation and user management
#
# + user - Username for which the JWT token is generated 
# + role - Array of roles assigned to the user
# + return - JWT token string or internal server error
public isolated function generateJWT(string user, string role) returns string|jwt:Error {
    jwt:IssuerConfig issuerConfig = {
        issuer: jwtInterceptorConfig.issuer,
        audience: jwtInterceptorConfig.audience,
        expTime: jwtInterceptorConfig.tokenExpiry,
        signatureConfig: {
            config: {
                keyFile: jwtInterceptorConfig.privateKeyFile
            }
        },
        customClaims: {
            user,
            role
        }
    };

    return jwt:issue(issuerConfig);
}

# Validate JWT token and extract payload
#
# + jwtToken - JWT token string to validate
# + return - JWT payload or error response
public isolated function validateJWT(string jwtToken) returns http:Unauthorized|http:InternalServerError|JwtPayload {
    jwt:ValidatorConfig validatorConfig = {
        issuer: jwtInterceptorConfig.issuer,
        audience: jwtInterceptorConfig.audience,
        signatureConfig: {
            certFile: jwtInterceptorConfig.certFile
        }
    };

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
