#ifndef __STLSTACK_HPP__
#define __STLSTACK_HPP__

#include <string>
#include <cstdio>
#include <vector>

#include "stack_interface.h"

struct Vec_string
{
	std::vector<std::string> data;
};

struct Entry
{
	std::string name;
	kind_list   kind;
	int         level;
	std::string type;
	union attr  attribute;
	std::string get_kind();
};

struct Table
{
	std::vector<Entry *> data;
	int level = 0;
	bool contains(std::string && s);
	Entry* get_entry(std::string && name);
	void show();
	Table(int l): level(l){}
};

struct Table_stack
{
	std::vector<Table *> tables;
};


#endif // __STLSTACK_HPP__
