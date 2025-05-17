# component_tasks.gd
extends Resource
class_name component_tasks

var task_queue: Array[Dictionary] = []

func enqueue(task: Dictionary):
	task_queue.append(task)

func current_task() -> Dictionary:
	return task_queue.front() if task_queue.size() > 0 else {}
