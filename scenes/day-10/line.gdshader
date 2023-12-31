shader_type canvas_item;

uniform float progress = 0.0;
uniform vec2 tip;

uniform vec4 color_from : source_color;
uniform vec4 color_to : source_color;


void vertex() {
	// Called for every vertex the material is visible on.
	//if (VERTEX.y > 540.0) {
		VERTEX += vec2(sin(TIME * 0.5) * VERTEX.y, 0) * 0.5;
		
		// https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/canvas_item_shader.html#built-ins
		
	//}
}

void fragment() {
	// Called for every pixel the material is visible on.
	// vec4 in_tex = texture(TEXTURE, UV * TIME);
	// COLOR = in_tex;
	//COLOR = vec4(sin(TIME), cos(TIME), sin(TIME) * cos(TIME * 4.0), 1.0);

	vec4 base_line = vec4((1.0 - progress) * color_from + progress * color_to);

	COLOR = base_line;

	// COLOR = in_tex * 12.0;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
