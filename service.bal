import portfolio_backend.authorization;
import portfolio_backend.constant;
import portfolio_backend.database;
import portfolio_backend.jwtToken;

import ballerina/http;
import ballerina/log;

service http:InterceptableService / on new http:Listener(9090) {
    # Register the JWT interceptor
    #
    # + return - Array of JwtInterceptor instances
    public function createInterceptors() returns [authorization:JwtAuthInterceptor] => [new authorization:JwtAuthInterceptor()];

    # Endpoint to generate new JWT tokens
    #
    # + return - JWT token string or internal server error
    resource function post refresh\-tokens() returns string|http:InternalServerError|error {

        string|error jwtResponse = jwtToken:generateJWT("default", ["reader"]);

        if jwtResponse is error {
            log:printError(constant:JWT_CREATION_ERROR, jwtResponse);
            return <http:InternalServerError>{
                body: constant:JWT_CREATION_ERROR
            };
        }

        return jwtResponse;
    }

    # Get all users (protected by JWT)
    #
    # + ctx - Request context containing JWT payload
    # + return - List of users, internal server error, or error
    resource function get user\-info(http:RequestContext ctx) returns http:InternalServerError|database:User[]|http:Unauthorized {
        jwtToken:JwtPayload|error payload = ctx.getWithType(authorization:HEADER_JWT_PAYLOAD);
        if payload is error {
            log:printError("Failed to retrieve JWT payload from context", payload);
            return <http:InternalServerError>{body: "Unable to retrieve user context"};
        }

        // if (payload.roles[0] != "admin") {
        //     return <http:Unauthorized>{body: "Insufficient permissions"};
        // }

        database:User[]|error response = database:getUsers();

        if response is error {
            log:printError("Database error: ", response);
            return <http:InternalServerError>{body: "Internal server error"};
        }

        return response;
    }

    # Endpoint for user login
    #
    # + req - LogInPayload containing username and password
    # + return - JWT token string, unauthorized error, or internal server error
    resource function post log\-in(authorization:LogInPayload req) returns string|http:Unauthorized|http:InternalServerError {

        boolean loginResponse = authorization:login(req.username, req.password);
        if loginResponse is false {
            log:printError("Invalid username or password");
            return <http:Unauthorized>{body: "Invalid username or password"};
        }

        string|error jwtResponse = jwtToken:generateJWT(req.username, ["admin"]);
        if jwtResponse is error {
            log:printError(constant:JWT_CREATION_ERROR, jwtResponse);
            return <http:InternalServerError>{
                body: constant:JWT_CREATION_ERROR
            };
        }

        return jwtResponse;
    }
}
