Texture2D hmap : register(t0);
SamplerState hSampler : register(s0);

Texture2D dmap : register(t1);
SamplerState dSampler : register(s1);

Texture2D tmap : register(t2);
SamplerState tSampler : register(s2);


cbuffer LightBuffer : register(b0)
{
    float4 ambient;
    float4 diffuse;
    float4 specular;
    float4 position;
    float4 direction;
}

struct Input
{
    float4 pos : sv_position;
    float2 tex : texcoord0;
    float4 lViewPos : texcoord1;
};

float4 calculateLighting(float3 normal)
{
    float intensity = saturate(dot(normal, direction.xyz));
    float4 colour = saturate((diffuse * intensity));
    return colour;
}

float3 calculateNormal(float3 position[3])
{
    float3 n = normalize(cross(position[0].xyz - position[2].xyz, position[1].xyz - position[0].xyz));
    
    return n;
}

float4 main(Input input) : sv_target
{
    // Default colour
    float colour = float4(0, 0, 0, 1);
    
    // Projected tex coord
    float2 pTex = input.lViewPos.xy / input.lViewPos.w;
    pTex *= float2(0.5f, -0.5f);
    pTex += float2(0.5f, 0.5f);
    
    // If tex coord is outside bounds return red to make it obvious
    if(pTex.x < 0.0f || pTex.x > 1.0f || pTex.y < 0.0f || pTex.y > 1.0f)
        return float4(1, 0, 0, 1);
    
    // Bias is adjusted later
    float bias = 0.008f;
    // Depth value from depth map
    float depth = dmap.Sample(dSampler, pTex).r;
    // Light depth for comparison
    float lDepth = input.lViewPos.z / input.lViewPos.w;
    
    // Calculate normals in pixel shader
    float3 positions[3];
    float3 normal;
    if (hmap.Sample(hSampler, input.tex).r > 0.03f)
    {
        // Takes values from height map and constructs approximate vertices based on them
        positions[0].y = hmap.Sample(hSampler, input.tex).r;
        positions[0].xz = float2(0, 0);
        positions[1].y = hmap.Sample(hSampler, input.tex + float2(0.01f, 0)).r;
        positions[1].xz = float2(0.01f, 0);
        positions[2].y = hmap.Sample(hSampler, input.tex + float2(0, 0.01f)).r;
        positions[2].xz = float2(0, 0.01f);
    
        normal = calculateNormal(positions);
        lDepth -= bias * 0.5f;
    }
    else
    {
        // Stops shadow artefacts on the flat plane surrounding the terrain
        lDepth -= bias * 10.0f;
        normal = float3(0, -1, 0);
    }
    
    // W component used as a bool to enable / disable shadows
    if(position.w == 1.0f)
    {
        if (lDepth < depth)
            colour = calculateLighting(normal);
    }
    else
        colour = calculateLighting(normal);
    
    return colour * tmap.Sample(tSampler, input.tex);

}