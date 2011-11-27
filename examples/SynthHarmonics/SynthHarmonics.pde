/*
 * SynthHarmonics: Mass additive synthesis using particle movements.
 * Before using, start SC server and load the included SynthDef.
 *
 * Press the mouse button to generate new velocities. Uses OpenGL
 * for pretty texture-based alpha blending.
 *
 * Working out how the harmonics interact is left as an exercise
 * to the reader...
 *
 * Part of the SuperCollider for Processing distribution.
 *   <http://www.erase.net/projects/processing-sc/>
 *
 * This program can be freely distributed and modified under the
 * terms of the GNU General Public License version 2.
 *   <http://www.gnu.org/copyleft/gpl.html> 
 *
 *-------------------------------------------------------------------*/

import supercollider.*;
import oscP5.*;

import processing.opengl.*;
import javax.media.opengl.*;
PGraphicsOpenGL pgl;
GL gl;

Particle [] particles;
Texture white, yellow;

void setup()
{
  size(800, 600, OPENGL);
  colorMode(RGB, 1);
  smooth();
  background(0.2, 0.2, 0.2);
  Server.init();
  
  initGL();
  
  white  = loadTexture("white.png");
  yellow = loadTexture("orange.png");
  
  particles = new Particle[10];
  
  for (int i = 0; i < particles.length; i++)
    particles[i] = new Particle();

  for (int i = 0; i < particles.length; i++)
    particles[i].init();
}

void draw()
{
  background(0.2, 0.1, 0.14);
  
  initGLdraw();

  pgl.beginGL();
  
  for (int i = 0; i < particles.length; i++)
    particles[i].move();
  
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE_MINUS_SRC_ALPHA);
  renderImage(width * 0.7, height * 0.9, 0, width * 1.5, color(1, 1, 1), 0.1);
  
  pgl.endGL();
}

void exit()
{
  for (int i = 0; i < particles.length; i++)
    particles[i].stop();
  super.exit();
}

void mousePressed()
{
  for (int i = 0; i < particles.length; i++)
  {
    particles[i].vx = random(-1, 1);
    particles[i].vy = random(-1, 1);
    particles[i].partial = floor(random(1, random(1, 40)));
  }
}
