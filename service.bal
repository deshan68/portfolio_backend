import portfolio_backend.database;

import ballerina/http;
import ballerina/os;

service / on new http:Listener(9090) {

    resource function get users() returns string|http:InternalServerError {

        string port = os:getEnv("HTTP_PORT");
        // Call the getUsers function to fetch data from the database.
        database:User[]|error response = database:getUsers();

        // If there's an error while fetching, return an internal server error.
        if response is error {
            return <http:InternalServerError>{
                body: "Error while retrieving users"
            };
        }

        // Return the response containing the list of users.
        return port;
    }
}

