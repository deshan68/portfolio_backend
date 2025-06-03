import portfolio_backend.jwtToken;

import ballerina/http;
import ballerina/log;

public configurable AdminConfig adminConfig = ?;

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
            log:printError("Invalid Authorization header format");
            return <http:Unauthorized>{body: "Invalid Authorization header format"};
        }

        string jwtToken = authHeader.substring(7);

        http:Unauthorized|http:InternalServerError|jwtToken:JwtPayload|error payload = jwtToken:validateJWT(jwtToken);
        if payload is http:Unauthorized|http:InternalServerError|error {
            return payload;
        }

        ctx.set(HEADER_JWT_PAYLOAD, payload);
        return ctx.next();
    }
}

public isolated function login(string username, string password) returns boolean {
    if !(username == adminConfig.adminUsername && password == adminConfig.adminPassword) {
        return false;
    }

    return true;
}

public isolated function checkPermission(string currentRoles, string requiredRole) returns boolean {
    if (requiredRole == currentRoles) {
        return true;
    }

    return false;
}
