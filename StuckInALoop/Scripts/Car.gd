extends VehicleBody

# EVENTS
signal engine_break

# PROPERTIES
export var steering_angle = deg2rad(15)
export var steering_reduction = 10
export var power_factor = 5000
export var max_rpm = 1000
export var break_factor = 50

# CONTROL VARIABLES
var engine_control = 0 # 0 = no power - 1 = full power
var steer_control = 0 # -1 = outerright - 1 = outerleft
var break_control = 0 # 0 = no break - 1 = full break

# MOTOR PROPERTIES
var rpm = 0

func _process(delta):
	rpm = ($left_back_wheel.get_rpm() + $right_back_wheel.get_rpm())/2
	$AudioStreamPlayer.pitch_scale = 0.8 + clamp(abs(rpm)/max_rpm*3.2, 0, 3.2)

func _integrate_forces(state):
	var forward_vel = state.linear_velocity.normalized().dot(transform.basis[2].normalized()) * state.linear_velocity.length()
	var force = 0
	if rpm < max_rpm:
		force = 1 - forward_vel/85
	engine_force = force * engine_control * power_factor
	steering = steer_control * steering_angle * clamp(steering_reduction/(1+abs(forward_vel)), 0.01, 1)
	brake = break_control * break_factor
	
