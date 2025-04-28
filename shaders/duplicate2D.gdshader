shader_type canvas_item;

uniform float offset_scale = 16.0;  // 控制偏移距离
uniform int copy_count : hint_range(1, 4, 1) = 4;  // 控制复制数量，范围1-4

void fragment() {
    vec2 offsets[4] = {
        vec2(0.0, 0.0),      // 原位置
        vec2(1.0, 0.5),      // 右上
        vec2(-1.0, 0.5),     // 左上
        vec2(0.0, 1.0)       // 正上
    };

    vec4 final_color = vec4(0.0, 0.0, 0.0, 0.0);

    // 根据copy_count控制复制数量
    for(int i = 0; i < copy_count; i++) {
        vec2 offset_uv = UV - offsets[i] * offset_scale / vec2(textureSize(TEXTURE, 0));
        if(offset_uv.x >= 0.0 && offset_uv.x <= 1.0 && offset_uv.y >= 0.0 && offset_uv.y <= 1.0) {
            vec4 sample_color = texture(TEXTURE, offset_uv);
            if(sample_color.a > 0.0) {
                final_color = sample_color;
            }
        }
    }

    COLOR = final_color;
}