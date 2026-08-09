# ☁️ Cloud Security & IAM Portfolio

A professional portfolio documenting my transition from **Software Engineering into Identity & Access Management (IAM), Cloud Security Engineering, and AI Security** through hands-on enterprise projects and security-focused implementations.

> **Enterprise Identity • Zero Trust • Cloud Security • Automation • AI Security**

The portfolio is built around a simple principle:

> **Secure the identity → secure the cloud → secure the workload → detect threats → secure the AI application.**

Rather than building isolated labs, the projects are designed to build upon one another, demonstrating how **identity, cloud infrastructure, security operations, automation, and AI security** work together in a modern enterprise environment.

---

# 👨‍💻 Profile Snapshot

Hi, I'm **David Adama**, a Cloud Security Engineer in training with a software engineering background and a focus on **Identity & Access Management, Microsoft cloud security, Zero Trust, automation, and AI workload security**.

I have **4 years of experience as a Mobile Software Engineer** and hold certifications/training in **CompTIA Security+, ISO 27001 Lead Implementer, and NIST RMF**.

I am transitioning into **IAM and Cloud Security Engineering**, building practical enterprise-inspired projects that demonstrate implementation ability rather than theoretical knowledge alone.

My current focus is developing expertise across:

* Identity & Access Management
* Microsoft Entra ID
* Identity Lifecycle Management
* Identity Federation
* Zero Trust
* Cloud Security
* Infrastructure as Code
* Identity Automation
* DevSecOps
* Security Monitoring & Detection
* AI Workload Security
* AI Application Security

This repository serves as the central portfolio for that journey.

---

# 🎯 Career Direction

My immediate goal is to become employable as an:

* **IAM Engineer**
* **Identity Engineer**
* **Cloud Identity Engineer**
* **Microsoft Entra Administrator**
* **Identity & Access Management Consultant**
* **Cloud Security Engineer**

As the portfolio develops, I am expanding toward:

* **Cloud Security Engineering**
* **AI Workload Security**
* **AI Security Engineering**
* **Cloud Identity & AI Security**

The long-term objective is to combine strong identity fundamentals with cloud and AI security expertise.

---

# 🧭 Portfolio Strategy

The portfolio follows an integrated progression rather than treating IAM and Cloud Security as separate disciplines.

```text
                         SECURITY ENGINEERING
                                │
               ┌────────────────┼────────────────┐
               ▼                ▼                ▼
              IAM             CLOUD          AI SECURITY
               │                │                │
          Entra ID           Azure          AI Workloads
          OAuth/OIDC         Defender        RAG
          SAML               Firewall        AI Agents
          SCIM               Network         Data Security
          PIM                Policy          AI Supply Chain
          JML                Logging         Threat Modeling
               │                │                │
               └────────────────┼────────────────┘
                                ▼
                           AUTOMATION
                                │
                 Terraform • Bicep • Graph
                 PowerShell • GitHub Actions
                 OIDC • Federated Credentials
```

The projects deliberately alternate between IAM and Cloud/AI Security so that each project reinforces the previous one.

---

# 🏗️ Portfolio Architecture

The portfolio consists of **three core IAM platforms** followed by **five Cloud & AI Security projects**.

```text
IAM 01
Enterprise Identity Platform
        │
        ▼
CLOUD/AI 01
Secure Azure & AI Landing Zone
        │
        ▼
IAM 02
Identity Federation & Zero Trust
        │
        ▼
CLOUD/AI 02
Zero-Trust AI Network Security
        │
        ▼
IAM 03
Identity Automation & DevSecOps
        │
        ▼
CLOUD/AI 03
AI Security Monitoring & Detection
        │
        ▼
CLOUD/AI 04
Secure AI/ML DevSecOps
        │
        ▼
CLOUD/AI 05
Secure AI Application & RAG Security
```

This creates a progression from **identity foundations to cloud security and ultimately AI security**.

---

# ⭐ IAM PROJECTS

## 01 — Enterprise Identity Platform

### Purpose

> **Build and govern enterprise identities throughout their lifecycle.**

This is the flagship IAM project and establishes the identity foundation used by the later projects.

### Business Scenario

**Mustard Innovations** is a fictional cloud-first technology company with approximately **250 employees** operating across **Nigeria, the United Kingdom, and Canada**.

As the Identity & Access Management Engineer, I am responsible for designing and implementing an enterprise Microsoft Entra ID environment using identity governance, automation, Zero Trust principles, and enterprise security practices.

### Project Phases

#### Phase 1 — Enterprise Identity Foundation

* Tenant strategy
* Naming standards
* Administrative roles
* Governance
* Administrative Units

