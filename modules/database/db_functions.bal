import ballerina/sql;

# Define the function to fetch books from the database
#
# + return - Books or error
public isolated function getUsers() returns User[]|sql:Error {
    // Execute the query and return a stream of Book records.
    stream<User, sql:Error?> resultStream = dbClient->query(getUsersQuery());

    // Check if the result is a stream of User records.
    if resultStream is stream<User> {
        return from User User in resultStream
            select User;
    }

    // If there is an error, return an error message.
    return error("Error fetching Users");
}
