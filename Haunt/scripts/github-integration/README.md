# GitHub Issues Integration

Automatically detect GitHub issues marked with `@haunt` and add them to the roadmap with PM approval.

## Architecture

This integration uses a **hybrid two-tier architecture**:

### Tier 1: Webhook Receiver (Real-time)
- Listens for GitHub `issues` and `issue_comment` webhook events
- Provides instant detection when `@haunt` marker is added
- No API rate limit consumption
- Requires public HTTPS endpoint

### Tier 2: Search API Polling (Fallback)
- Periodically scans GitHub Search API for issues with `@haunt` marker
- Catches any webhooks that failed to deliver
- Backfills issues created while webhook endpoint was offline
- Uses minimal API quota (~5% of available limit)

## Features

- **Real-time detection** - Webhooks provide instant notification
- **Fallback scanning** - Polling ensures no issues are missed
- **PM approval workflow** - All issues require PM review before adding to roadmap
- **Metadata mapping** - GitHub labels map to roadmap type/effort/complexity
- **Bidirectional linking** - Issues link to REQ-XXX and vice versa
- **Rate limiting** - Respects GitHub API rate limits
- **Authentication** - Secure webhook signature validation

## Quick Start

### 1. Install Dependencies

```bash
cd Haunt/scripts/github-integration
pip install -r requirements.txt
```

### 2. Configure Integration

```bash
# Copy template to config.yaml
cp config.yaml.template config.yaml

# Edit config.yaml with your settings
# Required changes:
#   - repository.name: your-org/your-repo
#   - webhook.secret: generate with `openssl rand -hex 32`
```

### 3. Set Environment Variables

```bash
export GH_TOKEN="ghp_your_github_personal_access_token"
export GH_WEBHOOK_SECRET="your_webhook_secret_from_config"
```

**GitHub Token Scopes Required:**
- `repo` (for private repositories)
- `public_repo` (for public repositories only)

### 4. Start Webhook Receiver (Optional - Tier 1)

If you have a public HTTPS endpoint:

```bash
python webhook_receiver.py
```

This starts a Flask server on the port specified in `config.yaml` (default: 8080).

### 5. Start Polling Scanner (Tier 2)

For continuous polling:

```bash
python issue_scanner.py config.yaml continuous
```

For one-time scan:

```bash
python issue_scanner.py config.yaml once
```

**Recommended:** Run as cron job or systemd service for continuous operation.

### 6. Review Pending Issues

```bash
python pm_approval.py
```

This launches an interactive CLI to approve/reject pending issues.

## Configuration

See `config.yaml.template` for all configuration options. Key settings:

### Repository Settings

```yaml
repository:
  name: "your-org/your-repo"
  token: "${GH_TOKEN}"
```

### Webhook Settings

```yaml
webhook:
  enabled: true
  port: 8080
  path: "/webhook"
  secret: "${GH_WEBHOOK_SECRET}"
  events:
    - issues
    - issue_comment
```

### Polling Settings

```yaml
polling:
  enabled: true
  interval: 15  # minutes
  limit: 100
  incremental: true
```

### Marker Detection

```yaml
marker:
  text: "@haunt"
  case_sensitive: false
  search_in:
    - body
    - comments
```

### Metadata Mapping

Map GitHub labels to roadmap fields:

```yaml
mapping:
  type:
    "bug": "Bug Fix"
    "feature": "Enhancement"
    "documentation": "Documentation"
    "research": "Research"

  effort:
    "effort:xs": "XS"
    "effort:s": "S"
    "effort:m": "M"

  complexity:
    "complexity:simple": "SIMPLE"
    "complexity:moderate": "MODERATE"
    "complexity:complex": "COMPLEX"

  defaults:
    type: "Enhancement"
    effort: "S"
    complexity: "MODERATE"
```

## GitHub Setup

### Configure Webhook (For Tier 1 - Real-time)

1. Go to repository Settings → Webhooks → Add webhook
2. Set Payload URL: `https://your-server.com:8080/webhook`
3. Set Content type: `application/json`
4. Set Secret: (same as `GH_WEBHOOK_SECRET` environment variable)
5. Select events:
   - Issues
   - Issue comments
6. Ensure webhook is Active
7. Save webhook

### Verify Webhook Delivery

After creating an issue with `@haunt` marker:

1. Go to Settings → Webhooks → Your webhook
2. Click "Recent Deliveries"
3. Verify status is `200 OK`
4. Check response indicates issue was processed

### Create Personal Access Token

