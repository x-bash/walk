
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

# Section: Using recursive to l_expr_eval

function l_expr_evall(){

}

function l_expr_eval( arr, arrl, start, args, argl, i, o, _token, _with_bracket ){
    i = start

    _token = arr[ i ]
    if (_token == "(") {
        _with_bracket = true
        i ++
    } else {
        _with_bracket = false
    }

    o = arr[ i ]
    i ++

    # Accept function
    if (o == "func") {
        _func_name = arr[i++]
        _token = arr[ i ]
        if (_token != "(")  panic("Expecting (")
        _func_args =
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
