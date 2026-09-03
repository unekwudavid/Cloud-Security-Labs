# MI Expense Portal — Application Authorization Model

## Project

**MI Expense Portal — Identity Federation & Zero Trust Platform**

## Purpose

This document defines the application authorization model for the MI Expense Portal.

Authentication establishes that a user has successfully signed in through Microsoft Entra ID.

Authorization determines what that authenticated user is permitted to do inside the application.

The application therefore treats authentication and authorization as separate security controls.

---

# 1. Authorization Architecture

The MI Expense Portal uses Microsoft Entra ID application roles to establish the user's application-level role.

The authorization flow is:

```text
User
  |
  v
Microsoft Entra ID
  |
  | Authentication
  v
ID Token
  |
  | roles claim
  v
Express Session
  |
  v
Authorization Middleware
  |
  | Role evaluation
  v
Application Endpoint
  |
  +---- Allowed ------> Application functionality
  |
  +---- Denied -------> HTTP 403 Forbidden