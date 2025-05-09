RSRC                    VisualShader            ���Y��X                                            B      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    linked_parent_graph_frame    source    texture    texture_type    script    input_name    op_type 	   operator 	   function    parameter_name 
   qualifier    default_value_enabled    default_value    hint    min    max    step    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    flags/world_vertex_coords    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/12/node    nodes/fragment/12/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections     	   &   local://VisualShaderNodeTexture_vgmfj d      $   local://VisualShaderNodeInput_wesjj �      '   local://VisualShaderNodeVectorOp_456hi �      (   local://VisualShaderNodeFloatFunc_3cl4w �      '   local://VisualShaderNodeVectorOp_7f6a7 1	      '   local://VisualShaderNodeVectorOp_uoows f	      +   local://VisualShaderNodeColorUniform_jx7il �	      +   local://VisualShaderNodeFloatUniform_fi245 �	      '   res://shaders/color_replace_shader.res D
         VisualShaderNodeTexture             	         VisualShaderNodeInput    
         texture 	         VisualShaderNodeVectorOp    	         VisualShaderNodeFloatFunc             	         VisualShaderNodeVectorOp             	         VisualShaderNodeVectorOp             	         VisualShaderNodeColorParameter             replaceColor          	         VisualShaderNodeFloatParameter             replaceAmount          	         VisualShader          �  shader_type canvas_item;
render_mode blend_mix;

uniform float replaceAmount : hint_range(0.0, 1.0);
uniform vec4 replaceColor : source_color = vec4(1.000000, 1.000000, 1.000000, 1.000000);



void fragment() {
	vec4 n_out4p0;
// Texture2D:4
	n_out4p0 = texture(TEXTURE, UV);


// FloatParameter:12
	float n_out12p0 = replaceAmount;


// FloatFunc:8
	float n_out8p0 = 1.0 - n_out12p0;


// VectorOp:10
	vec3 n_out10p0 = vec3(n_out4p0.xyz) * vec3(n_out8p0);


// ColorParameter:11
	vec4 n_out11p0 = replaceColor;


// VectorOp:9
	vec3 n_out9p0 = vec3(n_out12p0) * vec3(n_out11p0.xyz);


// VectorOp:6
	vec3 n_out6p0 = n_out10p0 + n_out9p0;


// Output:0
	COLOR.rgb = n_out6p0;


}
                    !             "   
     ��  p�#            $   
     ��   B%            &   
         \C'            (   
     4�  �C)            *   
     ��  D+            ,   
     ��  HC-            .   
     M�  HD/            0   
   \����4D1       $                	                                   
       
                     
                           	              	      	      RSRC