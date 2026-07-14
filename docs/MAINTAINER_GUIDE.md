# Maintainer guide: community collaboration and pull requests

This guide explains how to bring collaborators into a public GitHub project while
keeping `main`, release credentials, and users protected.

## 1. Choose the right collaboration model

### Outside contributors

Most contributors do not need repository access. They fork the repository, create
a branch in their fork, and open a pull request. This is the safest default because
they cannot push to the Kaidera repository or access organization secrets.

### Regular collaborators

Invite a proven contributor only when they need to triage issues or maintain work
over time. Start with the least privilege that works:

- **Read:** private-repository visibility without write access.
- **Triage:** issue and pull-request management without code pushes.
- **Write:** trusted maintainers who need repository branches.
- **Maintain:** project settings without destructive admin controls.
- **Admin:** repository owners only. Keep this group very small.

For an organization, prefer teams over individual permissions. A team makes access
review and offboarding predictable.

## 2. Protect `main`

Create a GitHub ruleset for the default branch with these minimum controls:

1. Require changes through pull requests.
2. Require at least one approving review.
3. Dismiss approvals when new commits materially change the pull request.
4. Require all review conversations to be resolved.
5. Require the repository's validation checks.
6. Block force pushes and branch deletion.
7. Allow bypass only for a very small owner group and use it only for emergencies.

Enable CODEOWNERS review for release workflows, package manifests, formulas, and
installer code. Do not let a pull request both modify a release workflow and gain
access to release secrets.

## 3. Triage contributions

For each issue or pull request:

1. Confirm the problem belongs to this repository.
2. Ask for reproduction steps, environment details, and the observed error.
3. Decide whether it is a bug, documentation change, proposal, or support request.
4. Define acceptance criteria before substantial implementation begins.
5. Route runtime-product changes to
   [`Kaidera-AI/kaidera-os`](https://github.com/Kaidera-AI/kaidera-os) and keep
   distribution-channel changes in this repository.

Useful labels include `bug`, `documentation`, `installer`, `homebrew`, `npm`,
`macos`, `linux`, `security`, `needs-reproduction`, and `good-first-issue`.

## 4. Review a pull request locally

Start from a clean checkout:

```sh
gh pr list
gh pr view 42 --web
gh pr checkout 42
git fetch origin
git diff --stat origin/main...HEAD
git diff origin/main...HEAD
```

Review in this order:

1. **Intent:** Does the change solve the stated problem and stay in scope?
2. **Security:** Could it expose secrets, weaken checksum verification, or run
   untrusted code with credentials?
3. **Correctness:** Do paths, versions, hashes, commands, and failure modes work?
4. **Compatibility:** Does it preserve supported macOS/Linux shells and tooling?
5. **Tests:** Is there evidence proportional to the risk?
6. **Documentation:** Are changed commands and user expectations documented?
7. **Maintainability:** Is the change smaller and clearer than the alternatives?

Run the repository checks from [CONTRIBUTING.md](../CONTRIBUTING.md). For installer
changes, also test in a temporary destination so the contributor's code does not
overwrite the maintainer's working installation.

## 5. Handle untrusted pull-request code safely

- Never paste a contributor's code into a shell without reviewing it first.
- Fork pull requests must not receive signing, npm, cloud, or production secrets.
- Avoid workflows that use `pull_request_target` to check out and execute fork code.
- Inspect changes to `.github/workflows`, installers, package scripts, and release
  URLs before running any automated command.
- Treat downloaded build artifacts as untrusted until checksums and provenance are
  verified.

## 6. Give actionable review feedback

Separate blocking findings from optional suggestions. A blocking comment should
name the risk, point to the affected line, and state the acceptance condition.

```sh
gh pr review 42 \
  --request-changes \
  --body "Empty checksums bypass verification. Fail closed and add a test."
```

Approve only the commit you reviewed. Recheck the diff after new commits arrive.

```sh
gh pr review 42 \
  --approve \
  --body "Installer checks pass and downloads remain fail-closed."
```

## 7. Merge deliberately

Use **squash merge** for most community pull requests. It keeps `main` readable
and lets the final commit message explain the user-visible change.

```sh
gh pr merge 42 --squash --delete-branch
```

Use rebase merge only when every commit is independently useful and clean. Avoid
merge commits for small changes. Never rewrite or force-push `main`; use a revert
pull request when a merged change must be undone.

After merging:

1. Confirm required checks on `main` are green.
2. Close or update the originating issue.
3. Thank the contributor and explain any follow-up work.
4. Include user-visible changes in the next release notes.

## 8. Promote trusted contributors

Do not grant write access based on one pull request. Look for a pattern of scoped
changes, responsive review follow-up, sound security judgement, and respectful
collaboration. Review collaborator and team access periodically and remove access
when it is no longer needed.

## 9. Manage releases separately from feature PRs

Community pull requests should not publish packages or create releases. A
maintainer performs the release from a reviewed commit:

1. Update the version and immutable release metadata.
2. Run all packaging and channel checks.
3. Merge the release pull request.
4. Tag the exact reviewed commit.
5. Publish the GitHub release and public macOS assets.
6. Let npm Trusted Publishing use GitHub OIDC from the bound workflow.
7. Verify Homebrew, npm, curl, and DMG downloads anonymously.

Keep signing credentials and deployment approvals outside contributor-controlled
workflows.

## 10. Recommended repository settings

- Enable Issues and private vulnerability reporting.
- Enable Discussions when the community is large enough to separate support and
  ideas from actionable issues.
- Enable automatic deletion of merged branches.
- Prefer squash merging; disable unused merge methods once the team agrees.
- Add branch rules only after required checks have stable names.
- Review organization members, outside collaborators, deploy keys, webhooks, and
  GitHub App access on a regular schedule.

The operating principle is simple: make contribution easy, make review explicit,
and keep release authority narrow.
