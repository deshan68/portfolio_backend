import ballerina/sql;

isolated function getUsersQuery() returns sql:ParameterizedQuery => `
    SELECT 
        id, fist_name, last_name, position_name, about
    FROM 
        users;
`;
