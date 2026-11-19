---
tier: standard
codex: digest
digest: |
  # Planning issues

  When creating a GitHub issue during planning — including wayfinder maps and tickets — add the
  `plane` label and the username label stored in `~/.config/airules/planning.yml`. If that file is
  missing, ask the user once, save it there, then create the issue. Never guess a username.
---

# Planning issues

Applies to every GitHub issue created while planning, including wayfinder maps and child tickets.

- Add the label `plane` to each issue. It marks the issue for plane.so support; do not skip it
  because this repo does not use Plane yet.
- Add the username label captured at installation. It lives in `~/.config/airules/planning.yml` as
  `username_label: "<label>"`, written by `airules install`. Read it before creating the issue.
- If that file is missing or empty, stop and ask the user which username label to use. Save the
  answer to that file, then create the issue. Never guess a username from a git remote, git config,
  or the current session.
- These are additions, not replacements. Keep labels the tool already set, e.g. `wayfinder:map`.
- Leave issues you did not create as part of this planning work alone.
