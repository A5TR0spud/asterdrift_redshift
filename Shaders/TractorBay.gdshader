shader_type canvas_item;

uniform vec4 Color: source_color = vec4(0.878, 0.541, 1.0, 0.5);
uniform float DistFade = 5.0;
uniform float TimeCoefficient = 5.0;
uniform float DistCoefficient = 60.0;
uniform float EdgeFadeout: hint_range(0.0, 1.0, 0.01) = 0.1;
uniform float Step: hint_range(0.0, 1.0, 0.01) = 0.4;
uniform float StepInfuence: hint_range(0.0, 1.0, 0.01) = 1.0;

void fragment() {
	vec2 localCoord = UV * 2.0 - vec2(1.0);
	float dist = length(localCoord);
	if (dist > 1.0) {
		discard;
	}
	dist *= 1.0 + EdgeFadeout;
	COLOR = Color;
	COLOR.a *= 0.5 * sin(TimeCoefficient * TIME + DistCoefficient * dist) + 0.5;
	float newA = (1.0 - step(COLOR.a, Step));
	
	COLOR.a = clamp(COLOR.a, 0.0, 1.0);
	COLOR.a = newA * StepInfuence + COLOR.a * (1.0 - StepInfuence);
	
		COLOR.a *= DistFade * dist - (DistFade - 1.0);
	if (dist > 1.0) {
		COLOR.a *= 1.0 - ((dist - EdgeFadeout) - (1.0 - EdgeFadeout)) / EdgeFadeout;
	}
}
