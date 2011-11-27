/*
 * SynthVideoFilter: Video-controlled Moog filter
 * Before using, start SC server and load the included SynthDef. 
 *
 * Treats 8 vertical bands from a video capture device as cutoff
 * frequencies for 8 Moog filters.
 *
 * Part of the SuperCollider for Processing distribution.
 *   <http://www.erase.net/projects/processing-sc/>
 *
 * This program can be freely distributed and modified under the
 * terms of the GNU General Public License version 2.
 *   <http://www.gnu.org/copyleft/gpl.html> 
 *
 *--------------------------------------------------------------*/
 
import processing.video.*;
import supercollider.*;
import oscP5.*;

Capture video;

int res = 8;
Synth [] synths;

float fundamental = 40;

void setup()
{
  size(800, 600);
  frameRate(50);
  noStroke();

  video = new Capture(this, res, 1);
  
  synths = new Synth[res];
  
  for (int x = 0; x < res; x++)
  {
    Synth synth = new Synth("moogsaw");
    synth.set("amp", 1.0 / res);
    synth.set("freq", fundamental * (x + 1) * random(0.99, 1.01));
    synth.set("pan", map(x, 0, 9, -1, 1));
    synth.create();
    
    synths[x] = synth;
  }
}

/*
 * Map mouse X position to the fundamental frequency.
 *--------------------------------------------------------------*/
void mouseMoved()
{
  for (int x = 0; x < res; x++)
  {
    float mx = map(mouseX, 0, width, 35, 80);
    synths[x].set("freq", mx * (x + 1) * random(0.99, 1.01));
  }
}

void draw()
{
  if (!video.available())
    return;

  video.read();
  
  int wx = width / res;
  
  for (int x = 0; x < res; x++)
  {
    color c = video.pixels[x];
    fill(c);
    
    rect(x * wx, 0, (x + 1) * wx, height);
    
    float b = brightness(c);
    b = map(b, 0, 256, 40, 4000);
    synths[x].set("cutoff", b);
  }
}

void exit()
{
  for (int x = 0; x < res; x++)
    synths[x].free();
    
  super.exit();
}

