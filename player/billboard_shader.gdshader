shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D tex : filter_nearest;

uniform vec4 albedo_color: source_color = vec4(1.0);
uniform float scale = 1.0;
uniform float size = 1.0;
uniform float rotation = 0.0;

void vertex(){
    mat4 modified_model_view = VIEW_MATRIX * mat4(
        INV_VIEW_MATRIX[0],
        INV_VIEW_MATRIX[1],
        INV_VIEW_MATRIX[2],
        MODEL_MATRIX[3] / (scale * size)
    );
	
	float rot = radians(rotation);
	
	modified_model_view[0][0] = cos(rot);
	modified_model_view[0][1] = -sin(rot);
	modified_model_view[1][0] = sin(rot);
	modified_model_view[1][1] = cos(rot);
	
    MODELVIEW_MATRIX = modified_model_view;
}

void fragment(){
	vec4 tex_samp = texture(tex,UV);
	ALBEDO = tex_samp.rgb*albedo_color.rgb;
	ALPHA = tex_samp.a*albedo_color.a;
}