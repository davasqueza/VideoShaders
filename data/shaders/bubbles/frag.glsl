#ifdef GL_ES
precision mediump float;
#endif

// rakesh@picovico.com : www.picovico.com

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float fRadius = 0.008;

const float ySpeed = 1.25;
const float bubblePopHeight = 1.0;
const float bubbleSpreadDist = 2.0;

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void)
{
    vec2 uv = -1. + 2.0*gl_FragCoord.xy / resolution.xy;
    uv.x *=  resolution.x / resolution.y;
    
    vec3 color = vec3(0.0);

        // bubbles
    for( int i=0; i<64; i++ )
    {
            // bubble seeds
        float pha = tan(float(i)*6.+1.0)*0.5 + 0.5;
        float siz = pow( cos(float(i)*2.4+4.0) * 0.5 + ySpeed, 4.0 );
        float pox = cos(float(i)*2.55+3.1) * resolution.x / resolution.y;
        
            // buble size, position and color
        float rad = fRadius + sin(float(i))*0.12+0.29;
        vec2  pos = vec2( pox+sin(time/50.+pha+siz), -abs(bubblePopHeight)-rad + (bubbleSpreadDist+2.0*rad)
                         *mod(pha+0.1*(time/5.)*(0.2+0.8*siz),1.0)) * vec2(1.0, 1.0);
        float dis = length( uv - pos );
        vec3  col = mix( vec3(0.2, 0.5, 0.1), vec3(0.2,0.3,0.6), 0.2+0.2*sin(float(i)*sin(time*pox*0.03)+1.9));
        
            // render
        color += col.xyz *(1.- smoothstep( rad*(0.65+0.20*sin(pox*time)), rad, dis )) * (1.0 - cos(pox*time));
    }

    gl_FragColor = texture2D(texture, vertTexCoord.st) * vertColor + vec4(color,2.0);
}