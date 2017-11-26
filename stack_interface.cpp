#include "stack_interface.h"
#include "stlstack.hpp"

extern "C"
{
	entry_ptr new_entry (const char * n, kind_list k, int l, type_list t, union attr a)
	{
		return new Entry {
			.name  = std::string(n),
			.kind  = k,
			.level = l,
			.type  = t,
			.attribute = a
		};
	}
	void delete_entry(entry_ptr e) {
		delete e;
	}
	const char * get_name (entry_ptr e) {
		return e->name.c_str();
	}
	kind_list  get_kind (entry_ptr e) {
		return e->kind;
	}
	int get_level (entry_ptr e) {
		return e->level;
	}
	type_list get_type (entry_ptr e) {
		return e->type;
	}
	union attr get_attribute (entry_ptr e) {
		return e->attribute;
	}

		table_ptr new_table() {
		return new Table;
	}
	void delete_table(table_ptr p) {
		delete p;
	}
	void table_push(table_ptr t, entry_ptr ent) {
		t->data.push_back(ent);
	}
	entry_ptr table_top (table_ptr t) {
		return t->data.back();
	}
	entry_ptr table_pop (table_ptr t)
	{
		entry_ptr p = t->data.back();
		t->data.pop_back();
		return p;
	}
	int table_contains(table_ptr t, const char * n) {
		return (t->contains(n))? 1: 0;
	}


    table_stack_ptr new_table_stack() {
		return new Table_stack;
	}
    void delete_table_stack(table_stack_ptr ts) {
		delete ts;
	}
    void table_stack_push(table_stack_ptr ts, table_ptr tb) {
		ts->tables.push_back(tb);
	}
	table_ptr table_stack_top (table_stack_ptr ts) {
		return ts->tables.back();
	}
    table_ptr table_stack_pop (table_stack_ptr ts)
	{
		table_ptr t = ts->tables.back();
		ts->tables.pop_back();
		return t;
	}
    int table_stack_size(table_stack_ptr ts) {
		return ts->tables.size();
	}

}
