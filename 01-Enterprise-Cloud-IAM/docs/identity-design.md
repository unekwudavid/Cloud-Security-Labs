# Identity Design Document

## Project

Enterprise Cloud IAM Platform

---

## Company

Mustard Innovations

---

## Identity Provider

Microsoft Entra ID

---

## Cloud Platform

Microsoft Azure

---

## Authentication Standard

Microsoft Entra Authentication

---

## Identity Model

Cloud-Only Identity

---

## Security Model

Zero Trust

---

## Access Model

Role-Based Access Control (RBAC)

---

## Governance Model

Least Privilege

Just-in-Time Administration

Identity Governance

Access Reviews

Privileged Identity Management

---

## Identity Organization Strategy

Mustard Innovations organizes identities using a combination of departmental and geographic attributes.

- **Departments** define business roles and determine access through Role-Based Access Control (RBAC).
- **Geographic locations** support delegated administration, regional compliance, Conditional Access policies, and reporting.

Administrative Units will be used to delegate identity management by country, while Security Groups will manage access permissions based on job function. This design provides a scalable, secure, and maintainable identity architecture that supports future organizational growth and regional expansion.

---

## Automation Platform

Terraform

PowerShell

Microsoft Graph API

---

## Documentation Standard

Markdown

Architecture Diagrams

Runbooks

Implementation Guides
