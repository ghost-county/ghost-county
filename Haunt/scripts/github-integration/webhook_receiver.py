#!/usr/bin/env python3
"""
GitHub Webhook Receiver for @haunt marker detection

Tier 1 of hybrid architecture - Real-time webhook event processing
Listens for GitHub 'issues' and 'issue_comment' events to detect @haunt marker
"""

import hmac
import hashlib
import json
import logging
import os
import sys
from typing import Dict, Any, Optional
from pathlib import Path

# Try to import Flask, fail gracefully with instructions if not available
try:
    from flask import Flask, request, jsonify
except ImportError:
    print("ERROR: Flask is not installed. Install with: pip install flask", file=sys.stderr)
    sys.exit(1)

try:
    import yaml
except ImportError:
    print("ERROR: PyYAML is not installed. Install with: pip install pyyaml", file=sys.stderr)
    sys.exit(1)


class WebhookReceiver:
    """Handles GitHub webhook events for @haunt marker detection"""

    def __init__(self, config_path: str = "config.yaml"):
        """Initialize webhook receiver with configuration"""
        self.config = self._load_config(config_path)
        self.setup_logging()
        self.app = Flask(__name__)
        self.setup_routes()

    def _load_config(self, config_path: str) -> Dict[str, Any]:
        """Load configuration from YAML file with environment variable substitution"""
        config_file = Path(__file__).parent / config_path

        if not config_file.exists():
            raise FileNotFoundError(
                f"Configuration file not found: {config_file}\n"
                f"Copy config.yaml.template to config.yaml and configure values."
            )

        with open(config_file, 'r') as f:
            config = yaml.safe_load(f)

        # Substitute environment variables
        config['webhook']['secret'] = os.getenv('GH_WEBHOOK_SECRET', config['webhook']['secret'])
        config['repository']['token'] = os.getenv('GH_TOKEN', config['repository']['token'])

        # Validate required fields
        if not config['webhook']['secret'] or config['webhook']['secret'].startswith('${'):
            raise ValueError("GH_WEBHOOK_SECRET environment variable not set")

        return config

    def setup_logging(self):
        """Configure logging based on config settings"""
        log_config = self.config.get('logging', {})
        log_level = getattr(logging, log_config.get('level', 'INFO'))
        log_file = log_config.get('file')

        # Create log directory if it doesn't exist
        if log_file:
            log_path = Path(log_file)
            log_path.parent.mkdir(parents=True, exist_ok=True)

        logging.basicConfig(
            level=log_level,
            format=log_config.get('format', '%(asctime)s - %(name)s - %(levelname)s - %(message)s'),
            handlers=[
                logging.FileHandler(log_file) if log_file else logging.StreamHandler(),
                logging.StreamHandler()  # Always log to console
            ]
        )

        self.logger = logging.getLogger(__name__)

    def setup_routes(self):
        """Register Flask routes"""
        webhook_path = self.config['webhook']['path']

        @self.app.route(webhook_path, methods=['POST'])
        def webhook_handler():
            return self.handle_webhook()

        @self.app.route('/health', methods=['GET'])
        def health_check():
            return jsonify({"status": "healthy", "service": "github-webhook-receiver"})

    def validate_signature(self, payload_body: bytes, signature_header: str) -> bool:
        """
        Validate GitHub webhook signature using HMAC-SHA256

        Args:
            payload_body: Raw request body as bytes
            signature_header: X-Hub-Signature-256 header value

        Returns:
            True if signature is valid, False otherwise
        """
        if not signature_header:
            self.logger.warning("Missing X-Hub-Signature-256 header")
            return False

        secret = self.config['webhook']['secret'].encode()
        expected_signature = 'sha256=' + hmac.new(
            secret,
            payload_body,
            hashlib.sha256
        ).hexdigest()

        return hmac.compare_digest(signature_header, expected_signature)

    def has_marker(self, text: str) -> bool:
        """
        Check if text contains @haunt marker

        Args:
            text: Text to search (issue body or comment)

        Returns:
            True if marker found, False otherwise
        """
        if not text:
            return False

        marker = self.config['marker']['text']
        case_sensitive = self.config['marker'].get('case_sensitive', False)

        if case_sensitive:
            return marker in text
        else:
            return marker.lower() in text.lower()

    def extract_issue_data(self, payload: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """
        Extract relevant issue data from webhook payload

        Args:
            payload: GitHub webhook payload

        Returns:
            Dictionary with issue data or None if marker not found
        """
        issue = payload.get('issue', {})
        action = payload.get('action')
        comment = payload.get('comment')

        # Check if @haunt marker is present
        marker_found = False
        marker_location = None

        # Check in issue body
        if 'body' in self.config['marker']['search_in']:
            if self.has_marker(issue.get('body', '')):
                marker_found = True
                marker_location = 'issue_body'

        # Check in comment
        if not marker_found and 'comments' in self.config['marker']['search_in']:
            if comment and self.has_marker(comment.get('body', '')):
                marker_found = True
                marker_location = 'comment'

        if not marker_found:
            return None

        # Extract issue metadata
        return {
            'issue_number': issue.get('number'),
            'issue_id': issue.get('id'),
            'title': issue.get('title'),
            'body': issue.get('body', ''),
            'state': issue.get('state'),
            'labels': [label['name'] for label in issue.get('labels', [])],
            'assignees': [assignee['login'] for assignee in issue.get('assignees', [])],
            'creator': issue.get('user', {}).get('login'),
            'created_at': issue.get('created_at'),
            'updated_at': issue.get('updated_at'),
            'url': issue.get('html_url'),
            'repository': payload.get('repository', {}).get('full_name'),
            'marker_location': marker_location,
            'action': action,
        }

    def handle_webhook(self):
        """Handle incoming webhook POST request"""
        # Validate signature
        signature = request.headers.get('X-Hub-Signature-256')
        if not self.validate_signature(request.get_data(), signature):
            self.logger.warning(f"Invalid webhook signature from {request.remote_addr}")
            return jsonify({"error": "Invalid signature"}), 401

        # Parse payload
        payload = request.json
        event_type = request.headers.get('X-GitHub-Event')

        self.logger.info(f"Received {event_type} event: {payload.get('action')}")

        # Only process issues and issue_comment events
        if event_type not in self.config['webhook']['events']:
            self.logger.debug(f"Ignoring event type: {event_type}")
            return jsonify({"status": "ignored", "reason": "event type not configured"}), 200

        # Extract issue data and check for marker
        issue_data = self.extract_issue_data(payload)

        if not issue_data:
            self.logger.debug("No @haunt marker found in issue or comments")
            return jsonify({"status": "ignored", "reason": "no marker found"}), 200

        # Log detected issue
        self.logger.info(
            f"@haunt marker detected in {issue_data['repository']}#{issue_data['issue_number']} "
            f"({issue_data['marker_location']})"
        )

        # Process issue (will trigger PM approval workflow in Phase 2)
        self.process_issue(issue_data)

        return jsonify({"status": "processed", "issue": issue_data['issue_number']}), 200

    def process_issue(self, issue_data: Dict[str, Any]):
        """
        Process detected issue with @haunt marker

        Phase 1: Log to file for manual PM review
        Phase 2: Trigger PM approval workflow

        Args:
            issue_data: Extracted issue metadata
        """
        # Phase 1 implementation: Write to pending issues file
        pending_file = Path(self.config['state']['processed_issues_file']).parent / 'pending-issues.json'
        pending_file.parent.mkdir(parents=True, exist_ok=True)

        # Load existing pending issues
        pending_issues = []
        if pending_file.exists():
            with open(pending_file, 'r') as f:
                pending_issues = json.load(f)

        # Check if already pending
        if any(p['issue_id'] == issue_data['issue_id'] for p in pending_issues):
            self.logger.info(f"Issue #{issue_data['issue_number']} already in pending queue")
            return

        # Add to pending queue
        pending_issues.append(issue_data)

        # Write back to file
        with open(pending_file, 'w') as f:
            json.dump(pending_issues, indent=2, fp=f)

        self.logger.info(f"Added issue #{issue_data['issue_number']} to pending approval queue")

    def run(self):
        """Start the webhook receiver server"""
        port = self.config['webhook']['port']
        self.logger.info(f"Starting webhook receiver on port {port}")
        self.app.run(
            host='0.0.0.0',
            port=port,
            debug=False  # Never run debug in production
        )


def main():
    """Entry point for webhook receiver"""
    # Check for config file path argument
    config_path = sys.argv[1] if len(sys.argv) > 1 else 'config.yaml'

    try:
        receiver = WebhookReceiver(config_path)
        receiver.run()
    except Exception as e:
        print(f"ERROR: Failed to start webhook receiver: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
