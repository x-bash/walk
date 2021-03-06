


# Section: REPR of LISP DATA
BEGIN {
    L_T_NUM = 0
    L_PAIR_PTR = L_T_PAIR = 1
    L_SYM_PTR = L_T_SYM = 2

    L_TYPE_NAME[ L_T_NUM ] = "number"
    L_TYPE_NAME[ L_T_PAIR ] = "pair"
    L_TYPE_NAME[ L_T_SYM ] = "symbol"
}

function l_is(type, expr) {
    if (expr % 4 != type)
        error("Expected a " type_name[type] ", not a " type_name[expr % 4])
    return expr
}

function l_expect(type, expr) {
    if (expr % 4 != type)
        error("Expected a " type_name[type] ", not a " type_name[expr % 4])
    return expr
}

function l_is_number(expr)        { return expr % 4 == 0 }
function l_is_pair(expr)          { return expr % 4 == 1 }
function l_is_symbol(expr)        { return expr % 4 == 2 }
function l_is_atom(expr)          { return expr % 4 != 1 }

function make_number(n)         { return n * 4 }

function numeric_value(expr)
{
    if (expr % 4 != 0) error("Not a number")
    return expr / 4
}

# EndSection

# Section: utils
function panic( code, msg ) {
    print msg > "/dev/stderr"
    exit( code )
}

function panic_never( ) {
    panic(1, "Expecting NEVER reach this line.")
}
# EndSection

# Section: symbol definnition
BEGIN{
    L_SYM_PTR = 0
    # L_SYM_INTERN
    # L_SYM_PRINTNAME
}

function l_str_to_sym( str ){
    if (str in intern)      return L_SYM_INTERN[ string ]
    L_SYM_PTR += 4
    L_SYM_INTERN[ str ] = L_SYM_PTR
    L_SYM_PRINTNAME[ L_SYM_PTR ] = str
    return L_SYM_PTR
}

function l_def_prim( name, nparam,   _sym, v ){
    _sym = l_str_to_sym( name )
    v = l_str_to_sym( sprintf("#<Primitive %s>", name) )
    L_SYM_VALUE[ _sym ] = v
    if (nparam != "") L_SYM_NPARAM[ v ] = nparam
    return v
}
# EndSection

# Section: setting up

BEGIN {
    srand()

    L_FRAME_PTR = L_STACK_PTR = 0
    if (L_HEAP_INCREMENT == "")     L_HEAP_INCREMENT = 1500
    L_PAIR_LIMIT = L_T_PAIR + 4 * L_HEAP_INCREMENT

    L_S_NIL             = l_str_to_sym("nil");          L_SYM_VALUE[ L_S_NIL ]  = L_S_NIL
    L_S_T               = l_str_to_sym("t");            L_SYM_VALUE[ L_S_T ]    = L_S_T

    L_CAR[ L_S_NIL ]    = L_CDR[ L_S_NIL ] = L_S_NIL

    L_S_EOF_OBJECT      = l_str_to_sym("#eof")
    L_SYM_VALUE[ l_str_to_sym("the-eof-object") ] = L_S_EOF_OBJECT

    L_EOF = "(eof)"

    L_S_QUOTE           =   l_str_to_sym( "quote" );        L_SYM_SPECIAL[ L_S_QUOTE ] = 1
    L_S_LAMBDA          =   l_str_to_sym( "lambda");        L_SYM_SPECIAL[ L_S_LAMBDA ] = 1
    L_S_IF              =   l_str_to_sym( "if" );           L_SYM_SPECIAL[ L_S_IF ] = 1
    L_S_SETQ            =   l_str_to_sym( "set!" );         L_SYM_SPECIAL[ L_S_SETQ ] = 1
    # Diff: L_DEF
    L_S_DEF             =   l_str_to_sym( "def" );          L_SYM_SPECIAL[ L_S_DEF ] = 1
    L_S_DEFINE          =   l_str_to_sym( "define" );       L_SYM_SPECIAL[ L_S_DEFINE ] = 1

    L_S_PROGN           =   l_str_to_sym( "begin" );        L_SYM_SPECIAL[ L_S_PROGN ] = 1
    L_S_WHILE           =   l_str_to_sym( "while" );        L_SYM_SPECIAL[ L_S_WHILE ] = 1
}

