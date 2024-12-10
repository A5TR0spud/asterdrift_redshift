shader_type canvas_item;


uniform vec4 ring_color: source_color = vec4(1.0);
uniform float ring_frequency = 50.0;
/** Portion of the visible rings. Negative values give wider rings, positive values give narrower rings*/
uniform float ring_portion: hint_range(-0.99, 0.99, 0.01) = 0.0;
/** Negative values move the rings outwards, positive value move the rings inwards */
uniform float move_speed = -10.0;
uniform bool smooth_edge = false;


void fragment() {
    float dist = distance(UV, vec2(0.5, 0.5));
    float rings = sin(dist * ring_frequency + (TIME * move_speed));
    rings = step(ring_portion, rings);
    float blend_alpha = smoothstep(0.5, 0.4, dist);
    bool is_rings = (rings > 0.0) && bool(1 - int(dist > 0.5 || rings < 1.0));
    COLOR = float(is_rings) * vec4(ring_color.xyz, smooth_edge ? blend_alpha * ring_color.a : ring_color.a);
}