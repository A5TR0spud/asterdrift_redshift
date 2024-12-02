shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1, 1, 1, 1);

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	vec2 ps = TEXTURE_PIXEL_SIZE;
	if (col.a < 0.003) {
		if (texture(TEXTURE, UV + vec2(-1, -1) * ps).a > 0.003) {
			COLOR = outline_color;
		}
		else if (texture(TEXTURE, UV + vec2(-1, 0) * ps).a > 0.003) {
			COLOR = outline_color;
		}
		else if (texture(TEXTURE, UV + vec2(-1, 1) * ps).a > 0.003) {
			COLOR = outline_color;
		}
		else if (texture(TEXTURE, UV + vec2(0, -1) * ps).a > 0.003) {
			COLOR = outline_color;
		}
		else if (texture(TEXTURE, UV + vec2(0, 1) * ps).a > 0.003) {
			COLOR = outline_color;
		}
		else if (texture(TEXTURE, UV + vec2(1, -1) * ps).a > 0.003) {
			COLOR = outline_color;
		}
		else if (texture(TEXTURE, UV + vec2(1, 0) * ps).a > 0.003) {
			COLOR = outline_color;
		}
		else if (texture(TEXTURE, UV + vec2(1, 1) * ps).a > 0.003) {
			COLOR = outline_color;
		}
	}
}