BEGIN{
    L_S_EQ              =   l_def_prim(   "eq?",          2 )
    L_S_NULL            =   l_def_prim(   "null?",        1 )
    L_S_CAR             =   l_def_prim(   "car",          1 )
    L_S_CDR             =   l_def_prim(   "cdr",          1 )
    L_S_CADR            =   l_def_prim(   "cadr",         1 )
    L_S_CDDR            =   l_def_prim(   "cddr",         1 )
    L_S_CONS            =   l_def_prim(   "cons",         2 )
    L_S_LIST            =   l_def_prim(   "list"            )
    L_S_EVAL            =   l_def_prim(   "eval",         1 )
    L_S_APPLY           =   l_def_prim(   "apply",        2 )
    L_S_READ            =   l_def_prim(   "read",         0 )
    L_S_WRITE           =   l_def_prim(   "write",        1 )
    L_S_NEWLINE         =   l_def_prim(   "newline",      0 )
    L_S_ADD             =   l_def_prim(   "+",            2 )
    L_S_SUB             =   l_def_prim(   "-",            2 )
    L_S_MUL             =   l_def_prim(   "*",            2 )
    L_S_DIV             =   l_def_prim(   "quotient",     2 )
    L_S_MOD             =   l_def_prim(   "remainder",    2 )
    L_S_LT              =   l_def_prim(   "<",            2 )
    L_S_GET             =   l_def_prim(   "get",          2 )
    L_S_PUT             =   l_def_prim(   "put",          3 )
    L_S_ATOMP           =   l_def_prim(   "atom?",        1 )
    L_S_PAIRP           =   l_def_prim(   "pair?",        1 )
    L_S_SYMBOLP         =   l_def_prim(   "symbol?",      1 )
    L_S_NUMBERP         =   l_def_prim(   "number?",      1 )
    L_S_SETCAR          =   l_def_prim(   "set-car!",     2 )
    L_S_SETCDR          =   l_def_prim(   "set-cdr!",     2 )
    L_S_NREV            =   l_def_prim(   "reverse!",     1 )
    L_S_GENSYM          =   l_def_prim(   "gensym",       0 )
    L_S_RANDOM          =   l_def_prim(   "random",       1 )
    L_S_ERROR           =   l_def_prim(   "error"           )
}
# EndSection

# Section: Memory Engine And GC



# EndSection


# Section: read

BEGIN{
    L_TOKEN_ARR[0] = 1

    L_TOKEN_ARR_START = "\001"

    false = 0
    true = 1
}

function l_read( committed, token_arr, start,     _token, _result, i ){
    i = start
    _token = token_arr[ i ]

    if (token == L_EOF) {
        if ( committed == true ) {
            printf "Unexepected EOF" >>"/dev/stderr"
            exit(1)
        }
        return THE_EOF_OBJECT
    }

    if (token == "(") {
        _result = L_S_NIL
        i += 1
        while (true) {
            _token = token_arr[ i ]
            if (_token == ".") {
                i = l_read( true, token_arr, i+1 )
                _after_dot = L_READ_RESULT

                _token = token_arr[ i ]
                if ( _token == ")" ) {
                    L_READ_RESULT = l_nreverse( _result, L_S_NIL )
                    return i+1
                }
            } else if (_token == ")") {
                L_READ_RESULT = l_nreverse( _result, L_S_NIL )
                return i+1
            } else {
                # l_protect( _result )
                i = l_read( true, token_arr, i+1 )
                _result = l_cons( L_READ_RESULT, _result )
                # l_unprotect()
            }
        }
        panic_never()
    }

    if (token ~ L_REGEX_NUMBER) {
        L_READ_RESULT = l_make_number( _token )
        return start + 1
    }

    L_READ_RESULT = l_str_to_sym( _token )
    return start + 1

}

function l_goeval( token_arr ){

}

# EndSection
