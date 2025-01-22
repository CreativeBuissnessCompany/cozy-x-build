extends CanvasLayer

@onready var holder: CenterContainer = %Holder
@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D
@onready var gpu_particles_2d_2: GPUParticles2D = %GPUParticles2D2





func turn_off_particles():
	gpu_particles_2d.emitting = false
	gpu_particles_2d_2.emitting = false

func turn_on_particles():
	gpu_particles_2d.emitting = true
	gpu_particles_2d_2.emitting = true
