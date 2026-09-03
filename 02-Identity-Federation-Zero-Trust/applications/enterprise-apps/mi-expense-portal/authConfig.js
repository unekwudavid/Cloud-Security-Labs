require("dotenv").config();

const msalConfig = {
    auth: {
        clientId: process.env.CLIENT_ID,
        authority: `https://login.microsoftonline.com/${process.env.TENANT_ID}`,
        clientSecret: process.env.CLIENT_SECRET
    }
};

const REDIRECT_URI = process.env.REDIRECT_URI;

module.exports = {
    msalConfig,
    REDIRECT_URI
};