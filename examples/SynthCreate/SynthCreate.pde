/*
 * SynthCreate: Create a synth, map frequency to mouse position. 
 * Before using, start SC server and load the included SynthDefs
 * (see the "SynthDef" tab above) 
 *
 * The "Hello World" of SuperCollider for Processing.
 *
 * Note the "stop" method, called when ESC is pressed, which
 * frees the synth on the server-side.
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

Synth synth;

void setup ()
{
    size(800, 200);

    // uses default sc server at 127.0.0.1:57110    
    // does NOT create synth!
    synth = new Synth("sine");
    
    // set initial arguments
    synth.set("amp", 0.5);
    synth.set("freq", 80);
    
    // create synth
    synth.create();
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

void exit()
{
    synth.free();
    super.exit();
}
