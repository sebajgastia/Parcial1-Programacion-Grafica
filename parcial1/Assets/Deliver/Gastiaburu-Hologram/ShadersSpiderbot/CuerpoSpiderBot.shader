// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CuerpoSpiderBot"
{
	Properties
	{
		_Frecuencia2("Frecuencia 2", Range( 0 , 50)) = 15
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _Frecuencia2;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color6 = IsGammaSpace() ? float4(0.1792453,0.1680847,0.1680847,0) : float4(0.02700252,0.02401715,0.02401715,0);
			float4 color7 = IsGammaSpace() ? float4(0.6037736,0.09910998,0.1035761,0) : float4(0.3229691,0.009885255,0.0105868,0);
			float3 ase_worldPos = i.worldPos;
			float4 appendResult14 = (float4(( frac( ( ase_worldPos.x * _Frecuencia2 ) ) - 0.5 ) , ( frac( ( ase_worldPos.y * _Frecuencia2 ) ) - 0.5 ) , 0.0 , 0.0));
			float temp_output_5_0 = step( length( appendResult14 ) , 0.5 );
			float4 lerpResult8 = lerp( color6 , color7 , temp_output_5_0);
			o.Albedo = lerpResult8.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
389.6;73.6;1173.2;577.4;1566.63;401.3678;1.640803;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1315.969,-58.07257;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;3;-1323.748,92.16694;Inherit;False;Property;_Frecuencia2;Frecuencia 2;0;0;Create;True;0;0;0;False;0;False;15;15;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-990.377,-96.44379;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-997.705,38.91444;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;4;-841.6492,-57.95879;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;11;-881.152,148.8706;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;12;-750.305,-209.5858;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-729.4125,58.70634;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-522.6965,42.21302;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LengthOpNode;15;-324.7757,45.51175;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-35.17673,-206.527;Inherit;False;Constant;_ColorVeta;ColorVeta;0;0;Create;True;0;0;0;False;0;False;0.6037736,0.09910998,0.1035761,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;116.4516,-399.7179;Inherit;False;Constant;_Colorbase;Color base;0;0;Create;True;0;0;0;False;0;False;0.1792453,0.1680847,0.1680847,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;5;-121.859,42.85765;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;8;284.0389,5.636184;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;263.2542,171.1496;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;635.7001,-78.95089;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;CuerpoSpiderBot;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;1
WireConnection;2;1;3;0
WireConnection;10;0;1;2
WireConnection;10;1;3;0
WireConnection;4;0;2;0
WireConnection;11;0;10;0
WireConnection;12;0;4;0
WireConnection;13;0;11;0
WireConnection;14;0;12;0
WireConnection;14;1;13;0
WireConnection;15;0;14;0
WireConnection;5;0;15;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;8;2;5;0
WireConnection;9;0;5;0
WireConnection;9;1;7;0
WireConnection;0;0;8;0
ASEEND*/
//CHKSM=435882ED6B0656D3110014BACD5C6AC60612647D