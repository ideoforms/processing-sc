/*
 * SynthDraw: Drawing with sine waves.
 * Before using, start SC server and load the included SynthDefs.
 *
 * Press the mouse button and draw on screen. 
 * Note the use of a Bus object to connect together two Synths
 *  - and notice that the delay line is created using addToTail(),
 * which adds the delay effect after the sines in the processing
 * chain. Otherwise, the delay will be reading and outputting silence.
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

Synth synth, delay;
Bus delaybus;

void setup()
{
  size(1200, 800);
  frameRate(30);
  
  delaybus = new Bus("audio", 2);
  
  synth = new Synth("sine_double");
  synth.set("amp", 0.0);
  synth.set("outbus", delaybus.index);
  synth.create();

  delay = new Synth("fx_comb");
  delay.set("wet", 0.5);
  delay.set("delaytime", 0.05);
  delay.set("inbus", delaybus.index);

  delay.addToTail();
}

void draw()
{
  noStroke();
  fill(30, 20);
  rect(0, 0, width, height);
  
  if (mousePressed)
  {
    stroke(255);
    strokeWeight(random(10));
    line(mouseX, mouseY, pmouseX, pmouseY);
    synth.set("amp", 0.5);
    synth.set("freqx", linexp(mouseX, 0, width, 100, 2000));
    synth.set("freqy", linexp(mouseY, 0, height, 2000, 100));
    synth.set("pan", map(mouseX, 0, width, -1, 1));
  }
  else
  {
    synth.set("amp", 0.0);
  }
}

float linexp (float x, float a, float b, float c, float d)
{
  if (x <= a) return c;
  if (x >= b) return d;
  return pow(d/c, (x-a)/(b-a)) * c;
}

void exit()
{
  synth.free();
  delay.free();
  delaybus.free();
  super.exit();
}
