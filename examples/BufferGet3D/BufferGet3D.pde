/*
 * BufferGet3D: Live visualization of the current sound input.
 * Before using, start SC server and load the included SynthDef.
 *
 * Continuously transfers audio data from the default sound input
 * device via SuperCollider buffers. 
 *
 * Part of the SuperCollider for Processing distribution.
 *   <http://www.erase.net/projects/processing-sc/>
 *
 * This program can be freely distributed and modified under the
 * terms of the GNU General Public License version 2.
 *   <http://www.gnu.org/copyleft/gpl.html> 
 *
 *-------------------------------------------------------------------*/
 
import processing.opengl.*;

import supercollider.*;
import oscP5.*;

Buffer buffer;
Synth synth;
float [][] history;
int history_pos = 0;
int xres = 4,
    yres = 16;
boolean got_data = false;

void setup ()
{
  size(1024, 600, OPENGL);
  
  colorMode(HSB, 1.0);
  background(0);
  stroke(1);
  frameRate(20);
  
  buffer = new Buffer(256, 1);
  buffer.alloc(this, "done");
  
  history = new float[48][width / xres];
}

void draw ()
{
  buffer.getn(0, buffer.frames, this, "getn");
  
  // draw
  background(0);
  stroke(1);
  strokeWeight(1.0);
  noFill();
  
  translate(0, -height / 4.0, -500);
  rotateX(PI / 4.5);
  
  int hip = history_pos;

  // also try LINES, TRIANGLES, or QUAD_STRIP  
  int shapeType = QUADS;
  
  for (int h = 1; h < history.length; h++)
  {
    int hi = (history_pos + h) % (history.length);
    for (int i = 0; i < (width / xres) - 1; i++)
    {
      float ratio = ((float) h / history.length);
      stroke(0.4, 1 - ratio, 0.8 * ratio, ratio);
      beginShape(shapeType);
      vertex(i * xres, h * yres, history[hi][i] * 200.0);
      vertex(i * xres + xres, h * yres, history[hi][i + 1] * 200.0);
      vertex(i * xres + xres, (h - 1) * yres, history[hip][i + 1] * 200.0);
      vertex(i * xres, (h - 1) * yres, history[hip][i] * 200.0);
      endShape();
    }
    hip = hi;
  }
}

void done (Buffer buffer)
{
  synth = new Synth("recordbuf_1");
  synth.set("bufnum", buffer.index);
  synth.set("loop", 1);
  synth.create();
}

void getn (Buffer buffer, int index, float [] values)
{
  for (int i = 0; i < values.length; i++)
  {
    history[history_pos][i] = values[i];
  }
  
  if (++history_pos >= history.length)
     history_pos = 0;
}

void exit()
{
  buffer.free();
  synth.free();
  super.exit();
}
