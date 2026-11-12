shader_type canvas_item;
uniform float intensidad : hint_range(0.0, 5.0, 0.1) = 2.0;

void fragment() {
	vec2 paso = TEXTURE_PIXEL_SIZE * intensidad;
	vec4 color = texture(TEXTURE, UV) * 0.20;
	color += texture(TEXTURE, UV + vec2(paso.x, 0.0)) * 0.12;
	color += texture(TEXTURE, UV - vec2(paso.x, 0.0)) * 0.12;
	color += texture(TEXTURE, UV + vec2(0.0, paso.y)) * 0.12;
	color += texture(TEXTURE, UV - vec2(0.0, paso.y)) * 0.12;
	color += texture(TEXTURE, UV + paso) * 0.08;
	color += texture(TEXTURE, UV - paso) * 0.08;
	color += texture(TEXTURE, UV + vec2(paso.x, -paso.y)) * 0.08;
	color += texture(TEXTURE, UV + vec2(-paso.x, paso.y)) * 0.08;
	COLOR = color;
}