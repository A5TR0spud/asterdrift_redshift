shader_type canvas_item;

uniform float TIME_COEFFICIENT = 5.0;
uniform float TIME_OFFSET: hint_range(0.0, 5.0, 0.01) = 0.0;
uniform vec4 GLOW_COLOR: source_color = vec4(0.6, 0.3, 1.0, 1.0);
uniform vec4 LIGHTNING_COLOR: source_color = vec4(0.8, 1.0, 1.0, 1.0);

float badMod(float v, float i) {
	while (v < 0.0) {
		v += i;
	}
	while (v > i) {
		v -= i;
	}
	return v / i;
}

vec2 rotate(vec2 input, float angle) {
	float x = input.x;
	float y = input.y;
	float cs = cos(angle);
	float sn = sin(angle);

	input.x = cs * x - sn * y;
	input.y = sn * x + cs * y;

	return input;
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
	float ttt = (TIME_OFFSET + TIME) * TIME_COEFFICIENT;
	float t = floor(ttt);
	float tt = floor(TIME);
	float timeVariance = badMod(ttt, 1.0);
	float targetAngle = sin(t * 2.12934151) + 1.0 + 2.0 * sin(0.977771 * t + 5.0);
	targetAngle += cos(t * 10.123123123);
	targetAngle += TIME_OFFSET * tt;
	targetAngle += 390.0 * tt * TIME_OFFSET;
	targetAngle = badMod(targetAngle, 1.0);
	//targetAngle = TIME * 0.1;
	float dif = badMod(a - targetAngle, 1.0);
	float angledA = max(dif, 1.0 - dif) * 2.0 - 1.0;
	a = angledA;
	a *= abs(dist - 0.5) * (2.0 - angledA) + angledA;
	a *= dist * 0.5 + 0.5;
	a -= dist;
	a *= 2.0;
	a -= 1.0 - dist;
	a *= 2.0;
	a *= 1.0 - timeVariance;

	float tar = 0.1;
	vec2 angledCoord = rotate(localCoord, -targetAngle * 3.14159265 * 2.0);
	a = clamp(a * 0.5, 0.0, 1.0);
	COLOR.rgb = GLOW_COLOR.rgb;
	if (angledCoord.x < 0.0) {
		float zed = 0.01 * sin(angledCoord.x * 50.0 + 5.0 * ttt);
		zed += 0.1 * sin(angledCoord.x * 10.0 + 2.0 * ttt);
		zed += 0.2 * sin(angledCoord.x * 10.0 + 1.0 * ttt);
		zed += 0.01 * sin(angledCoord.x * 100.0 + 5.0 * ttt);
		zed += 0.3 * sin(angledCoord.x * 1.0 + 2.0 * ttt);
		zed += 0.15 * sin(angledCoord.x * 3.0 - 5.0 * ttt);
		zed *= 0.1;
		if (abs(zed - angledCoord.y) < 0.01) {
			COLOR = LIGHTNING_COLOR + GLOW_COLOR * a;
			a = COLOR.a * 1.0 - timeVariance;
		}
	}
	COLOR.a = a;
}