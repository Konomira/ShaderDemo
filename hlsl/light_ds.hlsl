Texture2D hmap : register(t0);
SamplerState hSampler : register(s0);

cbuffer MatrixBuffer : register(b0)
{
    matrix world;
    matrix view;
    matrix proj;
    matrix lview;
    matrix lproj;
}

struct ConstantOutputType
{
    float edges[3] : SV_TessFactor;
    float inside : SV_InsideTessFactor;
};

struct Input
{
    float4 position : position;
    float2 tex : texcoord0;
};

struct Output
{
    float4 pos : sv_position;
    float2 tex : texcoord0;
    float4 lViewPos : texcoord1;
};

[domain("tri")]
Output main(ConstantOutputType input, float3 uvw : SV_DomainLocation, const OutputPatch<Input, 3> patch)
{
    Output output;
    
    // Linearly interpolate position and texcoord
    float3 vPos = uvw.x * patch[2].position + uvw.y * patch[1].position + uvw.z * patch[0].position;
    float2 tPos = uvw.x * patch[2].tex + uvw.y * patch[1].tex + uvw.z * patch[0].tex;
    
    
    output.pos = mul(float4(vPos, 1.0f), world);
    output.pos.y += hmap.SampleLevel(hSampler,tPos, 0).r * 20.0f;
    
    // Get position from light view
    output.lViewPos = mul(output.pos, lview);
    output.lViewPos = mul(output.lViewPos, lproj);
    
    output.pos = mul(output.pos, view);
    output.pos = mul(output.pos, proj);
    
    output.tex = tPos;
    
    return output;
}