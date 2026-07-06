---
slug: explore-and-run
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
  path: /?password=instruqt&autoconnect=true&resize=scale
  port: 8080
  protocol: https
  custom_request_headers:
  - key: Authorization
    value: Basic cm9vdDppbnN0cnVxdA==
- id: hmouxpilflbj
  title: Terminal
  type: terminal
  hostname: workstation
difficulty: basic
timelimit: 1080
enhanced_loading: null
---

# Explore the IDE and Run Your First Project

A full IntelliJ IDEA Community installation is running in this sandbox. The `task_tracker` project is already open — a small Python CLI for managing tasks. Your goal in this challenge is to get oriented and run it.

---

## Step 1 — Orient in the IDE

Switch to the **IDE Desktop** tab.

> [!NOTE]
> When the IDE first opens, one or more setup dialogs (License Agreement, Data Sharing) may appear. They will be **automatically dismissed within 5–10 seconds** — the sandbox runs a background script that accepts the license and closes those dialogs for you. If you see a dialog, just wait a moment and it will close on its own.

> [!NOTE]
> IntelliJ indexes the project on first launch. During indexing the IDE may feel slow or unresponsive — this is normal. Wait for the spinning progress indicator in the **status bar at the bottom** to finish before clicking around. Indexing typically takes 30–60 seconds.

Identify the main areas:

| Area | Location | Purpose |
|------|----------|---------|
| **Project tool window** | Left panel | File tree for the project |
| **Editor area** | Center | Read and write code |
| **Run toolbar** | Top right | Run, Debug, Stop buttons |
| **Status bar** | Bottom | Indexing progress, events |

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

## Step 3 — Find Your Way Around with Search Everywhere and Structure View

Before wiring up a run configuration, get comfortable navigating without the Project tree.

Press `Shift` twice quickly (**Search Everywhere**). Type `main.py` and press `Enter` to jump straight to it — this works for files, classes, functions, and even IDE settings from one box.

With a file open, go to **View > Tool Windows > Structure** (or `Ctrl+F12` / `Cmd+F12` — reserved by most browsers as a dev-tools shortcut, so the menu path is the reliable option here). The **Structure** tool window lists every function in the current file in one place, useful for orienting in a file before reading it top to bottom.

```bash,run
touch /tmp/c1-s3
```

---

## Step 4 — Create a Run Configuration

IntelliJ needs a run configuration to know how to execute the script.

1. Click **Run > Edit Configurations** in the menu bar (or click the dropdown next to the Run button in the top toolbar and choose **Edit Configurations**).
2. Click the **+** button and select **Python**.
3. Set:
   - **Name**: `task_tracker`
   - **Script path**: `/workspace/task_tracker/tasks.py`
   - **Parameters**: `list`
4. Click **OK**.

---

## Step 5 — Run the Project

Click the **Run button** (green triangle) in the top toolbar, or press `Shift+F10`.

> [!TIP]
> `Shift+F10` is safe here — it's not a browser-reserved shortcut. Later challenges use `Alt+Enter`, `Shift+F6`, and function keys; if a shortcut ever seems to do nothing, click once inside the **IDE Desktop** tab first so keystrokes are captured by the remote session instead of the browser tab.

<details>
<summary>Hint: Run button is greyed out</summary>

This usually means the run configuration from Step 4 wasn't saved. Reopen **Run > Edit Configurations** and confirm the `task_tracker` configuration is listed and selected in the dropdown next to the Run button, then try again.

</details>

The **Run tool window** opens at the bottom of the IDE and shows the output:

```
No pending tasks.
```

This confirms the project runs correctly. The output appears because we set `list` as the parameter — the app lists pending tasks, and there are none yet.

---

## Step 6 — Add a Task from the Terminal

Switch to the **Terminal** tab and run:

```bash,run
cd /workspace/task_tracker && python3 tasks.py add "Fix login bug" && touch /tmp/c1-s6
```

Switch back to the **IDE Desktop** tab and click the **Run button** again. The output now shows:

```
[1] Fix login bug (priority: medium)
```

The task you added from the terminal is now visible when running from the IDE — both use the same `tasks.json` file.

---

## Step 7 — Mark Complete

Switch to the **Terminal** tab and run:

```bash,run
touch /workspace/task_tracker/.run_done && touch /tmp/c1-s7
```

---

## What You Saw

- IntelliJ IDEA running in a browser via KasmVNC — no local install
- Search Everywhere and Structure view for navigating without the Project tree
- A Python project opened, configured, and executed from the IDE
- Terminal and IDE sharing the same filesystem

In the next challenge you'll use IntelliJ's Intention Actions and code completion to fix a warning and implement a function directly from a comment.

Click **Check** to continue.
