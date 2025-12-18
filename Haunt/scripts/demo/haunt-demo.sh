#!/bin/bash
# Haunt Framework - Interactive Demo Script
#
# Purpose: Showcase Haunt's capabilities for presentations
# Duration: 5-10 minutes
# Usage: bash haunt-demo.sh

set -e

# Color codes for output
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Banner art
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║     🌙  HAUNT FRAMEWORK - INTERACTIVE DEMO 🌙            ║
    ║                                                           ║
    ║        "Where AI Agents Haunt Your Codebase"             ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Pause for user input
pause() {
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read -r
}

# Section header
section() {
    clear
    echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}  $1${NC}"
    echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Simulated command output
simulate_command() {
    echo -e "${GREEN}\$ $1${NC}"
    sleep 0.5
}

# Typing effect for narration
narrate() {
    echo -e "${PURPLE}👻 Ghost County Guide:${NC} $1"
    echo ""
}

#######################################
# SECTION 1: INTRODUCTION
#######################################
section "1. INTRODUCTION - What is Haunt?"

narrate "Welcome to Ghost County, where AI agents haunt your codebase to make it better."

echo "Haunt is a lightweight framework for autonomous AI agent teams."
echo ""
echo -e "${BOLD}Core Concepts:${NC}"
echo "  🔮 Séance      - Planning workflow (idea → structured requirements)"
echo "  👻 Spirits     - AI agents (Dev, Research, Code Review, PM)"
echo "  🌙 Rituals     - Daily maintenance workflows"
echo "  💀 Curses      - Pattern detection (anti-patterns = defeated curses)"
echo "  📿 Haunting    - Active work tracking across agents"
echo ""
echo -e "${BOLD}Think of it as:${NC}"
echo "  Claude Code + autonomous agents + structured workflows"
echo ""

pause

#######################################
# SECTION 2: THE SÉANCE - PLANNING
#######################################
section "2. THE SÉANCE - From Idea to Roadmap"

narrate "The séance is where ideas materialize into structured work."

echo "Let's say you have an idea: 'Add dark mode to the app'"
echo ""
echo -e "${BOLD}Step 1: Start the séance${NC}"
simulate_command "/seance idea"
echo ""
echo "  🔮 Channeling the spirits..."
echo "  🔮 What feature would you like to manifest?"
echo ""
echo -e "${CYAN}  > Add dark mode toggle to application settings${NC}"
echo ""

sleep 1

echo -e "${BOLD}Step 2: The PM Spirit analyzes the request${NC}"
echo ""
cat << 'EOF'
  📋 Analyzing request...

  ✓ Feature validated: Dark mode implementation
  ✓ Breaking into requirements:
    - REQ-042: Create theme context and state management
    - REQ-043: Build dark mode toggle component
    - REQ-044: Implement dark theme CSS variables
    - REQ-045: Update existing components for theme support

  ✓ Added to roadmap: .haunt/plans/roadmap.md
  ✓ Estimated effort: 2 days (4 x S-sized tasks)
EOF
echo ""

narrate "The séance has materialized your idea into trackable requirements!"

pause

#######################################
#######################################
# SECTION 2.5: INTERACTIVE DECISIONS
#######################################
section "2.5. INTERACTIVE DECISIONS - Agents Ask, You Decide"

narrate "Agents don't guess when there's ambiguity - they ask!"

echo -e "${BOLD}Scenario: Ambiguous request${NC}"
echo "Let's try a vague idea: 'Add authentication'"
echo ""
simulate_command "/seance idea"
echo ""
echo "  🔮 Channeling the spirits..."
echo "  🔮 What feature would you like to manifest?"
echo ""
echo -e "${CYAN}  > Add authentication${NC}"
echo ""

sleep 1

echo -e "${YELLOW}⚠️  CLARITY NEEDED: Multiple ways to implement authentication${NC}"
echo ""
echo -e "${BOLD}How should we implement authentication?${NC}"
echo ""
echo "  [1] NextAuth.js (Recommended)"
echo "      ↳ Full-featured auth library with OAuth, email, credentials"
echo ""
echo "  [2] Clerk"
echo "      ↳ Managed service. Beautiful UI, adds external dependency"
echo ""
echo "  [3] Supabase Auth"
echo "      ↳ If using Supabase, integrated solution with RLS"
echo ""
echo "  [4] Custom JWT"
echo "      ↳ Full control, more work to secure properly"
echo ""

