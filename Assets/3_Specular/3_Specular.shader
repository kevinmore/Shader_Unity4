Shader "MyShaders/3 - Specular" {
	Properties {
		_Color ("Main Color", Color) = (1.0,1.0,1.0,1.0)
		_SpecColor ("Specular Color", Color) = (1.0,1.0,1.0,1.0)
		_Shininess ("Shininess", Range (0.01, 20)) = 10
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
			uniform float4 _SpecColor;
			uniform float _Shininess;
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
				float3 viewDirection = normalize((_WorldSpaceCameraPos - (mul(_Object2World, v.vertex))).xyz);
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				
				float3 diffuseReflection = _Atte * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
				float3 specularReflection = _Atte * _LightColor0.xyz * _SpecColor.rgb * max(0.0, dot(normalDirection, lightDirection)) * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				
				float3 lightFinal = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;
				
				
				o.col = float4(lightFinal * _Color.rgb, 1.0);				
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
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
