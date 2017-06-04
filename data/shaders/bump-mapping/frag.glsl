/*
	Andor Salga
	April 2015
	Normal Mapping demo
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 iResolution;
uniform vec3 iCursor;

uniform sampler2D diffuseMap;
uniform sampler2D normalMap;

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0);

void main(){
	vec2 uv = vec2(gl_FragCoord.xy / 512.0);
	
	// should we do this in pjs?
	uv.y = 1.0 - uv.y;

	vec2 p = vec2(gl_FragCoord);

	float mx = p.x - iCursor.x;
	float my = p.y - (iResolution.y - iCursor.y);
	float mz = 500.0;

	// use point light
	vec3 rayOfLight = normalize(vec3(mx, my, mz));

	// TODO: comment
	
	
	
	
	
	
	vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s, -texOffset.t);
	  vec2 tc1 = vertTexCoord.st + vec2(         0.0, -texOffset.t);
	  vec2 tc2 = vertTexCoord.st + vec2(+texOffset.s, -texOffset.t);
	  vec2 tc3 = vertTexCoord.st + vec2(-texOffset.s,          0.0);
	  vec2 tc4 = vertTexCoord.st + vec2(         0.0,          0.0);
	  vec2 tc5 = vertTexCoord.st + vec2(+texOffset.s,          0.0);
	  vec2 tc6 = vertTexCoord.st + vec2(-texOffset.s, +texOffset.t);
	  vec2 tc7 = vertTexCoord.st + vec2(         0.0, +texOffset.t);
	  vec2 tc8 = vertTexCoord.st + vec2(+texOffset.s, +texOffset.t);
	  
	  vec4 col0 = texture2D(texture, tc0);
	  vec4 col1 = texture2D(texture, tc1);
	  vec4 col2 = texture2D(texture, tc2);
	  vec4 col3 = texture2D(texture, tc3);
	  vec4 col4 = texture2D(texture, tc4);
	  vec4 col5 = texture2D(texture, tc5);
	  vec4 col6 = texture2D(texture, tc6);
	  vec4 col7 = texture2D(texture, tc7);
	  vec4 col8 = texture2D(texture, tc8);

	  vec4 sum = 8.0 * col4 - (col0 + col1 + col2 + col3 + col5 + col6 + col7 + col8); 
	
	vec3 normal = sum.rgb;
	normal = normalize(normal);

	float nDotL = max(0.0, dot(rayOfLight, normal));
	vec3 reflection = normal * (2.0 * (nDotL)) - rayOfLight;

	vec3 col = vec3(texture2D(diffuseMap, uv)) * nDotL;

	gl_FragColor = vec4(col, 1.0);
}
