struct Input
{
    float4 pos : position;
    float4 tex : color;
};

struct Output
{
    float3 pos : position;
    float4 tex : color;
};

Output main(Input input)
{
    
    Output output;
    output.pos = input.pos.xyz;
    output.tex = input.tex;
    
    return output;
}