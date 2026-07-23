# Security Principles

## Zero Trust

Mustard Innovations adopts a Zero Trust security model where no user, device, or application is trusted by default, regardless of its location or network. Every access request must be authenticated, authorized, and continuously validated based on identity, device health, location, and risk before access is granted.

---

## Verify Explicitly

All authentication and authorization decisions are based on multiple security signals, including user identity, device compliance, location, application sensitivity, and sign-in risk. Access decisions are continuously evaluated to ensure that users maintain the appropriate level of trust throughout their sessions.

---

## Least Privilege

Access to corporate resources is granted using the principle of least privilege. Users receive only the permissions required to perform their assigned responsibilities. Administrative privileges are minimized, regularly reviewed, and removed when no longer required.

---

## Assume Breach

Mustard Innovations operates under the assumption that security incidents may occur despite preventive controls. Monitoring, logging, alerting, and incident response capabilities are implemented to rapidly detect, contain, and recover from potential security events while minimizing business impact.

---

## Multi-Factor Authentication (MFA)

Multi-Factor Authentication is mandatory for all privileged accounts and will be progressively enforced for all employees. MFA provides an additional layer of protection by requiring multiple forms of verification before granting access to corporate resources.

---

## Passwordless Authentication

Where supported, passwordless authentication methods such as Microsoft Authenticator, Windows Hello for Business, and FIDO2 security keys will be adopted to reduce credential theft risks and improve user experience.

---

## Conditional Access

Conditional Access policies will evaluate contextual signals including user risk, device compliance, application sensitivity, geographic location, and authentication strength before granting access. Policies will enforce adaptive security controls while minimizing unnecessary user disruption.

---

## Just-In-Time Administration

Administrative privileges will be assigned through Microsoft Entra Privileged Identity Management (PIM) using Just-In-Time (JIT) activation. Administrative access will be time-bound, approval-based where appropriate, and fully audited to reduce the attack surface associated with permanently privileged accounts.

---

## Continuous Monitoring

Identity-related activities, authentication events, administrative actions, and security alerts will be continuously monitored through Microsoft Entra logs, Microsoft Defender, and Microsoft Sentinel. Monitoring supports proactive threat detection, compliance reporting, and continuous improvement of the organization's security posture.
