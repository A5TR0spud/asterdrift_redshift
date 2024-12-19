shader_type canvas_item;

uniform vec4 color: source_color = vec4(1, 1, 1, 1);
uniform float threshold: hint_range(0.0, 0.5, 0.0001) = 0.25;

void fragment() {
	float dist = distance(UV, vec2(0.5, 0.5));
	if (dist > 0.5 || dist < threshold) {
		discard;
	}
	COLOR = color;
}
