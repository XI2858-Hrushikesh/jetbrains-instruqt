---
slug: real-world-workflow
id: 8c8l3sbgtytr
type: challenge
title: Refactoring and Debugging
teaser: Use IntelliJ's refactoring tools to rename a parameter consistently across
  a function, then set a breakpoint and step through code in the debugger.
notes:
- type: text
  contents: |-
    ## In this challenge you will refactor and debug

    Two workflows that appear in every real development session: keeping a rename consistent across a codebase, and stepping through code with the debugger to understand exactly what happens at runtime.

    By the end of this challenge you will have:
    - Renamed a parameter using IntelliJ's Rename refactoring (Shift+F6) — with every reference updated automatically
    - Set a breakpoint and run the debugger to inspect variable values at runtime
    - Committed the changes with a descriptive message
    - Recovered an uncommitted edit using Local History — no git commit required
tabs:
- id: qwg364re0lly
  title: IDE Desktop
  type: service
  hostname: workstation
  path: /?password=instruqt&autoconnect=true&resize=scale
  port: 8080
  protocol: https
  custom_request_headers:
  - key: Authorization
    value: Basic cm9vdDppbnN0cnVxdA==
- id: yn1kndxovqxm
  title: Terminal
  type: terminal
  hostname: workstation
difficulty: intermediate
timelimit: 1500
enhanced_loading: null
---

# Refactoring and Debugging

Two workflows that appear in every real session: rename consistently, and understand what the code actually does at runtime.

---

## Step 1 — Confirm the Project State

Switch to the **Terminal** tab and run:

```bash,run
cd /workspace/task_tracker && git log --oneline && touch /tmp/c3-s1
```

You should see one initial commit. All your changes in this challenge will be built on top of it.

---

## Step 2 — Open the Function to Rename

Switch to the **IDE Desktop** tab. Open `tasks.py`.

Scroll to `sort_tasks_by_due_date`. Its parameter is currently named `task_list`:

```python,nocopy
def sort_tasks_by_due_date(task_list):
```

Every other function in this file uses `tasks` for the same concept. You will rename it to be consistent — but doing it by hand risks missing references inside the function body.

---

## Step 3 — Rename with Shift+F6

Click directly on the word `task_list` in the function **signature** (on the `def` line).

Press `Shift+F6` to trigger IntelliJ's **Rename** refactoring.

A small input field appears in-place. Type:

```text,copy
tasks
```

Press `Enter` to confirm.

IntelliJ updates every reference to `task_list` inside `sort_tasks_by_due_date` automatically — the signature and every use in the function body. Save the file (`Ctrl+S` / `Cmd+S`).

---

## Step 4 — Verify the Rename

Switch to the **Terminal** tab and run:

```bash,run
cd /workspace/task_tracker && python3 -c "from tasks import sort_tasks_by_due_date; print('rename OK')" && touch /tmp/c3-s4
```

If you see `rename OK`, the rename is consistent and the function is importable without errors.

---

## Step 5 — Set a Breakpoint

Switch back to the **IDE Desktop** tab. In `tasks.py`, find the `add_task` function.

Click in the **gutter** (the grey area to the left of the line numbers) on the line:

```python,nocopy
task = {
```

A red circle appears — this is a breakpoint. Execution will pause here whenever `add_task` is called.

---

## Step 6 — Run in Debug Mode

At the top of the IDE, click the **Debug button** (green bug icon, next to the Run button), or press `Shift+F9`.

> [!TIP]
> `Shift+F9`, `F8`, and `F9` all reach the IDE fine in this sandbox — they're not intercepted by the browser. If a press seems to do nothing, click once inside the editor first so focus is on the remote session.

IntelliJ runs the configured `task_tracker` script in debug mode. Execution pauses at the breakpoint inside `add_task`.

<details>
<summary>Hint: Execution doesn't pause at the breakpoint</summary>

Double-check the red circle is on the exact line `task = {` inside `add_task`, not on a blank line or a different function. Also confirm you used the **Debug** button (bug icon) and not **Run** — breakpoints are ignored in a normal run.

</details>

The **Debug tool window** opens at the bottom. In the **Variables** panel, inspect:
- `title` — the task title passed in
- `priority` — the default value `"medium"`
- `due_date` — `None`

Press `F8` (Step Over) to move to the next line and watch the `task` variable appear in the Variables panel with its full dictionary value.

Press `F9` (Resume) to let the program finish.

```bash,run
touch /tmp/c3-s6
```

---

## Step 7 — Remove the Breakpoint

Click the red circle in the gutter again to remove the breakpoint.

---

## Step 8 — Stage and Commit

Switch to the **Terminal** tab and run:

```bash,run
cd /workspace/task_tracker && \
  git add tasks.py && \
  git commit -m "Rename task_list to tasks in sort_tasks_by_due_date for consistency" && \
  touch /tmp/c3-s8
```

---

## Step 9 — Recover an Edit with Local History

Committing isn't the only safety net IntelliJ gives you — it also keeps a **Local History** of every save, independent of git. This matters most for the mistake git can't help with: an edit you made before you ever committed it.

In `tasks.py`, add a throwaway line at the very top of the file:

```python,copy
# TEMP: accidental edit
```

Save the file (`Ctrl+S`).

Now recover from it as if you'd closed the IDE and lost your undo history: right-click anywhere in the editor and select **Local History > Show History**. In the timeline on the left, pick the revision from just before you added the line, then right-click it and choose **Revert Selection**.

<details>
<summary>Hint: "Local History" isn't in the right-click menu</summary>

Make sure you're right-clicking inside the editor pane itself (not the Project tool window). If it's still missing, press `Ctrl+Shift+A` / `Cmd+Shift+A` for **Find Action** and type "Show History" — this search-by-name shortcut reaches every IDE action regardless of which menus are visible.

</details>

Confirm the throwaway line is gone:

```bash,run
cd /workspace/task_tracker && ! grep -q "TEMP: accidental edit" tasks.py && touch /tmp/c3-s9
```

---

## What You Used

| Feature | Shortcut | What it did |
|---------|----------|-------------|
| Rename refactoring | Shift+F6 | Renamed parameter + all references in one action |
| Debug mode | Shift+F9 | Ran the program and paused at the breakpoint |
| Step Over | F8 | Moved one line at a time through execution |
| Resume | F9 | Continued to end of program |
| Local History | — | Recovered an edit git never saw, with no commit required |

This is IntelliJ IDEA running in a browser — no local install, no configuration, no account. The same full IDE your developers use on their machines.

Click **Check** to finish.
