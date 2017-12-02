#include "stlstack.hpp"

std::string Entry::get_kind()
{
	switch(this->kind)
	{
	case K_PROGRAM:  return std::string("program");  break;
	case K_FUNCTION: return std::string("function"); break;
	case K_PARAMETER:return std::string("parameter"); break;
	case K_VARIABLE: return std::string("variable"); break;
	case K_CONSTANT: return std::string("constant"); break;	
	}
}

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

void Table::show()
{
    for(int i(0); i < 110; i++)
		std::printf("=");
	std::printf("\n");
	std::printf("%-33s%-11s%-11s%-17s%-11s\n", "Name", "Kind", "Level", "Type", "Attribute");
	for(int i(0); i < 110; i++)
		std::printf("-");
	std::printf("\n");
	for(auto & entry : data)
	{		
		std::printf("%-33s", entry->name.c_str());
		std::printf("%-11s", entry->get_kind().c_str());
		std::printf("%d%-10s", entry->level, (entry->level == 0)? "(global)": "(local)");
		std::printf("%-17s", entry->type.c_str());
		std::printf("%-11s", (entry->attribute_data == "" )?
					std::to_string(entry->attribute.val).c_str():
					entry->attribute_data.c_str());
		std::printf("\n");				
	}
	for(int i(0); i < 110; i++)
		std::printf("-");
	std::printf("\n");
}


Array_object::~Array_object() {
	if(of) delete of;
}
std::string Array_object::show()
{
    return this->deepest_type() + show_cap();
}

std::string Array_object::show_cap()
{
	if(this->of)
		return "[" + std::to_string(this->capacity) + "]" + this->of->show_cap();
	return "[" + std::to_string(this->capacity) + "]";
}

std::string Array_object::deepest_type() {
	return (of != nullptr) ? of->deepest_type(): type;
}
