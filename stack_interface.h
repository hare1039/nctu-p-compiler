#ifndef __STACK_INTERFACE__
#define __STACK_INTERFACE__

enum kind_list {K_PROGRAM, K_FUNCTION, K_PARAMETER, K_VARIABLE, K_CONSTANT};
enum type_list {T_INTEGER, T_REAL, T_BOOLEAN, T_STRING, T_ARRAY_SIG};

union attr
{
	int val;
	char * list;
};

struct Table;
struct Entry;

#ifdef __cplusplus
    #define extc extern "C" 
#else
    #define extc
#endif

extc typedef struct Table * table_ptr;
extc typedef struct Entry * entry_ptr;
extc typedef struct Table_stack * table_stack_ptr;

extc entry_ptr      new_entry (const char *, enum kind_list, int, enum type_list, union attr);
extc void           delete_entry(entry_ptr);
extc const char*    get_name  (entry_ptr);
extc enum kind_list get_kind  (entry_ptr);
extc int            get_level (entry_ptr);
extc enum type_list get_type  (entry_ptr);
extc union attr     get_attribute (entry_ptr);

extc table_ptr   new_table();
extc void        delete_table(table_ptr);
extc void        table_push(table_ptr, entry_ptr);
extc entry_ptr   table_top (table_ptr);
extc entry_ptr   table_pop (table_ptr);
extc int         table_contains(table_ptr, const char *);
extc entry_ptr   table_get_entry(table_ptr, const char *);

extc table_stack_ptr new_table_stack();
extc void            delete_table_stack(table_stack_ptr);
extc void            table_stack_push(table_stack_ptr, table_ptr);
extc table_ptr       table_stack_top (table_stack_ptr);
extc table_ptr       table_stack_pop (table_stack_ptr);
extc int             table_stack_size(table_stack_ptr);


#endif//__STACK_INTERFACE__
