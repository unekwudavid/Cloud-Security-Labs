# Entra ID Protection

## Overview

Microsoft Entra ID Protection was implemented to introduce identity and authentication risk signals into the access-control architecture of the MI Expense Portal.

The objective is to move beyond simple authentication and MFA by incorporating Microsoft Entra's assessment of:

- User risk
- Sign-in risk
- Risk-based Conditional Access
- Identity remediation
- Adaptive access decisions

This supports the Zero Trust principle of continuously evaluating identity and access risk rather than assuming that a successfully authenticated user should automatically be trusted.

---

## User Risk

User risk represents the probability that a user's identity has been compromised.

User risk can be influenced by identity-related security signals detected by Microsoft Entra ID Protection.

The project uses user risk as an additional input into Conditional Access decisions.

The intended control model is:

User
↓
Microsoft Entra ID Protection
↓
User risk assessment
↓
Conditional Access
↓
Access decision

High-risk users can be required to remediate their identity before continuing to access protected resources.

---

## User Risk Conditional Access Policy

### Policy Name

CA-MI-User-Risk-Remediation

### Objective

The user-risk Conditional Access policy protects the environment against identities that Microsoft Entra ID Protection determines to have a high probability of compromise.

### Configuration

| Setting | Configuration |
|---|---|
| Users | All users |
| Target resources | All resources |
| User risk | High |
| Grant control | Require risk remediation |
| Policy state | Report-only during validation |

### Control Logic

The policy evaluates the risk associated with the user's identity.

If Microsoft Entra ID Protection determines that the user's risk level is high, Conditional Access evaluates the policy and requires the user to remediate the risk before normal access can continue.

The logical flow is:

User
↓
Microsoft Entra ID Protection
↓
High user risk detected
↓
Conditional Access policy
↓
Require risk remediation
↓
User remediates risk
↓
Access can continue

### Validation Strategy

The policy was initially configured in Report-only mode to allow the configuration and expected impact to be evaluated before enforcement.

This follows a controlled Conditional Access deployment methodology:

1. Configure the policy.
2. Deploy in Report-only mode.
3. Review sign-in and Conditional Access results.
4. Validate that the intended users and resources are affected.
5. Enable enforcement after validation.

### Security Value

This control provides an additional layer beyond MFA.

MFA strengthens authentication, while user-risk detection evaluates whether the identity itself may have been compromised.

This allows access decisions to respond to identity compromise rather than relying exclusively on authentication success.

### Zero Trust Alignment

The control supports the Zero Trust principle of:

**Verify explicitly**

Authentication alone is not treated as sufficient evidence of trust. Identity risk is evaluated as an additional security signal before access is permitted.

---

## Sign-in Risk

Sign-in risk represents the probability that a particular authentication attempt is suspicious or potentially compromised.

Unlike user risk, which relates to the identity itself, sign-in risk evaluates the individual authentication event.

The project incorporates sign-in risk into Conditional Access to provide adaptive access decisions.

The intended control model is:

Authentication attempt
↓
Microsoft Entra ID Protection
↓
Sign-in risk assessment
↓
Conditional Access
↓
MFA / remediation / block
↓
Access decision

## Sign-in Risk Conditional Access Policy

### Policy Name

CA-MI-Sign-In-Risk-MFA

### Objective

The sign-in-risk Conditional Access policy evaluates the risk associated with an individual authentication event.

Unlike user risk, which evaluates the likelihood that an identity has been compromised, sign-in risk evaluates whether a particular authentication attempt appears suspicious.

### Configuration

| Setting | Configuration |
|---|---|
| Users | All users |
| Target resources | All resources |
| Sign-in risk | Medium and High |
| Grant control | Require multifactor authentication |
| Policy state | Report-only during validation |

### Control Logic

The policy evaluates the risk associated with each authentication attempt.

When Microsoft Entra ID Protection identifies a medium- or high-risk sign-in, Conditional Access requires multifactor authentication before access is granted.

The logical flow is:

Authentication attempt
↓
Microsoft Entra ID Protection
↓
Medium or High sign-in risk
↓
Conditional Access
↓
Require MFA
↓
Successful verification
↓
Access granted

