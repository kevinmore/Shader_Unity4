Shader "MyShaders/6 - Texutre" {
	Properties {
		_Color ("Color Tint", Color) = (1.0,1.0,1.0,1.0)
		_MainTex ("Diffuse Texture", 2D) = "white" {}
		
		_SpecColor ("Specular Color", Color) = (1.0,1.0,1.0,1.0)
		_Shininess ("Shininess", Range (0.01, 20)) = 5
		
		_RimColor ("Rim Color", Color) = (1.0,1.0,1.0,1.0)
		_RimPower ("Rim Power", Range (0.1, 10)) = 3
		
		_Atte ("Attenuation", Range(0.01, 1.0)) = 1.0
	}
	SubShader {
		Pass {
			Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
			// pragmas
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers flash
			// user difined variables
			uniform float4 _Color;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			
			uniform float4 _SpecColor;
			uniform float _Shininess;
			
			uniform float4 _RimColor;
			uniform float _RimPower;
		
			uniform float _Atte;
			
			// Unity defined variables
			uniform float4 _LightColor0;
			
			// base input structs
			struct vertexInput{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};
			struct vertexOutput{
				float4 pos : SV_POSITION;
				float4 tex : TEXCOORD0;	
				float4 posWorld : TEXCOORD1;
				float3 normalDir : TEXCOORD2;
			};
			// vertex function
			vertexOutput vert(vertexInput v){
				vertexOutput o;
							
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.posWorld = mul(_Object2World, v.vertex);
				o.normalDir = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);
				o.tex = v.texcoord;
				
				return o;
			}
			// fragment function
			float4 frag(vertexOutput i) : COLOR
			{
				float3 normalDirection = i.normalDir;
				float3 viewDirection = normalize(_WorldSpaceCameraPos - i.posWorld.xyz);
				
				float3 lightDirection;
				float atten = _Atte;
				if (_WorldSpaceLightPos0.w == 0.0){// directional lights
				
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
					
				}else{// point lights
				
					float3 fragmentToLightSource = _WorldSpaceLightPos0.xyz - i.posWorld.xyz;
					float dist = length(fragmentToLightSource);
					atten = 1/dist;
					lightDirection = normalize(fragmentToLightSource);
				}
				
				float3 diffuseReflection = atten * _LightColor0.xyz * saturate(dot(normalDirection, lightDirection));
				float3 specularReflection = diffuseReflection * _SpecColor.rgb * pow(saturate(dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				
				// rim lighting
				float rim = 1 - saturate(dot(normalDirection, viewDirection));
				float3 rimLighting = atten * _LightColor0.xyz * _RimColor.xyz * saturate(dot(normalDirection, lightDirection)) * pow(rim, _RimPower);
				float3 lightFinal = rimLighting + diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;
				
				// texutre maps
				float4 tex = tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				
				return float4(tex.xyz * lightFinal * _Color.rgb, 1.0);	
				
			}
			ENDCG
		
		}
		
		Pass {
			Tags{"LightMode" = "ForwardAdd"}
			Blend One One
			CGPROGRAM
			// pragmas
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers flash
			
			// user difined variables
			uniform float4 _Color;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			
			uniform float4 _SpecColor;
			uniform float _Shininess;
			
			uniform float4 _RimColor;
			uniform float _RimPower;
		
			uniform float _Atte;
			
			// Unity defined variables
			uniform float4 _LightColor0;
			
			// base input structs
			struct vertexInput{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};
			struct vertexOutput{
				float4 pos : SV_POSITION;
				float4 tex : TEXCOORD0;	
				float4 posWorld : TEXCOORD1;
				float3 normalDir : TEXCOORD2;
			};
			// vertex function
			vertexOutput vert(vertexInput v){
				vertexOutput o;
							
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.posWorld = mul(_Object2World, v.vertex);
				o.normalDir = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);
				o.tex = v.texcoord;
				
				return o;
			}
			// fragment function
			float4 frag(vertexOutput i) : COLOR
			{
				float3 normalDirection = i.normalDir;
				float3 viewDirection = normalize(_WorldSpaceCameraPos - i.posWorld.xyz);
				
				float3 lightDirection;
				float atten = _Atte;
				if (_WorldSpaceLightPos0.w == 0.0){// directional lights
				
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
					
				}else{// point lights
				
					float3 fragmentToLightSource = _WorldSpaceLightPos0.xyz - i.posWorld.xyz;
					float dist = length(fragmentToLightSource);
					atten = 1/dist;
					lightDirection = normalize(fragmentToLightSource);
				}
				
				float3 diffuseReflection = atten * _LightColor0.xyz * saturate(dot(normalDirection, lightDirection));
				float3 specularReflection = diffuseReflection * _SpecColor.rgb * pow(saturate(dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				
				// rim lighting
				float rim = 1 - saturate(dot(normalDirection, viewDirection));
				float3 rimLighting = atten * _LightColor0.xyz * _RimColor.xyz * saturate(dot(normalDirection, lightDirection)) * pow(rim, _RimPower);
				float3 lightFinal = rimLighting + diffuseReflection + specularReflection;
								
				return float4(lightFinal * _Color.rgb, 1.0);	
				
			}
			ENDCG
		
		}

	} 
	//FallBack "Diffuse"
}
