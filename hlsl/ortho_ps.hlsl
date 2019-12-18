Texture2D t0 : register(t0);
SamplerState tSampler : register(s0);

cbuffer AberrationBuffer : register(b0)
{
    float4 amount;
}

struct Input
{
    float4 pos : sv_position;
    float2 tex : texcoord0;
};

float4 main(Input input) : sv_target
{
    float4 colour = t0.Sample(tSampler, input.tex);
    // Distance from center of the screen
    float2 dist = (input.tex - float2(0.5, 0.5)) * amount.x;
    // Offsets each channel in a separate direction based on the distance
    colour.r = t0.Sample(tSampler, input.tex - float2(dist.x, dist.y) * 1.9f).r;
    colour.g = t0.Sample(tSampler, input.tex - float2(dist.x, dist.y)*1.5f).g;
    colour.b = t0.Sample(tSampler, input.tex - float2(dist.x,dist.y)*1.1f).b;
    return colour;
}