sleep 2

echo -e "${CYAN}Your choice: [1]${NC}"
echo ""

sleep 1

echo -e "${GREEN}✓${NC} Proceeding with NextAuth.js approach"
echo -e "${GREEN}✓${NC} Creating requirements:"
echo "  - REQ-047: Install NextAuth.js and configure providers"
echo "  - REQ-048: Create authentication API routes"
echo "  - REQ-049: Add session handling middleware"
echo "  - REQ-050: Build login/logout UI components"
echo ""

narrate "One question saved hours of work in the wrong direction!"

pause

# SECTION 3: SUMMONING SPIRITS
#######################################
section "3. SUMMONING SPIRITS - Agent Spawning"

narrate "Now we summon the spirits to do the work."

echo -e "${BOLD}Summon a single agent:${NC}"
simulate_command "/summon Dev-Frontend REQ-042"
echo ""
echo "  🌙 Summoning Dev-Frontend spirit..."
echo "  👻 Spirit materialized in new Claude tab"
echo "  📋 Assignment: REQ-042 (Create theme context)"
echo "  🎯 Status: 🟡 In Progress"
echo ""

sleep 1

echo -e "${BOLD}Or summon ALL available agents in parallel:${NC}"
simulate_command "/summon all"
echo ""
echo "  🌙 Channeling all available spirits..."
echo ""
echo "  👻 Dev-Frontend → REQ-042 (Theme context)"
echo "  👻 Dev-Frontend → REQ-043 (Toggle component)"
echo "  👻 Dev-Frontend → REQ-044 (CSS variables)"
echo "  👻 Dev-Backend  → (No backend work in this batch)"
echo ""
echo "  ✨ 3 spirits summoned, working in parallel"
echo ""

narrate "Each spirit works independently, guided by the roadmap."

pause

#######################################
# SECTION 4: PATTERN DETECTION (CURSE)
#######################################
section "4. THE CURSE - Pattern Detection"

narrate "Curses are anti-patterns we hunt and defeat with tests."

echo -e "${BOLD}Detect patterns in codebase:${NC}"
simulate_command "/seer"
echo ""
echo "  💀 Scanning codebase for known curses..."
echo ""
cat << 'EOF'
  Found potential curses:

  ⚠️  Silent Fallback Curse (3 instances)
      src/api/users.py:42    → user_id = data.get('id', 0)
      src/api/auth.py:18     → role = request.args.get('role', 'user')
      src/models/payment.py:67 → amount = params.get('amount', 0)

  ⚠️  Magic Number Curse (2 instances)
      src/utils/validator.py:23 → if age > 18
      src/utils/cache.py:15     → timeout = 86400

  ✓ God Function Curse (0 instances) - DEFEATED ✨
EOF
echo ""

sleep 1

echo -e "${BOLD}Defeat a curse with a test:${NC}"
simulate_command "/exorcism silent-fallback"
echo ""
echo "  📝 Creating defeat test..."
echo "  🧪 Test written: .haunt/tests/patterns/test_no_silent_fallback.py"
echo "  🔍 Test scans for .get() with defaults on required fields"
echo "  ✅ Test PASSES - curse banished!"
echo ""

narrate "Every defeated curse becomes a permanent guardian through tests."

pause

#######################################
# SECTION 5: STATUS TRACKING
#######################################
section "5. STATUS TRACKING - The Haunting"

narrate "Track all spirits and their work across the project."

echo -e "${BOLD}View active hauntings:${NC}"
simulate_command "/haunting"
echo ""
cat << 'EOF'
  👻 Active Spirits:

  Dev-Frontend (Session: abc123)
    🟡 REQ-042: Create theme context and state management
       ✓ Created ThemeContext.tsx
       ✓ Added theme provider to App.tsx
       ⏳ Writing tests for theme switching

  Dev-Frontend (Session: def456)
    🟡 REQ-043: Build dark mode toggle component
       ✓ Created ToggleSwitch component
       ⏳ Integrating with theme context

  Dev-Frontend (Session: ghi789)
    🟡 REQ-044: Implement dark theme CSS variables
       ✓ Added CSS custom properties
       ⏳ Testing color contrast ratios
