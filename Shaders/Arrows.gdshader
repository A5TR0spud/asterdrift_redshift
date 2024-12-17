shader_type canvas_item;

uniform float Scalar1: hint_range(0.0, 1.0, 0.01) = 0.5f;
uniform float Scalar2 = 16.0f;
uniform float Scalar3 = 20.0f;

void fragment() {
	vec2 xy = vec2(textureSize(TEXTURE, 0));
	if (sin(Scalar1 * xy.x * abs(2.0f * UV.x - 1.0f) + Scalar2 * UV.y / (Scalar1 * xy.x) * xy.y - Scalar3 * TIME) > 0.0f) {
		discard;
	}
}