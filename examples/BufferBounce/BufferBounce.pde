/*
 * BufferBounce: Fill a buffer with a bouncing ball.
 * Before using, start SC server and load the included SynthDef. 
 *
 * Press the mouse button to pull the ball towards the cursor.
 *
 * Part of the SuperColider for Processing distribution:
 *   <http://www.erase.net/projects/processing-sc/>
 *
 * This program can be freely distributed and modified under the
 * terms of the GNU General Public License version 2.
 *   <http://www.gnu.org/copyleft/gpl.html> 
 *
 *-------------------------------------------------------------------*/

import supercollider.*;
import oscP5.*;

float bx = width / 2,
      by = height / 2,
      vx = 0,
      vy = 0;

Buffer buffer;
Synth synth;

int [] samples;

void setup()
{  
  size(1024, 512);
  frameRate(25);
  smooth();
  
  samples = new int[width];
  
  buffer = new Buffer(width, 1);
  buffer.alloc(this, "allocated");
  
  vx = random(-10, 10);
  vy = random(-10, 10);
}

void allocated (Buffer buffer)
{
  buffer.zero();
  
  synth = new Synth("playbuf_1");
  synth.set("loop", 1);
  synth.set("bufnum", buffer.index);
  synth.create();
}

void exit()
{
  synth.free();
  buffer.free();
  super.exit();
}

void draw()
{
  background(0);
  fill(255);
  noStroke();
  
  // update position based on velocity
  bx += vx;
  by += vy;
  
  // bounce
  if (bx > width - 1)   { bx = width - 1; vx = -vx; }
  if (bx < 0)           { bx = 0; vx = -vx; }
  if (by > height - 1)  {  by = height - 1; vy = -vy; }
  if (by < 0)           { by = 0; vy = 0 - vy; }
  
  // press the mouse to drag the point towards you
  if (mousePressed)
  {
    vx += (mouseX - bx) * 0.001;
    vy += (mouseY - by) * 0.001;
  }
  
  buffer.fill((int) bx, (int) abs(vx + 1), (2.0 * by / height) - 1.0);

  for (int i = 0; (i < abs(vx + 1)) && (bx + i < width - 1); i++)
    samples[(int) bx + i] = (int) by;
  
  for (int i = 0; i < samples.length; i++)
  {
    stroke(150);
    point(i, samples[i]);
  }
  
  if (synth != null)
  {
    float velocity = dist(0, 0, vx, vy);
    synth.set("pan", (float) bx / width - 0.5);
    synth.set("rate", (float) 0.1 + 0.2 * velocity);
  }
  ellipse(bx, by, 3, 3);
}
