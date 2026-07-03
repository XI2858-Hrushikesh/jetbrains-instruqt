import json
import os
from datetime import datetime

TASKS_FILE = os.path.join(os.path.dirname(__file__), "tasks.json")


def load_tasks():
    if not os.path.exists(TASKS_FILE):
        return []
    with open(TASKS_FILE) as f:
        return json.load(f)


def save_tasks(tasks):
    with open(TASKS_FILE, "w") as f:
        json.dump(tasks, f, indent=2)


def add_task(title, priority="medium", due_date=None):
    tasks = load_tasks()
    task = {
        "id": len(tasks) + 1,
        "title": title,
        "priority": priority,
        "due_date": due_date,
        "completed": False,
        "created_at": datetime.now().isoformat(),
    }
    tasks.append(task)
    save_tasks(tasks)
    return task


def complete_task(task_id):
    """Mark a task as completed by its ID. Returns the task dict or None."""
    tasks = load_tasks()
    for task in tasks:
        if task["id"] == task_id:
            task["completed"] = True
            save_tasks(tasks)
            return task
    return None


def list_tasks(show_completed=False):
    tasks = load_tasks()
    if not show_completed:
        tasks = [t for t in tasks if not t["completed"]]
    return tasks


# TODO: filter_tasks_by_priority(tasks, priority)
# Given a list of task dicts and a priority string ("high", "medium", or "low"),
# return only the tasks whose "priority" key matches the given value.


def sort_tasks_by_due_date(task_list):
    return sorted(task_list, key=lambda t: (t["due_date"] is None, t["due_date"] or ""))


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage: python3 tasks.py <add|list|complete> [args]")
        sys.exit(1)

    cmd = sys.argv[1]
    if cmd == "add":
        title = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else "New task"
        task = add_task(title)
        print(f"Added task #{task['id']}: {task['title']}")
    elif cmd == "list":
        tasks = list_tasks()
        if not tasks:
            print("No pending tasks.")
        for t in tasks:
            print(f"[{t['id']}] {t['title']} (priority: {t['priority']})")
    elif cmd == "complete":
        task_id = int(sys.argv[2])
        task = complete_task(task_id)
        if task:
            print(f"Completed task #{task['id']}: {task['title']}")
        else:
            print(f"Task #{task_id} not found.")
    else:
        print(f"Unknown command: {cmd}")
        sys.exit(1)
