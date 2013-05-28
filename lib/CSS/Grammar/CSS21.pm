use v6;

use CSS::Grammar;
# specification: http://www.w3.org/TR/2011/REC-CSS2-20110607/

grammar CSS::Grammar::CSS21:ver<20110607.001>
    is CSS::Grammar {

    rule TOP {^ <stylesheet> $}

    # productions
    rule stylesheet { <charset>?
                      [<import> || <misplaced>]*
                      ['@'<at-rule> | <ruleset> || <misplaced> || <unknown>]* }

    rule charset { \@(:i'charset') <string> ';' }
    rule import  { \@(:i'import')  [<string>|<url>] <media-list>? ';' }
    # to detect out of order directives
    rule misplaced {<charset>|<import>}

    proto rule at-rule {*}

    rule at-rule:sym<media>   {(:i'media') <media-list> <media-rules> }
    rule media-list           {<media-query> +% ','}
    rule media-query          { <media=.ident> }
    rule media-rules          {'{' <ruleset>* <.end-block>}

    rule at-rule:sym<page>    {(:i'page')  <page=.page-pseudo>? <declarations> }
    rule page-pseudo          {':'<ident>}

    # inherited combinators: '+' (adjacent)
    token combinator:sym<not> { '-' }

    rule ruleset {
        <!after \@> # not an "@" rule
        <selectors> <declarations>
    }

    rule selectors {<selector> +% ','}

    rule declarations {
        '{' <declaration-list> <.end-block>
    }

    # this rule is suitable for parsing style attributes in HTML documents.
    # see: http://www.w3.org/TR/2010/CR-css-style-attr-20101012/#syntax
    #
    rule declaration-list { [ <declaration> || <dropped-decl> ]* }

    rule declaration:sym<base>       { <property> <expr> <prio>? <end-decl> }

    # should be '+%' - see rakudo rt #117831
    rule expr { <term> +%% [ <operator>? ] }

    proto token angle          {<...>}
    token angle-units          {:i[deg|rad|grad]}
    token angle:sym<dim>       {:i<num><units=.angle-units>}
    token dimension:sym<angle> {<angle>}

    token time-units           {:i m?s}
    proto token time           {<...>}
    token time:sym<dim>        {<num><units=.time-units>}
    token dimension:sym<time>  {<time>}

    proto token frequency      {<...>}
    token frequency-units      {:i k?Hz}
    token frequency:sym<dim>   {:i<num><units=.frequency-units>}
    token dimension:sym<frequency>  {<frequency>}

    rule term:sym<function>  {<function>}

    # should be '+%' - see rakudo rt #117831
    rule selector{ <simple-selector> +%% <combinator>? }

    token universal {'*'}
    token qname     {<element-name>}
    rule simple-selector { [<qname>|<universal>][<id>|<class>|<attrib>|<pseudo>]*
                           |                           [<id>|<class>|<attrib>|<pseudo>]+ }

    rule attrib  {'[' <ident> [ <attribute-selector> [<ident>|<string>] ]? ']'}

    proto token attribute-selector {*}
    token attribute-selector:sym<equals>   {'='}
    token attribute-selector:sym<includes> {'~='}
    token attribute-selector:sym<dash>     {'|='}

    rule pseudo:sym<element> {':'$<element>=[:i'first-'[line|letter]|before|after]}
    rule pseudo:sym<function> {':'[<function=.pseudo-function>||<any-pseudo-func>]}
    # assume anything else is a class
    rule pseudo:sym<class>     {':' <class=.ident> }

    token function      {<function=.ident>'(' [<args=.expr>||<args=.any-arg>]* ')'}

    proto rule pseudo-function { <...> }
    rule pseudo-function:sym<lang> {:i'lang(' [ <ident> || <any-args> ] ')'}
    # pseudo function catch-all
    rule any-pseudo-func   {<ident>'(' [<args=.expr>||<args=.any-arg>]* ')'}

    # 'lexer' css2 exceptions
    # non-ascii limited to single byte characters
    token nonascii            {<[\o240..\o377]>}
}

