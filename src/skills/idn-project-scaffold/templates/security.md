# Security

> Threat model, authentication, and data classification. Should change rarely — that is a sign
> it is written at the right level.
>
> Not applicable is a valid answer. If this component has no auth surface and handles no
> personal data, say exactly that and delete the rest.

## Data classification

| Class | Examples | Handling |
| --- | --- | --- |
| Public | | |
| Internal | | |
| Sensitive / PII | | encrypted at rest, never logged, never in fixtures |

## Authentication

<!-- Mechanism, token lifetime, refresh, where sessions live. -->

## Threat model

<!-- Who would attack this and how. The OWASP items that actually apply here. -->

## Known trade-offs

<!-- Accepted risks, with the reason and any compensating control. -->
