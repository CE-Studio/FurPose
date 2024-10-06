extends Pickable

var brightness:float:
	get:
		return $DirectionalLight3D.light_energy
	set(value):
		brightness = value
		$DirectionalLight3D.light_energy = value
