uniform float time;

vec4 position(mat4 transform_projection, vec4 vertex_position) {
    return transform_projection * (vertex_position + vec4(time, time, time, time));
    // return transform_projection * (vertex_position);
}