#### Phase 2 — Identity Provisioning

* HR-driven provisioning
* User creation
* Password profiles
* Manager assignment
* Logging

#### Phase 3 — Identity Automation

* Security groups
* Dynamic groups
* Administrative Units
* Manager assignment
* Licensing
* RBAC
* Configuration-driven automation

#### Phase 4 — Joiner / Mover / Leaver

**Joiner**

* Automated onboarding
* Group assignment
* Licensing
* Manager assignment

**Mover**

* Department changes
* Job title changes
* Manager changes
* Role changes
* License changes
* Group changes
* Administrative Unit changes

**Leaver**

* Account disablement
* License removal
* Privileged role removal
* Session revocation
* Offboarding reporting

#### Phase 5 — Identity Governance

* Reporting
* Dashboards
* Audit logs
* Lifecycle documentation
* Governance controls

### Technologies

* Microsoft Entra ID
* Microsoft Graph
* PowerShell
* JSON
* CSV
* Azure RBAC
* GitHub
* Mermaid

**Project Status:** 🚧 In Progress

---

# 02 — Identity Federation & Zero Trust Platform

### Purpose

> **Secure authentication, federation, application access, and identity lifecycle across enterprise applications and identity providers.**

This project expands the identity lifecycle established in Project 1 into external applications and identity providers.

### Phase 1 — Application Identity

* Enterprise Applications
* Application Registrations
* Service Principals

### Phase 2 — Authentication & Federation

* OAuth 2.0
* OpenID Connect (OIDC)
* SAML
* Single Sign-On

### Phase 3 — Identity Provisioning

* SCIM
* User provisioning
* User deprovisioning
* Group synchronization
* Application lifecycle management

### Phase 4 — Identity Providers

#### Microsoft Entra ID

* Enterprise federation
* Application access
* Conditional Access

#### Okta

* Federation
* Provisioning
* MFA
* Group synchronization

#### Keycloak

* Identity Provider
* Federation
* SSO

### Phase 5 — Zero Trust

* Conditional Access
* Risk-based policies
* Named locations
* Device compliance
* MFA
* Identity-aware access

### Phase 6 — Cloudflare Access

* Identity-aware proxy
* Zero Trust application access
* Identity-based policies

### Technologies

* Microsoft Entra ID
* Okta
* Keycloak
* Cloudflare Access
* OAuth 2.0
* OpenID Connect
* SAML
* SCIM
* MFA
* Conditional Access

**Project Status:** ⏳ Planned

---

# 03 — Identity Automation & DevSecOps Platform

### Purpose

> **Automate identity infrastructure and securely deploy identity changes through Infrastructure as Code and CI/CD.**

This project turns the identity capabilities developed in Projects 1 and 2 into a repeatable engineering workflow.

### Phase 1 — Infrastructure as Code

* Terraform
* Bicep

### Phase 2 — Identity Automation

* Microsoft Graph
* PowerShell modules
* Azure CLI

### Phase 3 — Secure CI/CD

* GitHub Actions
* Automated validation
* Deployment workflows
* Security gates

### Phase 4 — Workload Identity

* OIDC
* Federated credentials
* Managed identities
* Elimination of long-lived credentials

### Phase 5 — Secrets Management

* Azure Key Vault
* Secret management
* Credential protection

### Phase 6 — Complete Identity Pipeline

```text
Developer
    │
    ▼
GitHub
    │
    ▼
Pull Request
    │
    ▼
Validation
    │
    ▼
Security Checks
    │
    ▼
GitHub OIDC
    │
    ▼
Microsoft Entra ID
    │
    ▼
Azure
    │
    ▼
Identity Infrastructure
```

### Technologies

* Terraform
* Bicep
* Microsoft Graph
* PowerShell
* Azure CLI
* GitHub Actions
* Microsoft Entra ID
* OIDC
* Federated Credentials
* Azure Key Vault

**Project Status:** ⏳ Planned

---

# ☁️ CLOUD & AI SECURITY PROJECTS

The Cloud & AI Security projects apply the identity, Zero Trust, automation, and governance capabilities developed in the IAM projects to broader cloud and AI security scenarios.

---

# 04 — Secure Azure & AI Landing Zone

### Purpose

> **Build a governed Azure environment capable of securely hosting AI workloads.**

This project establishes the cloud security foundation.

### Security Domains

#### Governance

* Azure Policy
* Resource organization
* Security baselines
* Compliance controls

#### Cloud Security

* Microsoft Defender for Cloud
* Secure configuration
* Vulnerability management
* Security posture management
* Misconfiguration remediation

#### Identity

