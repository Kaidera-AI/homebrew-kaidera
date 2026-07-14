# Security policy

## Report a vulnerability

Do not disclose a suspected vulnerability in a public issue, pull request,
discussion, log, or chat transcript. Use GitHub's private vulnerability reporting
for the affected public repository:

- [Kaidera OS source](https://github.com/Kaidera-AI/kaidera-os/security/advisories/new)
- [Kaidera OS distribution](https://github.com/Kaidera-AI/homebrew-kaidera/security/advisories/new)

Include the affected version, operating system, installation channel, reproduction
steps, expected impact, and any proposed mitigation. Remove API keys, access
tokens, customer data, private workspace content, and local Cortex state from the
report.

## Supported versions

Security fixes target the latest published release. Upgrade to the latest release
before reporting an issue that may already be resolved. Older releases may not
receive separate patches.

## Scope

Useful reports include installer verification bypasses, unsafe archive handling,
credential exposure, authorization failures, project-boundary violations, and
ways for untrusted pull-request code to access release credentials.

Reports about the hosted Kaidera service should use the security contact published
on [kaidera.ai](https://kaidera.ai), not a public repository issue.
