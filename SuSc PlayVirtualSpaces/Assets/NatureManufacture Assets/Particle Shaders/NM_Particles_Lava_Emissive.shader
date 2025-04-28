Shader "NatureManufacture/HDRP/Particles/Lava Emissive"
{
    Properties
    {
        _AlphaClipThreshold("Alpha Clip Threshold", Range(0, 1)) = 1
        [ToggleUI]_ReadAlbedo("Read Albedo", Float) = 1
        [NoScaleOffset]_ParticleMask("Particle (RGB) Mask (A)", 2D) = "white" {}
        _TilingandOffset("Tiling and Offset", Vector) = (1, 1, 0, 0)
        _ParticleColor("Particle Color (RGB) Alpha (A)", Color) = (1, 1, 1, 1)
        [Normal][NoScaleOffset]_ParticleNormal("Particle Normal", 2D) = "bump" {}
        _ParticleNormalScale("Particle Normal Strenght", Float) = 1
        [NoScaleOffset]_Mask_Map("Mask Map (MT_AO_H_SM)", 2D) = "white" {}
        _AO_multiplier("AO multiplier", Range(0, 1)) = 1
        _Smoothness_multiplier("Smoothness multiplier", Range(0, 1)) = 1
        Vector1_bab3a2e609c74b6baff7b028a65ce418("Metallic multiplier", Range(0, 1)) = 0
        [NoScaleOffset]_Emission_Texture("Emission Texture", 2D) = "white" {}
        [HDR]_Emission_Color("Emission Color", Color) = (0, 0, 0, 0)
        [HideInInspector]_WorkflowMode("_WorkflowMode", Float) = 1
        [HideInInspector]_CastShadows("_CastShadows", Float) = 1
        [HideInInspector]_ReceiveShadows("_ReceiveShadows", Float) = 1
        [HideInInspector]_Surface("_Surface", Float) = 1
        [HideInInspector]_Blend("_Blend", Float) = 0
        [HideInInspector]_AlphaClip("_AlphaClip", Float) = 1
        [HideInInspector]_BlendModePreserveSpecular("_BlendModePreserveSpecular", Float) = 0
        [HideInInspector]_SrcBlend("_SrcBlend", Float) = 1
        [HideInInspector]_DstBlend("_DstBlend", Float) = 0
        [HideInInspector][ToggleUI]_ZWrite("_ZWrite", Float) = 0
        [HideInInspector]_ZWriteControl("_ZWriteControl", Float) = 0
        [HideInInspector]_ZTest("_ZTest", Float) = 4
        [HideInInspector]_Cull("_Cull", Float) = 2
        [HideInInspector]_AlphaToMask("_AlphaToMask", Float) = 0
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        AlphaToMask [_AlphaToMask]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _FORWARD_PLUS
        #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
        #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 color : INTERP7;
             float4 fogFactorAndVertexLight : INTERP8;
             float3 positionWS : INTERP9;
             float3 normalWS : INTERP10;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaClipThreshold;
        float _ReadAlbedo;
        float4 _ParticleMask_TexelSize;
        float4 _TilingandOffset;
        float4 _ParticleColor;
        float4 _ParticleNormal_TexelSize;
        float _ParticleNormalScale;
        float4 _Mask_Map_TexelSize;
        float _AO_multiplier;
        float _Smoothness_multiplier;
        float Vector1_bab3a2e609c74b6baff7b028a65ce418;
        float4 _Emission_Texture_TexelSize;
        float4 _Emission_Color;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_ParticleMask);
        SAMPLER(sampler_ParticleMask);
        TEXTURE2D(_ParticleNormal);
        SAMPLER(sampler_ParticleNormal);
        TEXTURE2D(_Mask_Map);
        SAMPLER(sampler_Mask_Map);
        TEXTURE2D(_Emission_Texture);
        SAMPLER(sampler_Emission_Texture);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float3 Specular;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_b4e0c30cf01756839030a5167b089dc6_Out_0_Boolean = _ReadAlbedo;
            float4 _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4 = _ParticleColor;
            UnityTexture2D _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_ParticleMask);
            float4 _UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4 = IN.uv0;
            float4 _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4 = _TilingandOffset;
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[0];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[1];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[2];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[3];
            float4 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4;
            float3 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3;
            float2 _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float, float(0), float(0), _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4, _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3, _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2);
            float4 _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4;
            float3 _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3;
            float2 _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float, float(0), float(0), _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4, _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2);
            float2 _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4.xy), _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2, _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2);
            float4 _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.tex, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.samplerstate, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_R_4_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.r;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_G_5_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.g;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_B_6_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.b;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.a;
            float4 _Multiply_ffed7e4d201e2e86974f2cc3d88026b2_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4, _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4, _Multiply_ffed7e4d201e2e86974f2cc3d88026b2_Out_2_Vector4);
            float4 _Branch_ef8236ada61be1869b3278db6ae02537_Out_3_Vector4;
            Unity_Branch_float4(_Property_b4e0c30cf01756839030a5167b089dc6_Out_0_Boolean, _Multiply_ffed7e4d201e2e86974f2cc3d88026b2_Out_2_Vector4, _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4, _Branch_ef8236ada61be1869b3278db6ae02537_Out_3_Vector4);
            float4 _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4);
            float4 _Multiply_3c7c94a1a6e2c08786b9b70a13b426fa_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Branch_ef8236ada61be1869b3278db6ae02537_Out_3_Vector4, _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4, _Multiply_3c7c94a1a6e2c08786b9b70a13b426fa_Out_2_Vector4);
            UnityTexture2D _Property_47d26322b0cbee809f7bb147ebce9c2b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_ParticleNormal);
            float4 _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_47d26322b0cbee809f7bb147ebce9c2b_Out_0_Texture2D.tex, _Property_47d26322b0cbee809f7bb147ebce9c2b_Out_0_Texture2D.samplerstate, _Property_47d26322b0cbee809f7bb147ebce9c2b_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4);
            float _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_R_4_Float = _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.r;
            float _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_G_5_Float = _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.g;
            float _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_B_6_Float = _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.b;
            float _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_A_7_Float = _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.a;
            float _Property_9ca212c6c965a284b1795febc12e7aed_Out_0_Float = _ParticleNormalScale;
            float3 _NormalStrength_2012b1b56379248a8afa64fa70f1b999_Out_2_Vector3;
            Unity_NormalStrength_float((_SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.xyz), _Property_9ca212c6c965a284b1795febc12e7aed_Out_0_Float, _NormalStrength_2012b1b56379248a8afa64fa70f1b999_Out_2_Vector3);
            float4 _Property_479229991d5542d796eac0e9def8c2d7_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Emission_Color) : _Emission_Color;
            UnityTexture2D _Property_62c46c558d8f4d209a7a17877af03aab_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Emission_Texture);
            float4 _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_62c46c558d8f4d209a7a17877af03aab_Out_0_Texture2D.tex, _Property_62c46c558d8f4d209a7a17877af03aab_Out_0_Texture2D.samplerstate, _Property_62c46c558d8f4d209a7a17877af03aab_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            float _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_R_4_Float = _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4.r;
            float _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_G_5_Float = _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4.g;
            float _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_B_6_Float = _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4.b;
            float _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_A_7_Float = _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4.a;
            float4 _Multiply_f5ae222b26e245a681d4c4005fdcd9dd_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_479229991d5542d796eac0e9def8c2d7_Out_0_Vector4, _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4, _Multiply_f5ae222b26e245a681d4c4005fdcd9dd_Out_2_Vector4);
            float4 _Multiply_d1894c3787b04ddc9f4316bde9b000ee_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4, _Multiply_f5ae222b26e245a681d4c4005fdcd9dd_Out_2_Vector4, _Multiply_d1894c3787b04ddc9f4316bde9b000ee_Out_2_Vector4);
            UnityTexture2D _Property_b76d286c926943aea555b7bf653aa933_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask_Map);
            float4 _SampleTexture2D_ce88e50c033044d283deb2776a46204d_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b76d286c926943aea555b7bf653aa933_Out_0_Texture2D.tex, _Property_b76d286c926943aea555b7bf653aa933_Out_0_Texture2D.samplerstate, _Property_b76d286c926943aea555b7bf653aa933_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            float _SampleTexture2D_ce88e50c033044d283deb2776a46204d_R_4_Float = _SampleTexture2D_ce88e50c033044d283deb2776a46204d_RGBA_0_Vector4.r;
            float _SampleTexture2D_ce88e50c033044d283deb2776a46204d_G_5_Float = _SampleTexture2D_ce88e50c033044d283deb2776a46204d_RGBA_0_Vector4.g;
            float _SampleTexture2D_ce88e50c033044d283deb2776a46204d_B_6_Float = _SampleTexture2D_ce88e50c033044d283deb2776a46204d_RGBA_0_Vector4.b;
            float _SampleTexture2D_ce88e50c033044d283deb2776a46204d_A_7_Float = _SampleTexture2D_ce88e50c033044d283deb2776a46204d_RGBA_0_Vector4.a;
            float _Property_52a58e015e194cd6827988c464ce8081_Out_0_Float = Vector1_bab3a2e609c74b6baff7b028a65ce418;
            float _Multiply_8146e5f348b44712abf415e139d5de39_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_ce88e50c033044d283deb2776a46204d_R_4_Float, _Property_52a58e015e194cd6827988c464ce8081_Out_0_Float, _Multiply_8146e5f348b44712abf415e139d5de39_Out_2_Float);
            float _Property_0f0d790c7ab2432eae4a03f04d7490c8_Out_0_Float = _Smoothness_multiplier;
            float _Multiply_e36c6ff9e74a4e81bcfd131039b673f6_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_ce88e50c033044d283deb2776a46204d_A_7_Float, _Property_0f0d790c7ab2432eae4a03f04d7490c8_Out_0_Float, _Multiply_e36c6ff9e74a4e81bcfd131039b673f6_Out_2_Float);
            float _Property_03e8f7eb67bf44c486e74298294a220c_Out_0_Float = _AO_multiplier;
            float _Multiply_fdf1d2924b844055a18446459f70922e_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_ce88e50c033044d283deb2776a46204d_G_5_Float, _Property_03e8f7eb67bf44c486e74298294a220c_Out_0_Float, _Multiply_fdf1d2924b844055a18446459f70922e_Out_2_Float);
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_R_1_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[0];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_G_2_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[1];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_B_3_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[2];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[3];
            float _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float;
            Unity_Multiply_float_float(_Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float, _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float, _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float);
            float _Split_12920bdaccef158ab9bd191cc9e45c04_R_1_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[0];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_G_2_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[1];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_B_3_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[2];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[3];
            float _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float, _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float, _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float);
            float _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float = _AlphaClipThreshold;
            surface.BaseColor = (_Multiply_3c7c94a1a6e2c08786b9b70a13b426fa_Out_2_Vector4.xyz);
            surface.NormalTS = _NormalStrength_2012b1b56379248a8afa64fa70f1b999_Out_2_Vector3;
            surface.Emission = (_Multiply_d1894c3787b04ddc9f4316bde9b000ee_Out_2_Vector4.xyz);
            surface.Metallic = _Multiply_8146e5f348b44712abf415e139d5de39_Out_2_Float;
            surface.Specular = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
            surface.Smoothness = _Multiply_e36c6ff9e74a4e81bcfd131039b673f6_Out_2_Float;
            surface.Occlusion = _Multiply_fdf1d2924b844055a18446459f70922e_Out_2_Float;
            surface.Alpha = _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            surface.AlphaClipThreshold = _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
        #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 color : INTERP7;
             float4 fogFactorAndVertexLight : INTERP8;
             float3 positionWS : INTERP9;
             float3 normalWS : INTERP10;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaClipThreshold;
        float _ReadAlbedo;
        float4 _ParticleMask_TexelSize;
        float4 _TilingandOffset;
        float4 _ParticleColor;
        float4 _ParticleNormal_TexelSize;
        float _ParticleNormalScale;
        float4 _Mask_Map_TexelSize;
        float _AO_multiplier;
        float _Smoothness_multiplier;
        float Vector1_bab3a2e609c74b6baff7b028a65ce418;
        float4 _Emission_Texture_TexelSize;
        float4 _Emission_Color;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_ParticleMask);
        SAMPLER(sampler_ParticleMask);
        TEXTURE2D(_ParticleNormal);
        SAMPLER(sampler_ParticleNormal);
        TEXTURE2D(_Mask_Map);
        SAMPLER(sampler_Mask_Map);
        TEXTURE2D(_Emission_Texture);
        SAMPLER(sampler_Emission_Texture);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float3 Specular;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_b4e0c30cf01756839030a5167b089dc6_Out_0_Boolean = _ReadAlbedo;
            float4 _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4 = _ParticleColor;
            UnityTexture2D _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_ParticleMask);
            float4 _UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4 = IN.uv0;
            float4 _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4 = _TilingandOffset;
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[0];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[1];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[2];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[3];
            float4 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4;
            float3 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3;
            float2 _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float, float(0), float(0), _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4, _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3, _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2);
            float4 _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4;
            float3 _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3;
            float2 _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float, float(0), float(0), _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4, _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2);
            float2 _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4.xy), _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2, _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2);
            float4 _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.tex, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.samplerstate, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_R_4_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.r;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_G_5_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.g;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_B_6_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.b;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.a;
            float4 _Multiply_ffed7e4d201e2e86974f2cc3d88026b2_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4, _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4, _Multiply_ffed7e4d201e2e86974f2cc3d88026b2_Out_2_Vector4);
            float4 _Branch_ef8236ada61be1869b3278db6ae02537_Out_3_Vector4;
            Unity_Branch_float4(_Property_b4e0c30cf01756839030a5167b089dc6_Out_0_Boolean, _Multiply_ffed7e4d201e2e86974f2cc3d88026b2_Out_2_Vector4, _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4, _Branch_ef8236ada61be1869b3278db6ae02537_Out_3_Vector4);
            float4 _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4);
            float4 _Multiply_3c7c94a1a6e2c08786b9b70a13b426fa_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Branch_ef8236ada61be1869b3278db6ae02537_Out_3_Vector4, _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4, _Multiply_3c7c94a1a6e2c08786b9b70a13b426fa_Out_2_Vector4);
            UnityTexture2D _Property_47d26322b0cbee809f7bb147ebce9c2b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_ParticleNormal);
            float4 _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_47d26322b0cbee809f7bb147ebce9c2b_Out_0_Texture2D.tex, _Property_47d26322b0cbee809f7bb147ebce9c2b_Out_0_Texture2D.samplerstate, _Property_47d26322b0cbee809f7bb147ebce9c2b_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4);
            float _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_R_4_Float = _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.r;
            float _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_G_5_Float = _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.g;
            float _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_B_6_Float = _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.b;
            float _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_A_7_Float = _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.a;
            float _Property_9ca212c6c965a284b1795febc12e7aed_Out_0_Float = _ParticleNormalScale;
            float3 _NormalStrength_2012b1b56379248a8afa64fa70f1b999_Out_2_Vector3;
            Unity_NormalStrength_float((_SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.xyz), _Property_9ca212c6c965a284b1795febc12e7aed_Out_0_Float, _NormalStrength_2012b1b56379248a8afa64fa70f1b999_Out_2_Vector3);
            float4 _Property_479229991d5542d796eac0e9def8c2d7_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Emission_Color) : _Emission_Color;
            UnityTexture2D _Property_62c46c558d8f4d209a7a17877af03aab_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Emission_Texture);
            float4 _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_62c46c558d8f4d209a7a17877af03aab_Out_0_Texture2D.tex, _Property_62c46c558d8f4d209a7a17877af03aab_Out_0_Texture2D.samplerstate, _Property_62c46c558d8f4d209a7a17877af03aab_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            float _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_R_4_Float = _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4.r;
            float _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_G_5_Float = _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4.g;
            float _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_B_6_Float = _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4.b;
            float _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_A_7_Float = _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4.a;
            float4 _Multiply_f5ae222b26e245a681d4c4005fdcd9dd_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_479229991d5542d796eac0e9def8c2d7_Out_0_Vector4, _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4, _Multiply_f5ae222b26e245a681d4c4005fdcd9dd_Out_2_Vector4);
            float4 _Multiply_d1894c3787b04ddc9f4316bde9b000ee_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4, _Multiply_f5ae222b26e245a681d4c4005fdcd9dd_Out_2_Vector4, _Multiply_d1894c3787b04ddc9f4316bde9b000ee_Out_2_Vector4);
            UnityTexture2D _Property_b76d286c926943aea555b7bf653aa933_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Mask_Map);
            float4 _SampleTexture2D_ce88e50c033044d283deb2776a46204d_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b76d286c926943aea555b7bf653aa933_Out_0_Texture2D.tex, _Property_b76d286c926943aea555b7bf653aa933_Out_0_Texture2D.samplerstate, _Property_b76d286c926943aea555b7bf653aa933_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            float _SampleTexture2D_ce88e50c033044d283deb2776a46204d_R_4_Float = _SampleTexture2D_ce88e50c033044d283deb2776a46204d_RGBA_0_Vector4.r;
            float _SampleTexture2D_ce88e50c033044d283deb2776a46204d_G_5_Float = _SampleTexture2D_ce88e50c033044d283deb2776a46204d_RGBA_0_Vector4.g;
            float _SampleTexture2D_ce88e50c033044d283deb2776a46204d_B_6_Float = _SampleTexture2D_ce88e50c033044d283deb2776a46204d_RGBA_0_Vector4.b;
            float _SampleTexture2D_ce88e50c033044d283deb2776a46204d_A_7_Float = _SampleTexture2D_ce88e50c033044d283deb2776a46204d_RGBA_0_Vector4.a;
            float _Property_52a58e015e194cd6827988c464ce8081_Out_0_Float = Vector1_bab3a2e609c74b6baff7b028a65ce418;
            float _Multiply_8146e5f348b44712abf415e139d5de39_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_ce88e50c033044d283deb2776a46204d_R_4_Float, _Property_52a58e015e194cd6827988c464ce8081_Out_0_Float, _Multiply_8146e5f348b44712abf415e139d5de39_Out_2_Float);
            float _Property_0f0d790c7ab2432eae4a03f04d7490c8_Out_0_Float = _Smoothness_multiplier;
            float _Multiply_e36c6ff9e74a4e81bcfd131039b673f6_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_ce88e50c033044d283deb2776a46204d_A_7_Float, _Property_0f0d790c7ab2432eae4a03f04d7490c8_Out_0_Float, _Multiply_e36c6ff9e74a4e81bcfd131039b673f6_Out_2_Float);
            float _Property_03e8f7eb67bf44c486e74298294a220c_Out_0_Float = _AO_multiplier;
            float _Multiply_fdf1d2924b844055a18446459f70922e_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_ce88e50c033044d283deb2776a46204d_G_5_Float, _Property_03e8f7eb67bf44c486e74298294a220c_Out_0_Float, _Multiply_fdf1d2924b844055a18446459f70922e_Out_2_Float);
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_R_1_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[0];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_G_2_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[1];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_B_3_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[2];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[3];
            float _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float;
            Unity_Multiply_float_float(_Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float, _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float, _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float);
            float _Split_12920bdaccef158ab9bd191cc9e45c04_R_1_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[0];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_G_2_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[1];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_B_3_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[2];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[3];
            float _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float, _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float, _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float);
            float _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float = _AlphaClipThreshold;
            surface.BaseColor = (_Multiply_3c7c94a1a6e2c08786b9b70a13b426fa_Out_2_Vector4.xyz);
            surface.NormalTS = _NormalStrength_2012b1b56379248a8afa64fa70f1b999_Out_2_Vector3;
            surface.Emission = (_Multiply_d1894c3787b04ddc9f4316bde9b000ee_Out_2_Vector4.xyz);
            surface.Metallic = _Multiply_8146e5f348b44712abf415e139d5de39_Out_2_Float;
            surface.Specular = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
            surface.Smoothness = _Multiply_e36c6ff9e74a4e81bcfd131039b673f6_Out_2_Float;
            surface.Occlusion = _Multiply_fdf1d2924b844055a18446459f70922e_Out_2_Float;
            surface.Alpha = _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            surface.AlphaClipThreshold = _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
             float3 normalWS : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaClipThreshold;
        float _ReadAlbedo;
        float4 _ParticleMask_TexelSize;
        float4 _TilingandOffset;
        float4 _ParticleColor;
        float4 _ParticleNormal_TexelSize;
        float _ParticleNormalScale;
        float4 _Mask_Map_TexelSize;
        float _AO_multiplier;
        float _Smoothness_multiplier;
        float Vector1_bab3a2e609c74b6baff7b028a65ce418;
        float4 _Emission_Texture_TexelSize;
        float4 _Emission_Color;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_ParticleMask);
        SAMPLER(sampler_ParticleMask);
        TEXTURE2D(_ParticleNormal);
        SAMPLER(sampler_ParticleNormal);
        TEXTURE2D(_Mask_Map);
        SAMPLER(sampler_Mask_Map);
        TEXTURE2D(_Emission_Texture);
        SAMPLER(sampler_Emission_Texture);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4 = _ParticleColor;
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_R_1_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[0];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_G_2_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[1];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_B_3_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[2];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[3];
            UnityTexture2D _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_ParticleMask);
            float4 _UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4 = IN.uv0;
            float4 _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4 = _TilingandOffset;
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[0];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[1];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[2];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[3];
            float4 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4;
            float3 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3;
            float2 _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float, float(0), float(0), _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4, _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3, _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2);
            float4 _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4;
            float3 _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3;
            float2 _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float, float(0), float(0), _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4, _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2);
            float2 _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4.xy), _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2, _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2);
            float4 _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.tex, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.samplerstate, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_R_4_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.r;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_G_5_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.g;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_B_6_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.b;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.a;
            float _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float;
            Unity_Multiply_float_float(_Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float, _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float, _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float);
            float4 _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4);
            float _Split_12920bdaccef158ab9bd191cc9e45c04_R_1_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[0];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_G_2_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[1];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_B_3_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[2];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[3];
            float _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float, _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float, _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float);
            float _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float = _AlphaClipThreshold;
            surface.Alpha = _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            surface.AlphaClipThreshold = _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "MotionVectors"
            Tags
            {
                "LightMode" = "MotionVectors"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask RG
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.5
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaClipThreshold;
        float _ReadAlbedo;
        float4 _ParticleMask_TexelSize;
        float4 _TilingandOffset;
        float4 _ParticleColor;
        float4 _ParticleNormal_TexelSize;
        float _ParticleNormalScale;
        float4 _Mask_Map_TexelSize;
        float _AO_multiplier;
        float _Smoothness_multiplier;
        float Vector1_bab3a2e609c74b6baff7b028a65ce418;
        float4 _Emission_Texture_TexelSize;
        float4 _Emission_Color;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_ParticleMask);
        SAMPLER(sampler_ParticleMask);
        TEXTURE2D(_ParticleNormal);
        SAMPLER(sampler_ParticleNormal);
        TEXTURE2D(_Mask_Map);
        SAMPLER(sampler_Mask_Map);
        TEXTURE2D(_Emission_Texture);
        SAMPLER(sampler_Emission_Texture);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4 = _ParticleColor;
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_R_1_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[0];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_G_2_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[1];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_B_3_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[2];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[3];
            UnityTexture2D _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_ParticleMask);
            float4 _UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4 = IN.uv0;
            float4 _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4 = _TilingandOffset;
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[0];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[1];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[2];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[3];
            float4 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4;
            float3 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3;
            float2 _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float, float(0), float(0), _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4, _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3, _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2);
            float4 _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4;
            float3 _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3;
            float2 _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float, float(0), float(0), _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4, _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2);
            float2 _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4.xy), _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2, _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2);
            float4 _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.tex, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.samplerstate, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_R_4_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.r;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_G_5_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.g;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_B_6_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.b;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.a;
            float _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float;
            Unity_Multiply_float_float(_Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float, _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float, _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float);
            float4 _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4);
            float _Split_12920bdaccef158ab9bd191cc9e45c04_R_1_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[0];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_G_2_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[1];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_B_3_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[2];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[3];
            float _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float, _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float, _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float);
            float _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float = _AlphaClipThreshold;
            surface.Alpha = _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            surface.AlphaClipThreshold = _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask R
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaClipThreshold;
        float _ReadAlbedo;
        float4 _ParticleMask_TexelSize;
        float4 _TilingandOffset;
        float4 _ParticleColor;
        float4 _ParticleNormal_TexelSize;
        float _ParticleNormalScale;
        float4 _Mask_Map_TexelSize;
        float _AO_multiplier;
        float _Smoothness_multiplier;
        float Vector1_bab3a2e609c74b6baff7b028a65ce418;
        float4 _Emission_Texture_TexelSize;
        float4 _Emission_Color;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_ParticleMask);
        SAMPLER(sampler_ParticleMask);
        TEXTURE2D(_ParticleNormal);
        SAMPLER(sampler_ParticleNormal);
        TEXTURE2D(_Mask_Map);
        SAMPLER(sampler_Mask_Map);
        TEXTURE2D(_Emission_Texture);
        SAMPLER(sampler_Emission_Texture);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4 = _ParticleColor;
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_R_1_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[0];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_G_2_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[1];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_B_3_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[2];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[3];
            UnityTexture2D _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_ParticleMask);
            float4 _UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4 = IN.uv0;
            float4 _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4 = _TilingandOffset;
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[0];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[1];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[2];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[3];
            float4 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4;
            float3 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3;
            float2 _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float, float(0), float(0), _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4, _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3, _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2);
            float4 _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4;
            float3 _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3;
            float2 _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float, float(0), float(0), _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4, _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2);
            float2 _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4.xy), _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2, _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2);
            float4 _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.tex, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.samplerstate, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_R_4_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.r;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_G_5_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.g;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_B_6_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.b;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.a;
            float _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float;
            Unity_Multiply_float_float(_Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float, _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float, _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float);
            float4 _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4);
            float _Split_12920bdaccef158ab9bd191cc9e45c04_R_1_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[0];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_G_2_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[1];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_B_3_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[2];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[3];
            float _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float, _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float, _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float);
            float _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float = _AlphaClipThreshold;
            surface.Alpha = _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            surface.AlphaClipThreshold = _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float4 color : INTERP2;
             float3 normalWS : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaClipThreshold;
        float _ReadAlbedo;
        float4 _ParticleMask_TexelSize;
        float4 _TilingandOffset;
        float4 _ParticleColor;
        float4 _ParticleNormal_TexelSize;
        float _ParticleNormalScale;
        float4 _Mask_Map_TexelSize;
        float _AO_multiplier;
        float _Smoothness_multiplier;
        float Vector1_bab3a2e609c74b6baff7b028a65ce418;
        float4 _Emission_Texture_TexelSize;
        float4 _Emission_Color;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_ParticleMask);
        SAMPLER(sampler_ParticleMask);
        TEXTURE2D(_ParticleNormal);
        SAMPLER(sampler_ParticleNormal);
        TEXTURE2D(_Mask_Map);
        SAMPLER(sampler_Mask_Map);
        TEXTURE2D(_Emission_Texture);
        SAMPLER(sampler_Emission_Texture);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_47d26322b0cbee809f7bb147ebce9c2b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_ParticleNormal);
            float4 _UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4 = IN.uv0;
            float4 _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4 = _TilingandOffset;
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[0];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[1];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[2];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[3];
            float4 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4;
            float3 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3;
            float2 _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float, float(0), float(0), _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4, _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3, _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2);
            float4 _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4;
            float3 _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3;
            float2 _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float, float(0), float(0), _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4, _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2);
            float2 _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4.xy), _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2, _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2);
            float4 _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_47d26322b0cbee809f7bb147ebce9c2b_Out_0_Texture2D.tex, _Property_47d26322b0cbee809f7bb147ebce9c2b_Out_0_Texture2D.samplerstate, _Property_47d26322b0cbee809f7bb147ebce9c2b_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4);
            float _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_R_4_Float = _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.r;
            float _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_G_5_Float = _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.g;
            float _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_B_6_Float = _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.b;
            float _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_A_7_Float = _SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.a;
            float _Property_9ca212c6c965a284b1795febc12e7aed_Out_0_Float = _ParticleNormalScale;
            float3 _NormalStrength_2012b1b56379248a8afa64fa70f1b999_Out_2_Vector3;
            Unity_NormalStrength_float((_SampleTexture2D_0ed25a5d03077d89ba21a94bf21a8a6e_RGBA_0_Vector4.xyz), _Property_9ca212c6c965a284b1795febc12e7aed_Out_0_Float, _NormalStrength_2012b1b56379248a8afa64fa70f1b999_Out_2_Vector3);
            float4 _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4 = _ParticleColor;
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_R_1_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[0];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_G_2_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[1];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_B_3_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[2];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[3];
            UnityTexture2D _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_ParticleMask);
            float4 _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.tex, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.samplerstate, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_R_4_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.r;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_G_5_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.g;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_B_6_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.b;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.a;
            float _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float;
            Unity_Multiply_float_float(_Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float, _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float, _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float);
            float4 _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4);
            float _Split_12920bdaccef158ab9bd191cc9e45c04_R_1_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[0];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_G_2_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[1];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_B_3_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[2];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[3];
            float _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float, _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float, _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float);
            float _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float = _AlphaClipThreshold;
            surface.NormalTS = _NormalStrength_2012b1b56379248a8afa64fa70f1b999_Out_2_Vector3;
            surface.Alpha = _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            surface.AlphaClipThreshold = _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_COLOR
        #define ATTRIBUTES_NEED_INSTANCEID
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
             float4 texCoord2 : INTERP2;
             float4 color : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.color.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.color = input.color.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaClipThreshold;
        float _ReadAlbedo;
        float4 _ParticleMask_TexelSize;
        float4 _TilingandOffset;
        float4 _ParticleColor;
        float4 _ParticleNormal_TexelSize;
        float _ParticleNormalScale;
        float4 _Mask_Map_TexelSize;
        float _AO_multiplier;
        float _Smoothness_multiplier;
        float Vector1_bab3a2e609c74b6baff7b028a65ce418;
        float4 _Emission_Texture_TexelSize;
        float4 _Emission_Color;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_ParticleMask);
        SAMPLER(sampler_ParticleMask);
        TEXTURE2D(_ParticleNormal);
        SAMPLER(sampler_ParticleNormal);
        TEXTURE2D(_Mask_Map);
        SAMPLER(sampler_Mask_Map);
        TEXTURE2D(_Emission_Texture);
        SAMPLER(sampler_Emission_Texture);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_b4e0c30cf01756839030a5167b089dc6_Out_0_Boolean = _ReadAlbedo;
            float4 _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4 = _ParticleColor;
            UnityTexture2D _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_ParticleMask);
            float4 _UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4 = IN.uv0;
            float4 _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4 = _TilingandOffset;
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[0];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[1];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[2];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[3];
            float4 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4;
            float3 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3;
            float2 _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float, float(0), float(0), _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4, _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3, _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2);
            float4 _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4;
            float3 _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3;
            float2 _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float, float(0), float(0), _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4, _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2);
            float2 _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4.xy), _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2, _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2);
            float4 _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.tex, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.samplerstate, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_R_4_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.r;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_G_5_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.g;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_B_6_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.b;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.a;
            float4 _Multiply_ffed7e4d201e2e86974f2cc3d88026b2_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4, _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4, _Multiply_ffed7e4d201e2e86974f2cc3d88026b2_Out_2_Vector4);
            float4 _Branch_ef8236ada61be1869b3278db6ae02537_Out_3_Vector4;
            Unity_Branch_float4(_Property_b4e0c30cf01756839030a5167b089dc6_Out_0_Boolean, _Multiply_ffed7e4d201e2e86974f2cc3d88026b2_Out_2_Vector4, _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4, _Branch_ef8236ada61be1869b3278db6ae02537_Out_3_Vector4);
            float4 _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4);
            float4 _Multiply_3c7c94a1a6e2c08786b9b70a13b426fa_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Branch_ef8236ada61be1869b3278db6ae02537_Out_3_Vector4, _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4, _Multiply_3c7c94a1a6e2c08786b9b70a13b426fa_Out_2_Vector4);
            float4 _Property_479229991d5542d796eac0e9def8c2d7_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Emission_Color) : _Emission_Color;
            UnityTexture2D _Property_62c46c558d8f4d209a7a17877af03aab_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Emission_Texture);
            float4 _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_62c46c558d8f4d209a7a17877af03aab_Out_0_Texture2D.tex, _Property_62c46c558d8f4d209a7a17877af03aab_Out_0_Texture2D.samplerstate, _Property_62c46c558d8f4d209a7a17877af03aab_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            float _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_R_4_Float = _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4.r;
            float _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_G_5_Float = _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4.g;
            float _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_B_6_Float = _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4.b;
            float _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_A_7_Float = _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4.a;
            float4 _Multiply_f5ae222b26e245a681d4c4005fdcd9dd_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_479229991d5542d796eac0e9def8c2d7_Out_0_Vector4, _SampleTexture2D_86cbac1f49464c8e9280d55370c445ac_RGBA_0_Vector4, _Multiply_f5ae222b26e245a681d4c4005fdcd9dd_Out_2_Vector4);
            float4 _Multiply_d1894c3787b04ddc9f4316bde9b000ee_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4, _Multiply_f5ae222b26e245a681d4c4005fdcd9dd_Out_2_Vector4, _Multiply_d1894c3787b04ddc9f4316bde9b000ee_Out_2_Vector4);
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_R_1_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[0];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_G_2_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[1];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_B_3_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[2];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[3];
            float _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float;
            Unity_Multiply_float_float(_Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float, _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float, _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float);
            float _Split_12920bdaccef158ab9bd191cc9e45c04_R_1_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[0];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_G_2_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[1];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_B_3_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[2];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[3];
            float _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float, _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float, _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float);
            float _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float = _AlphaClipThreshold;
            surface.BaseColor = (_Multiply_3c7c94a1a6e2c08786b9b70a13b426fa_Out_2_Vector4.xyz);
            surface.Emission = (_Multiply_d1894c3787b04ddc9f4316bde9b000ee_Out_2_Vector4.xyz);
            surface.Alpha = _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            surface.AlphaClipThreshold = _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaClipThreshold;
        float _ReadAlbedo;
        float4 _ParticleMask_TexelSize;
        float4 _TilingandOffset;
        float4 _ParticleColor;
        float4 _ParticleNormal_TexelSize;
        float _ParticleNormalScale;
        float4 _Mask_Map_TexelSize;
        float _AO_multiplier;
        float _Smoothness_multiplier;
        float Vector1_bab3a2e609c74b6baff7b028a65ce418;
        float4 _Emission_Texture_TexelSize;
        float4 _Emission_Color;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_ParticleMask);
        SAMPLER(sampler_ParticleMask);
        TEXTURE2D(_ParticleNormal);
        SAMPLER(sampler_ParticleNormal);
        TEXTURE2D(_Mask_Map);
        SAMPLER(sampler_Mask_Map);
        TEXTURE2D(_Emission_Texture);
        SAMPLER(sampler_Emission_Texture);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4 = _ParticleColor;
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_R_1_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[0];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_G_2_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[1];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_B_3_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[2];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[3];
            UnityTexture2D _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_ParticleMask);
            float4 _UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4 = IN.uv0;
            float4 _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4 = _TilingandOffset;
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[0];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[1];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[2];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[3];
            float4 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4;
            float3 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3;
            float2 _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float, float(0), float(0), _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4, _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3, _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2);
            float4 _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4;
            float3 _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3;
            float2 _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float, float(0), float(0), _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4, _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2);
            float2 _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4.xy), _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2, _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2);
            float4 _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.tex, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.samplerstate, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_R_4_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.r;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_G_5_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.g;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_B_6_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.b;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.a;
            float _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float;
            Unity_Multiply_float_float(_Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float, _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float, _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float);
            float4 _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4);
            float _Split_12920bdaccef158ab9bd191cc9e45c04_R_1_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[0];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_G_2_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[1];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_B_3_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[2];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[3];
            float _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float, _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float, _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float);
            float _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float = _AlphaClipThreshold;
            surface.Alpha = _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            surface.AlphaClipThreshold = _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull [_Cull]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaClipThreshold;
        float _ReadAlbedo;
        float4 _ParticleMask_TexelSize;
        float4 _TilingandOffset;
        float4 _ParticleColor;
        float4 _ParticleNormal_TexelSize;
        float _ParticleNormalScale;
        float4 _Mask_Map_TexelSize;
        float _AO_multiplier;
        float _Smoothness_multiplier;
        float Vector1_bab3a2e609c74b6baff7b028a65ce418;
        float4 _Emission_Texture_TexelSize;
        float4 _Emission_Color;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_ParticleMask);
        SAMPLER(sampler_ParticleMask);
        TEXTURE2D(_ParticleNormal);
        SAMPLER(sampler_ParticleNormal);
        TEXTURE2D(_Mask_Map);
        SAMPLER(sampler_Mask_Map);
        TEXTURE2D(_Emission_Texture);
        SAMPLER(sampler_Emission_Texture);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_b4e0c30cf01756839030a5167b089dc6_Out_0_Boolean = _ReadAlbedo;
            float4 _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4 = _ParticleColor;
            UnityTexture2D _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_ParticleMask);
            float4 _UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4 = IN.uv0;
            float4 _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4 = _TilingandOffset;
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[0];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[1];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[2];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[3];
            float4 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4;
            float3 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3;
            float2 _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float, float(0), float(0), _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4, _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3, _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2);
            float4 _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4;
            float3 _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3;
            float2 _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float, float(0), float(0), _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4, _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2);
            float2 _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4.xy), _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2, _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2);
            float4 _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.tex, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.samplerstate, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_R_4_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.r;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_G_5_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.g;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_B_6_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.b;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.a;
            float4 _Multiply_ffed7e4d201e2e86974f2cc3d88026b2_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4, _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4, _Multiply_ffed7e4d201e2e86974f2cc3d88026b2_Out_2_Vector4);
            float4 _Branch_ef8236ada61be1869b3278db6ae02537_Out_3_Vector4;
            Unity_Branch_float4(_Property_b4e0c30cf01756839030a5167b089dc6_Out_0_Boolean, _Multiply_ffed7e4d201e2e86974f2cc3d88026b2_Out_2_Vector4, _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4, _Branch_ef8236ada61be1869b3278db6ae02537_Out_3_Vector4);
            float4 _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4);
            float4 _Multiply_3c7c94a1a6e2c08786b9b70a13b426fa_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Branch_ef8236ada61be1869b3278db6ae02537_Out_3_Vector4, _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4, _Multiply_3c7c94a1a6e2c08786b9b70a13b426fa_Out_2_Vector4);
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_R_1_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[0];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_G_2_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[1];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_B_3_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[2];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[3];
            float _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float;
            Unity_Multiply_float_float(_Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float, _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float, _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float);
            float _Split_12920bdaccef158ab9bd191cc9e45c04_R_1_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[0];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_G_2_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[1];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_B_3_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[2];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[3];
            float _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float, _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float, _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float);
            float _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float = _AlphaClipThreshold;
            surface.BaseColor = (_Multiply_3c7c94a1a6e2c08786b9b70a13b426fa_Out_2_Vector4.xyz);
            surface.Alpha = _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            surface.AlphaClipThreshold = _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Universal 2D"
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaClipThreshold;
        float _ReadAlbedo;
        float4 _ParticleMask_TexelSize;
        float4 _TilingandOffset;
        float4 _ParticleColor;
        float4 _ParticleNormal_TexelSize;
        float _ParticleNormalScale;
        float4 _Mask_Map_TexelSize;
        float _AO_multiplier;
        float _Smoothness_multiplier;
        float Vector1_bab3a2e609c74b6baff7b028a65ce418;
        float4 _Emission_Texture_TexelSize;
        float4 _Emission_Color;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_ParticleMask);
        SAMPLER(sampler_ParticleMask);
        TEXTURE2D(_ParticleNormal);
        SAMPLER(sampler_ParticleNormal);
        TEXTURE2D(_Mask_Map);
        SAMPLER(sampler_Mask_Map);
        TEXTURE2D(_Emission_Texture);
        SAMPLER(sampler_Emission_Texture);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_b4e0c30cf01756839030a5167b089dc6_Out_0_Boolean = _ReadAlbedo;
            float4 _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4 = _ParticleColor;
            UnityTexture2D _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_ParticleMask);
            float4 _UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4 = IN.uv0;
            float4 _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4 = _TilingandOffset;
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[0];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[1];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[2];
            float _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float = _Property_70516ee8ebaaa28b9d5f77232f742384_Out_0_Vector4[3];
            float4 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4;
            float3 _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3;
            float2 _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_R_1_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_G_2_Float, float(0), float(0), _Combine_13a8f7d471c16c87bba732ba638d5d14_RGBA_4_Vector4, _Combine_13a8f7d471c16c87bba732ba638d5d14_RGB_5_Vector3, _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2);
            float4 _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4;
            float3 _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3;
            float2 _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2;
            Unity_Combine_float(_Split_9e98eeb2b55b6082b367a40240ad1f5f_B_3_Float, _Split_9e98eeb2b55b6082b367a40240ad1f5f_A_4_Float, float(0), float(0), _Combine_75591f92a94419868e344fd5de21bb70_RGBA_4_Vector4, _Combine_75591f92a94419868e344fd5de21bb70_RGB_5_Vector3, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2);
            float2 _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_85147850253e5a80b9d2c8ddf437e4da_Out_0_Vector4.xy), _Combine_13a8f7d471c16c87bba732ba638d5d14_RG_6_Vector2, _Combine_75591f92a94419868e344fd5de21bb70_RG_6_Vector2, _TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2);
            float4 _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.tex, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.samplerstate, _Property_22e694d78262e38f9b1745f585f0f4b4_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_bdb45f607c204e7b80d5bc71b3d00436_Out_3_Vector2) );
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_R_4_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.r;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_G_5_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.g;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_B_6_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.b;
            float _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float = _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4.a;
            float4 _Multiply_ffed7e4d201e2e86974f2cc3d88026b2_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4, _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_RGBA_0_Vector4, _Multiply_ffed7e4d201e2e86974f2cc3d88026b2_Out_2_Vector4);
            float4 _Branch_ef8236ada61be1869b3278db6ae02537_Out_3_Vector4;
            Unity_Branch_float4(_Property_b4e0c30cf01756839030a5167b089dc6_Out_0_Boolean, _Multiply_ffed7e4d201e2e86974f2cc3d88026b2_Out_2_Vector4, _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4, _Branch_ef8236ada61be1869b3278db6ae02537_Out_3_Vector4);
            float4 _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4);
            float4 _Multiply_3c7c94a1a6e2c08786b9b70a13b426fa_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Branch_ef8236ada61be1869b3278db6ae02537_Out_3_Vector4, _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4, _Multiply_3c7c94a1a6e2c08786b9b70a13b426fa_Out_2_Vector4);
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_R_1_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[0];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_G_2_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[1];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_B_3_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[2];
            float _Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float = _Property_b7fc7bb7e8ed2c8da6489b6d9d78d3f7_Out_0_Vector4[3];
            float _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float;
            Unity_Multiply_float_float(_Split_4d25adc154b2cd889bea31041dc0b8bd_A_4_Float, _SampleTexture2D_185b79e27fa17080b89730ca7c4303ce_A_7_Float, _Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float);
            float _Split_12920bdaccef158ab9bd191cc9e45c04_R_1_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[0];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_G_2_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[1];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_B_3_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[2];
            float _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float = _Clamp_40a04c92716b499d87e45494624e46af_Out_3_Vector4[3];
            float _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_adbe396b9120628ea1a79eee1222a007_Out_2_Float, _Split_12920bdaccef158ab9bd191cc9e45c04_A_4_Float, _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float);
            float _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float = _AlphaClipThreshold;
            surface.BaseColor = (_Multiply_3c7c94a1a6e2c08786b9b70a13b426fa_Out_2_Vector4.xyz);
            surface.Alpha = _Multiply_04951b1c5969598aa7f847c67f0bab47_Out_2_Float;
            surface.AlphaClipThreshold = _Property_e23b1daac78b0a87a81cf357c01bb1c6_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}