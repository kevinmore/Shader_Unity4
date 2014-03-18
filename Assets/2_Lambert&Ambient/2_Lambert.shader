Shader "MyShaders/2 - Lambert" {
	Properties {
		_Color ("Choose Color", Color) = (1.0,1.0,1.0,1.0)
	}
	SubShader {
		Pass {
			Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
			// pragmas
			#pragma vertex vert
			#pragma fragment frag
			
			// user difined variables
			uniform float4 _Color;
			
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
				float attenuation = 1.0;
				float3 normalDirection = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				float3 diffuseReflection = attenuation * _LightColor0.xyz * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));
				
				
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.col = float4(diffuseReflection, 1.0);
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
