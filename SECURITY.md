# Security Policy

## Supported Versions

The following versions of this project are currently supported with security
updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.x     | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability within this
project, please report it responsibly.

### How to Report

**Please DO NOT create a public GitHub issue for security vulnerabilities.**

Instead, please report security issues via:

1. **Email**: Send details to [lgzarturo@gmail.com](mailto:lgzarturo@gmail.com)
2. **GitHub Security Advisory**: Use
   [GitHub's private vulnerability reporting](https://github.com/lgzarturo/setup-claude-developer/security/advisories/new)
   (if enabled)

### What to Include

When reporting a vulnerability, please include:

- **Description**: A clear description of the vulnerability
- **Impact**: What could an attacker do with this vulnerability?
- **Steps to reproduce**: Detailed steps to reproduce the issue
- **Affected versions**: Which versions are affected?
- **Mitigation**: Any suggestions for fixing the vulnerability (optional)
- **Proof of concept**: If applicable, provide a minimal proof of concept

### What to Expect

1. **Acknowledgment**: We will acknowledge receipt of your report within 48
   hours
2. **Assessment**: We will assess the vulnerability and determine its impact
3. **Updates**: We will keep you informed about our progress
4. **Resolution**: Once fixed, we will notify you and publicly disclose the
   issue (with credit if desired)

### Disclosure Policy

- We follow a **coordinated disclosure** policy
- We ask that you give us reasonable time to address the issue before public
  disclosure
- We will credit you in the security advisory unless you prefer to remain
  anonymous

## Security Best Practices for Users

When using these setup scripts:

1. **Review before execution**: Always review scripts before running them in
   your environment
2. **Use in isolated environments**: Test in a container or VM before production
   use
3. **Keep dependencies updated**: If the scripts install tools, ensure they are
   up to date
4. **Verify checksums**: When downloading scripts, verify their integrity
5. **Principle of least privilege**: Run scripts with minimal required
   permissions

## Known Security Considerations

### Script Execution

- These scripts create files and directories in your project
- They do not execute arbitrary code downloaded from the internet
- All content is generated locally from templates within the scripts

### Generated Content

The scripts generate:

- Markdown files with configuration instructions
- No compiled binaries or executable code
- No network connections are made during execution

### Permissions

- On Windows: Scripts may require execution policy changes
- On Unix: Scripts require execute permissions (`chmod +x`)

## Security Updates

Security updates will be:

1. Released as patch versions (e.g., 1.0.1)
2. Documented in the [CHANGELOG](CHANGELOG.md) (if maintained)
3. Announced via GitHub Releases

---

**Thank you for helping keep this project and its users secure!**

Last updated: 2026-04-19
