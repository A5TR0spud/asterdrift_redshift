shader_type canvas_item;

void fragment() {
	if (abs(2.0f * UV.x - 1.0f) + UV.y > 1.0f) {
		discard;
	}
}