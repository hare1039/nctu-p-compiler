#include "stlstack.hpp"

bool Table::contains(std::string && name)
{
	for(auto & s: this->data)
		if(s->name == name)
			return true;
	return false;
}

Entry* Table::get_entry(std::string && name)
{
	for(auto & s: this->data)
		if(s->name == name)
			return s;
	return nullptr;
}
