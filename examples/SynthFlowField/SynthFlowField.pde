/*
 * SynthFlowField: A windy particle storm.
 * Before using, start SC server and load the included SynthDefs. 
 *
 * Click to add more particles.
 *
 * Part of the SuperCollider for Processing distribution.
 *   <http://www.erase.net/projects/processing-sc/>
 *
 * This program can be freely distributed and modified under the
 * terms of the GNU General Public License version 2.
 *   <http://www.gnu.org/copyleft/gpl.html> 
 *
 *--------------------------------------------------------------*/
 
import processing.opengl.*;
import supercollider.*;
import oscP5.*;

int cellSize = 40;
int cellsX = 28;
int cellsY = 18;

int particle_count = 0;
Particle particles[];
FlowField field;
Synth reverb;

void setup()
{
  size(cellSize * cellsX, cellSize * cellsY, OPENGL);
  field = new FlowField(cellsX, cellsY);
  
  particles = new Particle[256];
  frameRate(25);
  
  for (int i = 0; i < 2; i++)
    particles[particle_count++] = new Particle(i, random(width), random(height));
  
  colorMode(HSB, 1);
  
  reverb = new Synth("fx_rev_gverb");
  reverb.set("wet", 1.0);
  reverb.set("reverbtime", 1.5);
  reverb.set("damp", 0.4);
  reverb.addToTail();
}


void draw()
{
  w_inertia = map(mouseX, 0, width, 0.8, 1.0);
  field.noiseScale = map(mouseY, 0, height, 0.01, 0.5);
  
  // move particles
  for (int i = 0; i < particle_count; i++)
    particles[i].move();

  field.draw();
  
  // draw particles
  for (int i = 0; i < particle_count; i++)
    particles[i].draw();
  
  field.step();
}

void exit()
{
  // stop synths
  for (int i = 0; i < particle_count; i++)
    particles[i].stop();
  
  reverb.free();
  super.exit();
}

void mousePressed()
{
  particles[particle_count] = new Particle(particle_count++, mouseX, mouseY);
}

void mouseDragged()
{
  particles[particle_count] = new Particle(particle_count++, mouseX, mouseY);
}
