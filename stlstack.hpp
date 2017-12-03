#ifndef __STLSTACK_HPP__
#define __STLSTACK_HPP__

#include <string>
#include <cstdio>
#include <vector>
#include <iostream>
#include <sstream>
#include <algorithm>
#include <cmath>
#include <string>
#include "stack_interface.h"

struct Const_type
{
	int    int_val;
	double real_val;
	bool   bool_val;
	std::string string_val;
	std::string type;
	static
	double to_double(std::string && sci);
	std::string get_attrbute_string();
};

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
	std::string attribute_data;
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
	~Table();
};

struct Table_stack
{
	std::vector<Table *> tables;
};

struct Array_object
{
	Array_object()=default;
	~Array_object();
	Array_object *of = nullptr;
	std::string type;
	int capacity = 0;

	std::string show();
	std::string deepest_type();
	std::string show_cap();
};


#endif // __STLSTACK_HPP__
