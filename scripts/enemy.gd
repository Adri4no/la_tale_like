extends KinematicBody2D

enum STATES {IDLE, MOVE, ATTACK};
enum LIFE_TYPE {AGRESSIVE, PASSIVE};

const CONST_MOVEMENT = 0.45;
const FLOOR = Vector2(0, -1);
const GRAVITY = 20;
const ACCELERATION = 50;
const MAX_SPEED = 200;
const SPEED = 50;
const JUMPFORCE = 350;
const DASHFORCE = {"x":6000, "y":190};

onready var player = get_node("/root/Level/player");

var motion = Vector2();
var sent = 1;
var life = 15;
var current_life_type = LIFE_TYPE.PASSIVE;

signal killed;

func _ready():
	$AnimationPlayer.play("moving");
	print(player);
	pass

func _process(delta):
	if current_life_type == LIFE_TYPE.PASSIVE:
		var new_offset = get_parent().unit_offset+delta*sent*CONST_MOVEMENT;
		if sent ==1 and new_offset >=0.999:
			sent = -1;
			get_parent().unit_offset = 0.999;
			$Sprite.flip_h = true;
		elif sent == -1 and new_offset <= 0:
			sent = 1;
			get_parent().unit_offset = 0;
			$Sprite.flip_h = false;
		else:
			get_parent().unit_offset = new_offset;
			pass
	else:
		motion.y += GRAVITY;
		var friction = false;
		var direction = player.position - get_global_position();
		var distance = sqrt(direction.x*direction.x+direction.y*direction.y);
#		print(distance);
		if distance > 300:
			current_life_type = LIFE_TYPE.PASSIVE;
		else:
			if distance > 30:
				var aux = direction.normalized()*SPEED;
				motion.x = aux.x;
				motion = move_and_slide(motion, FLOOR);
			else:
				#execute attack
				pass
			pass
		pass
	
	pass

func get_hurt(damage):
	life -= damage;
	if life <=0:
		queue_free();
		emit_signal("killed");
	elif current_life_type == LIFE_TYPE.PASSIVE:
		current_life_type = LIFE_TYPE.AGRESSIVE
		pass
	pass