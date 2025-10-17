vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 texcolor = Texel(tex, texture_coords);
    vec4 pixelColor = texcolor * color;

    pixelColor.y = 0.0f;

    return pixelColor;
}