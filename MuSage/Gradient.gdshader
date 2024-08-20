shader_type canvas_item;

uniform vec4 topleft:source_color;
uniform vec4 topright:source_color;
uniform vec4 bottomleft:source_color;
uniform vec4 bottomright:source_color;

void fragment() {
	vec4 top = mix(topleft, topright, UV.x);
	vec4 bottom = mix(bottomleft, bottomright, UV.x);
	COLOR =  mix(top, bottom, UV.y);
}
