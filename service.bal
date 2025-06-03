import portfolio_backend.authorization;
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
        string|error jwtResponse = jwtToken:generateJWT("default", "reader");

        if jwtResponse is error {
            log:printError("Error while creating JWT.", jwtResponse);
            return <http:InternalServerError>{
                body: "Error while creating JWT."
            };
        }

        return jwtResponse;
    }

    # Get all users (protected by JWT)
    #
    # + return - List of users, internal server error, or error
    resource function get user\-info() returns http:InternalServerError|http:NotFound|database:User {
        database:User[]|error response = database:getUsers();

        if response is error {
            log:printError("Database error: ", response);
            return <http:InternalServerError>{body: "Internal server error"};
        }

        if response.length() == 0 {
            log:printError("No users found");
            return <http:NotFound>{body: "No users found"};
        }

        return response[0];
    }

    # Create a new user (protected by JWT)
    #
    # + payload - UserCreate payload containing user details
    # + return - SQL execution result or error
    resource function post users(http:RequestContext ctx, database:UserCreate payload) returns http:InternalServerError|http:Created & readonly|http:Unauthorized {
        jwtToken:JwtPayload|error authPayload = ctx.getWithType(authorization:HEADER_JWT_PAYLOAD);
        if authPayload is error {
            log:printError("Failed to retrieve JWT payload from context", authPayload);
            return <http:InternalServerError>{body: "Unable to retrieve user context"};
        }

        if (authorization:checkPermission(authPayload.role, "admin") is false) {
            return <http:Unauthorized>{body: "Insufficient permissions"};
        }

        sql:ExecutionResult|error result = database:createUser(payload);

        if result is error {
            log:printError("Database error: ", result);
            return <http:InternalServerError>{body: "Internal server error"};
        }

        return http:CREATED;
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

        string|error jwtResponse = jwtToken:generateJWT(req.username, "admin");
        if jwtResponse is error {
            log:printError("Error while creating JWT.", jwtResponse);
            return <http:InternalServerError>{
                body: "Error while creating JWT."
            };
        }

        return jwtResponse;
    }

    # Get all projects (protected by JWT)
    #
    # + return - List of projects, internal server error, or unauthorized
    resource function get projects() returns http:InternalServerError|database:ProjectWithTechStack[] {
        database:ProjectWithTechStack[]|sql:Error response = database:getProjects();

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
    resource function post projects(http:RequestContext ctx, database:ProjectCreate payload) returns http:InternalServerError|http:Created & readonly|http:Unauthorized {
        jwtToken:JwtPayload|error authPayload = ctx.getWithType(authorization:HEADER_JWT_PAYLOAD);
        if authPayload is error {
            log:printError("Failed to retrieve JWT payload from context", authPayload);
            return <http:InternalServerError>{body: "Unable to retrieve user context"};
        }

        if (authorization:checkPermission(authPayload.role, "admin") is false) {
            return <http:Unauthorized>{body: "Insufficient permissions"};
        }

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
    resource function post writings(http:RequestContext ctx, database:WritingCreate payload) returns http:InternalServerError|http:Created & readonly|http:Unauthorized {
        jwtToken:JwtPayload|error authPayload = ctx.getWithType(authorization:HEADER_JWT_PAYLOAD);
        if authPayload is error {
            log:printError("Failed to retrieve JWT payload from context", authPayload);
            return <http:InternalServerError>{body: "Unable to retrieve user context"};
        }

        if (authorization:checkPermission(authPayload.role, "admin") is false) {
            return <http:Unauthorized>{body: "Insufficient permissions"};
        }
        sql:ExecutionResult|error result = database:createWriting(payload);

        if result is error {
            log:printError("Database error: ", result);
            return <http:InternalServerError>{body: "Internal server error"};
        }

        return http:CREATED;
    }

    # Get all tech stacks (protected by JWT)
    #
    # + return - List of tech stacks, internal server error, or unauthorized
    resource function get tech\-stacks() returns http:InternalServerError|database:TechStack[] {
        database:TechStack[]|error response = database:getTechStacks();

        if response is error {
            log:printError("Database error: ", response);
            return <http:InternalServerError>{body: "Internal server error"};
        }

        return response;
    }

    # Create a new tech stack (protected by JWT)
    #
    # + payload - TechStackCreate payload containing tech stack details
    # + return - SQL execution result or error
    resource function post tech\-stacks(http:RequestContext ctx, database:TechStackCreate payload) returns http:InternalServerError|http:Created & readonly|http:Unauthorized {
        jwtToken:JwtPayload|error authPayload = ctx.getWithType(authorization:HEADER_JWT_PAYLOAD);
        if authPayload is error {
            log:printError("Failed to retrieve JWT payload from context", authPayload);
            return <http:InternalServerError>{body: "Unable to retrieve user context"};
        }

        if (authorization:checkPermission(authPayload.role, "admin") is false) {
            return <http:Unauthorized>{body: "Insufficient permissions"};
        }

        sql:ExecutionResult|error result = database:createTechStack(payload);

        if result is error {
            log:printError("Database error: ", result);
            return <http:InternalServerError>{body: "Internal server error"};
        }

        return http:CREATED;
    }

    # Get all experiences (protected by JWT)
    #
    # + return - List of experiences, internal server error, or unauthorized
    resource function get experiences() returns http:InternalServerError|database:ExperienceWithTechStack[]|http:Unauthorized {
        database:ExperienceWithTechStack[]|error response = database:getExperiences();

        if response is error {
            log:printError("Database error: ", response);
            return <http:InternalServerError>{body: "Internal server error"};
        }

        return response;
    }

    # Create a new experience (protected by JWT)
    #
    # + ctx - Request context to extract JWT payload
    # + payload - ExperienceCreate payload containing experience details
    # + return - SQL execution result or error
    resource function post experiences(http:RequestContext ctx, database:ExperienceCreate payload) returns http:InternalServerError|http:Created & readonly|http:Unauthorized {
        jwtToken:JwtPayload|error authPayload = ctx.getWithType(authorization:HEADER_JWT_PAYLOAD);
        if authPayload is error {
            log:printError("Failed to retrieve JWT payload from context", authPayload);
            return <http:InternalServerError>{body: "Unable to retrieve user context"};
        }

        if (authorization:checkPermission(authPayload.role, "admin") is false) {
            return <http:Unauthorized>{body: "Insufficient permissions"};
        }

        sql:ExecutionResult|error result = database:createExperience(payload);

        if result is error {
            log:printError("Database error: ", result);
            return <http:InternalServerError>{body: "Internal server error"};
        }

        return http:CREATED;
    }
}
