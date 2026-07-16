# Terraform Automation

This folder contains Infrastructure as Code definitions for Microsoft Entra ID resources.

## Purpose
Use Terraform to provision and manage consistent identity infrastructure across environments.

## Typical contents
- Administrative Unit definitions
- Security Group definitions
- Conditional Access or named location definitions
- Role assignments

## Notes
- Keep state management consistent and secure.
- Use this folder to define reusable identity infrastructure artifacts that complement the automation scripts.
- Terraform works best for resource configuration that is stable and repeatable.