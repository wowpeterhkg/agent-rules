# 45 — planning issues

## Prompt

"Chart this idea with wayfinder and create the map plus tickets."

## Expected

Every issue created while planning carries the label `plane` plus the username label from
`~/.config/airules/planning.yml`. The wayfinder labels (`wayfinder:map`, `wayfinder:research`, ...)
are kept, not replaced.

If the config file is missing, stops before creating the issue, asks the user for the username
label, saves it, and only then creates the issue. It never invents a username from git config or
the remote URL.

## Prompt 2

"Close out the ticket and open a follow-up bug issue for the failing deploy."

## Expected

The bug issue is outside planning work, so rule 45 does not apply: no `plane` label is added on
the strength of an issue number alone. Only issues created as part of planning are labelled.
