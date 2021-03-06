#include "stack_interface.h"
#include "stlstack.hpp"

std::string to_32chars(std::string s) {
	return s.size() >= 32 ? s.substr(0, 32): s;
}

extern "C"
{
    const_type_ptr new_const_type() { return new Const_type; }
    void           delete_const_type  (const_type_ptr p)                 { delete p; }
    void           const_type_set_type(const_type_ptr p, const char * t) { p->type = t;}
    const char *   const_type_get_type(const_type_ptr p)                 { return p->type.c_str(); }
    void           const_type_set_int (const_type_ptr p, int i)          { p->int_val = i; }
    void           const_type_set_real(const_type_ptr p, double d)       { p->real_val = d; }
	void           const_type_set_bool(const_type_ptr p, const char *s)  { p->bool_val = (std::string(s) == "false")? false: true; }
	void           const_type_set_string(const_type_ptr p, const char *s){ p->string_val = std::string(s); }
    void           const_type_set_science(const_type_ptr p, const char *s) { p->real_val = Const_type::to_double(std::string(s)); }
    int            const_type_get_int (const_type_ptr p)                 { return p->int_val; }
    double         const_type_get_real(const_type_ptr p)                 { return p->real_val; }
	int            const_type_get_bool(const_type_ptr p)                 { return (p->bool_val)? 1: 0; }
	const char *   const_type_get_string(const_type_ptr p)               { return p->string_val.c_str(); }
    char *         const_type_get_attrbute_string(const_type_ptr p)      { return strdup(p->get_attrbute_string().c_str()); }
	
    array_object_ptr new_array_object(const char * type, int cap) {
		return new Array_object {
			.type = std::string(type),
			.capacity = cap
		};
	}
    void delete_array_object(array_object_ptr p) {
		delete p;
	}
	char* array_object_show(array_object_ptr p) {
		return strdup(p->show().c_str());
	}
    array_object_ptr array_object_append(array_object_ptr parent, array_object_ptr child) {
		parent->of = child;
		return parent;
	}
	const char * array_object_deepest_type(array_object_ptr p) {
		return p->deepest_type().c_str();
	}

	
    vec_string_ptr new_vec_string() {
		return new Vec_string;
	}
    void delete_vec_string(vec_string_ptr p) {
		delete p;
	}
    void vec_string_push_back(vec_string_ptr p, const char * s) {
		p->data.push_back(s);
	}
    void vec_string_clear(vec_string_ptr p) {
		p->data.clear();
	}
    const char * vec_string_at(vec_string_ptr p, int i) {
		return (p->data.at(i)).c_str();
	}
	int vec_string_size(vec_string_ptr p) {
		return static_cast<int>(p->data.size());
	}
	int vec_string_includes_str(vec_string_ptr p, const char * target) {
		for(auto &s: p->data)
			if(s == std::string(target))
				return 1;
		return 0;
	}
	void vec_string_pop(vec_string_ptr p) {
	    if(not p->data.empty())
			p->data.pop_back();
	}
	void vec_string_remove_str(vec_string_ptr p, const char * target) {
		for(auto iter(p->data.begin()); iter != p->data.end(); ++iter) {
			if((*iter) == std::string(target))
				p->data.erase(iter);
		}
	}

	
	entry_ptr new_entry (const char * n, kind_list k, int l, const char * t, union attr a, const char * attr_data)
	{
		return new Entry {
			.name  = to_32chars(std::string(n)),
			.kind  = k,
			.level = l,
			.type  = std::string(t),
			.attribute = a,
			.attribute_data = std::string(attr_data)
		};
	}
	void delete_entry(entry_ptr e) {
		delete e;
	}
	void entry_set_level(entry_ptr e, int l) {
		e->level = l;
	}
	const char * entry_get_name (entry_ptr e) {
		return e->name.c_str();
	}
	kind_list  entry_get_kind (entry_ptr e) {
		return e->kind;
	}
	int entry_get_level (entry_ptr e) {
		return e->level;
	}
	const char * entry_get_type (entry_ptr e) {
		return e->type.c_str();
	}
	union attr entry_get_attribute (entry_ptr e) {
		return e->attribute;
	}

	
	table_ptr new_table(int i) {
		return new Table(i);
	}
	void delete_table(table_ptr p) {
		delete p;
	}
	int table_push(table_ptr t, entry_ptr ent) {
		if (t->contains(to_32chars(std::string(ent->name))))
			return 1;
		t->data.push_back(ent);
		return 0;
	}
	entry_ptr table_top (table_ptr t) {
		return t->data.back();
	}
	entry_ptr table_pop (table_ptr t)
	{
		if(t->data.empty())
			return NULL;
		entry_ptr p = t->data.back();
		t->data.pop_back();
		return p;
	}
	int table_contains(table_ptr t, const char * n) {
		return (t->contains(n))? 1: 0;
	}
	entry_ptr table_get_entry(table_ptr t, const char * n) {
		return t->get_entry(std::string(n));
	}
	int table_get_level(table_ptr t) {
		return t->level;
	}
	void table_set_level(table_ptr t, int n) {
		t->level = n;
	}
	void table_print(table_ptr t) {
		t->show();
	}
	void table_remove(table_ptr t, const char * name) {
		t->remove(to_32chars(std::string(name)));
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

// some extra functions
    char * newstringconcat(const char * a, const char * b) {
		return strdup((std::string(a) + std::string(b)).c_str());
	}

	char * new_for_varrange(int from, int to) {
		return strdup(("for [" + std::to_string(from) + "->" + std::to_string(to) + "]").c_str());
	}
	void report_error(int line, const char *msg) {
		printf("<Error> found in Line %d: %s\n", line, msg);
	}
	void report_error_redeclared_var(int line, const char *var_name) {
		std::string err = "symbol " + to_32chars(std::string(var_name)) + " is redeclared";
		report_error(line, err.c_str());
	}
}
