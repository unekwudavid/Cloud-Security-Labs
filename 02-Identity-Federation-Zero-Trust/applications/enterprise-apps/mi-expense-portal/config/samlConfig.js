require("dotenv").config();

const fs = require("fs");
const path = require("path");

const samlCertificatePath = path.join(
    __dirname,
    "entra-saml-cert.pem"
);

const samlConfig = {
    entryPoint: process.env.SAML_ENTRY_POINT,

    issuer: process.env.SAML_ISSUER,

    callbackUrl: process.env.SAML_CALLBACK_URL,

    cert: fs.readFileSync(
        samlCertificatePath,
        "utf8"
    ),

    identifierFormat: null
};

module.exports = {
    samlConfig
};