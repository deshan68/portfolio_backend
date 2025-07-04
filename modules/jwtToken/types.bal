public type JWTInterceptorConfig record {|
    string issuer;
    string audience;
    string certFile;
    string privateKeyFile;
    decimal tokenExpiry;
    decimal clockSkew;
|};

# Custom JWT Payload type
#
# + iss - issuer of the JWT token
# + aud - audience for which the JWT token is intended
# + exp - expiration time of the JWT token in seconds since epoch
# + nbf - not before time of the JWT token in seconds since epoch
# + iat - issued at time of the JWT token in seconds since epoch
# + user - unique identifier for the user
# + role - array of roles assigned to the user  
public type JwtPayload record {|
    string iss;
    string aud;
    int exp;
    int nbf;
    int iat;
    string user;
    string role;
|};

