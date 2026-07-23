# Group Mapping Design

## Purpose

This document describes how Mustard Innovations maps employee attributes from the HR system to Microsoft Entra ID security groups.

## Design Principles

- Configuration-driven (JSON)
- No hardcoded group names
- Easily extensible
- Supports future automation

## Mapping Rules

| Employee Attribute | Target Group |
|-------------------|--------------|
| HR | SG-HR |
| Finance | SG-Finance |
| IT | SG-IT |
| Engineering | SG-Engineering |
| Marketing | SG-Marketing |
| Sales | SG-Sales |
| Operations | SG-Operations |
| Security | SG-Security |
| Executive | SG-Executive |
| Customer Support | SG-CustomerSupport |

## Default Group

Every provisioned employee is automatically added to:

- All Company

## Future Enhancements

- Regional group assignment
- Project-based groups
- Dynamic groups
- Role-based access assignments