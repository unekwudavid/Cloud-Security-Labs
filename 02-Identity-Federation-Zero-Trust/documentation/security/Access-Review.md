# Identity Governance — Access Reviews

## Project Module

Identity Federation & Zero Trust Platform — Project 2

## Objective

Implement Microsoft Entra Access Reviews to periodically validate membership of privileged business groups.

This demonstrates Identity Governance capabilities by ensuring access remains appropriate over time.

---

## Business Scenario

Mustard Innovations performs quarterly reviews of Finance group membership.

Employees who no longer require Finance access should have access removed after review.

The group under governance is:

**SG-Finance**

---

## Governance Principle

> Access should be periodically reviewed rather than granted permanently.

Identity Governance ensures access remains aligned with business responsibilities.

---

## Access Review Configuration

| Setting               | Configuration                           |
| --------------------- | --------------------------------------- |
| Review Name           | `AR-SG-Finance-Quarterly-Access-Review` |
| Resource Type         | Teams + Groups                          |
| Resource              | `SG-Finance`                            |
| Scope                 | All Users                               |
| Frequency             | Quarterly                               |
| Review Duration       | 14 Days                                 |
| Reviewer              | Selected Reviewer / IAM Administrator   |
| Auto Apply Results    | Enabled                                 |
| Non-response Action   | Remove Access                           |
| Recommendation Helper | No Sign-in Within 30 Days               |

---

## Governance Workflow

Finance User
↓
SG-Finance Membership
↓
Quarterly Access Review
↓
IAM Reviewer
├── Approve Access
└── Deny Access
↓
Automatic Membership Update

---

## Review Lifecycle

### Review Creation

The access review was created for SG-Finance.

### Review Execution

The reviewer evaluated each group member.

### Review Decision

Possible reviewer decisions:

* Approve
* Deny

### Remediation

Approved members retain access.

Denied members are automatically removed from SG-Finance after review completion.

---

## Security Value

Access Reviews reduce:

* Privilege accumulation.
* Stale group memberships.
* Former employee access.
* Excessive departmental permissions.

The implementation demonstrates continuous governance rather than one-time provisioning.

---

## Zero Trust Alignment

Zero Trust assumes access requirements change over time.

Access Reviews provide continuous verification that access remains justified.

---

## Evidence Captured

Screenshots collected:

* Access Review creation.
* Review schedule and recurrence.
* Reviewer configuration.
* Review settings.
* Review overview.
* Review results.
* Membership remediation behavior.

---


### Why use Access Reviews?

To periodically validate that users still require access to privileged groups and applications.

### Why enable Auto Apply Results?

To automate access remediation after reviewer decisions instead of relying on manual cleanup.

### Why quarterly reviews?

Quarterly reviews balance operational overhead with governance and compliance requirements.
