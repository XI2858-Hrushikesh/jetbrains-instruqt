---
slug: generate-and-transform
id: imwr9sh3yrsk
type: challenge
title: Smart Editing with IntelliJ Intentions
teaser: Use IntelliJ's built-in Intention Actions and code completion to fix warnings,
  implement a function from a comment, and add a docstring — without leaving the editor.
notes:
- type: text
  contents: |-
    ## In this challenge you will use IntelliJ's built-in smart editing features

    IntelliJ IDEA analyses your code continuously and surfaces suggestions through Intention Actions — the light bulb that appears when your cursor is on a line with a warning, an error, or an opportunity to improve.

    By the end of this challenge you will have:
    - Used Alt+Enter to trigger Intention Actions on a code warning
    - Implemented a function from a natural-language comment using code completion
    - Added a docstring to a function using an inspection quick-fix
tabs:
- id: shfdgorn2blx
  title: IDE Desktop
  type: service
  hostname: workstation
  path: /?password=instruqt&autoconnect=true&resize=scale
  port: 8080
  protocol: https
  custom_request_headers:
  - key: Authorization
    value: Basic cm9vdDppbnN0cnVxdA==
- id: 7arnmsji6wen
  title: Terminal
  type: terminal
  hostname: workstation
difficulty: intermediate
timelimit: 1200
enhanced_loading: null
---

# Smart Editing with IntelliJ Intentions

IntelliJ IDEA continuously inspects your code and surfaces improvements through **Intention Actions** — accessible with a single shortcut. This challenge puts three of them to work.

---

## Step 1 — Confirm Your Connection

Switch to the **Terminal** tab and run:

```bash,run
echo "Project: /workspace/task_tracker" && touch /tmp/c2-s1
```

---

## Step 2 — Open tasks.py and Find the Warning

Switch to the **IDE Desktop** tab. In the **Project tool window**, open `tasks.py`.

Look at the `sort_tasks_by_due_date` function near the bottom of the file. It has no type hints and no docstring — IntelliJ will show a faint warning gutter icon on the `def` line.

Click anywhere on the `def sort_tasks_by_due_date` line to place your cursor there.

---

## Step 3 — Trigger Intention Actions with Alt+Enter

Press `Alt+Enter` (Windows/Linux) or `Option+Return` (macOS).

A context menu of **Intention Actions** appears. These are IntelliJ's suggestions for the current line — they can range from quick-fixes to refactoring shortcuts.

Look for **"Add docstring"** or **"Insert documentation string stub"** and select it.

<details>
<summary>Hint: No docstring option appears in the Alt+Enter menu</summary>

Make sure your cursor is on the `def sort_tasks_by_due_date` line itself, not on a blank line above or below it. Intention Actions are context-sensitive to the exact line your cursor is on.

</details>

IntelliJ inserts a docstring template immediately below the `def` line. Fill in a one-line description:

```python,copy
"""Sort a list of task dicts by due_date, placing tasks with no due date last."""
```

Save the file (`Ctrl+S` / `Cmd+S`).

```bash,run
touch /tmp/c2-s3
```

---

## Step 4 — Implement a Function from a Comment

Scroll to the `TODO` comment stub near the bottom of `tasks.py`:

```python,nocopy
# TODO: filter_tasks_by_priority(tasks, priority)
# Given a list of task dicts and a priority string ("high", "medium", or "low"),
# return only the tasks whose "priority" key matches the given value.
```

Click on the blank line immediately below the comment. Type:

```python,copy
def filter_tasks_by_priority(tasks, priority):
```

Press `Enter`. IntelliJ's code completion analyses the comment above and suggests the function body. Accept the suggestion with `Tab`, or type the implementation manually:

```python,copy
    return [t for t in tasks if t.get("priority") == priority]
```

Save the file (`Ctrl+S` / `Cmd+S`).

---

## Step 5 — Verify the Function Works

Switch to the **Terminal** tab and run:

```bash,run
cd /workspace/task_tracker && python3 -c "
from tasks import filter_tasks_by_priority
sample = [
    {'title': 'A', 'priority': 'high'},
    {'title': 'B', 'priority': 'low'},
    {'title': 'C', 'priority': 'high'},
]
result = filter_tasks_by_priority(sample, 'high')
assert len(result) == 2, f'Expected 2, got {len(result)}'
print('filter_tasks_by_priority works correctly')
" && touch /tmp/c2-s5
```

---

## Step 6 — Use Find Usages to Explore the Codebase

Switch back to the **IDE Desktop** tab. In `tasks.py`, right-click on the `add_task` function name and select **Find Usages** (or press `Alt+F7`).

> [!TIP]
> If `Alt+F7` doesn't respond, click once inside the editor first — the keystroke needs to reach the remote IDE session, not the browser tab. The right-click menu option always works as a fallback.

IntelliJ shows every place `add_task` is referenced in the project. This is IntelliJ's deep code understanding at work — not a text search, but a semantic analysis of actual call sites.

```bash,run
touch /tmp/c2-s6
```

---

## What You Used

- **Alt+Enter** — IntelliJ's universal shortcut for Intention Actions and quick-fixes
- **Code completion** — context-aware suggestions that read your comments as specifications
- **Find Usages** — semantic reference search across the whole project

In the next challenge you'll rename a parameter consistently across a function with Shift+F6, then set a breakpoint and step through execution in the debugger.

Click **Check** to continue.
