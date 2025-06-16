# component_registry.gd
extends Node
class_name ComponentRegistry

static var _registry: Dictionary[String,Script] = {
	"HealthComponent":preload("uid://ddkykskdp4j3k"),
	"PositionComponent":preload("uid://mf3f25jqbatb"),
	"InventoryComponent":preload("uid://wqcyyk717ile"),
	"ResourceComponent":preload("uid://cbf7xwqkjlycj"),
	"VisionComponent":preload("uid://du37dx3d1do2e"),
	"ActionQueueComponent":preload("uid://buynuass4lwjo"),
	"CurrentGoalComponent":preload("uid://dpgl3nykq5ubu"),
	"EquippableComponent":preload("uid://dw40ybygh1467"),
	"EquipmentComponent":preload("uid://dn786unhvh1mg"),
	"MobilityComponent":preload("uid://csies4wklr1qv"),
	"MovementPathComponent":preload("uid://cef53qosior36"),
	"TargetEntityComponent":preload("uid://ciuw2dj0bcuce"),
	"AvailableActionComponent":preload("uid://b778wfmssldvq"),
	"CurrentPlanComponent":preload("uid://dk6vxkygw8g6c"),
	"SaughtEntityComponent":preload("uid://6syjoyosbikf")
}

static func register_component(name: String, class_ref: Script) -> void:
	_registry[name] = class_ref

static func get_component_class(name: String) -> Script:
	return _registry.get(name)

static func has_component(name: String) -> bool:
	return _registry.has(name)

static func get_registered_names() -> Array[String]:
	return _registry.keys()
