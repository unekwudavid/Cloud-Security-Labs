const express = require("express");
const passport = require("passport");
const { Strategy: SamlStrategy } = require("passport-saml");

const { samlConfig } = require("../config/samlConfig");

const router = express.Router();

passport.use(
    new SamlStrategy(
        {
            ...samlConfig
        },
        (profile, done) => {
            return done(null, profile);
        }
    )
);

passport.serializeUser((user, done) => {
    done(null, user);
});

passport.deserializeUser((user, done) => {
    done(null, user);
});


/*
 * Start SAML authentication
 */
router.get(
    "/login",
    passport.authenticate("saml")
);


/*
 * SAML Assertion Consumer Service (ACS)
 */
router.post(
    "/callback",
    passport.authenticate("saml", {
        failureRedirect: "/"
    }),
    (req, res) => {

        console.log("=== SAML AUTHENTICATION SUCCESS ===");

        console.log("=== AUTHENTICATED SAML USER ===");
        console.dir(req.user, { depth: null });

        console.log("=== SAML ATTRIBUTES ===");
        console.dir(req.user?.attributes, { depth: null });

        console.log("=== SAML ROLES ===");
        console.log("req.user.roles:", req.user?.roles);
        console.log("req.user.attributes.roles:", req.user?.attributes?.roles);
        console.log(
            "URI role claim:",
            req.user?.attributes?.[
                "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"
            ]
        );

        req.session.samlUser = req.user;

        res.redirect("/");
    }
);


module.exports = router;