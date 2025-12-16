"""
Tests for GitHub issue to roadmap format mapping
"""

import pytest
from datetime import datetime


class TestRoadmapMapper:
    """Test roadmap mapping functionality"""

    @pytest.fixture
    def config(self):
        """Sample configuration for testing"""
        return {
            'mapping': {
                'type': {
                    'bug': 'Bug Fix',
                    'feature': 'Enhancement',
                    'documentation': 'Documentation',
                    'research': 'Research'
                },
                'effort': {
                    'effort:xs': 'XS',
                    'effort:s': 'S',
                    'effort:m': 'M'
                },
                'complexity': {
                    'complexity:simple': 'SIMPLE',
                    'complexity:moderate': 'MODERATE',
                    'complexity:complex': 'COMPLEX'
                },
                'defaults': {
                    'type': 'Enhancement',
                    'effort': 'S',
                    'complexity': 'MODERATE'
                }
            },
            'roadmap': {
                'bidirectional_linking': {
                    'enabled': True,
                    'comment_template': 'This issue has been added to the roadmap as **{req_id}**.\n\nTrack progress: {roadmap_link}'
                },
                'file': '.haunt/plans/roadmap.md'
            }
        }

    def test_map_type_from_label(self, config):
        """Test mapping GitHub labels to roadmap type"""
        labels = ['bug', 'priority:high']
        req_type = self.map_type(labels, config)
        assert req_type == 'Bug Fix'

    def test_map_type_default(self, config):
        """Test default type when no matching label"""
        labels = ['unknown-label']
        req_type = self.map_type(labels, config)
        assert req_type == 'Enhancement'

    def test_map_effort_from_label(self, config):
        """Test mapping GitHub labels to effort estimate"""
        labels = ['effort:s', 'feature']
        effort = self.map_effort(labels, config)
        assert effort == 'S'

    def test_map_effort_default(self, config):
        """Test default effort when no matching label"""
        labels = ['feature']
        effort = self.map_effort(labels, config)
        assert effort == 'S'

    def test_map_complexity_from_label(self, config):
        """Test mapping GitHub labels to complexity"""
        labels = ['complexity:complex', 'feature']
        complexity = self.map_complexity(labels, config)
        assert complexity == 'COMPLEX'

    def test_map_complexity_default(self, config):
        """Test default complexity when no matching label"""
        labels = ['feature']
        complexity = self.map_complexity(labels, config)
        assert complexity == 'MODERATE'

    def test_extract_tasks_from_body(self):
        """Test extracting task checklist from issue body"""
        body = """
        This is an issue description.

        **Tasks:**
        - [ ] Implement feature X
        - [ ] Write tests
        - [x] Design mockups

        Some more text.
        """

        tasks = self.extract_tasks_from_body(body)

        assert len(tasks) == 3
        assert 'Implement feature X' in tasks
        assert 'Write tests' in tasks
        assert 'Design mockups' in tasks

    def test_extract_tasks_empty_body(self):
        """Test extracting tasks from empty body"""
        tasks = self.extract_tasks_from_body('')
        assert tasks == []

        tasks = self.extract_tasks_from_body(None)
        assert tasks == []

    def test_extract_tasks_no_checklist(self):
        """Test extracting tasks when no checklist exists"""
        body = "Just a regular issue description without checkboxes."
        tasks = self.extract_tasks_from_body(body)
        assert tasks == []

    def test_generate_requirement(self, config):
        """Test generating full requirement markdown"""
        issue_data = {
            'issue_number': 42,
            'title': 'Add user authentication',
            'body': 'We need to add user authentication.\n\n- [ ] Create login endpoint\n- [ ] Add JWT tokens',
            'labels': ['feature', 'effort:m'],
            'url': 'https://github.com/owner/repo/issues/42'
        }

        req_number = 123
        requirement = self.generate_requirement(issue_data, req_number, config)

        # Check structure
        assert 'REQ-123' in requirement
        assert 'Add user authentication' in requirement
        assert 'Enhancement' in requirement
        assert 'Effort:** M' in requirement
        assert 'Create login endpoint' in requirement
        assert 'Add JWT tokens' in requirement
        assert 'GitHub Issue #42' in requirement
        assert issue_data['url'] in requirement

    def test_generate_completion_criteria_bug(self, config):
        """Test completion criteria for bug fix"""
        issue_data = {'labels': ['bug']}
        criteria = self.generate_completion_criteria(issue_data, config)
        assert 'Bug resolved' in criteria
        assert 'regression test' in criteria

    def test_generate_completion_criteria_documentation(self, config):
        """Test completion criteria for documentation"""
        issue_data = {'labels': ['documentation']}
        criteria = self.generate_completion_criteria(issue_data, config)
        assert 'Documentation updated' in criteria

    def test_generate_completion_criteria_research(self, config):
        """Test completion criteria for research"""
        issue_data = {'labels': ['research']}
        criteria = self.generate_completion_criteria(issue_data, config)
        assert 'Research findings' in criteria

    def test_generate_completion_criteria_default(self, config):
        """Test default completion criteria for enhancement"""
        issue_data = {'labels': ['feature']}
        criteria = self.generate_completion_criteria(issue_data, config)
        assert 'Feature implemented' in criteria

    def test_bidirectional_link_enabled(self, config):
        """Test bidirectional link comment generation"""
        issue_data = {'issue_number': 42}
        req_number = 123

        comment = self.add_bidirectional_link(issue_data, req_number, config)

        assert comment is not None
        assert 'REQ-123' in comment
        assert '.haunt/plans/roadmap.md' in comment

    def test_bidirectional_link_disabled(self, config):
        """Test bidirectional link when disabled"""
        config['roadmap']['bidirectional_linking']['enabled'] = False

        issue_data = {'issue_number': 42}
        req_number = 123

        comment = self.add_bidirectional_link(issue_data, req_number, config)

        assert comment is None

    # Helper methods (duplicate roadmap_mapper logic for testing)

    @staticmethod
    def map_type(labels: list, config: dict) -> str:
        """Map GitHub labels to roadmap type"""
        type_mapping = config.get('mapping', {}).get('type', {})

        for label in labels:
            if label in type_mapping:
                return type_mapping[label]

        return config.get('mapping', {}).get('defaults', {}).get('type', 'Enhancement')

    @staticmethod
    def map_effort(labels: list, config: dict) -> str:
        """Map GitHub labels to effort estimate"""
        effort_mapping = config.get('mapping', {}).get('effort', {})

        for label in labels:
            if label in effort_mapping:
                return effort_mapping[label]

        return config.get('mapping', {}).get('defaults', {}).get('effort', 'S')

    @staticmethod
    def map_complexity(labels: list, config: dict) -> str:
        """Map GitHub labels to complexity"""
        complexity_mapping = config.get('mapping', {}).get('complexity', {})

        for label in labels:
            if label in complexity_mapping:
                return complexity_mapping[label]

        return config.get('mapping', {}).get('defaults', {}).get('complexity', 'MODERATE')

    @staticmethod
    def extract_tasks_from_body(body: str) -> list:
        """Extract task checklist from issue body"""
        if not body:
            return []

        tasks = []
        lines = body.split('\n')

        for line in lines:
            stripped = line.strip()
            if stripped.startswith('- [ ]') or stripped.startswith('- [x]'):
                task_text = stripped[5:].strip()
                if task_text:
                    tasks.append(task_text)

        return tasks

    @staticmethod
    def generate_requirement(issue_data: dict, req_number: int, config: dict) -> str:
        """Generate roadmap requirement markdown"""
        req_type = TestRoadmapMapper.map_type(issue_data.get('labels', []), config)
        effort = TestRoadmapMapper.map_effort(issue_data.get('labels', []), config)
        complexity = TestRoadmapMapper.map_complexity(issue_data.get('labels', []), config)

        tasks = TestRoadmapMapper.extract_tasks_from_body(issue_data.get('body', ''))
        if not tasks:
            tasks = ['Implement solution as described in issue']

        tasks_md = '\n'.join([f'- [ ] {task}' for task in tasks])
        today = datetime.now().strftime('%Y-%m-%d')

        completion = TestRoadmapMapper.generate_completion_criteria(issue_data, config)

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
**Completion:** {completion}
**Blocked by:** None

**GitHub Issue Link:** {issue_data['url']}
"""

        return requirement

    @staticmethod
    def generate_completion_criteria(issue_data: dict, config: dict) -> str:
        """Generate completion criteria based on issue type"""
        req_type = TestRoadmapMapper.map_type(issue_data.get('labels', []), config)

        if req_type == 'Bug Fix':
            return 'Bug resolved, regression test added, all tests passing'
        elif req_type == 'Documentation':
            return 'Documentation updated and reviewed'
        elif req_type == 'Research':
            return 'Research findings documented with recommendation'
        else:
            return 'Feature implemented, tested, and documented'

    @staticmethod
    def add_bidirectional_link(issue_data: dict, req_number: int, config: dict) -> str:
        """Generate bidirectional link comment"""
        if not config.get('roadmap', {}).get('bidirectional_linking', {}).get('enabled', False):
            return None

        template = config.get('roadmap', {}).get('bidirectional_linking', {}).get('comment_template', '')

        comment = template.format(
            req_id=f'REQ-{req_number:03d}',
            roadmap_link=config.get('roadmap', {}).get('file', '.haunt/plans/roadmap.md')
        )

        return comment


if __name__ == '__main__':
    pytest.main([__file__, '-v'])
