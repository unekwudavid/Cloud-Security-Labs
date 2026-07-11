# Automation Configuration

This folder stores centralized configuration used by the automation framework.

## Purpose
The config files define tenant settings, company information, identity mappings, and provisioning defaults used by PowerShell, Graph, and Terraform automation.

## Contents
- `tenant-config.psd1` — Tenant metadata, naming conventions, Administrative Unit and Security Group mappings, license settings, and environment-specific values.

## Usage
Automation scripts should reference configuration values here rather than hard-coding them in script logic.

## Notes
- Keep sensitive values out of source control.
- Use different config files for separate environments if needed (e.g. dev, test, prod).