#ifndef __STACK_INTERFACE__
#define __STACK_INTERFACE__

#ifdef __cplusplus
    #define extc extern "C"
#else
    #define extc
#endif

enum kind_list {K_PROGRAM, K_FUNCTION, K_PARAMETER, K_VARIABLE, K_CONSTANT};
// enum type_list {T_INTEGER, T_REAL, T_BOOLEAN, T_STRING, T_ARRAY_SIG};

union attr
{
	int val;
	char * list;
};

struct Table;
struct Entry;
struct Vec_string;

extc typedef struct Table * table_ptr;
extc typedef struct Entry * entry_ptr;
extc typedef struct Table_stack * table_stack_ptr;
extc typedef struct Vec_string  * vec_string_ptr;

extc vec_string_ptr new_vec_string();
extc void           delete_vec_string(vec_string_ptr);
extc void           vec_string_push_back(vec_string_ptr, const char *);
extc void           vec_string_clear(vec_string_ptr);
extc const char *   vec_string_at(vec_string_ptr, int);
extc int            vec_string_size(vec_string_ptr);

extc entry_ptr      new_entry (const char * name, enum kind_list kind, int level, const char * type, union attr);
extc void           delete_entry(entry_ptr);
extc const char*    get_name  (entry_ptr);
extc enum kind_list get_kind  (entry_ptr);
extc int            get_level (entry_ptr);
extc const char*    get_type  (entry_ptr);
extc union attr     get_attribute (entry_ptr);

extc table_ptr   new_table(int);
extc void        delete_table(table_ptr);
extc void        table_push(table_ptr, entry_ptr);
extc entry_ptr   table_top (table_ptr);
extc entry_ptr   table_pop (table_ptr);
extc int         table_contains(table_ptr, const char *);
extc entry_ptr   table_get_entry(table_ptr, const char *);
extc int         table_get_level(table_ptr);
extc void        table_set_level(table_ptr, int);
extc void        table_print(table_ptr);

extc table_stack_ptr new_table_stack();
extc void            delete_table_stack(table_stack_ptr);
extc void            table_stack_push(table_stack_ptr, table_ptr);
extc table_ptr       table_stack_top (table_stack_ptr);
extc table_ptr       table_stack_pop (table_stack_ptr);
extc int             table_stack_size(table_stack_ptr);

#endif//__STACK_INTERFACE__
