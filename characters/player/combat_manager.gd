extends RayCast2D

onready var audio_player = $AudioStreamPlayer
onready var stats_manager = get_parent().get_node("Inventory/Stats")
var fist_dmg = 10
var fist_speed = 0.4
var fist_hit_snd = "res://audio/weapons/punch.wav"
var fist_swing_snd = "res://audio/weapons/punch.wav"

var damage = fist_dmg
var atk_rate = fist_speed
var atk_radius = 0

var prep_sound = ""
var atk_sound = fist_swing_snd
var atk_hit_sound = fist_hit_snd
var prep_sound_time = 0
var ranged = false
var attack_type = "melee"
var played_prep = false

var time_since_atk = 0

#func _ready():
#	set_process_input(true)

func _process(delta):
	if Input.is_action_pressed("attack"):
		time_since_atk += delta
		attempt_attack()
	else:
		time_since_atk = 0
		
	
	if prep_sound != "" and !audio_player.playing and !played_prep:
		audio_player.stream = load(prep_sound)
		played_prep = true
		audio_player.play()

func unequip_wep():
	damage = fist_dmg
	atk_rate = fist_speed
	prep_sound = ""
	atk_sound = fist_swing_snd
	atk_hit_sound = fist_hit_snd
	ranged = false
	attack_type = "melee"
	prep_sound_time = 0

#pass dictionary from database
func equip_wep(var item_to_eq):
	damage = item_to_eq["damage"]
	atk_rate = item_to_eq["attack_rate"] / 10.0
	atk_sound = item_to_eq["sounds"]["swing"]
	atk_hit_sound = item_to_eq["sounds"]["hit"]
	prep_sound = item_to_eq["sounds"]["prep"]
	attack_type = item_to_eq["attack_type"]
	ranged = attack_type == "range" or attack_type == "magic"
	if attack_type == "range":
		damage += stats_manager.stats["ranged"]
	elif attack_type == "melee":
		damage += stats_manager.stats["melee"] 
	elif attack_type == "magic":
		damage += stats_manager.stats["magic"] 
		atk_radius = item_to_eq["attack_radius"]
	


func attempt_attack():
	if time_since_atk >= atk_rate:
		time_since_atk -= atk_rate
		var snd_to_play = atk_sound
		var coll = get_collider()
		if is_colliding() and coll.has_method("deal_damage"):
			var rn = global_position.distance_squared_to(coll.global_position)
			if ranged or rn < 32 * 32:
				if attack_type == "magic":
					area_damage(coll.global_position)
					#TODO: area affect for spells
				else:
					coll.deal_damage(damage)
				snd_to_play = atk_hit_sound
		audio_player.stream = load(snd_to_play)
		audio_player.play()
		played_prep = false

func area_damage(var hit_pos):
	pass