shader_type canvas_item;

uniform vec4 Color1: source_color = vec4(1.0, 1.0, 0.5, 1.0);
uniform vec4 Color2: source_color = vec4(1.0, 0.0, 0.0, 0.0);
uniform float minAlpha: hint_range(0.0, 1.0, 0.00390625) = 0.543;
uniform float distCoefficient = 18.0;
uniform float timeCoefficient = 2.0;
uniform float distFade: hint_range(0.0, 1.0, 0.00390625) = 0.5;
uniform float rotationCoefficient: hint_range(0.0, 1.0, 0.00390625) = 0.125;
uniform float rotationSpeed = 2.0;
uniform float rotationPulse = 5.0;

void fragment() {
	vec2 localCoord = 2.0 * (UV - 0.5);
	float dist = length(localCoord);
	if (dist > 1.0) {
		discard;
	}
	float variance = minAlpha + (1.0 - minAlpha) * (0.5 + 0.5 * sin(distCoefficient * dist - timeCoefficient * TIME));
	variance *= clamp(dist / distFade - 1.0, 0.0, 1.0);
	
	vec2 tanner = atan(localCoord);
	tanner = vec2(tanner.x * cos(rotationSpeed * TIME) + tanner.y * sin(rotationSpeed * TIME));
	float rotPulse = 0.5 + 0.5 * sin(rotationPulse * TIME);
	
	variance += tanner.x * rotationCoefficient * rotPulse;
	variance += tanner.y * rotationCoefficient * rotPulse;
	
	variance = clamp(variance, 0.0, 1.0);
	COLOR *= (variance) * Color1 + (1.0 - variance) * Color2;
}

