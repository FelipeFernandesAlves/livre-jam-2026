shader_type canvas_item;

uniform bool active = true;
uniform float speed: hint_range(1.0, 100.0);

void fragment() {
	if (active) {
		COLOR.a *= abs(sin(TIME * speed));
	}
}
