shader_type canvas_item;

uniform vec4 source_main : source_color;
uniform vec4 source_accent : source_color;

uniform vec4 main : source_color;
uniform vec4 accent : source_color;

void vertex() {
}

void fragment() {
	float dist_to_main = length(source_main - COLOR);
	float dist_to_accent = length(source_accent - COLOR);
	if (dist_to_main < 0.01) {
		COLOR = main;
	}
	if (dist_to_accent < 0.01) {
		COLOR = accent;
	}
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
