shader_type canvas_item;

uniform vec3 blood_color = vec3(0.5, 0.05, 0.1);
uniform sampler2D vessel;
uniform float grey_intensity = 0.3;
uniform float chromatic_intensity = 0.005;
uniform float blur_base_radius = 15.0;

uniform float overall_intensity = 0.0;

float ranf(float time, float freq, float seed) {
	return fract(sin(time) * freq / seed);
}

// get intensity that is 1 on the border, 0 in the center
float get_base_intensity(vec2 uv) {
	vec2 new_UV = uv - vec2(0.5, 0.5);
	float d = sqrt(new_UV.x * new_UV.x + new_UV.y * new_UV.y);
	float intensity = clamp(pow(d, 3) * 2.0, 0.0, 1.0);
	return intensity;
}

vec4 shaked_chromatic_aberration(sampler2D tex, vec2 uv, float time, float amplitude) {
	float freq = 150.0;
	vec4 chromatic = vec4(
		texture(tex, vec2(uv + amplitude * 
			vec2(ranf(time, freq, 30f), ranf(time, freq, 100f)))).r,
		texture(tex, vec2(uv + amplitude *
			vec2(ranf(time, freq, 140f), ranf(time, freq, 60f)))).g,
		texture(tex, vec2(uv + amplitude *
			vec2(ranf(time, freq, 70f), ranf(time, freq, 50f)))).b,
		1.0
	);
	return chromatic;
}

vec4 blur_edge(sampler2D tex, vec2 uv, vec2 pixel_size, float intensity) {
	vec3 blur = vec3(0);
	float radius = blur_base_radius * pow(intensity, 0.33);
	blur += texture(tex, uv).rgb;
    blur += texture(tex, uv + vec2(0, -radius) * pixel_size).rgb;
    blur += texture(tex, uv + vec2(0, radius) * pixel_size).rgb;
    blur += texture(tex, uv + vec2(-radius, 0) * pixel_size).rgb;
    blur += texture(tex, uv + vec2(radius, 0) * pixel_size).rgb;
    blur /= 5.0;
	
	return vec4(blur, 1.0);
}

vec4 blood(float intensity, vec2 uv) {
	vec4 vessel_col = texture(vessel, uv);
	vec4 blood = vec4(intensity * blood_color.xyz * vessel_col.xyz * 1.5, 1.0);
	return blood;
}

vec4 grey_scale(vec4 input_col, float _grey_intensity) {
	float main_channel_i = 1.0 - _grey_intensity;
	float other_channel_i = (1.0 - main_channel_i) / 2.0;
	return vec4(
		input_col.r * main_channel_i + input_col.g * other_channel_i + input_col.b * other_channel_i,
		input_col.r * other_channel_i + input_col.g * main_channel_i + input_col.b * other_channel_i,
		input_col.r * other_channel_i + input_col.g * other_channel_i + input_col.b * main_channel_i,
		1.0
	);
}

void fragment() {
	float intensity = get_base_intensity(UV) * overall_intensity;
	float chromatic_amptitude = chromatic_intensity * overall_intensity;

	vec4 chromatic = shaked_chromatic_aberration(TEXTURE, UV, TIME, chromatic_amptitude);
	vec4 blur = blur_edge(TEXTURE, UV, TEXTURE_PIXEL_SIZE, intensity);
	vec4 blood = blood(intensity, UV);
	vec4 dark_edge = vec4(vec3(pow(1.0 - intensity, 3)), 1.0);
	
	vec4 base = vec4(chromatic.xyz * 0.5 + blur.xyz * 0.5, 1.0);
	vec4 greyed = grey_scale(base, grey_intensity * overall_intensity);

	COLOR = dark_edge * greyed + blood;
}
