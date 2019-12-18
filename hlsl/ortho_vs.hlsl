cbuffer MatrixBuffer : register(b0)
{
    matrix world;
    matrix oView;
    matrix ortho;
}

struct Input
{
    float4 pos : position;
    float2 tex : texcoord0;
};

struct Output
{
    float4 pos : sv_position;
    float2 tex : texcoord0;
};

Output main(Input input)
{
    Output output;
    
    output.pos = mul(input.pos, world);
    output.pos = mul(output.pos, oView);
    output.pos = mul(output.pos, ortho);
    
    output.tex = input.tex;
    
    return output;
}