extends Node2D

export (PackedScene) var enemy_resource = preload("res://scenes/enemy.tscn");

var AMOUNT_OF_ENEMIES = 5;
var area_of_spawn = Vector2();
var number_of_enemies = 0;

func _ready():
	randomize();
	$Area2D/Timer.connect("timeout", self, 'spawn');
	area_of_spawn = $Area2D/CollisionShape2D.shape.extents;
	$Area2D/Timer.start();
	pass

func spawn():
	number_of_enemies = get_child_count()-1;
	var enemy = enemy_resource.instance();
	var x = rand_range(-area_of_spawn.x, area_of_spawn.x);
	enemy.position = Vector2(x, 12);
	enemy.get_node("PathFollow2D/enemy").connect("killed", self, "spawn");
	add_child(enemy);
	if $Area2D/Timer.time_left == 0:
		if number_of_enemies >= 0 and number_of_enemies <= AMOUNT_OF_ENEMIES-1:
			$Area2D/Timer.start();
			pass
		pass
	pass
