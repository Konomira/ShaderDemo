struct Input
{
    float4 pos : sv_position;
    float3 normal : normal;
};

float4 main (Input input) : sv_target
{
    // return normal value
    return float4(input.normal.x, input.normal.y, input.normal.z, 1);
}