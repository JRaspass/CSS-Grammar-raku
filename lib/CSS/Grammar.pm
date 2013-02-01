use v6;

grammar CSS::Grammar:ver<0.0.1> {

    # abstract base grammar for CSS instance grammars:
    #  CSS::Grammar::CSS1 - CSS level 1
    #  CSS::Grammar::CSS2 - CSS level 2.1
    #  CSS::Grammar::CSS3 - CSS level 3 (tba)

    # Comments and whitespace

    token nl {["\n"|"r\n"|"\r"|"\f"]+}

    token unclosed_comment {$}
    token comment {('<!--') .*? ['-->' | <unclosed_comment>]
		  |('/*')  .*?  ['*/'  | <unclosed_comment>]}

    token ws_char {"\n" | "\t" | "\f" | "\r" | " " }

    token ws {<!ww>[<ws_char>|<comment>]*}

    # "lexer"

    rule unicode	{'\\'(<[0..9 a..f A..F]>**1..6)}
    rule nonascii	{<[\o241..\o377]>}
    rule escape		{<unicode>|'\\'<[' '..~¡..ÿ]>}
    rule stringchar	{<escape>|<nonascii>|<[\o40 \! \# \$ \% \& \( .. \~]>}
    rule nmstrt		{<[a..z A..Z]>|<nonascii>|<escape>}
    rule nmchar		{<[\- a..z A..Z 0..9]>|<nonascii>|<escape>}
    rule ident		{<nmstrt><nmchar>*}
    rule name		{<nmchar>+}
    rule d		{<[0..9]>}
    rule notnm		{<-[\- a..z A..Z 0..9\\]>|<nonascii>}
    rule num		{[<d>*\.]?<d>+}
    rule string		{\"(<stringchar>|\')*\" | \'(<stringchar>|\")*\'}

    rule id             {'#'<name>}
    rule class          {'.'<name>}

    rule percentage     {<num>'%'}
    rule length         {<num>(:i[pt|mm|cm|pc|in|px|em|ex])}
    rule angle          {<num>(:i[deg|rad|grad])}  # css2+
    rule time           {<num>(:i[m?s])}  # css2+
    rule freq           {<num>(:i[k?Hz])} # css2+
    # see discussion in http://www.w3.org/TR/CSS21/grammar.html G.3
    rule dimension      {<num>(<[a..zA..Z]>\w*)}

# I was having trouble grokking the CSS2 url parsing rules, so have
# re-expressed the URI CSS2 parsing rules as perl6 symbol tokens.
# This rule is constructed from  http://www.w3.org/TR/CSS21/syndata.html#uri,
# which mentions that uri escapes are permitted (%20 etc),
# The grammar also seems to allow backslash escape sequences ( \' etc )
# Url character sets are taken from http://tools.ietf.org/html/rfc3986
# (URI generic Syntax).

    # need to be escaped - so that css term url(...) is parseable
    rule url_delim_char {\( | \) | ' ' | "'"| '"' }

    proto rule url_char {<...>}
    rule url_char:sym<escape>      {<escape>}
    rule url_char:sym<path>        {'/'}
    rule url_char:sym<esc_delim>   {'%'}
    rule url_char:sym<gen_delim>   {':' | '|' | '?' | '#' | '[' | ']' | '@'}
    rule url_char:sym<sub_delim>   {'!' | '$' | '&' | "'" | '(' | ')'
                                   | '*' | '+' | ',' | ';' | '='}
    rule url_char:sym<unreserved>  {\w|'-'|'.'|'~'}
    rule url_chars                 {[<!url_delim_char><url_char>]+}
    rule url_spec                  {<string>|<url_chars>}
}
