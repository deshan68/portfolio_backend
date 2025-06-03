import ballerina/sql;

isolated function getUsersQuery() returns sql:ParameterizedQuery {
    return
    `
        SELECT 
            id, first_name, last_name, position_name, about
        FROM 
            users;
    `;
}

isolated function getProjectsQuery() returns sql:ParameterizedQuery {
    return
    `
        SELECT 
            id, title, description, github_repo_link, other_link
        FROM 
            projects;
    `;
}

isolated function getTechStackByProjectIdQuery(string projectId) returns sql:ParameterizedQuery {
    return
    `
        SELECT 
            t.name 
        FROM 
            tech_stack t
        JOIN 
            project_tech_stack pts ON t.id = pts.tech_stack_id
        WHERE 
            pts.project_id = ${projectId};
    `;
}

isolated function createExperienceQuery(ExperienceCreate payload) returns sql:ParameterizedQuery {
    return
    `
        INSERT INTO experiences 
            (
                company_name, 
                start_date, 
                end_date, 
                is_current_employee,
                position,
                description
            )
        VALUES 
            (
                ${payload.companyName},
                ${payload.startDate},
                ${payload.endDate},
                ${payload.isCurrentEmployee},
                ${payload.position}, 
                ${payload.description}
            )
    `;
}

isolated function getWritingsQuery() returns sql:ParameterizedQuery {
    return
    `
        SELECT 
            id, title, description, link
        FROM 
            writings;
    `;
}

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

isolated function getTechStacksQuery() returns sql:ParameterizedQuery {
    return
    `
        SELECT 
            id, name
        FROM 
            tech_stack;
    `;
}

isolated function createTechStackQuery(TechStackCreate payload) returns sql:ParameterizedQuery {
    return
        `
            INSERT INTO tech_stack 
                (
                    name
                )
            VALUES 
                (
                    ${payload.name}
                )
        `;
}

isolated function getExperiencesQuery() returns sql:ParameterizedQuery {
    return
    `
        SELECT 
            id, 
            company_name, 
            start_date, 
            end_date, 
            is_current_employee, 
            position, 
            description
        FROM 
            experiences;
    `;
}

isolated function getTechStackByExperienceIdQuery(string experienceId) returns sql:ParameterizedQuery {
    return `
        SELECT 
            t.name 
        FROM 
            tech_stack t
        JOIN 
            experience_tech_stack ets ON t.id = ets.tech_stack_id
        WHERE 
            ets.experience_id = ${experienceId};
    `;
}

isolated function insertProjectTechStacksQuery(string projectId, string techStackId) returns sql:ParameterizedQuery {
    return `INSERT INTO project_tech_stack (project_id, tech_stack_id) VALUES (${projectId}, ${techStackId})`;
}

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

isolated function insertExperienceTechStacksQuery(string experienceId, string techStackId) returns sql:ParameterizedQuery {
    return `INSERT INTO experience_tech_stack (experience_id, tech_stack_id) VALUES (${experienceId}, ${techStackId})`;
}
