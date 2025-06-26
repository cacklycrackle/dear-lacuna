shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
uniform vec2 player_pos;             // Player global position, in pixels
uniform float radius = 50.0;        // Max radius of vision, in pixels
uniform float ratio = 0.7;           // Ratio of pixels within radius where fading vision begins
uniform float darkness_factor = 0.9; // Amount of darkening for colour outside vision


void fragment() {
	// Called for every pixel the material is visible on.
	vec2 pixel_pos = SCREEN_UV * (1.0 / SCREEN_PIXEL_SIZE);
	float dist = distance(pixel_pos, player_pos);
	float fade_start = radius * ratio;
	
	float fade_value = smoothstep(fade_start, radius, dist);
	float darkness_multiplier = 1.0 - (darkness_factor * fade_value);
	darkness_multiplier = max(0.0, darkness_multiplier);
	
	vec4 bg_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	bg_color.rgb *= darkness_multiplier;
	vec4 overlay_color = vec4(0.0, 0.0, 0.0, fade_value);
	COLOR = mix(bg_color, overlay_color, overlay_color.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
