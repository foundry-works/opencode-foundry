# Querying Spec and Task Data Efficiently

Before running a fidelity review, you may need to gather context about the spec, phases, or tasks. Use the following MCP tools instead of writing bash loops:

## Query Multiple Tasks at Once
```bash
# Get all tasks in a phase
foundry-mcp_task action="query" spec_id={spec-id} parent="phase-1"

# Get tasks by status
foundry-mcp_task action="query" spec_id={spec-id} status="completed"

# Combine filters
foundry-mcp_task action="query" spec_id={spec-id} parent="phase-2" status_filter="pending"
```

## Get Single Task Details
```bash
# Get detailed information about a specific task
foundry-mcp_task action="info" spec_id={spec-id} task_id="task-1-3"
```

## List Phases
```bash
# See all phases with progress information
foundry-mcp_task action="list" spec_id={spec-id} include_phases=true
```

## DON'T Do This (Inefficient)
```bash
# BAD: Bash loop calling task info repeatedly
for i in 1 2 3 4 5; do
  foundry-mcp_task action="info" spec_id={spec-id} task_id="task-1-$i"
done

# BAD: Creating temp scripts
cat > /tmp/get_tasks.sh << 'EOF'
...
EOF
```

## DO This Instead
```bash
# GOOD: Single command gets all tasks in phase-1
foundry-mcp_task action="query" spec_id={spec-id} parent="phase-1"
```