### Difference from User Risk

User risk evaluates the security state of the identity.

Sign-in risk evaluates the security context of the individual authentication event.

Therefore:

User Risk
→ Potentially compromised identity

Sign-in Risk
→ Potentially suspicious authentication event

Using both controls allows the environment to respond differently to identity compromise and suspicious login activity.

### Validation Strategy

The policy was initially deployed in Report-only mode.

This allows Conditional Access results and potential policy impact to be reviewed before enforcement.

The deployment approach is:

1. Configure the policy.
2. Deploy in Report-only mode.
3. Review sign-in activity and Conditional Access evaluation.
4. Validate the intended behavior.
5. Enable enforcement after validation.

### Security Value

The policy provides adaptive authentication based on the security context of a sign-in.

A normal authentication attempt can proceed through the existing authentication controls, while a medium- or high-risk sign-in requires additional MFA verification.

### Zero Trust Alignment

This control supports continuous verification by evaluating the risk of the authentication event rather than assuming that every login attempt is trustworthy simply because the user has previously authenticated successfully.

The resulting model is:

Identity
+
Authentication
+
Sign-in risk
+
Conditional Access
=
Adaptive access decision

---

## Relationship with MFA

The project combines Microsoft Entra ID Protection with Conditional Access and MFA.

MFA provides an additional authentication factor.

Identity Protection provides risk signals.

Conditional Access evaluates those signals and determines the appropriate access control.

Therefore:

Identity Protection
= Risk detection

Conditional Access
= Policy enforcement

MFA
= Strong authentication control

Together these controls provide adaptive identity protection.

---

## Zero Trust Alignment

The implementation supports the Zero Trust principles of:

- Verify explicitly
- Use least privilege
- Assume breach

Authentication alone is not treated as sufficient evidence of trust.

Access decisions can incorporate:

- User identity
- Application assignment
- Application role
- MFA status
- User risk
- Sign-in risk
- Privileged access state
- Group membership

This creates a layered identity security model for the MI Expense Portal.

---

## Evidence

The following evidence was captured during implementation:

1. Entra ID Protection configuration
2. User-risk Conditional Access policy
3. Sign-in-risk Conditional Access policy
4. Policy configuration and conditions
5. Resulting access-control behavior where testable

Sensitive information such as passwords, client secrets, access tokens, authorization codes, and session credentials must not be included in screenshots or documentation.

---


## Sign-in Risk Validation

After configuring the sign-in-risk Conditional Access policy, a new authentication was performed through the MI Expense Portal.

The resulting Microsoft Entra sign-in event was reviewed through the Entra sign-in logs.

The Conditional Access evaluation was inspected to confirm that the configured risk-based policy was evaluated against the authentication event.

The validation demonstrates the relationship between:

MI Expense Portal
↓
Microsoft Entra authentication
↓
Identity Protection risk evaluation
↓
Conditional Access evaluation
↓
Access decision

The policy remained in Report-only mode during validation to prevent unintended disruption while confirming the expected evaluation behavior.

### Evidence Captured

The following evidence was captured:

- User-risk Conditional Access configuration
- Sign-in-risk Conditional Access configuration
- MI Expense Portal authentication event
- Conditional Access evaluation associated with the authentication event

No authentication codes, access tokens, client secrets, passwords, or session credentials were included in the evidence.

### Validation Result

The sign-in-risk policy was successfully configured and evaluated against an actual MI Expense Portal authentication event.

A genuine medium- or high-risk sign-in was not artificially generated for testing. The implementation instead validates the policy configuration and its evaluation through the normal authentication process.

This provides evidence that risk-based access controls have been integrated into the MI Expense Portal's Microsoft Entra authentication architecture.

___

## Summary

The implementation demonstrates practical experience with:

- Microsoft Entra ID Protection
- User risk
- Sign-in risk
- Risk-based Conditional Access
- MFA
- Adaptive access control
- Identity threat detection
- Zero Trust architecture
- Risk-based identity governance

The key architectural principle is that authentication establishes identity, while risk signals and authorization controls determine whether access should continue.