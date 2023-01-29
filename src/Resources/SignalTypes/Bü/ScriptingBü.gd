extends Spatial

onready var signal_logic: Node = get_parent()
onready var world: Node = find_parent("World")
onready var mat = SpatialMaterial.new()


var lightUp = true #Whether the light is currently getting brighter while flashing
var blinking = true #Whether the signal is showing Bü1

func _ready() -> void:
	mat.albedo_color = Color(0,0,0)
	mat.emission_enabled = true
	mat.emission = Color(1,1,1)
	mat.emission_operator = SpatialMaterial.EMISSION_OP_ADD
	$MeshInstance/White.set_surface_material(0,mat)
	# force the signal to be a main signal
	signal_logic.signal_type = signal_logic.SignalType.PRESIGNAL
	update_visual_instance(signal_logic)


func _process(delta):
	if blinking:
		if lightUp:
			mat.emission_energy = move_toward(mat.emission_energy,1,delta)
			if mat.emission_energy == 1:
				lightUp = false
		else:
			mat.emission_energy = move_toward(mat.emission_energy,0,delta)
			if mat.emission_energy == 0:
				lightUp = true
		$MeshInstance/White.set_surface_material(0,mat)

# this is a sort of Presignal, it CANNOT be red!
func update_visual_instance(instance: Node) -> void:
	match instance.status:
		SignalStatus.ORANGE: orange()
		SignalStatus.GREEN: green()


func green() -> void: #Signal Bü 1
	blinking = true


func orange() -> void: #Signal Bü 0
	blinking = false
	mat.emission_energy = 0
	$MeshInstance/White.set_surface_material(0,mat)
