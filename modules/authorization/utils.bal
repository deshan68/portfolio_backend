isolated function isUnprotectedPath(string[] path) returns boolean {
    boolean isTokenEndpoint = false;

    foreach var p in UNPROTECTED_PATHS {
        if p == path[0] {
            isTokenEndpoint = true;
            break;
        }
    }

    return isTokenEndpoint;
}
