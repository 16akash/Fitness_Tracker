# Enterprise DevOps Architecture Flow

This document details the software delivery lifecycle flow, from local development commits to cloud monitoring and automated operations, using a Mermaid flowchart.

```mermaid
graph TD
    %% Define Nodes
    Developer[Developer Workstation]
    Jira[Jira Agile Project Management]
    GitRepo[GitHub Repository]
    CI[GitHub Actions CI Pipeline]
    SonarQube[SonarQube Quality Gate]
    DockerHub[Docker Hub Registry]
    PromoScript[Promotion Automation Script]
    HelmRepo[Helm Chart Artifact Repository]
    ArgoCD[ArgoCD GitOps Operator]
    EKS[Amazon EKS Cluster]
    KGateway[Kubernetes Gateway API - KGateway]
    Datadog[Datadog Observability]
    AIAgent[AI SRE Agent Operations]

    %% Define Connections
    Developer -->|1. Commit & Push Code| GitRepo
    Developer -.->|Tracks Tasks & Stories| Jira
    GitRepo -->|2. Triggers| CI
    CI -->|3. Runs Lint & Tests| SonarQube
    SonarQube -->|4. Quality Gate Pass| CI
    CI -->|5. Builds Container & Pushes| DockerHub
    DockerHub -->|6. Promotes tag develop -> staging| PromoScript
    PromoScript -->|7. Packages & Version updates| HelmRepo
    HelmRepo -->|8. Syncs Config| ArgoCD
    ArgoCD -->|9. Deploys via GitOps| EKS
    EKS -->|10. Exposes Service via| KGateway
    EKS -->|11. Ships Metrics & Logs| Datadog
    Datadog -.->|12. Generates log feeds| AIAgent
    AIAgent -->|13. Runs corrective patches| EKS
```

---

## Process Breakdown

1. **Jira Agile Project Management:** Tracks the sprint backlog, assigning Epics, Stories, and Tasks to developers.
2. **GitHub SCM Strategy:** Code is merged into `develop` through PR approval gates.
3. **Continuous Integration (GitHub Actions):** Automates dependencies, runs standard ESLint checks, and triggers SonarQube quality analysis.
4. **SonarQube Quality Gate:** Blocks builds containing high tech debt or open security holes.
5. **Docker Build & Registry:** Standardizes the app environment. The image promotion script tags and moves validated images across stages (Dev ➔ Staging ➔ Production) without rebuilds.
6. **GitOps CD (ArgoCD):** Deploys packaged Helm chart configurations into Amazon EKS namespaces, ensuring self-healing and synchronicity with Git.
7. **KGateway Traffic Handling:** Restricts external traffic, routing it securely to the App backend services inside EKS.
8. **Datadog Observability:** Displays live performance data, warning of memory issues or db outages.
9. **AI SRE Agent Operations:** Analyzes log failures to resolve and patch runtime clusters automatically.
