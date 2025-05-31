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

# Book create record type.
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

