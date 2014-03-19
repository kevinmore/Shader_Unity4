Shader "MyShaders/2 - Ambient" {
	Properties {
		_Color ("Main Color", Color) = (1.0,1.0,1.0,1.0)
		_Atte ("Attenuation", Range(0.01, 1.0)) = 1.0
	}
	SubShader {
		Tags{"LightMode" = "ForwardBase"}
		Pass {
			CGPROGRAM
			// pragmas
			#pragma vertex vert
			#pragma fragment frag
			
			// user difined variables
			uniform float4 _Color;
			uniform float _Atte;
			
			// Unity defined variables
			uniform float4 _LightColor0;
			
			// base input structs
			struct vertexInput{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			struct vertexOutput{
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};
			// vertex function
			vertexOutput vert(vertexInput v){
				vertexOutput o;
				
				float3 normalDirection = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				float3 diffuseReflection = _Atte * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
				float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;
				
				
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.col = float4(lightFinal * _Color.rgb, 1.0);
				return o;
			}
			// fragment function
			float4 frag(vertexOutput i) : COLOR
			{
				return i.col;
			}
			ENDCG
		
		}

	} 
	//FallBack "Diffuse"
}
