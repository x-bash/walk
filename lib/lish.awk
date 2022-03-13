
# Section: tokeninzed & Interpreter
function l_regex_or(p0, p1){
    return p0 "|" p1
}

BEGIN{
    L_REGEX_SPACE = "[ \\t]+"

    L_REGEX_NUMBER = "^[-+]?[0-9]+$"

    # TOKENIZE_REGEX = "[()'.]" "|" "[_A-Za-z0-9=!@$%&*<>?+\\-*/:]+" "|" "[ \\t]+" "|" ""
    L_REGEX = l_regex_or( "[()'.]", "[_A-Za-z0-9=!@$%&*<>?+\\-*/:]+" )
    L_REGEX = l_regex_or(L_REGEX, L_REGEX_SPACE)
    L_REGEX = l_regex_or(L_REGEX, ";")

    L_REGEX_REDUNDANT = "([ \\t]*[\n]+)+"

    L_REGEX_TRIM = l_regex_or( "^[\n]+", "[\n]+$" )
}

function l_interpreter_tokenize( astr, tokenarr){
    # print L_REGEX
    gsub( L_REGEX, "&\n", astr )
    gsub( L_REGEX_REDUNDANT, "\n", astr)
    # gsub( L_REGEX_SPACE, "\n", astr)
    gsub( L_REGEX_TRIM , "", astr)
    return split( astr, tokenarr, "\n")
}
# EndSection

function panic_if_not( token, expect_char, msg ) {
    if ( token == expect_char )  return
    print "Exepecting " expect_char " : " msg >"/dev/stderr"
    panic(1)
}

# Section: Using recursive to l_expr_eval

function l_expr_evall(){

}

function l_expr_eval( arr, arrl, start, args, argl, i, o, _token, _with_bracket ){
    i = start

    _token = arr[ i ++ ]
    panic_if_not( _token, "(" )

    o = arr[ i ++ ]

    # Accept function
    if (o == "func") {
        _func_name = arr[ i ++ ]
        _func_argptr = i
        panic_if_not( arr[ i ++ ], "(" )
        while ( arr[ i ++ ] != ")" ) {
            if (i > arrl) panic("Expecting ) in the function variable scope.")
        }

        # Eval macro
        _func_body_start = i
    }

    argl = 0
    while (i<=arrl) {
        _token = arr[ i ]
        if (_token == "(") {
            i = l_expr_eval( arr, arrl, i )
            args[ ++argl ] =
            continue
        }
        if (_token == ")") {
            return i+1
        }
    }
}

# EndSection

{
    l = l_interpreter_tokenize( $0, arr )
    l_expr_eval( arr, l, 1 )
}
