import portfolio_backend.authorization;
import portfolio_backend.database;

import ballerina/http;
import ballerina/jwt;
import ballerina/log;

service http:InterceptableService / on new http:Listener(9090) {
    # Register the JWT interceptor
    # + return - Array of JwtInterceptor instances
    public function createInterceptors() returns [authorization:JwtAuthInterceptor] => [new authorization:JwtAuthInterceptor()];

    # Endpoint to generate new JWT tokens
    # + return - JWT token string or internal server error
    resource function post tokens() returns string|http:InternalServerError {

        jwt:IssuerConfig issuerConfig = {
            issuer: authorization:jwtInterceptorConfig.issuer,
            audience: authorization:jwtInterceptorConfig.audience,
            expTime: authorization:jwtInterceptorConfig.tokenExpiry,
            signatureConfig: {
                config: {
                    keyFile: authorization:jwtInterceptorConfig.privateKeyFile
                }
            },
            customClaims: {
                userId: "test-user",
                roles: ["admin", "user"]
            }
        };

        string|error jwt = jwt:issue(issuerConfig);
        if jwt is error {
            log:printError("Failed to generate JWT", jwt);
            return <http:InternalServerError>{
                body: "Failed to generate token"
            };
        }

        return jwt;
    }

    # Get all users (protected by JWT)
    # + return - List of users, internal server error, or error
    resource function get users(http:RequestContext ctx) returns http:InternalServerError|database:User[]|http:Unauthorized {
        // Get the validated JWT payload from context
        authorization:JwtPayload|error payload = ctx.getWithType(authorization:HEADER_JWT_PAYLOAD);
        if payload is error {
            return <http:InternalServerError>{body: "Unable to retrieve user context"};
        }

        if (payload.roles[0] != "user") {
            return <http:Unauthorized>{body: "Insufficient permissions"};
        }

        // Call the getUsers function to fetch data from the database
        database:User[]|error response = database:getUsers();

        // If there's an error while fetching, return an internal server error
        if response is error {
            log:printError("Database error: ", response);
            return <http:InternalServerError>{body: "Internal server error"};
        }

        // Return the response containing the list of users
        return response;
    }
}
