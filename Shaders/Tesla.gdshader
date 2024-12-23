shader_type canvas_item;

float badMod(float v, float i) {
	while (v < 0.0) {
		v += i;
	}
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
	float a = 1.0;
	a = angle + 0.5;
	float dif = badMod(a - TIME * 0.1, 1.0);
	float angledA = max(dif, 1.0 - dif) * 2.0 - 1.0;
	a = angledA;
	float timeVariance = badMod(TIME, 1.0);
	a *= abs(dist - 0.5) * (2.0 - angledA) + angledA;
	a *= dist * 0.5 + 0.5;
	a -= dist;
	a *= 2.0;
	a -= 1.0 - dist;
	a *= 2.0;
	COLOR.a = a;
}