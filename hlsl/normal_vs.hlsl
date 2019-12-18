struct Input
{
    float4 pos : position;
    float2 tex : texcoord0;
};

struct Output
{
    float4 pos : position;
    float2 tex : texcoord0;
};

Output main(Input input)
{
    Output output;
    
    input.pos.w = 1.0f;
    output.pos = input.pos;    
    // Flips texcoord y-value to align with tessellated mesh
    output.tex = float2(input.tex.x, 1 - input.tex.y);
    return output;
}