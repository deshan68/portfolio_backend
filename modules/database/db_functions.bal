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

public isolated function getProjects() returns Project[]|sql:Error {
    stream<Project, sql:Error?> resultStream = dbClient->query(getProjectsQuery());

    if resultStream is stream<Project> {
        return from Project project in resultStream
            select project;
    }

    return error("Error fetching Projects");
}

public isolated function createProject(ProjectCreate payload) returns sql:ExecutionResult|sql:Error {
    return dbClient->execute(createProjectQuery(payload));
}

public isolated function createWriting(WritingCreate payload) returns sql:ExecutionResult|sql:Error {
    return dbClient->execute(createWritingQuery(payload));
}

public isolated function getWritings() returns Writing[]|sql:Error {
    stream<Writing, sql:Error?> resultStream = dbClient->query(getWritingsQuery());

    if resultStream is stream<Writing> {
        return from Writing writing in resultStream
            select writing;
    }

    return error("Error fetching Writings");
}
