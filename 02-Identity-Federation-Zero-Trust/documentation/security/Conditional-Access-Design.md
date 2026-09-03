# Conditional Access Security Design

## Purpose

This document defines the Conditional Access security controls for the Mustard Innovations Identity Federation & Zero Trust Platform.

The objective is to ensure that authentication alone does not automatically result in application access.

Access to enterprise applications should be evaluated continuously based on identity, authentication strength, device state, risk, and privilege.

---

## Security Principle

The project follows the Zero Trust principle:

> Never trust, always verify , assume breach.

Successful authentication establishes the identity of the user, but Conditional Access determines whether the authentication context satisfies the organization's security requirements.

---

## Protected Application

Application:

MI Expense Portal

Identity Provider: Microsoft Entra ID

Authentication Protocol: OAuth 2.0 / OpenID Connect

Authorization Model: Microsoft Entra Application Roles + backend RBAC

---

## Conditional Access Policy Design

### CA-001 — Require MFA

Purpose:

Require multifactor authentication when accessing the MI Expense Portal.

Threat addressed: Credential theft and password-only authentication.

Control: Require multifactor authentication.

Expected outcome: A valid username and password alone should not be sufficient when the policy applies.

Validation:

1. Sign in to the MI Expense Portal.
2. Observe the authentication challenge.
3. Complete MFA.
4. Verify successful application access.
5. Confirm the sign-in event in Microsoft Entra sign-in logs.

---

### CA-002 — Block Legacy Authentication

Purpose: Prevent authentication protocols that cannot enforce modern authentication security controls.

Threat addressed: Legacy authentication protocols can bypass modern authentication protections such as MFA.

Control: Block legacy authentication.

Expected outcome: Authentication attempts using legacy authentication protocols should be denied.

Validation: Review sign-in logs and confirm that applicable legacy authentication attempts are blocked.

---

### CA-003 — Protect Privileged Users

Purpose: Apply stronger authentication requirements to privileged identities.

Threat addressed: Compromise of privileged administrator accounts.

Control: Apply stronger Conditional Access requirements to privileged roles.

Expected outcome: Privileged identities should be subject to stronger authentication controls than ordinary workforce identities.

Validation: Test with a privileged test identity and verify that the expected authentication requirement is enforced.

---

### CA-004 — Require Compliant Devices

Purpose: Restrict application access to devices that satisfy organizational security requirements.

Threat addressed: Access from unmanaged or potentially compromised devices.

Control: Require device compliance.

Expected outcome: Users accessing the protected application from non-compliant devices should be denied or challenged according to policy configuration.

Validation: Test access using compliant and non-compliant device scenarios and review the resulting sign-in events.

---

### CA-005 — Risk-Based Authentication

Purpose: Use identity and sign-in risk information to dynamically increase authentication requirements.

Threat addressed: Compromised credentials and suspicious authentication activity.

Control: Use Microsoft Entra ID Protection risk signals with Conditional Access.

Expected outcome: Higher-risk authentication events should trigger additional controls such as MFA or access restrictions.

Validation: Generate or simulate an applicable risk condition and verify the resulting Conditional Access decision.

---

### CA-006 — Phishing-Resistant Authentication

Purpose: Protect sensitive identities from credential phishing and token theft.

Threat addressed: Phishing attacks against passwords and weaker authentication methods.

Control: Require phishing-resistant authentication methods for applicable users or privileged identities.

Expected outcome: Users within the policy scope must authenticate using an approved phishing-resistant authentication method.

Validation: Test the authentication flow using the configured authentication method and confirm the Conditional Access result.

---

## Policy Evaluation Model

The Conditional Access architecture follows:

User
↓
Microsoft Entra ID
↓
Authentication
↓
Conditional Access Evaluation
↓
Identity / Device / Risk / Application Conditions
↓
Grant / Require Control / Block
↓
Application
↓
Application Role
↓
Backend RBAC
↓
Authorized Functionality

---

## Security Layers

The platform therefore implements multiple identity security layers:

1. Authentication
2. Conditional Access
3. Identity Risk Evaluation
4. Application Roles
5. Backend Authorization
6. Audit Logging
7. Monitoring

This creates defense in depth around enterprise application access.

---

## Validation Principle

Each Conditional Access policy will be documented using:

Policy
→ Threat
→ Control
→ Expected Outcome
→ Test Scenario
→ Result
→ Evidence

No policy will be considered complete until its behavior has been validated and documented.