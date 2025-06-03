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
    @sql:Column {name: "first_name"}
    string firstName;

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
    string firstName;

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

# Project with tech stack record type.
public type ProjectWithTechStack record {|
    *Project;
    # Tech stacks associated with the project
    string[] techStacks = [];
|};

# Experience record type.
public type ExperienceWithTechStack record {|
    *Experience;
    # Tech stacks associated with the experience
    string[] techStacks = [];
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

    # Tech stacks associated with the project
    int[] techStacks = [];
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

public type TechStack record {|
    # Tech stack ID
    @sql:Column {name: "id"}
    readonly int id;

    # Tech stack name
    @sql:Column {name: "name"}
    string name;
|};

# TechStack create record type.
public type TechStackCreate record {|
    # Tech stack name
    string name;
|};

# Experience record type.
public type Experience record {|
    # Experience ID
    @sql:Column {name: "id"}
    readonly int id;

    # Company name
    @sql:Column {name: "company_name"}
    string companyName;

    # Start date
    @sql:Column {name: "start_date"}
    string startDate;

    # End date (nullable)
    @sql:Column {name: "end_date"}
    string? endDate;

    # Is current employee
    @sql:Column {name: "is_current_employee"}
    boolean isCurrentEmployee;

    # Position
    @sql:Column {name: "position"}
    string position;

    # Description (nullable)
    @sql:Column {name: "description"}
    string description;
|};

# Experience create record type.
public type ExperienceCreate record {|
    # Company name
    string companyName;

    # Start date
    string startDate;

    # End date (nullable)
    string? endDate = ();

    # Is current employee
    boolean isCurrentEmployee;

    # Position
    string position;

    # Description (nullable)
    string description;

    # Tech stacks associated with the experience
    int[] techStacks = [];
|};
