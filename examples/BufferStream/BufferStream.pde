/*
 * BufferStream: Uses cueSoundFile to stream a file from disk.
 *
 * This example courtesy of Antoine Schmitt:
 *
 *   http://www.schmittmachine.com/
 *   http://www.gratin.org/as
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

Buffer buffer;
Synth synth;

void setup ()
{
  buffer = new Buffer(32768, 1); // must set a size for cueSoundFile
  buffer.cueSoundFile("sounds/a11wlk01-44_1.aiff", this, "cued");
}

void draw ()
{
}

void cued (Buffer buf)
{
  println("Buffer loaded.");
  println("Channels:    " + buffer.channels);
  println("Frames:      " + buffer.frames);
  println("Sample Rate: " + buffer.sampleRate);
  
  synth = new Synth("help-Diskin_1");
  synth.set("bufnum", buffer.index);
  synth.create();
}

void exit()
{
  if (synth != null)
    synth.free();

  if (buffer != null)
  {
    buffer.close(); // very important
    buffer.free();
  }
  
  super.exit();
}

