extends CharacterBody2D
class_name Player


var _state_machine: AnimationNodeStateMachinePlayback
var _is_attacking: bool = false
@export_category("variables")
@export var _move_speed: float = 64.0
@export var _acceleration: float = 0.2
@export var _friction: float = 0.2
@export_category("objects")
@export var _animation_tree: AnimationTree = null


func _ready() -> void:
  _animation_tree.active = true
  _state_machine = _animation_tree["parameters/playback"]


func _physics_process(_delta: float) -> void:
  _move()
  _attack()
  _animate()
  move_and_slide()
  
  
func _move() -> void:
  var direction: Vector2 = Vector2(
    Input.get_axis("move_left", "move_right"),
    Input.get_axis("move_up", "move_down"),
  )
  if direction != Vector2.ZERO:
    _animation_tree["parameters/idle/blend_position"] = direction
    _animation_tree["parameters/walk/blend_position"] = direction
    _animation_tree["parameters/attack/blend_position"] = direction
    velocity.x = lerp(velocity.x, direction.normalized().x * _move_speed, _acceleration)
    velocity.y = lerp(velocity.y, direction.normalized().y * _move_speed, _acceleration)
    return
  
  velocity.x = lerp(velocity.x, direction.normalized().x * _move_speed, _friction)
  velocity.y = lerp(velocity.y, direction.normalized().y * _move_speed, _friction)
  velocity = direction.normalized() * _move_speed


func _attack() -> void:
  if Input.is_action_just_pressed("attack") and not _is_attacking:
    set_physics_process(false)
    _is_attacking = true


func _animate() -> void:
  if _is_attacking:
    _state_machine.travel("attack")
    return
  if velocity.length() > 10:
    _state_machine.travel("walk")
    return
  _state_machine.travel("idle")



func _on_animation_tree_animation_finished(anim_name: StringName):
    if anim_name.contains("attack"):
      set_physics_process(true)
      _is_attacking = false


func _on_attack_area_body_entered(body: Enemy) -> void:
  if body.is_in_group("enemy"):
    body.update_health(randi_range(1, 5))
