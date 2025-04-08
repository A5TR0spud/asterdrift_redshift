shader_type canvas_item;

uniform vec4 Color1: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 Color2: source_color = vec4(1.0, 0.0, 0.0, 0.0);
uniform float threshold = 1.0;
uniform float distFadeOffset = 4.0;
uniform float distFadePerLayer = 0.2;
uniform int layers: hint_range(1, 256, 1) = 4;
uniform float seedOffset = 0;
uniform float speed = 1.0;
uniform float lenCoef = 1.0;
uniform float sharpness: hint_range(0.0, 27.0, 0.001) = 7.07106781187;

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

float rand(int seed) {
	float s = float(seed) + seedOffset;
	//s *= 308912.084245;
	float r = sin(s) + cos(s * 0.1) + cos(s * 10.0);
	r += 0.7265 * cos(s * 1028.0);
	r = badMod(r, 1.0);
	return r;
}

float flareFromRot(vec2 rotCoord) {
	float a = 1.0;
	float n = sharpness * sharpness;
	float z = pow(abs(rotCoord.x) - 1.0, 2.0) / (n * abs(rotCoord.x) + 1.0);
	a *= z;
	a *= 2.0;
	return a;
}

void fragment() {
	vec2 localCoord = UV * 2.0 - 1.0;
	float dist = length(localCoord);
	if (dist > 1.0) {
		discard;
	}
	float a = threshold - dist * (distFadeOffset / float(layers) + distFadePerLayer) * float(layers);
	for (int i = 0; i < layers; i++) {
		float a1 = lenCoef * (rand(i) * 1.3 + 0.2);
		float a2 = (rand(i + layers) - 0.5) * 2.5;
		float a3 = rand(i + layers * 2) * 3.14159265;
		float a4 = (rand(i + layers * 3) - 0.5) * 1.8 + 0.1;
		float a5 = rand(i - layers * 2) * 3.14159265;
		a += a1 * flareFromRot(rotate(localCoord, speed * TIME * a2 + a3)) * (0.5 + sin(speed * TIME * a4 + a5) * 0.5);
	}

	a = clamp(a, 0.0, 1.0);

	COLOR *= a * Color1 + (1.0 - a) * Color2;
}
