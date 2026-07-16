# Organization Structure

> **Project:** Enterprise Identity & Access Management  
> **Module:** 02 – Entra ID Administration  
> **Document:** Organization Structure  
> **Client:** Mustard Innovations  
> **Consultant:** David Adama  
> **Version:** 1.0

---

# Company Overview

Mustard Innovations is a multinational technology company with operations across Africa, Europe, and North America.

To support secure identity administration and delegated management, users will be organized using both **geographical location** and **departmental structure**.

This design enables:

- Regional administration
- Compliance with local regulations (e.g., GDPR)
- Department-based access control
- Scalable identity management
- Least privilege administration

---

# Geographic Structure

| Region | Country |
|---------|----------|
| Africa | Nigeria |
| Europe | United Kingdom |
| North America | Canada |

---

# Departments

- Executive
- Human Resources
- Finance
- Engineering
- Information Technology
- Security Operations
- Sales
- Marketing
- Customer Support

---

# Identity Design Principle

Primary organization will be based on **geographical location**, while authorization and resource access will be managed using **department-based Security Groups**.

This hybrid model aligns with enterprise IAM best practices by supporting regulatory compliance, delegated administration, and simplified access management.

## Administrative Unit Naming Standard

Administrative Units will use the following naming convention:

**Format**

MI(where MI stands for mustard innovations)-<Country>

**Examples**

- MI-Nigeria
- MI-UnitedKingdom
- MI-Canada

This naming convention ensures organizational clarity, supports future business expansion, and enables consistent administration across multiple business entities.