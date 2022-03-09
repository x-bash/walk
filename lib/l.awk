
# Section: utils
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
    v = string_to_symbol(sprintf("#<Primitive %s>", name))
    L_SYM_VALUE[ _sym ] = v
    if (nparam != "") L_SYM_NPARAM[ v ] = nparam
    return v
}
# EndSection

# Section: setting up
BEGIN {
    srand()

}
# EndSection
