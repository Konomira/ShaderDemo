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
    float3 normal : normal;
};

float4 calculateNormal(float4 position[3])
{
    float3 n = normalize(cross(position[2].xyz - position[0].xyz, position[1].xyz - position[0].xyz));
    return float4(n.x, n.y, n.z, 1.0f);
}

float4 calculateCentroid(float4 p[3], float3 normal = float3(0, 0, 0))
{
    // Averages 3 points to get centroid, adds normal if supplied
    return float4(
    ((p[0].x + p[1].x + p[2].x) / 3.0f) + normal.x,
    ((p[0].y + p[1].y + p[2].y) / 3.0f) + normal.y,
    ((p[0].z + p[1].z + p[2].z) / 3.0f) + normal.z,
    1.0f
    );    
}

[maxvertexcount(2)]
void main(triangle Input input[3], inout LineStream<Output> stream)
{   
    // Get current positions transformed into world space
    float4 positions[3];
    
    // Offset vertex height based on heightmap data
    for (int i = 0; i < 3; i++)
    {
        positions[i] = input[i].pos;
        positions[i].y += hmap.SampleLevel(hSampler, input[i].tex, 0).r * 20.0f;
        positions[i] = mul(positions[i], world);
    }

    Output output;    
    // Get centroid of face and transform into screen space
    output.pos = calculateCentroid(positions);
    output.pos = mul(output.pos, view);
    output.pos = mul(output.pos, proj);
    
    // Calculate normals given vertices of face
    output.normal = calculateNormal(positions).xyz;
    stream.Append(output);
    
    // Repeat, this time offset by the normal
    output.pos = calculateCentroid(positions,output.normal);
    output.pos = mul(output.pos, view);
    output.pos = mul(output.pos, proj);
    
    stream.Append(output);
    stream.RestartStrip();
}