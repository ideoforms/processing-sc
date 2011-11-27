/*
	
	processing-sc: A SuperCollider library for Processing.org
	
	Copyright (c) 2007-2011 Daniel Jones. All rights reserved.
	http://www.erase.net/
	
	----------------------------------------------------------------------

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
	
*/

package supercollider;

import java.util.Hashtable;
import java.util.Enumeration;

import oscP5.*;
import netP5.*;

public class Synth extends Node
{
	public String synthname;

	public boolean created = false;
	
	Hashtable args;

	public Synth()
	{
		this("sine");
	}
	
	public Synth(String synthname)
	{
		this.synthname = synthname;
		args = new Hashtable();
		
		this.server = Server.local;
		this.group = server.default_group;
	}

	public Synth (String synthname, Server server)
	{
		this.synthname = synthname;		
		this.server = server;
		this.group = server.default_group;

		args = new Hashtable();
	}
	
	public Synth (String synthname, Group group)
	{
		this.synthname = synthname;
		this.group = group;
		this.server = group.server;
	}


	
	public void create (int position, int group)
	{
		nodeID = Synth.nodeID_base++;

		OscBundle bundle = new OscBundle();

		OscMessage msg = new OscMessage("/s_new");
		msg.add(synthname);
		msg.add(nodeID);
		msg.add(position);
		msg.add(group);
		bundle.add(msg);

		for (Enumeration e = args.keys(); e.hasMoreElements();)
		{
			String key = (String) e.nextElement();
			Object obj = args.get(key);
			msg.clear();
			msg.setAddrPattern("/n_set");
			msg.add(nodeID);
			msg.add(key);
			
			try
			{
				Class thisClass = obj.getClass();
				
				if (thisClass == Class.forName("java.lang.Float"))
					msg.add(((Float) obj).floatValue()); 
				else if (thisClass == Class.forName("java.lang.Integer"))
					msg.add(((Integer) obj).intValue());
				else if (thisClass == Class.forName("java.lang.String"))
					msg.add((String) obj);
			} 
			catch (Exception ex)
			{ 
//				println("EXCEPTION: " + ex);
			}

			bundle.add(msg);
		}

		bundle.setTimetag((long) (bundle.now() + server.latency * 1000.0));
		Server.osc.send(bundle, server.addr);

		created = true;
	}

	public void set (String arg, String value)
	{
		args.put(arg, value);
		
		if (created)
		{
			OscMessage msg = new OscMessage("/n_set");
			
			msg.add(nodeID);
			msg.add(arg);
			msg.add(value);
			Server.osc.send(msg, server.addr);
		}
	}

	public void set (String arg, Buffer buffer)
	{
		set(arg, buffer.index);
	}

	public void set (String arg, Bus bus)
	{
		set(arg, bus.index);
	}

	public void set (String arg, int value)
	{
		Integer value_object = new Integer(value);
		args.put(arg, value_object);
		
		if (created)
		{
			OscMessage msg = new OscMessage("/n_set");
			
			msg.add(nodeID);
			msg.add(arg);
			msg.add(value);
			Server.osc.send(msg, server.addr);
		}
	}

	public void set (String arg, float value)
	{
		Float value_object = new Float(value);
		args.put(arg, value_object);
			 
		if (created)
		{
			OscMessage msg = new OscMessage("/n_set");
			msg.add(nodeID);
			msg.add(arg);
			msg.add(value);
			Server.osc.send(msg, server.addr);
		}
	}

	public void set (String [] args, float [] values)
	{
		OscBundle bundle = new OscBundle();
		OscMessage msg = new OscMessage("/n_set");

		for (int i = 0; i < args.length; i++)
		{
			String key = args[i];
			float value = values[i];
			Float value_object = new Float(value);
			this.args.put(key, value_object);
			
			if (created)
			{
				msg.clear();
				msg.setAddrPattern("/n_set");
				msg.add(nodeID);
				msg.add(key);
				msg.add(value);
			}
						
			bundle.add(msg);
		}

		bundle.setTimetag((long) (bundle.now() + server.latency * 1000.0));
		Server.osc.send(bundle, server.addr);

		created = true;
	}

	public void set (String [] args, int [] values)
	{
		OscBundle bundle = new OscBundle();
		OscMessage msg = new OscMessage("/n_set");

		for (int i = 0; i < args.length; i++)
		{
			String key = args[i];
			int value = values[i];
			Integer value_object = new Integer(value);
			this.args.put(key, value_object);
			
			if (created)
			{
				msg.clear();
				msg.setAddrPattern("/n_set");
				msg.add(nodeID);
				msg.add(key);
				msg.add(value);
			}
						
			bundle.add(msg);
		}

		bundle.setTimetag((long) (bundle.now() + server.latency * 1000.0));
		Server.osc.send(bundle, server.addr);

		created = true;
	}

	public void set (String [] args, String [] values)
	{
		OscBundle bundle = new OscBundle();
		OscMessage msg = new OscMessage("/n_set");

		for (int i = 0; i < args.length; i++)
		{
			String key = args[i];
			String value = values[i];
			this.args.put(key, value);
			
			if (created)
			{
				msg.clear();
				msg.setAddrPattern("/n_set");
				msg.add(nodeID);
				msg.add(key);
				msg.add(value);
			}
						
			bundle.add(msg);
		}

		bundle.setTimetag((long) (bundle.now() + server.latency * 1000.0));
		Server.osc.send(bundle, server.addr);

		created = true;
	}
	
	public void get (String arg, Object target, String action)
	{
		if (created)
		{
			OscMessage msg = new OscMessage("/s_get");
			msg.add(nodeID);
			msg.add(arg);
			Server.osc.send(msg, server.addr);
			server.add_responder_n_set(nodeID, arg, target, action);
		}
	}
}


