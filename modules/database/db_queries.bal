import ballerina/sql;

isolated function getUsersQuery() returns sql:ParameterizedQuery => `
    SELECT 
        id, fist_name, last_name, position_name, about
    FROM 
        users;
`;

isolated function getProjectsQuery() returns sql:ParameterizedQuery => `
    SELECT 
        id, title, description, github_repo_link, other_link
    FROM 
        projects;
`;

isolated function createProjectQuery(ProjectCreate payload) returns sql:ParameterizedQuery {
    return
        `
            INSERT INTO projects 
                (
                    title, 
                    description, 
                    github_repo_link, 
                    other_link
                )
            VALUES 
                (
                    ${payload.title}, 
                    ${payload.description}, 
                    ${payload.githubRepoLink}, 
                    ${payload.otherLink}
                )
        `;
}

isolated function getWritingsQuery() returns sql:ParameterizedQuery => `
    SELECT 
        id, title, description, link
    FROM 
        writings;
`;

isolated function createWritingQuery(WritingCreate payload) returns sql:ParameterizedQuery {
    return
        `
            INSERT INTO writings 
                (
                    title, 
                    description, 
                    link
                )
            VALUES 
                (
                    ${payload.title}, 
                    ${payload.description}, 
                    ${payload.link}
                )
        `;
}
