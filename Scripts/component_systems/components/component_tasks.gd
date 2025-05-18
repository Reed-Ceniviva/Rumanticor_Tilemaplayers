extends Resource
class_name component_tasks

var task_queue: Array[task] = []
var current_task: task = null

func add_task(_task: task):
	task_queue.append(_task)

func start_next_task(entity):
	if task_queue.size() > 0:
		current_task = task_queue.pop_front()
		current_task.on_start(entity)
	else:
		current_task = null

func update(entity):
	if current_task:
		if current_task.is_complete(entity):
			current_task.on_finish(entity)
			start_next_task(entity)

func process_tasks(entity):
	if task_queue.size() == 0:
		return
	var current_task = task_queue[0]
	if current_task.execute(entity):
		task_queue.pop_front()
