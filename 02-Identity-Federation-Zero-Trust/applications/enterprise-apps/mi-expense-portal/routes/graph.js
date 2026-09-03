const express = require("express");
const axios = require("axios");

const router = express.Router();

router.get("/me", async (req, res) => {
    try {
        // Ensure the user is authenticated
        if (!req.session.account || !req.session.accessToken) {
            return res.status(401).json({
                error: "Not authenticated"
            });
        }

        const response = await axios.get(
            "https://graph.microsoft.com/v1.0/me",
            {
                headers: {
                    Authorization: `Bearer ${req.session.accessToken}`
                }
            }
        );

        res.json({
            success: true,
            user: response.data
        });

    } catch (error) {
        console.error(
            "Microsoft Graph request failed:",
            error.response?.data || error.message
        );

        res.status(
            error.response?.status || 500
        ).json({
            success: false,
            error: "Unable to retrieve Microsoft Graph profile"
        });
    }
});

module.exports = router;