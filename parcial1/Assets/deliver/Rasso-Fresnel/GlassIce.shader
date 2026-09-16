// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GlassIce"
{
	Properties
	{
		_IceNormal("Ice Normal", 2D) = "white" {}
		_distortion("distortion", Float) = 0.03
		_IceTint("IceTint", Color) = (0.8431373,0.9607843,1,0)
		_FresnelPower("FresnelPower", Float) = 3.5
		_FresnelScale("FresnelScale", Float) = 1
		_EdgeGlow("EdgeGlow", Color) = (0.1268838,0.8584902,0.8584906,0)
		_CenterAlpha("CenterAlpha", Float) = 0.15
		_EdgeAlpha("EdgeAlpha", Float) = 0
		_GlassSmoothness("GlassSmoothness", Float) = 0.95
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		GrabPass{ }
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _IceNormal;
		uniform float4 _IceNormal_ST;
		uniform float _distortion;
		uniform float4 _IceTint;
		uniform float4 _EdgeGlow;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _GlassSmoothness;
		uniform float _CenterAlpha;
		uniform float _EdgeAlpha;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 uv_IceNormal = i.uv_texcoord * _IceNormal_ST.xy + _IceNormal_ST.zw;
			float4 screenColor8 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( (ase_screenPosNorm).xy + ( (tex2D( _IceNormal, uv_IceNormal )).rg * _distortion ) ));
			o.Albedo = ( screenColor8 * _IceTint ).rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV13 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode13 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV13, _FresnelPower ) );
			o.Emission = ( _EdgeGlow * fresnelNode13 ).rgb;
			o.Smoothness = _GlassSmoothness;
			float lerpResult18 = lerp( _CenterAlpha , _EdgeAlpha , fresnelNode13);
			o.Alpha = lerpResult18;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
323.3333;72.66667;978.6666;620.3333;2029.547;374.0247;2.39922;True;False
Node;AmplifyShaderEditor.SamplerNode;3;-868.5579,135.7106;Inherit;True;Property;_IceNormal;Ice Normal;0;0;Create;True;0;0;0;False;0;False;-1;01db065bddd531142b3199296d4cae4d;b061ff7959cdaa3459dbb176f49a9def;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-455.8656,363.8246;Inherit;False;Property;_distortion;distortion;1;0;Create;True;0;0;0;False;0;False;0.03;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;4;-511.0331,218.1921;Inherit;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1;-1027.109,-93.51228;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;2;-593.8204,-115.6916;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-294.5719,281.9582;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-233.179,113.1893;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-545.4996,836.8685;Inherit;False;Property;_FresnelScale;FresnelScale;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-592.1213,936.3901;Inherit;False;Property;_FresnelPower;FresnelPower;3;0;Create;True;0;0;0;False;0;False;3.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-26.67333,1051.972;Inherit;False;Property;_EdgeGlow;EdgeGlow;5;0;Create;True;0;0;0;False;0;False;0.1268838,0.8584902,0.8584906,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;-67.1842,789.424;Inherit;False;Property;_IceTint;IceTint;2;0;Create;True;0;0;0;False;0;False;0.8431373,0.9607843,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;13;-245.3487,1471.676;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;131.4901,1489.125;Inherit;False;Property;_EdgeAlpha;EdgeAlpha;7;0;Create;True;0;0;0;False;0;False;0;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;8;-131.1739,473.5778;Inherit;False;Global;_GrabScreen0;Grab Screen 0;2;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;126.4685,1400.362;Inherit;False;Property;_CenterAlpha;CenterAlpha;6;0;Create;True;0;0;0;False;0;False;0.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;559.2112,1904.434;Inherit;False;Property;_GlassSmoothness;GlassSmoothness;8;0;Create;True;0;0;0;False;0;False;0.95;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;505.4874,1666.536;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;200.9913,739.6814;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;174.5628,1287.971;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1077.131,1625.385;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;GlassIce;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;3;0
WireConnection;2;0;1;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;7;0;2;0
WireConnection;7;1;6;0
WireConnection;13;2;12;0
WireConnection;13;3;11;0
WireConnection;8;0;7;0
WireConnection;18;0;16;0
WireConnection;18;1;17;0
WireConnection;18;2;13;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;15;0;14;0
WireConnection;15;1;13;0
WireConnection;0;0;10;0
WireConnection;0;2;15;0
WireConnection;0;4;19;0
WireConnection;0;9;18;0
ASEEND*/
//CHKSM=FA79EF2134F3CDE8488BED656C708F162331A0B8