1. Go to Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token
3. Select scopes:
   - `repo` (for private repositories)
   - `public_repo` (for public repositories)
4. Copy token and set as `GH_TOKEN` environment variable
5. **Rotate token every 90 days** for security

## Usage

### Mark an Issue for Roadmap Addition

In any GitHub issue, add `@haunt` marker in:
- Issue body (description)
- Issue comment

**Example:**

```markdown
We need to add user authentication to the application.

@haunt

**Tasks:**
- [ ] Create login endpoint
- [ ] Add JWT token generation
- [ ] Write tests
```

### Label Issues for Better Mapping

Add labels to issues for automatic metadata mapping:

**Type labels:**
- `bug` → Bug Fix
- `feature` → Enhancement
- `documentation` → Documentation
- `research` → Research

**Effort labels:**
- `effort:xs` → XS
- `effort:s` → S
- `effort:m` → M

**Complexity labels:**
- `complexity:simple` → SIMPLE
- `complexity:moderate` → MODERATE
- `complexity:complex` → COMPLEX

### PM Approval Workflow

1. Run `python pm_approval.py`
2. Review each pending issue:
   - **Approve (a)** - Adds to roadmap with next REQ-XXX number
   - **Reject (r)** - Marks as processed, does not add to roadmap
   - **Skip (s)** - Leave in pending queue for later review
   - **Quit (q)** - Exit workflow, save progress
3. Approved issues are added to roadmap immediately
4. Bidirectional links are created (if enabled)

## File Structure

```
github-integration/
├── config.yaml.template      # Configuration template
├── config.yaml               # Your configuration (gitignored)
├── webhook_receiver.py       # Tier 1: Webhook event handler
├── issue_scanner.py          # Tier 2: Polling fallback
├── pm_approval.py            # PM approval CLI workflow
├── roadmap_mapper.py         # GitHub → Roadmap format mapping
├── requirements.txt          # Python dependencies
├── README.md                 # This file
└── tests/                    # Test suite
    ├── test_webhook_receiver.py
    └── test_roadmap_mapper.py
```

## State Files

Integration creates state files in `.haunt/github-integration/`:

```
.haunt/github-integration/
├── pending-issues.json       # Issues awaiting PM approval
├── processed-issues.json     # Issues already approved/rejected
├── cache/                    # Temporary cache data
│   └── scanner-state.json    # Last polling scan timestamp
└── integration.log           # Integration log file
```

**Note:** These files are gitignored by default.

## Testing

Run test suite:

```bash
cd tests
pytest -v
```

Run specific test file:

```bash
pytest test_webhook_receiver.py -v
pytest test_roadmap_mapper.py -v
```

## Deployment Options

### Option 1: Local Development

Run webhook receiver and scanner locally:

```bash
# Terminal 1: Webhook receiver
python webhook_receiver.py

# Terminal 2: Polling scanner (continuous)
python issue_scanner.py config.yaml continuous
```

**Note:** Webhooks require public HTTPS endpoint. Use ngrok for local testing.

### Option 2: Server Deployment

Deploy to server with systemd:

```ini
# /etc/systemd/system/github-webhook.service
[Unit]
Description=GitHub Webhook Receiver
After=network.target

[Service]
Type=simple
User=haunt
WorkingDirectory=/opt/haunt/scripts/github-integration
Environment="GH_TOKEN=your_token"
Environment="GH_WEBHOOK_SECRET=your_secret"
ExecStart=/usr/bin/python3 webhook_receiver.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

```ini
# /etc/systemd/system/github-scanner.service
[Unit]
Description=GitHub Issue Scanner
After=network.target

[Service]
Type=simple
User=haunt
WorkingDirectory=/opt/haunt/scripts/github-integration
Environment="GH_TOKEN=your_token"
ExecStart=/usr/bin/python3 issue_scanner.py config.yaml continuous
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Enable and start services:

```bash
sudo systemctl enable github-webhook github-scanner
sudo systemctl start github-webhook github-scanner
```

### Option 3: GitHub Actions (Polling Only)

For polling without webhook endpoint:

```yaml
# .github/workflows/issue-scanner.yml
name: GitHub Issue Scanner

on:
  schedule:
    - cron: '*/15 * * * *'  # Every 15 minutes
  workflow_dispatch:

jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - name: Install dependencies
        run: |
          cd Haunt/scripts/github-integration
          pip install -r requirements.txt
      - name: Run scanner
        env:
          GH_TOKEN: ${{ secrets.GH_TOKEN }}
        run: |
          cd Haunt/scripts/github-integration
          python issue_scanner.py config.yaml once
```

