import ballerina/sql;

type DatabaseConfig record {|
    # User of the database
    string user;
    # Password of the database
    string password;
    # Name of the database
    string database;
    # Host of the database
    string host;
    # Port
    int port;
|};

# Book record type.
public type User record {|
    # User ID
    @sql:Column {name: "id"}
    readonly int id;

    # User fist name
    @sql:Column {name: "fist_name"}
    string fistName;

    # User last name
    @sql:Column {name: "last_name"}
    string lastName;

    # User position
    @sql:Column {name: "position_name"}
    string position;

    # User about
    @sql:Column {name: "about"}
    string about;
|};

# User create record type.
public type UserCreate record {|
    # User fist name
    string fistName;

    # User last name
    string lastName;

    # User position
    string position;

    # User about
    string about;
|};

# Project record type.
public type Project record {|
    # Project ID
    @sql:Column {name: "id"}
    readonly int id;

    # Project title
    @sql:Column {name: "title"}
    string title;

    # Project description
    @sql:Column {name: "description"}
    string description;

    # GitHub repository link
    @sql:Column {name: "github_repo_link"}
    string githubRepoLink;

    # Other link
    @sql:Column {name: "other_link"}
    string otherLink;
|};

# Project create record type.
public type ProjectCreate record {|
    # Project title
    string title;

    # Project description
    string description;

    # GitHub repository link
    string githubRepoLink;

    # Other link
    string otherLink;
|};

# Writing record type.
public type Writing record {|
    # Writing ID
    @sql:Column {name: "id"}
    readonly int id;

    # Writing title
    @sql:Column {name: "title"}
    string title;

    # Writing description
    @sql:Column {name: "description"}
    string description;

    # Writing link
    @sql:Column {name: "link"}
    string link;
|};

# Writing create record type.
public type WritingCreate record {|
    # Writing title
    string title;

    # Writing description
    string description;

    # Writing link
    string link;
|};
