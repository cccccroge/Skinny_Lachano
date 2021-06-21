shader_type canvas_item;

uniform vec3 effect_col = vec3(0.5, 0.05, 0.1);

void fragment() {
	vec2 new_UV = UV - vec2(0.5, 0.5);
	float d = sqrt(new_UV.x * new_UV.x + new_UV.y * new_UV.y);
	float intensity = clamp(pow(d, 3) * 2.0, 0.0, 1.0);
	
	vec4 base = texture(TEXTURE, UV);
	vec4 chromatic_aberration = vec4(
		texture(TEXTURE, vec2(UV.x + 0.005, UV.y)).r,
		texture(TEXTURE, UV).g,
		texture(TEXTURE, vec2(UV.x - 0.005, UV.y)).b,
		1.0
	);
	vec4 dark_edge = vec4(chromatic_aberration.xyz * pow(1.0 - intensity, 3), 1.0);
	
	vec4 blood = vec4(intensity * effect_col, 0.0);
	
	COLOR = dark_edge + blood;
}