---
slug: activate-and-chat
id: mqwghirormzt
type: challenge
title: Explore the IDE and Run Your First Project
teaser: Get oriented in IntelliJ IDEA, open the sample Python project, and run it
  from the IDE — all from a browser with no local installation required.
notes:
- type: text
  contents: |-
    ## Welcome to IntelliJ IDEA — running entirely in your browser

    A full IntelliJ IDEA Community installation is running inside this sandbox — no download, no local install, no account required.

    In this first challenge you will:
    - Get oriented in the IDE layout and tool windows
    - Open and explore the sample Python project
    - Run the application from IntelliJ and interact with it from the terminal
tabs:
- id: 0xerhjceximf
  title: IDE Desktop
  type: service
  hostname: workstation
  port: 8080
- id: hmouxpilflbj
  title: Terminal
  type: terminal
  hostname: workstation
difficulty: basic
timelimit: 900
enhanced_loading: null
---

# Explore the IDE and Run Your First Project

A full IntelliJ IDEA Community installation is running in this sandbox. The `task_tracker` project is already open — a small Python CLI for managing tasks. Your goal in this challenge is to get oriented and run it.

---

## Step 1 — Orient in the IDE

Switch to the **IDE Desktop** tab.

Identify the main areas:

| Area | Location | Purpose |
|------|----------|---------|
| **Project tool window** | Left panel | File tree for the project |
| **Editor area** | Center | Read and write code |
| **Run toolbar** | Top right | Run, Debug, Stop buttons |
| **Status bar** | Bottom | Indexing progress, events |

> [!NOTE]
> IntelliJ may still be indexing the project when you first open the tab. Wait for the status bar at the bottom to show no spinning progress before continuing.

---

## Step 2 — Open tasks.py

In the **Project tool window** on the left, expand the `task_tracker` folder and double-click `tasks.py` to open it in the editor.

Read through the file. It contains:
- `add_task` — adds a new task to a JSON file
- `complete_task` — marks a task as done
- `list_tasks` — returns pending tasks
- `sort_tasks_by_due_date` — sorts by due date
- A `TODO` comment stub for a function you will implement in Challenge 2

---

## Step 3 — Create a Run Configuration

IntelliJ needs a run configuration to know how to execute the script.

1. Click **Run > Edit Configurations** in the menu bar (or click the dropdown next to the Run button in the top toolbar and choose **Edit Configurations**).
2. Click the **+** button and select **Python**.
3. Set:
   - **Name**: `task_tracker`
   - **Script path**: `/workspace/task_tracker/tasks.py`
   - **Parameters**: `list`
4. Click **OK**.

---

## Step 4 — Run the Project

Click the **Run button** (green triangle) in the top toolbar, or press `Shift+F10`.

The **Run tool window** opens at the bottom of the IDE and shows the output:

```
No pending tasks.
```

This confirms the project runs correctly. The output appears because we set `list` as the parameter — the app lists pending tasks, and there are none yet.

---

## Step 5 — Add a Task from the Terminal

Switch to the **Terminal** tab and run:

```bash,run
cd /workspace/task_tracker && python3 tasks.py add "Fix login bug" && touch /tmp/c1-s5
```

Switch back to the **IDE Desktop** tab and click the **Run button** again. The output now shows:

```
[1] Fix login bug (priority: medium)
```

The task you added from the terminal is now visible when running from the IDE — both use the same `tasks.json` file.

---

## Step 6 — Mark Complete

Switch to the **Terminal** tab and run:

```bash,run
touch /workspace/task_tracker/.run_done && touch /tmp/c1-s6
```

---

## What You Saw

- IntelliJ IDEA running in a browser via KasmVNC — no local install
- A Python project opened, configured, and executed from the IDE
- Terminal and IDE sharing the same filesystem

Click **Check** to continue.
