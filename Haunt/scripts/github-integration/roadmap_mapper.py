"""
GitHub Issue to Roadmap Format Mapper

Maps GitHub issue metadata to Haunt roadmap requirement format
"""

from typing import Dict, Any, Optional
from datetime import datetime


class RoadmapMapper:
    """Maps GitHub issues to roadmap requirements"""

    def __init__(self, config: Dict[str, Any]):
        """Initialize mapper with configuration"""
        self.config = config

    def map_type(self, labels: list) -> str:
        """
        Map GitHub labels to roadmap requirement type

        Args:
            labels: List of GitHub label names

        Returns:
            Roadmap type (Enhancement, Bug Fix, Documentation, Research)
        """
        type_mapping = self.config.get('mapping', {}).get('type', {})

        for label in labels:
            if label in type_mapping:
                return type_mapping[label]

        # Return default if no matching label
        return self.config.get('mapping', {}).get('defaults', {}).get('type', 'Enhancement')

    def map_effort(self, labels: list) -> str:
        """
        Map GitHub labels to roadmap effort estimate

        Args:
            labels: List of GitHub label names

        Returns:
            Effort estimate (XS, S, M)
        """
        effort_mapping = self.config.get('mapping', {}).get('effort', {})

        for label in labels:
            if label in effort_mapping:
                return effort_mapping[label]

        # Return default if no matching label
        return self.config.get('mapping', {}).get('defaults', {}).get('effort', 'S')

    def map_complexity(self, labels: list) -> str:
        """
        Map GitHub labels to roadmap complexity

        Args:
            labels: List of GitHub label names

        Returns:
            Complexity (SIMPLE, MODERATE, COMPLEX, UNKNOWN)
        """
        complexity_mapping = self.config.get('mapping', {}).get('complexity', {})

        for label in labels:
            if label in complexity_mapping:
                return complexity_mapping[label]

        # Return default if no matching label
        return self.config.get('mapping', {}).get('defaults', {}).get('complexity', 'MODERATE')

    def extract_tasks_from_body(self, body: str) -> list:
        """
        Extract task checklist items from issue body

        Args:
            body: GitHub issue body text

        Returns:
            List of task strings
        """
        if not body:
            return []

        tasks = []
        lines = body.split('\n')

        for line in lines:
            # Match GitHub task list syntax: - [ ] Task description
            stripped = line.strip()
            if stripped.startswith('- [ ]') or stripped.startswith('- [x]'):
                task_text = stripped[5:].strip()  # Remove checkbox syntax
                if task_text:
                    tasks.append(task_text)

        return tasks

    def generate_requirement(self, issue_data: Dict[str, Any], req_number: int) -> str:
        """
        Generate roadmap requirement text from GitHub issue data

        Args:
            issue_data: Extracted GitHub issue metadata
            req_number: REQ number to assign

        Returns:
            Formatted requirement markdown
        """
        # Map metadata
        req_type = self.map_type(issue_data.get('labels', []))
        effort = self.map_effort(issue_data.get('labels', []))
        complexity = self.map_complexity(issue_data.get('labels', []))

        # Extract tasks from issue body
        tasks = self.extract_tasks_from_body(issue_data.get('body', ''))

        # If no tasks found, add default task
        if not tasks:
            tasks = ['Implement solution as described in issue']

        # Format tasks as markdown checklist
        tasks_md = '\n'.join([f'- [ ] {task}' for task in tasks])

        # Get today's date
        today = datetime.now().strftime('%Y-%m-%d')

        # Build requirement text
        requirement = f"""### ⚪ REQ-{req_number:03d}: {issue_data['title']}

**Type:** {req_type}
**Reported:** {today}
**Source:** GitHub Issue #{issue_data['issue_number']} ({issue_data['url']})

**Description:**
{issue_data.get('body', 'No description provided.')}

**Tasks:**
{tasks_md}

**Files:**
- TBD (to be determined during implementation)

**Effort:** {effort}
**Complexity:** {complexity}
**Agent:** TBD
**Completion:** {self._generate_completion_criteria(issue_data)}
**Blocked by:** None

**GitHub Issue Link:** {issue_data['url']}
"""

        return requirement

    def _generate_completion_criteria(self, issue_data: Dict[str, Any]) -> str:
        """
        Generate completion criteria based on issue type

        Args:
            issue_data: GitHub issue metadata

        Returns:
            Completion criteria text
        """
        req_type = self.map_type(issue_data.get('labels', []))

        # Type-specific completion criteria
        if req_type == 'Bug Fix':
            return 'Bug resolved, regression test added, all tests passing'
        elif req_type == 'Documentation':
            return 'Documentation updated and reviewed'
        elif req_type == 'Research':
            return 'Research findings documented with recommendation'
        else:  # Enhancement
            return 'Feature implemented, tested, and documented'

    def add_bidirectional_link(self, issue_data: Dict[str, Any], req_number: int) -> Optional[str]:
        """
        Generate GitHub comment linking issue to REQ

        Args:
            issue_data: GitHub issue metadata
            req_number: Assigned REQ number

        Returns:
            Comment body text or None if bidirectional linking disabled
        """
        if not self.config.get('roadmap', {}).get('bidirectional_linking', {}).get('enabled', False):
            return None

        template = self.config.get('roadmap', {}).get('bidirectional_linking', {}).get('comment_template', '')

        # Substitute placeholders
        comment = template.format(
            req_id=f'REQ-{req_number:03d}',
            roadmap_link=self.config.get('roadmap', {}).get('file', '.haunt/plans/roadmap.md')
        )

        return comment
