struct Input
{
    float4 pos : sv_position;
    float depth : texcoord0;
};

float4 main(Input input) : sv_target
{
    // Output depth value
    return float4(input.depth, input.depth, input.depth, 1);
}