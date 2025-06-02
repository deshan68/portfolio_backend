import portfolio_backend.authorization;
import portfolio_backend.constant;
import portfolio_backend.database;
import portfolio_backend.jwtToken;

import ballerina/http;
import ballerina/log;
import ballerina/sql;

service http:InterceptableService / on new http:Listener(9090) {
    # Register the JWT interceptor
    #
    # + return - Array of JwtInterceptor instances
    public function createInterceptors() returns [authorization:JwtAuthInterceptor] => [new authorization:JwtAuthInterceptor()];

    # Endpoint to generate new JWT tokens
    #
    # + return - JWT token string or internal server error
    resource function get refresh() returns string|http:InternalServerError|error {

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
    resource function post login(authorization:LogInPayload req) returns string|http:Unauthorized|http:InternalServerError {

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

    # Get all projects (protected by JWT)
    #
    # + return - List of projects, internal server error, or unauthorized
    resource function get projects() returns http:InternalServerError|database:Project[]|http:Unauthorized {
        database:Project[]|error response = database:getProjects();

        if response is error {
            log:printError("Database error: ", response);
            return <http:InternalServerError>{body: "Internal server error"};
        }

        return response;
    }

    # Create a new project (protected by JWT)
    #
    # + payload - ProjectCreate payload containing project details
    # + return - SQL execution result or error
    resource function post projects(database:ProjectCreate payload) returns http:InternalServerError|http:Created {
        sql:ExecutionResult|error result = database:createProject(payload);

        if result is error {
            log:printError("Database error: ", result);
            return <http:InternalServerError>{body: "Internal server error"};
        }

        return http:CREATED;
    }

    # Get all writings (protected by JWT)
    #
    # + return - List of writings, internal server error, or unauthorized
    resource function get writings() returns http:InternalServerError|database:Writing[]|http:Unauthorized {
        database:Writing[]|error response = database:getWritings();

        if response is error {
            log:printError("Database error: ", response);
            return <http:InternalServerError>{body: "Internal server error"};
        }

        return response;
    }

    # Create a new writing (protected by JWT)
    #
    # + payload - WritingCreate payload containing writing details
    # + return - SQL execution result or error
    resource function post writings(database:WritingCreate payload) returns http:InternalServerError|http:Created {
        sql:ExecutionResult|error result = database:createWriting(payload);

        if result is error {
            log:printError("Database error: ", result);
            return <http:InternalServerError>{body: "Internal server error"};
        }

        return http:CREATED;
    }
}