## Rate Limiting

### GitHub API Rate Limits

| Method | Limit | Reset |
|--------|-------|-------|
| REST API (Authenticated) | 5,000/hour | Per-hour boundary |
| Webhooks | Unlimited | N/A |

### Rate Limit Handling

- **Webhook receiver:** No rate limit consumption
- **Issue scanner:** ~5% of quota (polling every 15 minutes = ~96 requests/day)
- **PM approval:** Minimal usage (only when posting comments)

**Monitoring:**

```bash
# Check rate limit status
curl -H "Authorization: token $GH_TOKEN" https://api.github.com/rate_limit
```

**Backoff strategy:**

If rate limit falls below threshold (default: 1000 remaining):
1. Scanner logs warning and skips cycle
2. Exponential backoff applied (60s → 120s → 240s → ...)
3. Normal operation resumes when rate limit resets

## Security Considerations

### Webhook Secret Validation

**Always validate webhook signatures** before processing events:

```python
import hmac
import hashlib

def validate_signature(payload_body: bytes, signature_header: str, secret: str) -> bool:
    expected_signature = 'sha256=' + hmac.new(
        secret.encode(),
        payload_body,
        hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(signature_header, expected_signature)
```

### Token Security

- **Never commit tokens** to version control
- **Store tokens in environment variables** (not config files)
- **Rotate tokens every 90 days**
- **Use fine-grained tokens** with minimal scopes
- **Revoke tokens immediately** if compromised

### HTTPS Only

- Webhook endpoint **must use HTTPS** (GitHub requirement)
- Self-signed certificates not supported
- Use Let's Encrypt for free TLS certificates

## Troubleshooting

### Webhooks Not Delivering

**Check webhook configuration:**
1. Go to Settings → Webhooks → Recent Deliveries
2. Look for failed deliveries (non-200 status)
3. Check error message in delivery details
4. Verify webhook URL is publicly accessible via HTTPS

**Common issues:**
- Firewall blocking webhook port
- Self-signed SSL certificate
- Webhook secret mismatch
- Server not running

**Solution:** Check logs in `integration.log`

### Issues Not Being Detected

**Verify marker:**
- Marker text is correct (`@haunt` by default)
- Case sensitivity setting matches usage
- Marker is in searchable location (body or comments, not code blocks in some cases)

**Check polling:**
```bash
# Run one-time scan with debug logging
python issue_scanner.py config.yaml once
```

### Rate Limit Exhausted

**Reduce polling frequency:**
```yaml
polling:
  interval: 30  # Increase from 15 to 30 minutes
```

**Check other API consumers:**
```bash
# See which apps are consuming quota
curl -H "Authorization: token $GH_TOKEN" https://api.github.com/rate_limit
```

### PM Approval Not Working

**Check pending issues file:**
```bash
cat .haunt/github-integration/pending-issues.json
```

**Verify roadmap exists:**
```bash
ls -la .haunt/plans/roadmap.md
```

**Check permissions:**
```bash
# Ensure .haunt directory is writable
ls -la .haunt/
```

## Roadmap

### Phase 1: Core Detection (Implemented ✅)
- [x] Webhook receiver
- [x] Search API polling
- [x] @haunt marker detection
- [x] PM approval workflow
- [x] Metadata mapping
- [x] Bidirectional linking

### Phase 2: Enhanced Workflow (Future)
- [ ] PM agent integration (interactive approval in Claude Code)
- [ ] Issue status synchronization (close issue → update REQ status)
- [ ] REQ completion → GitHub issue auto-close
- [ ] Rich metadata extraction (effort from issue size, complexity from dependencies)
- [ ] Multiple repository support

### Phase 3: Enterprise Features (Future)
- [ ] GitHub App (vs Personal Access Token)
- [ ] Organization-wide installation
- [ ] Slack/Email notifications for PM approval
- [ ] Analytics dashboard (issue processing metrics)
- [ ] Webhook delivery retry logic

## Contributing

Improvements welcome. Please:
1. Follow existing code style
2. Add tests for new features
3. Update documentation
4. Test with sample GitHub repository

## References

- [GitHub Webhooks Documentation](https://docs.github.com/en/webhooks)
- [GitHub REST API - Issues](https://docs.github.com/en/rest/issues)
- [GitHub REST API - Search](https://docs.github.com/en/rest/search)
- [Research Document](/.haunt/docs/research/req-205-github-integration-investigation.md)
