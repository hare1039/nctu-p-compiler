#ifndef __STACK_INTERFACE__
#define __STACK_INTERFACE__

#ifdef __cplusplus
    #include <cstring>
    #include <cstdio>
    using std::printf;
    #define extc extern "C"
#else
    #include <string.h>
    #define extc
#endif

enum kind_list {K_PROGRAM, K_FUNCTION, K_PARAMETER, K_VARIABLE, K_CONSTANT};
// enum type_list {T_INTEGER, T_REAL, T_BOOLEAN, T_STRING, T_ARRAY_SIG};

union attr
{
	int val;
	const char * list;
};

struct Table;
struct Entry;
struct Vec_string;

extc typedef struct Table * table_ptr;
extc typedef struct Entry * entry_ptr;
extc typedef struct Table_stack * table_stack_ptr;
extc typedef struct Vec_string  * vec_string_ptr;
extc typedef struct Array_object * array_object_ptr;
extc typedef struct Const_type * const_type_ptr;

extc const_type_ptr new_const_type();
extc void           delete_const_type(const_type_ptr);
extc void           const_type_set_type(const_type_ptr, const char *);
extc const char *   const_type_get_type(const_type_ptr);
extc void           const_type_set_int(const_type_ptr, int);
extc void           const_type_set_real(const_type_ptr, double);
extc void           const_type_set_bool(const_type_ptr, const char *);
extc void           const_type_set_string(const_type_ptr, const char *);
extc void           const_type_set_science(const_type_ptr, const char *);
extc int            const_type_get_int(const_type_ptr);
extc double         const_type_get_real(const_type_ptr);
extc int            const_type_get_bool(const_type_ptr);
extc const char *   const_type_get_string(const_type_ptr);
extc char *         const_type_get_attrbute_string(const_type_ptr);

extc array_object_ptr new_array_object(const char * type, int cap);
extc void             delete_array_object(array_object_ptr);
extc char *           array_object_show(array_object_ptr);
extc array_object_ptr array_object_append(array_object_ptr parent, array_object_ptr child);
extc const char *     array_object_deepest_type(array_object_ptr);


extc vec_string_ptr new_vec_string();
extc void           delete_vec_string(vec_string_ptr);
extc void           vec_string_push_back(vec_string_ptr, const char *);
extc void           vec_string_clear(vec_string_ptr);
extc const char *   vec_string_at(vec_string_ptr, int);
extc int            vec_string_size(vec_string_ptr);
extc int            vec_string_includes_str(vec_string_ptr, const char *);
extc void           vec_string_pop(vec_string_ptr);

extc entry_ptr      new_entry (const char * name,
							   enum kind_list kind,
							   int level,
							   const char * type,
							   union attr,
							   const char * attr_data);
extc void           delete_entry(entry_ptr);
extc const char*    entry_get_name  (entry_ptr);
extc enum kind_list entry_get_kind  (entry_ptr);
extc int            entry_get_level (entry_ptr);
extc const char*    entry_get_type  (entry_ptr);
extc union attr     entry_get_attribute (entry_ptr);
extc void           entry_set_level(entry_ptr, int);

extc table_ptr   new_table(int);
extc table_ptr   new_table_copy_from(table_ptr);
extc void        delete_table(table_ptr);
extc int         table_push(table_ptr, entry_ptr);
extc entry_ptr   table_top (table_ptr);
extc entry_ptr   table_pop (table_ptr);
extc int         table_contains(table_ptr, const char *);
extc entry_ptr   table_get_entry(table_ptr, const char *);
extc int         table_get_level(table_ptr);
extc void        table_set_level(table_ptr, int);
extc void        table_print(table_ptr);
extc void        table_remove(table_ptr, const char * name);

extc table_stack_ptr new_table_stack();
extc void            delete_table_stack(table_stack_ptr);
extc void            table_stack_push(table_stack_ptr, table_ptr);
extc table_ptr       table_stack_top (table_stack_ptr);
extc table_ptr       table_stack_pop (table_stack_ptr);
extc int             table_stack_size(table_stack_ptr);

// some extra functions
extc char *          newstringconcat(const char *, const char *);
extc char *          new_for_varrange(int from, int to);
extc void            report_error(int line, const char *msg);
extc void            report_error_redeclared_var(int line, const char *var_name);

#endif//__STACK_INTERFACE__
