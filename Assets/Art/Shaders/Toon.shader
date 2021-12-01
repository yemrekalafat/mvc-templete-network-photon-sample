// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Toon"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_ColorMultiply("Color Multiply", Color) = (1,1,1,0)
		_HighlightSpeed("Highlight Speed", Float) = 1
		[Toggle(_HIGHLIGHTONOFF_ON)] _HighlightONOFF("Highlight ON/OFF", Float) = 0
		_HighlightColor("Highlight Color", Color) = (0.5,0.5,0.5,0)
		[Toggle(_SOLIDCOLORONOFF_ON)] _SolidColorONOFF("Solid Color ON/OFF", Float) = 0
		_SolidColor("Solid Color", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend One OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _HIGHLIGHTONOFF_ON
		#pragma shader_feature_local _SOLIDCOLORONOFF_ON
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			float3 worldPos;
		};

		uniform float4 _ColorMultiply;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _SolidColor;
		uniform float4 _HighlightColor;
		uniform float _HighlightSpeed;

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 color6 = IsGammaSpace() ? float4(0.15,0.15,0.15,0) : float4(0.01960665,0.01960665,0.01960665,0);
			o.Albedo = color6.rgb;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode11 = tex2D( _MainTex, uv_MainTex );
			float grayscale92 = Luminance(tex2DNode11.rgb);
			float4 temp_cast_2 = (grayscale92).xxxx;
			float4 blendOpSrc94 = _SolidColor;
			float4 blendOpDest94 = temp_cast_2;
			#ifdef _SOLIDCOLORONOFF_ON
				float4 staticSwitch95 = (( blendOpDest94 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest94 ) * ( 1.0 - blendOpSrc94 ) ) : ( 2.0 * blendOpDest94 * blendOpSrc94 ) );
			#else
				float4 staticSwitch95 = ( _ColorMultiply * tex2DNode11 );
			#endif
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult19 = dot( ase_worldNormal , ase_worldlightDir );
			float4 temp_output_34_0 = ( staticSwitch95 * ( 1.0 - ( step( dotResult19 , 0.0 ) * 0.1 ) ) );
			float4 color81 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float mulTime87 = _Time.y * _HighlightSpeed;
			float4 lerpResult84 = lerp( color81 , _HighlightColor , (sin( mulTime87 )*0.5 + 0.5));
			#ifdef _HIGHLIGHTONOFF_ON
				float4 staticSwitch89 = ( temp_output_34_0 + lerpResult84 );
			#else
				float4 staticSwitch89 = temp_output_34_0;
			#endif
			o.Emission = staticSwitch89.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Lambert keepalpha fullforwardshadows exclude_path:deferred 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
