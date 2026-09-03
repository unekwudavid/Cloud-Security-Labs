const express = require("express");
const { requireRole } = require("../middleware/authorization");

const router = express.Router();

router.get("/employee", requireRole("Employee"), (req, res) => {
    res.json({
        message: "Employee access granted",
        user: req.session.account.username
    });
});

router.get("/manager", requireRole("Manager"), (req, res) => {
    res.json({
        message: "Manager access granted",
        user: req.session.account.username
    });
});

router.get("/finance", requireRole("Finance"), (req, res) => {
    res.json({
        message: "Finance access granted",
        user: req.session.account.username
    });
});

router.get("/admin", requireRole("Admin"), (req, res) => {
    res.json({
        message: "Admin access granted",
        user: req.session.account.username
    });
});

module.exports = router;