cbuffer TessellationBuffer : register(b0)
{
    float4 tessellationFactor;
}

struct ConstantOutputType
{
    float edges[3] : SV_TessFactor;
    float inside : SV_InsideTessFactor;
};

struct Output
{
    float4 position : position;
    float2 tex : texcoord0;
};

struct Input
{
    float4 position : position;
    float2 tex : texcoord0;
};

ConstantOutputType PatchConstantFunction(InputPatch<Input, 3> input, uint id : SV_PrimitiveID)
{
    ConstantOutputType output;
    
    output.edges[0] = tessellationFactor.x;
    output.edges[1] = tessellationFactor.y;
    output.edges[2] = tessellationFactor.z;
    
    output.inside = tessellationFactor.w;
    
    return output;
}

[domain("tri")]
[partitioning("integer")]
[outputtopology("triangle_ccw")]
[outputcontrolpoints(3)]
[patchconstantfunc("PatchConstantFunction")]
Output main(InputPatch<Input, 3> patch, uint pointId : SV_OutputControlPointID, uint patchId : SV_PrimitiveID)
{
    Output output;
    
    output.position = patch[pointId].position;
    
    output.tex = patch[pointId].tex;
    
    return output;
}