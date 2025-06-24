extends System
class_name MovementSystem

var layer : TileMapLayer

func _init():
	required_components = ["PositionComponent", "MovementPathComponent"]

func process(entity: Entity) -> void:
		#print("processing movement")
		if not entity.has_component_type("PositionComponent"):
			print("entity has no position")
			return
		##would use the traversable values for how many steps in the path is moved per tick
		if not entity.has_component_type("BrainComponent"):
			print("entity has no brain")
			return
		var brain_comp : BrainComponent = entity.get_component_by_type("BrainComponent")
		if not brain_comp.knows("traverses"):
			print("entity does not have traversal knowledge")
			return
		if not brain_comp.knows("current_path"):
			print("entity does not have pathing knowledge")
			return

		var pos_comp : PositionComponent= entity.get_component_by_type("PositionComponent")
		var cur_path : Array = brain_comp.recall("current_path", [])

		#if cur_path.size() == 1:
			#print("Arrived at final destination")
			#brain_comp.memory["current_path"].clear()
			## Optionally: update intent, clear target, etc.

		#var steps = clamp(brain_comp.recall("traverses", 1), 1, cur_path.size())
		#for i in steps:
			#var next_pos = cur_path[0]
			#pos_comp.pos = next_pos
			#cur_path = cur_path.slice(1)
			#if cur_path.is_empty():
				#break
		#brain_comp.remember("current_path", cur_path)

		if cur_path.is_empty():
			#print("path is empty")
			return
			
		
		var next_pos
		if cur_path.size() == 1:
			next_pos = cur_path[0]
		else:
			next_pos = cur_path[1]

		# You could insert movement validation logic here if needed (e.g., check terrain passability)

		# Instantly move to next tile
		pos_comp.pos = next_pos
		brain_comp.remember("current_path", cur_path.slice(1))
