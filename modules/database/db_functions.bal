import ballerina/log;
import ballerina/sql;

public isolated function getUsers() returns User[]|sql:Error {
    stream<User, sql:Error?> resultStream = dbClient->query(getUsersQuery());

    if resultStream is stream<User> {
        return from User User in resultStream
            select User;
    }

    return error("Error fetching Users");
}

public isolated function createUser(UserCreate payload) returns sql:ExecutionResult|sql:Error {
    return dbClient->execute(createUserQuery(payload));
}

public isolated function getTechStackByProjectId(string id) returns string[]|sql:Error {
    stream<TechStack, sql:Error?> techStackStream = dbClient->query(getTechStackByProjectIdQuery(id));

    if techStackStream is stream<TechStack> {
        return from TechStack tech in techStackStream
            select tech.name;
    }
    return error("Error fetching Users");
}

public isolated function getTechStackByExperienceId(string id) returns string[]|sql:Error {
    stream<TechStack, sql:Error?> techStackStream = dbClient->query(getTechStackByExperienceIdQuery(id));

    if techStackStream is stream<TechStack> {
        return from TechStack tech in techStackStream
            select tech.name;
    }
    return error("Error fetching TechStacks for Experience");
}

public isolated function getTechStacks() returns TechStack[]|sql:Error {
    stream<TechStack, sql:Error?> resultStream = dbClient->query(getTechStacksQuery());

    if resultStream is stream<TechStack> {
        return from TechStack tech in resultStream
            select tech;
    }

    return error("Error fetching TechStacks");
}

public isolated function createTechStack(TechStackCreate payload) returns sql:ExecutionResult|sql:Error {
    return dbClient->execute(createTechStackQuery(payload));
}

public isolated function getProjects() returns ProjectWithTechStack[]|sql:Error {
    stream<Project, sql:Error?> resultStream = dbClient->query(getProjectsQuery());

    if resultStream is stream<Project> {
        return from Project project in resultStream
            let ProjectWithTechStack projectWithTS = {
                id: project.id,
                title: project.title,
                description: project.description,
                githubRepoLink: project.githubRepoLink,
                otherLink: project.otherLink,
                techStacks: check getTechStackByProjectId(project.id.toString())
            }
            select projectWithTS;
    }

    log:printError("Error fetching Projects");
    return error("Error fetching Projects");
}

public isolated function createProject(ProjectCreate payload) returns error|sql:ExecutionResult {
    transaction {
        sql:ExecutionResult createProjectResult = check dbClient->execute(createProjectQuery(payload));
        string|int? lastInsertId = createProjectResult.lastInsertId;
        sql:ParameterizedQuery[] insertProjectTechStacksResult = from int techStackId in payload.techStacks
            select insertProjectTechStacksQuery(lastInsertId.toString(), techStackId.toString());

        _ = check dbClient->batchExecute(insertProjectTechStacksResult);
        check commit;
        return createProjectResult;
    }
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

public isolated function getExperiences() returns ExperienceWithTechStack[]|sql:Error {
    stream<Experience, sql:Error?> resultStream = dbClient->query(getExperiencesQuery());

    if resultStream is stream<Experience> {
        return from Experience exp in resultStream
            let ExperienceWithTechStack expWithTS = {
                id: exp.id,
                description: exp.description,
                startDate: exp.startDate,
                endDate: exp.endDate,
                isCurrentEmployee: exp.isCurrentEmployee,
                companyName: exp.companyName,
                position: exp.position,
                techStacks: check getTechStackByExperienceId(exp.id.toString())

            }
            select expWithTS;
    }

    return error("Error fetching Experiences");
}

public isolated function createExperience(ExperienceCreate payload) returns error|sql:ExecutionResult {
    transaction {
        sql:ExecutionResult createExperienceResult = check dbClient->execute(createExperienceQuery(payload));
        string|int? lastInsertId = createExperienceResult.lastInsertId;
        sql:ParameterizedQuery[] insertExperienceTechStacksResult = from int techStackId in payload.techStacks
            select insertExperienceTechStacksQuery(lastInsertId.toString(), techStackId.toString());

        _ = check dbClient->batchExecute(insertExperienceTechStacksResult);
        check commit;
        return createExperienceResult;
    }
}
