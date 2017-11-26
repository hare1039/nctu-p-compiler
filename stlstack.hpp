#ifndef __STLSTACK_HPP__
#define __STLSTACK_HPP__

#include <string>
#include <vector>

#include "stack_interface.h"
struct Entry
{
	std::string name;
	kind_list   kind;
	int         level;
	type_list   type;
	union attr  attribute;
};

struct Table
{
	std::vector<Entry *> data;
	bool contains(std::string && s);
	Entry* get_entry(std::string && name);
};

struct Table_stack
{
	std::vector<Table *> tables;
};


#endif // __STLSTACK_HPP__