* Entra ID
* RBAC
* Managed identities
* Least privilege

#### Data Security

* Azure Storage
* Key Vault
* Encryption
* Secure access controls

#### AI Workloads

* Azure AI services
* AI application resources
* AI data stores
* Secure AI endpoints

### Security Methodology

```text
Deploy
  ↓
Introduce / Identify Misconfiguration
  ↓
Security Finding
  ↓
Risk Assessment
  ↓
Remediation
  ↓
Validation
  ↓
Evidence
```

### Project Outcome

Demonstrate how enterprise identity and governance controls can be applied to an Azure environment hosting AI workloads.

**Project Status:** ⏳ Planned

---

# 05 — Zero-Trust AI Network Security

### Purpose

> **Protect AI workloads through network segmentation, private connectivity, identity-aware access, and controlled egress.**

### Architecture

```text
                         Internet
                            │
                            X
                            │
                     Azure Firewall
                            │
                     ┌──────▼──────┐
                     │     HUB     │
                     └──────┬──────┘
                            │
              ┌─────────────┼─────────────┐
              ▼             ▼             ▼
           AI-App         AI-Data      AI-Platform
           Spoke           Spoke          Spoke
              │             │             │
              └─────────────┼─────────────┘
                            │
                    Private Connectivity
```

### Technologies

* Azure Virtual Network
* Hub-and-Spoke
* NSGs
* Azure Firewall
* User Defined Routes
* Private Endpoints
* Private DNS
* Azure Bastion
* Network segmentation

### AI Security Scenarios

* Restrict AI workload internet access
* Prevent unauthorized data access
* Control outbound traffic
* Isolate compromised workloads
* Secure AI-to-data communication
* Prevent unnecessary lateral movement

### Identity Integration

```text
User
 ↓
Entra ID
 ↓
Conditional Access
 ↓
AI Application
 ↓
Managed Identity
 ↓
AI Resource
```

**Project Status:** ⏳ Planned

---

# 06 — AI Security Monitoring & Detection Engineering

### Purpose

> **Detect, investigate, and respond to identity, cloud, network, and AI security threats.**

### Architecture

```text
Entra ID
Azure
Network
AI Services
Applications
    │
    ▼
Security Logs
    │
    ▼
Log Analytics
    │
    ▼
KQL
    │
    ▼
Detection Rules
    │
    ▼
Alerts
    │
    ▼
Investigation
    │
    ▼
Response
```

### Detection Categories

#### Identity

* Suspicious authentication
* Privilege escalation
* PIM activation
* Workload identity abuse

#### Cloud

* Dangerous configuration changes
* Public exposure
* Resource modifications
* Security control changes

#### Network

* Unusual connections
* Suspicious outbound traffic
* Firewall rule changes
* Potential lateral movement

#### AI

* Abnormal AI API activity
* Unusual model access
* Unauthorized AI resource modifications
* Suspicious AI data access

### Technologies

* Azure Monitor
* Log Analytics
* Microsoft Entra logs
* Azure Activity Logs
* KQL
* Microsoft Defender
* Alerting and automated response

**Target:** 8–12 meaningful security detections.

**Project Status:** ⏳ Planned

---

# 07 — Secure AI/ML DevSecOps Platform

### Purpose

> **Secure AI infrastructure, applications, and deployment pipelines throughout the software supply chain.**

### Pipeline

```text
Developer
    │
    ▼
GitHub
    │
    ▼
Pull Request
    │
    ├── SAST
    ├── Dependency Scanning
    ├── Secret Scanning
    ├── Terraform / IaC Scanning
    ├── Container Scanning
    ├── Policy-as-Code
    └── AI Security Tests
              │
              ▼
        Security Gate
              │
              ▼
          Deployment
              │
              ▼
        Azure AI Workload
```

### Security Domains

* Secure source code
* Dependency security
* Secret detection
* Infrastructure security
* Container security
* Policy-as-Code
* AI supply-chain security
* Secure CI/CD
* Workload identity

### Identity Integration

GitHub Actions authenticates to Azure using:

**OIDC + Microsoft Entra federated credentials**

rather than long-lived credentials.

### Technologies

* GitHub Actions
* Terraform
* Bicep
* OIDC
* Microsoft Entra ID
* SAST
* Dependency scanning
* Secret scanning
* Container scanning
* Policy-as-Code

**Project Status:** ⏳ Planned

---

# 08 — Secure AI Application & RAG Security

### Purpose

> **Secure AI applications, RAG architectures, data access, and AI agent capabilities against application-layer threats.**

This is the AI security capstone.

### Reference Architecture

