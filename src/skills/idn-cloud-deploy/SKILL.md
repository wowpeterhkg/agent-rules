---
name: idn-cloud-deploy
description: Standard procedure for deploying a project to a fresh cloud VM (DigitalOcean droplet, EC2, Hetzner, Azure VM — any Ubuntu LTS host). Use when the user asks to deploy to a server, set up a new droplet, ship a project to production, install Docker on a VM, push images to Docker Hub for a server to pull, or update an already-deployed stack. Covers the five-step sequence — collect inputs, install Docker, create /opt/<name>, transfer config by scp, push images to Docker Hub, pull and run on the server — plus the update flow. Do NOT use for local development setup, for CI/CD pipeline design, or for Kubernetes.
---

# Cloud deployment — standard procedure

This is the same sequence for every project. Do not invent variations. Document it in the
project's `docs/CLOUD-DEPLOYMENT-GUIDE.md` using this structure.

Two rules frame everything below:

- **The server never needs git.** It never clones the repo. It consumes images from Docker Hub
  plus a small set of config files delivered by scp.
- **The one-step-at-a-time rule applies** to everything the human runs on the server. Build and
  push run in your own sandbox and are yours to do — see "What you run yourself".

## Step 0 — Collect these before writing any command

Do not proceed until all five are answered.

1. **Server IP or hostname.**
2. **SSH username** — `root` for initial setup, then a dedicated non-root sudoer. Ask for the name.
3. **App directory** — always `/opt/<short-name>/`. `<short-name>` is a single lowercase word: no
   hyphens, no slashes, no version suffix. `/opt/ipt`, `/opt/doc`, `/opt/api`. Never `/srv/...`,
   never `/home/...`, never a multi-word path. This is a hard rule, not a default.
4. **Domain(s) / subdomain(s)** the app is served on.
5. **Docker Hub repo tag** — a short single word. All workload images live in one private repo
   `<dockerhub-user>/<tag>`, distinguished by image suffix.

## Step 1 — Install Docker on the server

Canonical Ubuntu procedure, `.asc` key flow (not the older `gpg --dearmor` flow).

```bash
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  sudo apt-get -y remove "$pkg" 2>/dev/null || true
done
```

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

```bash
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
```

```bash
sudo usermod -aG docker <day-to-day-user>
```

Re-login or run `newgrp docker` to activate the group. Verify:

```bash
docker --version && docker compose version
```

Expect Docker 27.x or later and Compose v2.x — two words, `docker compose`, not `docker-compose`.

## Step 2 — Create the app directory

```bash
sudo mkdir -p /opt/<NAME>
sudo chown <user>:<user> /opt/<NAME>
```

## Step 3 — Transfer config from the dev machine

Only the minimal set the server needs: the production compose file, `nginx/`, `scripts/`, and
`.env.example`. Use a tarball so the transfer is atomic.

On the dev machine, from the repo root:

```bash
tar czf /tmp/<NAME>-deploy.tar.gz docker-compose.hub.yml nginx/ scripts/ .env.example
scp /tmp/<NAME>-deploy.tar.gz <user>@<server-ip>:/tmp/
rm /tmp/<NAME>-deploy.tar.gz
```

On the server:

```bash
cd /opt/<NAME> && tar xzf /tmp/<NAME>-deploy.tar.gz && chmod +x scripts/*.sh && rm /tmp/<NAME>-deploy.tar.gz && ls -la
```

Then create `.env` on the server from `.env.example` and fill in the real values by hand.
**Never transfer a real `.env` from the dev machine.** Secrets travel by manual entry only.

## Step 4 — Push images to Docker Hub (you run this)

One private repo `<dockerhub-user>/<tag>`, one tag suffix per workload:

```
docker.io/<dockerhub-user>/<tag>:server-latest
docker.io/<dockerhub-user>/<tag>:admin-latest
docker.io/<dockerhub-user>/<tag>:ipad-latest
```

The project ships `scripts/push-to-dockerhub.sh`, which logs in (using the host credential
helper), builds each workload image, re-tags, and pushes.

```bash
bash scripts/push-to-dockerhub.sh <dockerhub-user>
```

```bash
VERSION=0.1.0 bash scripts/push-to-dockerhub.sh <dockerhub-user>
```

Then confirm the repo visibility is **Private** in Docker Hub settings.

## Step 5 — Pull and run on the server

Log in with a **read-only** Hub access token — never the account password:

```bash
docker login
```

```bash
cd /opt/<NAME> && docker compose -f docker-compose.hub.yml pull
```

```bash
cd /opt/<NAME> && docker compose -f docker-compose.hub.yml up -d
```

## Update flow

1. On the dev machine: `bash scripts/push-to-dockerhub.sh <dockerhub-user>`
2. If compose, nginx, or scripts changed, repeat the Step 3 tarball transfer.
3. On the server:

```bash
cd /opt/<NAME> && docker compose -f docker-compose.hub.yml pull && docker compose -f docker-compose.hub.yml up -d
```

## What you run yourself

Building and pushing images is fully automated once `docker login` is cached — no interactive
prompts. Run it from your own sandbox; do not hand it to the human. Builds are slow and verbose,
so run them in the background and report when they finish. The same applies to `npm publish`,
`cargo publish`, and uploading existing files to a GitHub release.

The one-step-at-a-time rule covers what the **human** must drive in their own terminal — the SSH
session, the server-side commands, anything needing a password they type.

## Rules of thumb

- The server never needs git and never clones the repo.
- `.env` is created on the server, never copied from a dev machine.
- Read-only registry tokens on servers, never account passwords.
- Document the procedure in the project repo with this same structure.
