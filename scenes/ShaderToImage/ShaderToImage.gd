# Source: https://github.com/bitsydoge/godot-shader-to-image/

extends Node2D

signal generated

#########################
# Internal
# Onready
@onready var ___drawer = $Renderer
@onready var ___shader_container = $SubViewport/Shader
@onready var ___viewport = $SubViewport

# ###
var ___generated_image

func get_image() -> Image:
	if ___generated_image != null:
		return ___generated_image
	else:
		printerr("No image generated, use generate_image() and wait for \"generated\" signal")
		return null

func generate_image(material : Material, resolution := Vector2(512,512), multiplier := 1.0, args := {}):
	# Resize generating nodes
	___viewport.size = resolution
	___viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	___shader_container.size = resolution
	
	# Set material type
	___shader_container.set_material(material)
	
	# Set shaders param
	___shader_container.get_material().set_shader_parameter("resolution", resolution*multiplier)
	for arg in args:
		___shader_container.get_material().set_shader_parameter(arg, args[arg])
	
	## Actually Generate Image
	___drawer.show()
	await get_tree().idle_frame
	await get_tree().idle_frame
	await get_tree().idle_frame
	___generated_image = ___drawer.get_texture().get_data().duplicate()
	false # ___generated_image.unlock() # TODOConverter40, Image no longer requires locking, `false` helps to not break one line if/else, so it can freely be removed
	emit_signal("generated")
	___viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
	___drawer.hide()
