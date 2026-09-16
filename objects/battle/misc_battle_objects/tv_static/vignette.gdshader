shader_type canvas_item;

uniform float base_alpha : hint_range(0,1) = 1.0f;
uniform float alpha_high : hint_range(0,1) = 0.5f;
uniform float alpha_low : hint_range(0,1) = 0.0f;

void fragment(){
	float dist = distance(vec2(0.5, 0.5), UV);
	COLOR.a = smoothstep(alpha_low, alpha_high, dist);
	COLOR.a *= base_alpha;

}

