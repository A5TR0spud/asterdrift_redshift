shader_type canvas_item;

uniform float XSpeed = 0.01f;
uniform float YSpeed = 0.009f;
uniform float XOffset = 0.0f;
uniform float YOffset = 0.0f;

void fragment() {
	vec2 newUV = UV * 0.5f;
	newUV.x += 0.5f * cos(TIME * XSpeed + XOffset);
	newUV.y += 0.5f * sin(TIME * YSpeed + YOffset);
	COLOR = texture(TEXTURE, newUV);
}