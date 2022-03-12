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
