/*
	
	ProcessCollider: A SuperCollider library for Processing.
	
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

import java.util.Hashtable;
import java.util.ArrayList;
import java.lang.reflect.Method;

import oscP5.*;
import netP5.*;

public class Server
{
	public NetAddress addr;
	
	public static OscP5 osc;
	public static Server local;
	public Group default_group;
	public Group root_group;
	
	public float latency;
	
	ResourceAllocator allocator_synth,			// XXX: not using this yet - need to implement
	                  allocator_audio_bus,
	                  allocator_control_bus,
	                  allocator_buffer;

	Hashtable responders_n_set,
	          responders_b_info,
	          responders_b_set,
	          responders_b_setn;
	
	public Buffer [] buffers;

	// Class init
	static
	{
		Server.local = new Server("127.0.0.1", 57110); 
	}

	public static void init ()
	{
		// Placeholder routine
	}

	public Server()
	{
		this("127.0.0.1", 57110);
	}

	public Server(String server_ip, int server_port)
	{
		addr = new NetAddress(server_ip, server_port);
		
		// Create bus/buffer allocators.
		// Initial block of audio buses are reserved for hardware.
		allocator_audio_bus = new ResourceAllocator(512);
		allocator_audio_bus.pos = 64;
		
		allocator_control_bus = new ResourceAllocator(512);
		allocator_buffer = new ResourceAllocator(512);
		
		buffers = new Buffer[512];
		
		// Need to allocate a global O listener.
		if (Server.osc == null)
		{
			Server.osc = new OscP5(this, 57150);
			
			// SRSP needed to receive aynschronous messages on the same port
			Server.osc.properties().setSRSP(OscProperties.ON);
		}
		
		root_group = new Group(this, 0);
		default_group = new Group(this, 1);
		
		responders_n_set = new Hashtable();
		responders_b_info = new Hashtable();
		responders_b_set = new Hashtable();
		responders_b_setn = new Hashtable();
		
		latency = (float) 0.05;
	}
		
	public void freeAll ()
	{
		OscMessage msg = new OscMessage("/g_freeAll");
		msg.add(0);
		Server.osc.send(msg, addr);
	}
	
	public void add_responder_n_set(int nodeID, String arg, Object target, String action)
	{
		Integer nodeIDobj = new Integer(nodeID);
		if (!responders_n_set.containsKey(nodeIDobj))
		{
			responders_n_set.put(nodeIDobj, new Hashtable());
		}
		Hashtable nodeResponders = (Hashtable) responders_n_set.get(nodeIDobj);
		Method method;
		
		try {
			method = target.getClass().getMethod(action, new Class [] { Integer.TYPE, String.class, Float.TYPE });
			Invocation handler = new Invocation(target, method);
			nodeResponders.put(arg, handler);
		}
		catch (Exception e)
		{
			System.err.println(e);
		}
	}
	
	public void add_responder_b_info(int index, Object target, String action)
	{
		Integer indexObj = new Integer(index);
		
		try {
			Method method = target.getClass().getMethod(action, new Class [] { Buffer.class });
			Invocation handler = new Invocation(target, method);
			responders_b_info.put(indexObj, handler);
		}
		catch (Exception e)
		{
			System.err.println(e);
		}
	}
	
	public void add_responder_b_set(int index, int frame, Object target, String action)
	{
		Integer indexObj = new Integer(index);
		
		try {
			Method method = target.getClass().getMethod(action, new Class [] { Buffer.class, Integer.TYPE, Float.TYPE });
			Invocation handler = new Invocation(target, method);
			responders_b_set.put(indexObj, handler);
		}
		catch (Exception e)
		{
			System.err.println(e);
		}
	}

	public void add_responder_b_set(int index, int [] frames, Object target, String action)
	{
		Integer indexObj = new Integer(index);
		
		try {
			Class iaClass = Class.forName("[I");
			Class faClass = Class.forName("[F");
			Method method = target.getClass().getMethod(action, new Class [] { Buffer.class, iaClass, faClass });
			Invocation handler = new Invocation(target, method);
			responders_b_set.put(indexObj, handler);
		}
		catch (Exception e)
		{
			System.err.println(e);
		}
	}

	public void add_responder_b_setn(int index, Object target, String action)
	{
		Integer indexObj = new Integer(index);
		
		try {
			// Class representing an array of floats - see Class.forName docs.
			Class faClass = Class.forName("[F");
			Method method = target.getClass().getMethod(action, new Class [] { Buffer.class, Integer.TYPE, faClass });
			Invocation handler = new Invocation(target, method);
			responders_b_setn.put(indexObj, handler);
		}
		catch (Exception e)
		{
			System.err.println(e);
		}
	}
	
	public void handle_n_set (Integer nodeID, String arg, Float value)
	{
		if (responders_n_set.containsKey(nodeID))
		{
			Hashtable nodeResponders = (Hashtable) responders_n_set.get(nodeID);
			if (nodeResponders.containsKey(arg))
	 		{
				Invocation handler = (Invocation) nodeResponders.get(arg);
				handler.invoke(new Object [] { nodeID, arg, value });
			} 
		}
	}
	
	public void handle_b_info (Integer index, Integer frames, Integer channels, Float sampleRate)
	{
		int i = index.intValue();
		Buffer buffer = buffers[i];
		
		if (buffer == null)
			return;
		
		buffer.channels = channels;
		buffer.frames = frames;
		buffer.sampleRate = sampleRate;
		
		if (responders_b_info.containsKey(index))
		{
			Invocation handler = (Invocation) responders_b_info.get(index);
			handler.invoke(new Object [] { buffer });
		}
	}
	
	public void handle_b_set (Integer index, Integer frame, Float value)
	{
		int i = index.intValue();
		Buffer buffer = buffers[i];
		
		if (buffer == null)
			return;
		
		if (responders_b_set.containsKey(index))
		{
			Invocation handler = (Invocation) responders_b_set.get(index);
			handler.invoke(new Object [] { buffer, frame, value });
		}		
	}


	public void handle_b_set (Integer index, int [] frames, float [] values)
	{
		int i = index.intValue();
		Buffer buffer = buffers[i];
		
		if (buffer == null)
			return;
		
		if (responders_b_set.containsKey(index))
		{
			Invocation handler = (Invocation) responders_b_set.get(index);
			handler.invoke(new Object [] { buffer, frames, values });
		}		
	}
	
	public void handle_b_setn (Integer index, Integer frame, Integer count, float[] values)
	{
		int i = index.intValue();
		Buffer buffer = buffers[i];
		
		if (buffer == null)
			return;
		
		if (responders_b_setn.containsKey(index))
		{
			Invocation handler = (Invocation) responders_b_setn.get(index);
			handler.invoke(new Object [] { buffer, frame, values });
		}		
	}
	
	public void oscEvent (OscMessage message)
	{
		System.out.println("oscEvent: " + message.addrPattern());
		if (message.checkAddrPattern("/n_set") && message.checkTypetag("isf"))
		{
			Integer nodeID = new Integer(message.get(0).intValue());
			String arg = message.get(1).stringValue();
			Float value = new Float(message.get(2).floatValue());
			
			this.handle_n_set(nodeID, arg, value);
		}
		else if (message.checkAddrPattern("/b_info") && message.checkTypetag("iiif"))
		{
			Integer index = new Integer(message.get(0).intValue());
			Integer frames = new Integer(message.get(1).intValue());
			Integer channels = new Integer(message.get(2).intValue());
			Float sampleRate = new Float(message.get(3).floatValue());
			
			this.handle_b_info(index, frames, channels, sampleRate);
		}
		else if (message.checkAddrPattern("/b_set") && message.checkTypetag("iif"))
		{
			Integer index = new Integer(message.get(0).intValue());
			Integer frame = new Integer(message.get(1).intValue());
			Float value = new Float(message.get(2).floatValue());
						
			this.handle_b_set(index, frame, value);
		}
		else if (message.checkAddrPattern("/b_set"))
		{
			// b_set with multiple indices
			Integer index = new Integer(message.get(0).intValue());
			
			int value_count = (int) (message.typetag().length() - 1) / 2;
			int [] frames = new int[value_count];
			float [] values = new float[value_count];
			
			for (int i = 0; i < value_count; i++)
			{
				frames[i] = message.get((i * 2) + 1).intValue();
				values[i] = message.get((i * 2) + 2).floatValue();
			}
						
			this.handle_b_set(index, frames, values);
		}		
		else if (message.checkAddrPattern("/b_setn"))
		{
			Integer index = new Integer(message.get(0).intValue());
			Integer frame = new Integer(message.get(1).intValue());
			Integer count = new Integer(message.get(2).intValue());
			
			int value_count = message.typetag().length() - 3;
			float[] values = new float[value_count];

			for (int i = 0; i < value_count; i++)
				values[i] = message.get(3 + i).floatValue();
			
			this.handle_b_setn(index, frame, count, values);
		}
	}
}

