RSRC                    ShaderMaterial            ˙˙˙˙˙˙˙˙                                                  resource_local_to_scene    resource_name    code    script    render_priority 
   next_pass    shader    shader_parameter/albedo    shader_parameter/point_size    shader_parameter/roughness *   shader_parameter/metallic_texture_channel    shader_parameter/specular    shader_parameter/metallic %   shader_parameter/uv1_blend_sharpness    shader_parameter/uv1_scale    shader_parameter/uv1_offset    shader_parameter/uv2_scale    shader_parameter/uv2_offset     shader_parameter/texture_albedo "   shader_parameter/texture_metallic #   shader_parameter/texture_roughness    
   Texture2D    res://textures/grid.jpg áŮűKi      local://Shader_cwof1 ?         local://ShaderMaterial_ipjso          Shader          <	  // NOTE: Shader automatically converted from Godot Engine 4.1.dev4's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform float point_size : hint_range(0,128);
uniform float roughness : hint_range(0,1);
uniform sampler2D texture_metallic : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float specular;
uniform float metallic;
varying vec3 uv1_triplanar_pos;
uniform float uv1_blend_sharpness;
varying vec3 uv1_power_normal;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;


void vertex() {
	TANGENT = vec3(0.0,0.0,-1.0) * abs(NORMAL.x);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(NORMAL.y);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(NORMAL.z);
	TANGENT = normalize(TANGENT);
	BINORMAL = vec3(0.0,1.0,0.0) * abs(NORMAL.x);
	BINORMAL+= vec3(0.0,0.0,-1.0) * abs(NORMAL.y);
	BINORMAL+= vec3(0.0,1.0,0.0) * abs(NORMAL.z);
	BINORMAL = normalize(BINORMAL);
	uv1_power_normal=pow(abs(NORMAL),vec3(uv1_blend_sharpness));
	uv1_triplanar_pos = VERTEX * uv1_scale + uv1_offset;
	uv1_power_normal/=dot(uv1_power_normal,vec3(1.0));
	uv1_triplanar_pos *= vec3(1.0,-1.0, 1.0);
}

vec4 triplanar_texture(sampler2D p_sampler,vec3 p_weights,vec3 p_triplanar_pos) {
	vec4 samp=vec4(0.0);
	samp+= texture(p_sampler,p_triplanar_pos.xy) * p_weights.z;
	samp+= texture(p_sampler,p_triplanar_pos.xz) * p_weights.y;
	samp+= texture(p_sampler,p_triplanar_pos.zy * vec2(-1.0,1.0)) * p_weights.x;
	return samp;
}

void fragment() {
	vec4 albedo_tex = triplanar_texture(texture_albedo,uv1_power_normal,uv1_triplanar_pos);
	ALBEDO = (albedo.rgb * albedo_tex.r) + albedo_tex.g + albedo_tex.b;
	float metallic_tex = dot(triplanar_texture(texture_metallic,uv1_power_normal,uv1_triplanar_pos),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	vec4 roughness_texture_channel = vec4(1.0,0.0,0.0,0.0);
	float roughness_tex = dot(triplanar_texture(texture_roughness,uv1_power_normal,uv1_triplanar_pos),roughness_texture_channel);
	ROUGHNESS = (1.0 - albedo_tex.g) * roughness;
	SPECULAR = specular;
}
          ShaderMaterial                                                         ?        ?	         ?
               ?                  ?         ?   ?   ?                          ?  ?  ?                                                        RSRC