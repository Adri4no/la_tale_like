extends KinematicBody2D


const FLOOR = Vector2(0, -1);
const GRAVITY = 20;
const ACCELERATION = 50;
const MAX_SPEED = 200;
const JUMPFORCE = 350;
const DASHFORCE = {"x":6000, "y":190};

var motion = Vector2();
var mouseButton = 0;
var mouseCoordinates = Vector2();
var sides = {'left': false, 'right': true};
var damage = 5;

func _ready():
	$Sprite/Area2D.connect("body_entered", self, "inflict_attack");
	pass

# warning-ignore:unused_argument
func _physics_process(delta):
	motion.y += GRAVITY;
	var friction = false;
	mouseButton = Input.get_mouse_button_mask();
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x+ACCELERATION, MAX_SPEED);
		sides.right = true;
		sides.left = false;
		$AnimationPlayer.play("walking_R");
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x-ACCELERATION, -MAX_SPEED);
		sides.right = false;
		sides.left = true;
		$AnimationPlayer.play("walking_L");
	elif Input.is_action_just_pressed("attack"):
		if sides.right == true:
			$AnimationPlayer.play("attack_R");
			pass
		if sides.left == true:
			$AnimationPlayer.play("attack_L");
			pass
	elif Input.is_action_just_pressed("dashR"):
		motion.x = lerp(0, DASHFORCE["x"], 0.3);
		motion.y = lerp(0, -DASHFORCE["y"], 0.7);
		print('E');
	elif Input.is_action_just_pressed("dashL"):
		motion.x = lerp(0, -DASHFORCE["x"], 0.3);
		motion.y = lerp(0, -DASHFORCE["y"], 0.7);
		print('Q');
	else:
		if sides.right == true and !($AnimationPlayer.current_animation == 'attack_R' or $AnimationPlayer.current_animation == 'attack_L'):
			$AnimationPlayer.play("idle");
			pass
		if sides.left == true and !($AnimationPlayer.current_animation == 'attack_R' or $AnimationPlayer.current_animation == 'attack_L'):
			$AnimationPlayer.play("idle_L");
			pass
		friction = true;
		motion.x = lerp(motion.x, 0, 0.2);
		pass
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_select"):
			motion.y = -JUMPFORCE;
			pass
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2);
			pass
	else:
		################################in the air
		if motion.y < 0:
			######subindo
			print('subindo');
		else :
			######caindo
			print('caindo');
			pass
		
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05);
			pass
		
		pass
	
	motion = move_and_slide(motion, FLOOR);
	
	################################ Reset
	if position.y > 600:
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		pass
		
	pass


func _input(event):
#	print(event);
	if event is InputEventMouseMotion:
#		print(event.position);
		mouseCoordinates = event.position;
		pass
	pass

func inflict_attack(body):
	print(body.name);
	if body.has_method("get_hurt"):
		if body.name != 'player':
			body.get_hurt(damage);
			pass
		pass
	pass