# GitHub Repository Strategy

This document details the enterprise Git branching model and collaboration process established for the **Fitness Tracker** application to ensure quality, security, and stability.

---

## 1. Branching Model (GitFlow Simplified)

We employ a simplified GitFlow model tailored for Continuous Integration and Continuous Deployment (GitOps):

```
                       [ feature/add-metrics ]
                              /        \
                             /          \
  (develop) ----------------o------------o------------o------------------->
                                          \          / (Integration PR)
                                           \        /
  (staging) --------------------------------o------o----------------------->
                                                    \
                                                     \ (Release PR)
  (master/prod) ----------------------------------------o--------------------->
```

### Main Branches

1. **`master` (Production)**
   * **Purpose:** Production release-ready code.
   * **Source:** Merged only from `staging` via pull request.
   * **Deployment:** Automatically tracked by ArgoCD in the production environment.
   * **Access:** Restricted (requires senior admin review).

2. **`staging` (Pre-production)**
   * **Purpose:** Represents the pre-production environment code. Used for final QA testing.
   * **Source:** Merged from `develop` via pull request.
   * **Deployment:** Tracked by ArgoCD in the staging namespace.

3. **`develop` (Integration/Testing)**
   * **Purpose:** Integration branch for all active features.
   * **Source:** Feature branches are merged here.
   * **Deployment:** Tracked by ArgoCD in the development namespace.

### Temporary Branches

4. **`feature/*` (Feature development)**
   * **Purpose:** Used by developers to build new user stories or bug fixes.
   * **Naming Convention:** `feature/ftdp-<issue-id>-<short-description>` (e.g., `feature/ftdp-12-add-metrics`).
   * **Source:** Created from `develop` and merged back into `develop`.

---

## 2. Pull Request (PR) Policy

To maintain code quality and prevent unauthorized changes, the following policies apply:

1. **No Direct Pushes**
   * Direct pushes to `master`, `staging`, and `develop` are blocked using GitHub branch protection rules. All code changes must come via Pull Requests.

2. **Required Approvals**
   * PRs merging feature branches into `develop` require at least **1 approved review** from a peer developer.
   * PRs merging `develop` to `staging` or `staging` to `master` require approval from the **DevOps/Tech Lead**.

3. **Required Status Checks (CI Pipelines)**
   * The **GitHub Actions CI pipeline** must complete successfully before merging:
     * NPM Install
     * Code lint check (`eslint`)
     * Unit Tests
     * **SonarQube Quality Gate Status: PASSED**

---

## 3. Merge Flow Example

1. **Checkout Feature Branch:**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/ftdp-12-add-metrics
   ```
2. **Work and Commit:**
   ```bash
   git add .
   git commit -m "feat(metrics): add weight and BMI tracking endpoints"
   ```
3. **Push Feature and Open PR:**
   ```bash
   git push origin feature/ftdp-12-add-metrics
   ```
   * Open PR on GitHub: `feature/ftdp-12-add-metrics` ➔ `develop`.
4. **CI & Review:**
   * Automated CI pipeline runs.
   * Peer reviews code and approves.
5. **Merge to develop:**
   * Squash-merge is preferred to keep develop history clean.
6. **Promotion to Staging & Production:**
   * After validation, a release PR is opened to merge `develop` into `staging`, and eventually `staging` into `master`.
