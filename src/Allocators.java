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

class Resource
{
	int address, size;
	Resource next;
	
	Resource (int address, int size)
	{
		this.address = address;
		this.size = size;
		next = null;
	}
}

/*
 * Port of James McCartney's PowerOfTwoAllocator (SuperCollider 3),
 * for blocks of arbitrary size.
 */

class ResourceAllocator
{
	int size, pos;

	Resource [] resources,
							free_lists;
	
	ResourceAllocator (int size)
	{
		this.size = size;
		pos = 0;
		resources = new Resource[size];
		free_lists = new Resource[32];

		for (int i = 0; i < free_lists.length; i++)
				free_lists[i] = null;
	}
	
	int alloc (int resource_size)
	{
		Resource res = free_lists[resource_size];
		
		// Resource of this size has previously been freed.
		if (res != null)
		{
			free_lists[resource_size] = res.next;
			return res.address;
		}
		
		// Not got previously freed resource but some have yet to be allocated.
		if ((pos + resource_size) <= size)
		{
			int address;
			resources[pos] = new Resource(pos, resource_size);
			address = pos;
			pos += resource_size;
			return address;
		}
		
		return -1;
	}
	
	void free (int address)
	{
		Resource res = resources[address];

		if (res != null)
		{
			res.next = free_lists[res.size];
			free_lists[res.size] = res;
			// should we set resources[address] = null?
		}
	}
}
