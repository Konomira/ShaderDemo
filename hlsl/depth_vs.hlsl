Texture2D hmap : register(t0);
SamplerState hSampler : register(s0);

cbuffer MatrixBuffer : register(b0)
{
    matrix world;
    matrix view;
    matrix proj;
}

struct Input
{
    float4 pos : position;
    float2 tex : texcoord0;
};

struct Output
{
    float4 pos : sv_position;
    float depth : texcoord0;
};

Output main(Input input)
{
    Output output;
    
    input.pos.w = 1.0f;
    output.pos = input.pos;
    
    // Manipulate height based on heightmap data
    output.pos.y += hmap.SampleLevel(hSampler, float2(input.tex.x,1-input.tex.y), 0).r * 20.0f;
    
    output.pos = mul(output.pos, world);
    output.pos = mul(output.pos, view);
    output.pos = mul(output.pos, proj);
    // Depth value is homogeneous
    output.depth = output.pos.z / output.pos.w;

    return output;
}