EOF
echo ""

sleep 1

echo -e "${BOLD}View roadmap status:${NC}"
simulate_command "/haunt status"
echo ""
cat << 'EOF'
  📊 Roadmap Status:

  Batch 1: Dark Mode Implementation
    🟡 REQ-042: Theme context         (In Progress)
    🟡 REQ-043: Toggle component      (In Progress)
    🟡 REQ-044: CSS variables         (In Progress)
    ⚪ REQ-045: Update components     (Not Started, blocked by REQ-042)

  Progress: 3/4 tasks in progress (75% active)
EOF
echo ""

narrate "Real-time visibility into all agent work, no manual syncing needed."

pause

#######################################
# SECTION 6: RITUALS
#######################################
section "6. RITUALS - Daily Maintenance"

narrate "Rituals keep the spirits organized and the codebase clean."

echo -e "${BOLD}Daily ritual (morning):${NC}"
simulate_command "/ritual daily"
echo ""
cat << 'EOF'
  🌅 Performing daily ritual...

  ✓ Checked roadmap health (4 active, 12 completed, 0 stale)
  ✓ Verified test suite passing (127 tests, 0 failures)
  ✓ Scanned for pattern violations (0 new curses)
  ✓ Synced agent memory (3 active sessions archived)
  ✓ Updated Active Work in CLAUDE.md

  🎯 Ready for today's work!
EOF
echo ""

sleep 1

echo -e "${BOLD}Weekly ritual (maintenance):${NC}"
simulate_command "/ritual weekly"
echo ""
cat << 'EOF'
  📅 Performing weekly ritual...

  ✓ Archived 12 completed requirements
  ✓ Roadmap size: 387 lines (healthy, under 500 limit)
  ✓ Updated pattern library (2 new defeats this week)
  ✓ Validated agent character sheets (all current)
  ✓ Checked dependency updates (3 available)

  📊 Weekly summary:
     - 12 requirements completed
     - 2 curses defeated
     - 3 agents active
     - 0 blockers
EOF
echo ""

narrate "Rituals automate the boring maintenance work, keeping focus on building."

pause

#######################################
# SECTION 7: WRAP-UP
#######################################
section "7. PUTTING IT ALL TOGETHER"

narrate "Let's review the complete workflow..."

echo -e "${BOLD}The Haunt Workflow:${NC}"
echo ""
echo "  1. 🔮 ${CYAN}/seance idea${NC}      → Turn ideas into structured requirements"
echo "  2. 👻 ${CYAN}/summon all${NC}       → Spawn agents to work in parallel"
echo "  3. 📊 ${CYAN}/haunting${NC}         → Track progress across all agents"
echo "  4. 💀 ${CYAN}/seer${NC}             → Detect and divine anti-patterns"
echo "  5. 🌙 ${CYAN}/ritual daily${NC}     → Keep everything organized"
echo ""
echo -e "${BOLD}Key Benefits:${NC}"
echo "  ✓ ${GREEN}Autonomous agents${NC} - Multiple Claude sessions working in parallel"
echo "  ✓ ${GREEN}Structured workflow${NC} - Clear process from idea → implementation"
echo "  ✓ ${GREEN}Pattern enforcement${NC} - Tests guard against anti-patterns"
echo "  ✓ ${GREEN}Low overhead${NC} - Minimal coordination needed"
echo "  ✓ ${GREEN}Transparent${NC} - Full visibility into agent work"
echo ""

pause

#######################################
# FINAL SCREEN
#######################################
clear
echo -e "${CYAN}"
cat << "EOF"
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║              Thank You for Watching! 🌙                  ║
    ║                                                           ║
    ║     Ready to haunt your codebase with helpful spirits?   ║
    ║                                                           ║
    ║              Get started: Haunt/SETUP-GUIDE.md           ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"
echo ""
echo -e "${BOLD}Questions?${NC}"
echo ""
echo "  📚 Full documentation: Haunt/README.md"
echo "  🔧 Setup instructions: Haunt/SETUP-GUIDE.md"
echo "  📋 Quick reference: Haunt/QUICK-REFERENCE.md"
echo ""
echo -e "${YELLOW}Demo complete! Thanks for your time.${NC}"
echo ""
