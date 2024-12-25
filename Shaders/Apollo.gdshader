shader_type canvas_item;

uniform vec4 Color1: source_color = vec4(1.0, 1.0, 0.5, 1.0);
uniform vec4 Color2: source_color = vec4(1.0, 0.0, 0.0, 0.0);
uniform float coronaPercent: hint_range(0.0, 1.0, 0.000001) = 0.0625;
uniform float coronaPercentPulse: hint_range(0.0, 1.0, 0.000001) = 0.025;
uniform float coronaPercentPulseSpeed = 1.0;
uniform int coronaCount: hint_range(2, 100, 1) = 50;
uniform float coronaSpeed = 0.3;
uniform float minAlpha: hint_range(0.0, 1.0, 0.00390625) = 0.543;
uniform float distCoefficient = 18.0;
uniform float timeCoefficient = 2.0;
uniform float distFade: hint_range(0.0, 1.0, 0.00390625) = 0.5;
uniform float rotationCoefficient: hint_range(0.0, 1.0, 0.00390625) = 0.125;
uniform float rotationSpeed = 2.0;
uniform float rotationPulse = 5.0;

float badMod(float v, float i) {
	v = abs(v);
	while (v > i) {
		v -= i;
	}
	return v / i;
}


void fragment() {
	vec2 localCoord = 2.0 * (UV - 0.5);
	float trueDist = length(localCoord);
	float rnCoronaPercent = coronaPercent + coronaPercentPulse * sin(coronaPercentPulseSpeed * TIME);
	float dist = trueDist + rnCoronaPercent;
	float coronaDist = (trueDist - (1.0 - rnCoronaPercent)) / rnCoronaPercent;
	if (trueDist > 1.0) {
		discard;
	}
	float variance = minAlpha + (1.0 - minAlpha) * (0.5 + 0.5 * sin(distCoefficient * dist - timeCoefficient * TIME));
	variance *= clamp(dist / distFade - 1.0, 0.0, 1.0);

	vec2 tanner = atan(localCoord);
	tanner = vec2(tanner.x * cos(rotationSpeed * TIME) + tanner.y * sin(rotationSpeed * TIME));
	float rotPulse = 0.5 + 0.5 * sin(rotationPulse * TIME);

	variance += tanner.x * rotationCoefficient * rotPulse;
	variance += tanner.y * rotationCoefficient * rotPulse;

	if (coronaDist >= 0.0) {
		variance *= 1.0 - coronaDist;
		float angle = atan(localCoord.y, localCoord.x) * 0.159154570919;
		angle -= TIME * coronaSpeed;
		float moddedAngle = badMod(angle + 1.0, 1.0 / float(coronaCount));
		float d = 2.0 * abs(moddedAngle - 0.5) + coronaDist;
		if (d > 1.0) {
			variance = 0.0;
		}
	}

	variance = clamp(variance, 0.0, 1.0);
	COLOR *= (variance) * Color1 + (1.0 - variance) * Color2;
}
