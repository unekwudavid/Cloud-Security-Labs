# 🔐 Microsoft Entra ID User Management & Licensing Configuration  
### Lab: SC-900 — Microsoft Security, Compliance, and Identity Fundamentals  

[![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=flat-square)]()  
[![Platform](https://img.shields.io/badge/Platform-Microsoft%20365%20%7C%20Entra%20ID-lightgrey?style=flat-square)]()  
[![Focus](https://img.shields.io/badge/Focus-Identity%20%7C%20Access%20Management%20%7C%20Licensing-orange?style=flat-square)]()  

---

## 🎯 Overview  

In this lab, I explored **Microsoft Entra ID (formerly Azure Active Directory)** to deepen my understanding of **identity types, user lifecycle management**, and **licensing configurations** in a Microsoft 365 environment.  

This exercise mapped directly to the **Microsoft SC-900: Security, Compliance, and Identity Fundamentals** certification learning objectives — specifically the module on **Describing the Function and Identity Types of Microsoft Entra ID**.

The goal was to simulate a real-world administrative task involving:
- Creating and configuring new user identities.  
- Managing user properties and group memberships.  
- Assigning appropriate licenses to users.  
- Testing authentication and access with Multi-Factor Authentication (MFA).

---

## ⚙️ Implementation Steps  

### 🧩 Step 1: Accessing Microsoft Entra Admin Center  

I began by signing into the **Microsoft 365 Admin Center** using my administrator credentials.  
From the navigation menu, I navigated to:  
**Admin centers → Identity**, which opened the **Microsoft Entra Admin Center**.  

Once inside, I explored the **Users** section to review existing accounts and familiarize myself with user-level administrative controls.

---

### 👤 Step 2: Creating a New User  

To simulate onboarding a new user:
1. I selected **+ New User → Create new user**.  
2. Entered the following details:  
   - **User Principal Name:** `sara@WWLxZZZZZZ.onmicrosoft.com`  
   - **Display Name:** *Sara Perez*  
   - **Password:** Manually created a secure temporary password.  
   - **Account Status:** Enabled  
3. In the **Properties** tab, I specified:
   - **First Name:** Sara  
   - **Last Name:** Perez  
   - **User Type:** Member  
   - **Usage Location:** My region (to enable license assignment).  

After reviewing the configuration, I selected **Review + Create** to finalize the account creation.  
Sara Perez was successfully added to the tenant’s user directory.

---

### 👥 Step 3: Assigning Groups and Roles  

Once Sara’s account was created, I added her to the **Operations** group to align her with departmental resources.  

I also reviewed the available **directory roles**, ensuring she had standard user-level permissions without elevated administrative access — maintaining the **principle of least privilege**.

---

### 🧾 Step 4: Assigning Licenses via Microsoft 365 Admin Center  

Next, I switched back to the **Microsoft 365 Admin Center** to manage Sara’s licenses:  
- Navigated to **Users → Active Users → Sara Perez**.  
- Opened the **Licenses and Apps** tab.  
- Assigned the **Microsoft Power Apps Developer** license (since E5 licenses were unavailable).  
- Selected **Save Changes**, confirming a successful license assignment notification.

This step validated my understanding of **licensing dependency on usage location** and **license allocation workflows** within Microsoft 365.

---

### 🔑 Step 5: Signing in as the New User  

To verify the configuration, I signed into the Microsoft 365 environment as **Sara Perez** via [https://login.microsoft.com](https://login.microsoft.com).  
- Entered the temporary password created earlier.  
- Updated it upon first login as prompted.  
- Completed **Multi-Factor Authentication (MFA)** setup for enhanced security.  

Sara successfully authenticated, confirming that account provisioning, password management, and license activation were configured correctly.

---

## 🧠 Skills Demonstrated  

| Skill | Description |
|--------|--------------|
| **Identity Management** | Created and configured user identities in Microsoft Entra ID |
| **Access Control** | Assigned groups and explored directory roles |
| **License Management** | Allocated Power Apps Developer license and validated configuration |
| **MFA Configuration** | Completed multi-factor authentication setup |
| **Security Governance** | Applied least privilege principle and verified compliance readiness |

---

## 🧰 Tools & Platforms  

| Tool / Service | Purpose |
|-----------------|----------|
| **Microsoft Entra ID** | Identity creation, group membership, and user property configuration |
| **Microsoft 365 Admin Center** | License assignment and user management |
| **Microsoft Edge** | Browser environment for administrative console access |
| **MFA (Multi-Factor Authentication)** | Enhanced login security for identity protection |

---

## 🏁 Outcome  

By completing this lab, I:  
✅ Developed practical experience managing **user identities and licenses** in Microsoft Entra ID.  
✅ Strengthened understanding of **Microsoft 365 identity hierarchy and access governance**.  
✅ Validated my ability to enforce **authentication and compliance best practices**.  
✅ Reinforced core concepts from the **Microsoft SC-900 Certification** in a hands-on environment.  

---

## 📸 Screenshots  

> Screenshots from this lab (user creation, license assignment, and MFA setup) are available in the folder:  
> 📁 `screenshots/`  

---

## 🚀 Summary  

This lab demonstrates my ability to manage **identity lifecycle tasks** within Microsoft Entra ID — from **user provisioning** to **license governance** and **secure authentication**.  

It highlights my foundational understanding of **cloud identity architecture**, **compliance alignment**, and **security configuration**, essential for enterprise cloud environments.  

---

**⭐ This lab is part of my ongoing Cloud Security Lab Portfolio — showcasing my journey in building secure, compliant, and governed cloud environments.**
