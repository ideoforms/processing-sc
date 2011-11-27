/*
 * BufferDraw: Draw a buffer to play back in SC.
 *
 * Data drawn onscreen is copied dynamically to a SC buffer object by
 * the "set" method. Note the use of alloc() / allocated() to 
 * create buffer and only begin playback once it has been allocated
 * by the SC server.
 *
 * Part of the SuperCollider for Processing distribution.
 *   <http://www.erase.net/projects/processing-sc/>
 *
 * This program can be freely distributed and modified under the
 * terms of the GNU General Public License version 2.
 *   <http://www.gnu.org/copyleft/gpl.html> 
 *
 *----------------------------------------------------------------------*/

import supercollider.*;
import oscP5.*;

float[] samples;
Buffer buffer;
Synth synth;
int prevX = -1,
    prevY = -1;

void setup ()
{
  // 1 pixel = 1 sample
  //  - vary the sketch width to alter fundamental frequency.
  size(512, 256);
  
  smooth();
  frameRate(30);
  
  // init with a sine wave
  samples = new float[width];
  for (int i = 0; i < width; i++)
    samples[i] = sin(TWO_PI * i / width);
  
  // allocate a 1-channel buffer
  buffer = new Buffer(width, 1);
  buffer.alloc(this, "allocated");
}

void allocated (Buffer buffer)
{
  // when buffer allocation is complete, zero the buffer and
  // begin playback with a synth object.
  buffer.setn(0, width, samples);
  
  println("allocated");
  synth = new Synth("playbuf_1");
  synth.set("loop", 1);
  synth.set("bufnum", buffer.index);
  synth.create(); 
}

void draw ()
{
  background(20);
  stroke(255);
  for (int i = 0; i < samples.length; i++)
  {
    point(i, (height * 0.5) + (0.5 * height * samples[i]));
  }
  if (!mousePressed)
  {
    prevX = -1;
    prevY = -1;
  }
  else {
    prevX = mouseX;
    prevY = mouseY;
  }
}

void exit()
{
  buffer.free();
  synth.free();
  super.exit();
}

void mouseDragged ()
{
  if ((mouseX >= 0) && (mouseX < width) && (prevX < width))
  {
    samples[mouseX] = (2.0 * mouseY / height) - 1.0;
    if ((prevX > -1) && (prevX != mouseX))
    {
      // Linear interpolation between values - prevents gaps.
      float curY = prevY;
      float stepY = ((float) mouseY - prevY) / abs((float) mouseX - prevX);
      int stepX = (mouseX > prevX) ? 1 : -1;
      
      for (int i = 0; i < abs(mouseX - prevX); i++)
      {
        samples[prevX + (i * stepX)] = (2.0 * curY / height) - 1.0;
        curY += stepY;
      }
    }
    
    buffer.setn(0, width, samples);
  }
}

