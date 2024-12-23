shader_type canvas_item;

uniform float TIME_COEFFICIENT = -0.1;
uniform float ANGLE_STEP = 0.5;
uniform float PULSE_COEFFICIENT = 0.0;
uniform float PULSE_TIME_COEFFICIENT = 1.0;
uniform float PULSE_DIST_COEFFICIENT = 5.0;
uniform float PULSE_GROW_COEFFICIENT = 5.0;

float badMod(float v, float i) {
	v = abs(v);
	while (v > i) {
		v -= i;
	}
	return v / i;
}

void fragment() {
	vec2 localCoord = UV * 2.0 - 1.0;
	float dist = length(localCoord);
	if (dist > 1.0) {
		discard;
	}
	float angle = atan(localCoord.y, localCoord.x) * 0.159154570919;
	angle += 0.1 * PULSE_COEFFICIENT * sin(-PULSE_GROW_COEFFICIENT * TIME + dist * PULSE_DIST_COEFFICIENT + cos(TIME * PULSE_TIME_COEFFICIENT));
	angle += 0.5 * dist;
	float a = badMod(angle + 0.5 + TIME * TIME_COEFFICIENT, ANGLE_STEP);
	a -= dist;
	
	a = sign(a);
	a = clamp(a, 0.0, 1.0);
	COLOR.a = a;
}
