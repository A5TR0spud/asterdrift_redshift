shader_type canvas_item;

uniform float TIME_COEFFICIENT = 1.0;
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

void fragment() {
	vec2 localCoord = UV * 2.0 - 1.0;
	float dist = length(localCoord);
	if (dist > 1.0) { 
		discard;
	}
	float angle = atan(localCoord.y, localCoord.x) * 0.159154570919;
	float a = 1.0;
	a = angle + 0.5;
	float timeCoef = TIME_COEFFICIENT;
	float t = floor(TIME * timeCoef);
	float targetAngle = sin(t) + 1.0 + 2.0 * sin(0.9 * t + 5.0);
	float dif = badMod(a - targetAngle, 1.0);
	float angledA = max(dif, 1.0 - dif) * 2.0 - 1.0;
	a = angledA;
	float timeVariance = badMod(TIME * timeCoef, 1.0);
	a *= abs(dist - 0.5) * (2.0 - angledA) + angledA;
	a *= dist * 0.5 + 0.5;
	a -= dist;
	a *= 2.0;
	a -= 1.0 - dist;
	a *= 2.0;
	a *= 1.0 - timeVariance;
	COLOR = GLOW_COLOR;
	
	COLOR.a *= a;
	
	float angledPolarX = dist * sin(angledA * 3.14159265);
	float angledPolarY = dist * cos(angledA * 3.14159265);
	//angledPolarX += 0.1 * sin(angledPolarY * 10.0);
	vec2 angledPolarCoord = vec2(angledPolarX, angledPolarY);
	float tar = 0.4;
	angledPolarCoord = vec2(localCoord.x * tar + localCoord.y * (1.0 - tar), localCoord.y * badMod(tar + badMod(TIME, 5.0), 1.0) + localCoord.x * badMod(1.0 - tar + badMod(TIME, 5.0), 1.0));
	COLOR.xy = angledPolarCoord;
	COLOR.z = 0.0;
	COLOR.a = 1.0;
	if (angledPolarX > 0.9 && angledPolarY < 0.0) {
		//COLOR = LIGHTNING_COLOR;
		//COLOR.a *= 1.0 - timeVariance;
	}
}