# Versioning

## Versioning Strategy

We use [Semantic Versioning 2.0.0](https://semver.org/) for all pipeline template repositories.

**Format:**  
`vMAJOR.MINOR.PATCH` (e.g., `v2.4.1`)

---

### Summary

- **MAJOR** – Incompatible / Breaking Changes
- **MINOR** – Backward-Compatible Features / Additions
- **PATCH** – Fixes, Internal Refactors, Docs

---

## 🔢 Version Segment Guide

| Change Type            | Description                                                                            | Version Segment |
|------------------------|----------------------------------------------------------------------------------------|-----------------|
| 🚨 **Breaking Change** | Removes or changes current behaviour; users **must update** their templates            | **MAJOR**       |
| 🚀 **New Feature**     | Adds new optional behaviour, flags, steps, templates, or parameters                    | **MINOR**       |
| 🛠 **Patch/Fix**       | Bug fixes, refactors that don’t affect output, documentation updates, internal cleanup | **PATCH**       |

---

## 📘 Examples

All the examples listed below are placed in the worst case scenario category. For example, an item in the breaking change list could in certain cases may not be a breaking change. This list should be used as a guideline, only through testing will breaking changes be fully understood.

### 🚨 MAJOR (Breaking Changes)

| Example                                                                                  | Why                                                    |
|------------------------------------------------------------------------------------------|--------------------------------------------------------|
| Removing a parameter                                                                     | User templates will fail unless updated                |
| Renaming a parameter                                                                     | Breaks backwards compatibility                         |
| Changing default value of a parameter from `true` to `false` (or vice versa)             | May silently change behaviour                          |
| Changing the name of a `stage`, `job`, or `step` relied on in condition expressions      | Could cause existing references to break               |
| Altering a required input parameter to behave differently                                | Could cause misconfigured pipelines                    |
| Replacing an entire job with a differently structured one                                | Requires consumers to restructure usage                |
| Moving required logic to a separate template without maintaining backwards compatibility | Users may need to import or call templates differently |
| Switching from inline script to a script path that must now exist in the repo            | Assumes repo structure users may not have              |

---

### 🚀 MINOR (New Features - Non-Breaking)

| Example                                                                                   | Why                                          |
|-------------------------------------------------------------------------------------------|----------------------------------------------|
| Adding a new optional parameter (e.g., `enableFoo: false`)                                | Default must maintain existing behaviour     |
| Adding a new step behind a condition or flag                                              | Should not affect current users              |
| Adding support for a new environment or tool (e.g., `.NET 8`, `Node 20`)                  | Parallel support with existing versions      |
| Making a previously static value configurable via a new optional parameter                | Keeps old behaviour by default               |
| Adding a new template file for additional functionality (`template.deploy-infra.yml`)     | Doesn’t alter existing ones                  |
| Introducing outputs from a job that consumers can optionally use                          | No current user depends on them              |
| Adding a `displayName` or `condition` that improves UX/logic but doesn’t change execution | Optional improvements                        |
| Supporting multiple strategies (e.g., matrix builds) via opt-in                           | Should be feature flagged or behind defaults |

---

### 🛠 PATCH (Fixes, Internal Refactors)

| Example                                                                     | Why                                                |
|-----------------------------------------------------------------------------|----------------------------------------------------|
| Fixing a step `condition` or logic error                                    | Fixes broken usage without requiring change        |
| Correcting a typo in a variable, script, or comment                         | Doesn’t affect logic if variable unused            |
| Reformatting YAML for readability                                           | Indentation, spacing, or anchor usage improvements |
| Updating inline documentation or comment blocks                             | Clarity for maintainers/users                      |
| Refactoring steps into a reusable job while maintaining same inputs/outputs | If completely transparent to consumers             |
| Improving runtime performance by reordering non-dependent steps             | Functional behaviour unchanged                     |
| Minor tool version bump that retains compatibility                          | e.g., `Node 18.12.1` to `18.17.0`                  |
| Adding test pipelines or validation checks                                  | Internal dev experience only                       |

---

## 🏷️ Tagging Releases

All changes must be tagged using Git in the format:

```bash
git tag -a v1.3.0 -m "Release v1.3.0 - Added support for dotnet 8"
git push origin v1.3.0
```

> Tags must be applied from the `main` branch only after validation.

---

## ✅ Checklist for Versioning a Change

Before merging:

1. Is this change **breaking**?
    - ✅ Yes → Bump MAJOR
2. Does it **add functionality**?
    - ✅ Yes → Bump MINOR
3. Is it a **bug fix or internal improvement**?
    - ✅ Yes → Bump PATCH
4. Update the `CHANGELOG.md` accordingly.
5. Apply a new Git tag after merge.

---

## 💡 Tips for Preventing Breaking Changes

- Prefer **optional parameters** with safe defaults.
- Use `condition:` statements to wrap new logic behind flags.
- Deprecate parameters with warnings before removing in next MAJOR.
- Avoid renaming elements referenced by users (e.g., `steps`, `jobs`, `outputs`).