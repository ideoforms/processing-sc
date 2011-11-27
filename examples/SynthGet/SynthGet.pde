/*
 * SynthGet: Demonstrates the get() method.
 * Before using, start SC server and load the included SynthDef. 
 *
 * Identical to SynthCreate, but pulls the current frequency from
 * the SC server when the mouse button is pressed.
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

Group group;
Synth synth;

void setup ()
{
    size(800, 200);
    
    group = new Group();
    group.create();

    // uses default sc server at 127.0.0.1:57110    
    // does NOT create synth!
    synth = new Synth("sine");
    
    // set initial arguments
    synth.set("amp", 0.5);
    synth.set("freq", 80);
    
    // create synth
    synth.addToTail(group);
}

void draw ()
{
    background(0);
    stroke(255);
    line(mouseX, 0, mouseX, height);
}

void mouseMoved ()
{
    synth.set("freq", 40 + (mouseX * 3)); 
}

void mousePressed ()
{
  synth.get("freq", this, "show");
}

void show (int nodeID, String arg, float value)
{
  println("frequency: " + value);
}

void exit()
{
    synth.free();
    group.free();
    super.exit();
}