```text
                         User
                           │
                           ▼
                    AI Application
                           │
                    ┌──────┴──────┐
                    ▼             ▼
                   LLM           RAG
                                  │
                                  ▼
                              AI Search
                                  │
                                  ▼
                         Enterprise Data
```

### Security Testing

* Prompt injection
* Indirect prompt injection
* Unauthorized document retrieval
* Sensitive information disclosure
* Excessive agent permissions
* Insecure tool/function access
* Data leakage
* Excessive AI application privileges

### Security Controls

* Entra ID
* RBAC
* Managed identities
* Least privilege
* Network isolation
* Data authorization
* Input validation
* Output validation
* Monitoring
* Secure CI/CD

### Security Methodology

```text
Threat
  ↓
Attack Simulation
  ↓
Detection
  ↓
Control Design
  ↓
Implementation
  ↓
Validation
  ↓
Documentation
```

**Project Status:** ⏳ Planned

---

# 📊 Portfolio Roadmap

## Stage 1 — Identity Foundation

### IAM Project 1

**Enterprise Identity Platform**

Focus:

* Entra ID
* Provisioning
* JML
* Graph
* PowerShell
* Governance
* RBAC

↓

## Stage 2 — Cloud Foundation

### Cloud/AI Project 1

**Secure Azure & AI Landing Zone**

Focus:

* Azure security
* Defender
* Policy
* Governance
* AI workloads
* Identity integration

↓

## Stage 3 — Federation & Zero Trust

### IAM Project 2

**Identity Federation & Zero Trust Platform**

Focus:

* OAuth 2.0
* OIDC
* SAML
* SCIM
* Okta
* Keycloak
* Conditional Access
* Zero Trust

↓

## Stage 4 — AI Network Security

### Cloud/AI Project 2

**Zero-Trust AI Network Security**

Focus:

* Hub-and-Spoke
* NSGs
* Azure Firewall
* Private Endpoints
* Private DNS
* AI workload isolation

↓

## Stage 5 — Identity Automation

### IAM Project 3

**Identity Automation & DevSecOps Platform**

Focus:

* Terraform
* Bicep
* Graph
* PowerShell
* GitHub Actions
* OIDC
* Federated Credentials
* Key Vault

↓

## Stage 6 — Detection Engineering

### Cloud/AI Project 3

**AI Security Monitoring & Detection**

Focus:

* Log Analytics
* KQL
* Defender
* Identity telemetry
* AI telemetry
* Detection engineering

↓

## Stage 7 — AI DevSecOps

### Cloud/AI Project 4

**Secure AI/ML DevSecOps**

Focus:

* CI/CD
* Security scanning
* IaC
* Supply-chain security
* Policy-as-Code
* AI security testing

↓

## Stage 8 — AI Application Security

### Cloud/AI Project 5

**Secure AI Application & RAG Security**

Focus:

* RAG security
* Prompt injection
* AI agents
* Data security
* Application authorization
* AI threat modeling

---

# 🧠 Technical Skills Matrix

| Domain                     | Technologies / Skills                                            |
| -------------------------- | ---------------------------------------------------------------- |
| **Identity**               | Microsoft Entra ID, RBAC, MFA, Conditional Access, PIM           |
| **Identity Lifecycle**     | JML, Provisioning, Governance, Access Reviews                    |
| **Identity Federation**    | OAuth 2.0, OIDC, SAML, SCIM                                      |
| **Identity Providers**     | Entra ID, Okta, Keycloak                                         |
| **Zero Trust**             | Conditional Access, Identity-aware access, Cloudflare Access     |
| **Cloud Security**         | Azure, Defender for Cloud, Azure Policy                          |
| **Network Security**       | VNets, Hub-Spoke, NSGs, Azure Firewall, Private Endpoints        |
| **AI Security**            | AI Workloads, RAG, AI Agents, Prompt Injection, AI Data Security |
| **Detection Engineering**  | Log Analytics, KQL, Azure Monitor, Defender                      |
| **Infrastructure as Code** | Terraform, Bicep                                                 |
| **Automation**             | PowerShell, Microsoft Graph, Azure CLI                           |
| **DevSecOps**              | GitHub Actions, OIDC, Security Gates, Policy-as-Code             |
| **Secrets & Credentials**  | Azure Key Vault, Federated Credentials                           |
| **Governance**             | ISO 27001, NIST RMF, NIST CSF, CIS Benchmarks                    |
| **Version Control**        | Git, GitHub                                                      |
| **Documentation**          | Markdown, Mermaid, Draw.io                                       |

---

# 🧰 Core Technology Stack

### Cloud

* Microsoft Azure
* Microsoft 365

### Identity

