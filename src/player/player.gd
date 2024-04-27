extends CharacterBody2D
class_name Player


@export_category("variables")
@export var _move_speed: float = 64.0
@export var _acceleration: float = 0.2
@export var _friction: float = 0.2


func _physics_process(delta: float) -> void:
  _move()
  move_and_slide()
  
  
func _move() -> void:
  var direction: Vector2 = Vector2(
    Input.get_axis("move_left", "move_right"),
    Input.get_axis("move_up", "move_down"),
  )
  if direction != Vector2.ZERO:
    velocity.x = lerp(velocity.x, direction.normalized().x * _move_speed, _acceleration)
    velocity.y = lerp(velocity.y, direction.normalized().y * _move_speed, _acceleration)
    return
  
  velocity.x = lerp(velocity.x, direction.normalized().x * _move_speed, _friction)
  velocity.y = lerp(velocity.y, direction.normalized().y * _move_speed, _friction)
  velocity = direction.normalized() * _move_speed
