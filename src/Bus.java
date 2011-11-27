/*
	
	processing-sc: A SuperCollider library for Processing.
	
	Copyright (c) 2007-2011 Daniel Jones. All rights reserved.
	http://www.erase.net/
	
	----------------------------------------------------------------------

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
	
*/

package supercollider;

import oscP5.*;
import netP5.*;

public class Bus
{
	public Server server;
	public String type;
	public int index = -1,
	           channels;

	public Bus()
	{
		this("audio", Server.local, 1);
	}

	public Bus(int channels)
	{
		this("audio", Server.local, channels);
	}

	public Bus(String type, int channels)
	{
		this("audio", Server.local, 1);
	}
	
	public Bus (String type, Server server, int channels)
	{
		this.type      = type;
		this.server    = server;
		this.channels  = channels;
		
		if (type == "control")
		{
			index = server.allocator_control_bus.alloc(channels);
//      if (index > -1)
//        trace("Allocated control bus: (" + index + ", " + channels + "c)");
//      else
//        warn("ALLOC FAILED!");
		}
		else
		{
			index = server.allocator_audio_bus.alloc(channels);
//      if (index > -1)
//        trace("Allocated audio bus: (" + index + ", " + channels + "c)");
//      else
//        warn("ALLOC FAILED!");
		}
	}
	
	public void set (String arg, float value)
	{
		if (index > -1)
		{
			OscMessage msg = new OscMessage("/c_set");
			msg.add(index);
			msg.add(arg);
			msg.add(value);
			Server.osc.send(msg, server.addr);
		}
	}
	
	public void free()
	{
		if (index < 0)
			return;
			 
		if (type == "control")
		{
			server.allocator_control_bus.free(index);
		}
		else
		{
			server.allocator_audio_bus.free(index);
		}
	}
}
