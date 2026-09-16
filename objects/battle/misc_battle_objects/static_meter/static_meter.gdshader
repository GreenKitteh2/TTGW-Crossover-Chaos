shader_type canvas_item;
render_mode unshaded;

uniform float ratio : hint_range(0,1) = 0.8;
uniform sampler2D meter_tex;
uniform float wave_speed : hint_range(0.01,10.0) = 5.0;
uniform float wave_period : hint_range(0.1,10) = 2.0;
uniform float wave_amplitude : hint_range(0,0.35) = 0.025;

void fragment()
{
	// construct sinewave value that varies horizontally based on speed and period
	float sin_wave = sin( ( TIME + ( UV.x / wave_period ) ) * wave_speed );
	// normalise to 0..1
	float scaled_sin_wave = (sin_wave * 0.5) + 0.5;
	// value to smoothly lower the amplitude near the full and empty health levels
	float wave_amp_scale = min( smoothstep(1.0, 1.0-wave_amplitude, ratio),  smoothstep(0.0, wave_amplitude*2.0, ratio) );
	// compute the wave testing value
	float wave_test_val = ratio - scaled_sin_wave * wave_amplitude * wave_amp_scale ;
	// test it against the fragment y value
	float wave = (1.0-UV.y) < wave_test_val ? 1.0 : 0.0;

	// output
	COLOR.rgba = texture(meter_tex,UV);
	COLOR.a = wave;
	texture(meter_tex,vec2(0,0));

}