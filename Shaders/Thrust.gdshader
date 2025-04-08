shader_type canvas_item;

uniform float TIME_COEFFICIENT = 32.0;
uniform float DIST_COEFFICIENT = 16.0;
uniform vec4 FLAME_COLOR: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 FADE_COLOR: source_color = vec4(1.0, 0.353, 0.796, 0.0);
uniform float STEP: hint_range(0.0, 1.0, 0.01) = 0.1;
uniform float STEP_INFLUENCE: hint_range(0.0, 1.0, 0.01) = 0.5;

void fragment() {
	//if (abs(2.0f * UV.x - 1.0f) + UV.y > 1.0f) {
		//discard;
	//}

	float a = 1.0;

	a = 0.875 + 0.125 * sin(UV.y * DIST_COEFFICIENT - TIME_COEFFICIENT * TIME);
	a *= sin(UV.x * 3.14159265);
	a *= 1.2 - abs(2.0f * UV.x - 1.0f) - UV.y;

	a = clamp(a, 0, 1);
	a = STEP_INFLUENCE * step(STEP, a) + (1.0 - STEP_INFLUENCE) * a;
	if (a < 0.75 && a > 0.25) {
		a = 0.5;
	}
	COLOR *= a * FLAME_COLOR + (1.0 - a) * FADE_COLOR;
}