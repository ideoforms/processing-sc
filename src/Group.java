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
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
	
*/

package supercollider;

import oscP5.*;
import netP5.*;

public class Group extends Node
{
	public Group (Group target)
	{
		this.nodeID = nodeID_base++;
		this.server = target.server;
		this.group = target;
	}
	
	public Group (Server target)
	{
		this.nodeID = nodeID_base++;
		this.server = target;
		this.group = target.default_group;
	}

	public Group (Server target, int nodeID)
	{
		this.nodeID = nodeID;
		this.server = target;
		this.group = target.default_group;
	}
	
	public Group ()
	{
		this.nodeID = nodeID_base++;
				
		this.server = Server.local;
		this.group = Server.local.default_group;
	}

	public void create (int position, int groupID)
	{
		OscMessage msg = new OscMessage("/g_new");
		msg.add(nodeID);
		msg.add(position);
		msg.add(groupID);
		Server.osc.send(msg, server.addr);
	}

	public void freeAll ()
	{
		OscMessage msg = new OscMessage("/g_freeAll");
		msg.add(nodeID);
		Server.osc.send(msg, server.addr);
	}
}
