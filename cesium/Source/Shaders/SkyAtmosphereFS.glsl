/**
 * @license
 * Copyright (c) 2000-2005, Sean O'Neil (s_p_oneil@hotmail.com)
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * * Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * * Neither the name of the project nor the names of its contributors may be
 *   used to endorse or promote products derived from this software without
 *   specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Modifications made by Analytical Graphics, Inc.
 */
 
 // Code:  http://sponeil.net/
 // GPU Gems 2 Article:  http://http.developer.nvidia.com/GPUGems2/gpugems2_chapter16.html
 
const float g = -0.95;
const float g2 = g * g;

uniform float fCameraHeight;
uniform float fInnerRadius;

varying vec3 v_rayleighColor;
varying vec3 v_mieColor;
varying vec3 v_toCamera;
varying vec3 v_positionEC;

void main (void)
{
    // TODO: make arbitrary ellipsoid
    czm_ellipsoid ellipsoid = czm_getWgs84EllipsoidEC();
    
    vec3 direction = normalize(v_positionEC);
    czm_ray ray = czm_ray(vec3(0.0), direction);
    
    if (fCameraHeight > fInnerRadius) {
	    //czm_raySegment intersection = czm_rayEllipsoidIntersectionInterval(ray, ellipsoid);
	    //if (!czm_isEmpty(intersection)) {
	    //    discard;
	    //}
	} else {
	    // The ellipsoid test above will discard fragments when the ray origin is
	    // inside the ellipsoid.
	    vec3 radii = ellipsoid.radii;
	    float maxRadius = max(radii.x, max(radii.y, radii.z));
	    vec3 ellipsoidCenter = czm_modelView[3].xyz;
	    
	    float t1 = -1.0;
	    float t2 = -1.0;
	    
	    float b = -2.0 * dot(direction, ellipsoidCenter);
	    float c = dot(ellipsoidCenter, ellipsoidCenter) - maxRadius * maxRadius;
	
	    float discriminant = b * b - 4.0 * c;
	    if (discriminant >= 0.0) {
	        t1 = (-b - sqrt(discriminant)) * 0.5;
	        t2 = (-b + sqrt(discriminant)) * 0.5;
	    }
	    
	    if (t1 < 0.0 && t2 < 0.0) {
	        // The ray through the fragment intersected the sphere approximating
	        // the ellipsoid behind the ray origin.
	        discard;
	    }
    }
    
    // Extra normalize added for Android
    float fCos = dot(czm_sunDirectionWC, normalize(v_toCamera)) / length(v_toCamera);
    float fRayleighPhase = 0.75 * (1.0 + fCos*fCos);
    float fMiePhase = 1.5 * ((1.0 - g2) / (2.0 + g2)) * (1.0 + fCos*fCos) / pow(1.0 + g2 - 2.0*g*fCos, 1.5);
    
    const float fExposure = 2.0;
    
    vec3 rgb = fRayleighPhase * v_rayleighColor + fMiePhase * v_mieColor;
    rgb = vec3(1.0) - exp(-fExposure * rgb);
    float l = czm_luminance(rgb);
    gl_FragColor = vec4(rgb, min(smoothstep(0.0, 1.0, l), 1.0) * smoothstep(0.0, 1.0, czm_morphTime));
}