* Microsoft Entra ID
* Okta
* Keycloak

### Security

* Microsoft Defender
* Azure Policy
* Azure Firewall
* Microsoft Sentinel
* Microsoft Purview

### Infrastructure

* Terraform
* Bicep
* Azure CLI

### Automation

* PowerShell
* Microsoft Graph API
* GitHub Actions

### AI Security

* Azure AI services
* RAG architectures
* AI security testing
* AI threat modeling
* AI workload security

### Development & Version Control

* Git
* GitHub
* JSON
* CSV
* Markdown
* Mermaid
* Draw.io

---

# 📚 Certification Roadmap

Certifications are selected to reinforce the practical projects rather than replace hands-on experience.

### Priority

* [ ] **SC-300 — Microsoft Identity and Access Administrator**
* [ ] **AZ-500 — Azure Security Engineer Associate**

### Optional

* [ ] **HashiCorp Terraform Associate**

The objective is to combine certifications with demonstrated implementation rather than pursuing a large number of certifications without practical evidence.

---

# 📖 Documentation Philosophy

Each major project is documented as an **engineering case study**, not simply as a collection of screenshots.

Every project aims to contain:

```text
Business Scenario
       ↓
Security Requirements
       ↓
Architecture
       ↓
Threat Model
       ↓
Implementation
       ↓
Intentional Misconfiguration / Attack
       ↓
Detection
       ↓
Remediation
       ↓
Validation
       ↓
Evidence
       ↓
Lessons Learned
```

Where appropriate, projects include:

* Architecture diagrams
* Mermaid diagrams
* Terraform/Bicep code
* PowerShell scripts
* Configuration files
* Screenshots
* Security findings
* KQL queries
* Attack simulations
* Remediation evidence
* Design decisions
* Troubleshooting notes
* Lessons learned

---

# 🔗 Project Relationships

The projects are intentionally interconnected.

### IAM Project 1 → Cloud/AI Project 1

Enterprise identity and RBAC become the identity foundation for the Azure AI environment.

### IAM Project 1 → IAM Project 2

The identity lifecycle established in Project 1 becomes the source for application federation and SCIM provisioning.

### IAM Project 2 → Cloud/AI Project 2

Federation and Conditional Access become part of the Zero Trust architecture protecting AI workloads.

### IAM Project 3 → Cloud/AI Project 4

OIDC, federated credentials, Terraform, and GitHub Actions become the secure deployment mechanism for AI infrastructure.

### All IAM Projects → Cloud/AI Projects

Identity provides the foundation for:

* Authentication
* Authorization
* Least privilege
* Workload identity
* Zero Trust
* AI data access
* Security monitoring

---

# 🏆 Portfolio Outcomes

By completing this roadmap, I aim to demonstrate practical capability across:

### Identity

* Enterprise IAM
* Identity lifecycle management
* JML
* Identity governance
* Federation
* SSO
* SCIM
* Privileged access
* Workload identity

### Cloud Security

* Azure security architecture
* Cloud governance
* Network security
* Defender for Cloud
* Azure Policy
* Private connectivity
* Security posture management

### Security Operations

* Security monitoring
* KQL
* Detection engineering
* Alerting
* Investigation
* Incident response concepts

### Automation & DevSecOps

* Terraform
* Bicep
* PowerShell
* Microsoft Graph
* GitHub Actions
* OIDC
* Federated credentials
* Policy-as-Code

### AI Security

* AI workload security
* AI infrastructure security
* AI application security
* RAG security
* AI threat modeling
* Prompt injection defense
* AI data security
* AI supply-chain security

---

# 🚀 About This Portfolio

This repository is a living portfolio documenting my transition from **Software Engineering → IAM → Cloud Security → AI Security**.

The goal is not simply to demonstrate that I can configure cloud services.

The goal is to demonstrate that I can:

> **Design secure architectures, implement security controls, automate them, intentionally test their weaknesses, detect security events, remediate findings, and document the resulting security posture.**

The portfolio follows an identity-first security philosophy:

> **Identity is the foundation of modern cloud security.**

From enterprise identity lifecycle management to federation, Zero Trust, cloud infrastructure, detection engineering, DevSecOps, and AI application security, each project builds upon the previous one.

---

# 📫 Connect With Me

* 💼 **LinkedIn:** https://www.linkedin.com/in/davidadama
* 📧 **Email:** [david.adama35@gmail.com](mailto:david.adama35@gmail.com)

---

⭐ **Thank you for visiting my portfolio.**

Explore the projects, review the architecture and implementation evidence, and follow my progression from **IAM Engineering into Cloud and AI Security Engineering**.
