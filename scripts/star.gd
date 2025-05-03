class_name Star extends TextureRect

@export var from_center = true
@export var time = 0.1
@export var transition_type = Tween.TransitionType.TRANS_SPRING
@export var scale_up_to = 1.5

@export var button: bool = false : set = animate_star

var default_transform : Transform2D

var ON_STAR_TEXTURE : AtlasTexture = preload("res://assets/star_on.tres")
var OFF_STAR_TEXTURE : AtlasTexture = preload("res://assets/star_off.tres")


func animate_star(_a : bool) -> void:
# Changes the star texture from black to gold and
# adds an animation to scale up the star with a bounce using Tween.
	if not is_inside_tree():
		return
	if _a == false:
		self.texture = OFF_STAR_TEXTURE
		self.scale = default_transform.get_scale()
		return
	self.texture = ON_STAR_TEXTURE
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(scale_up_to, scale_up_to), time).set_trans(transition_type)
	#tween.tween_property($TextureRect, "modulate", Color(1, 1, 0), time).set_trans(Tween.TRANS_BOUNCE)
	
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_transform = self.get_transform()
	self.texture = OFF_STAR_TEXTURE
	if from_center:
		pivot_offset = size / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
