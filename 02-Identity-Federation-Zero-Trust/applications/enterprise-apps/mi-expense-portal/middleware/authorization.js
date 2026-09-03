function requireRole(requiredRole) {
    return (req, res, next) => {

        // Authentication check
        if (!req.session || !req.session.samlUser) {
            return res.status(401).send("Authentication required.");
        }

        // Read roles from the federated SAML identity
        const roles = req.session.samlUser.roles || [];

        // Authorization check
        if (!roles.includes(requiredRole)) {
            return res.status(403).send("Forbidden.");
        }

        next();
    };
}

module.exports = {
    requireRole
};