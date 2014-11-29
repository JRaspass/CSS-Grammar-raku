perl6-CSS-Grammar
=================

CSS::Grammar is under construction as an experimental set of Perl 6 grammars for the W3C family of CSS standards.

It aims to implement a reasonable portion of the base grammars with an
emphasis on:

- support for CSS1, CSS2.1 and CSS3
- forward compatibility rules, scanning and error recovery

This module performs only generic parsing of declarations in style-sheet rules.

Contents
========

Base Grammars
-------------
- `CSS::Grammar::CSS1`  - CSS 1.0 compatible grammar
- `CSS::Grammar::CSS21` - CSS 2.1 compatible grammar
- `CSS::Grammar::CSS3`  - CSS 3.0 (core) compatible grammar

The CSS 3.0 core grammar, `CSS::Grammar::CSS3`, is mostly feature-compatabile with CSS2.1. In particular, it understands:

- `#hex` and `rgb(...)` colors; but not `rgba(..)`, `hsl(...)`, `hsla(...)` or named colors.
- basic `@media` at-rules; but not advanced media queries, resolutions or embedded `@page` rules.
- basic `@page` page description rules
- basic css2.1 compatibile selectors.

Parser Actions
--------------
`CSS::Grammar::Actions` can be used with in conjunction with any of the CSS1
CSS21 or CSS3 base grammars. It produces an abstract syntax tree (AST), plus
warnings for any unexpected input.

    use v6;
    use CSS::Grammar::CSS3;
    use CSS::Grammar::Actions;

    my $css = 'H1 { color: blue; gunk }';

    my $actions =  CSS::Grammar::Actions.new;
    my $p = CSS::Grammar::CSS3.parse($css, :actions($actions));
    note $_ for $actions.warnings;
    say "H1: " ~ $p.ast[0]<ruleset><selectors>.perl;
    # output:
    # skipping term: gunk
    # H1: ["selector" => ["simple_selector" => ["element_name" => "H1"]]]

Installation (Rakudo Star)
--------------------------

You'll first need to download and build Rakudo Star 2013.05 or better (http://rakudo.org/downloads/star/ - don't forget the final `make install`):

Ensure that `perl6` and `panda` are available on your path, e.g. :

    % export PATH=~/src/rakudo-star-2013.05/install/bin:$PATH

You can then use `panda` to test and install `CSS::Grammar`:

    % panda install CSS::Grammar

To try parsing some content:

    % perl6 -MCSS::Grammar::CSS3 -e"say CSS::Grammar::CSS3.parse('H1 {color:blue}')"

See Also
========
- [CSS::Module](https://github.com/p6-css/perl6-CSS-Module) extends CSS::Grammar. Its aim is to perform property-specific validation for CSS Levels 1, 2.1 and 3.
- [CSS::Writer](https://github.com/p6-css/perl6-Writer-Grammar) - AST reserializer
- [CSS::Drafts](https://github.com/p6-css/perl6-CSS-Drafts) construction area for draft/experimental CSS Level 3 extension modules.
- [CSSGrammar.pm](https://github.com/perl6/perl6-examples/blob/master/parsers/CSSGrammar.pm) from [perl6-examples](https://github.com/perl6/perl6-examples) gives an introductory Perl 6 grammar for CSS 2.1.

References
==========
These grammars have been built from the W3C CSS Specifications. In particular:

- CSS 1.0 Grammar - http://www.w3.org/TR/2008/REC-CSS1-20080411/#appendix-b
- CSS 2.1 Grammar - http://www.w3.org/TR/CSS21/grammar.html
- CSS3 module: Syntax - http://www.w3.org/TR/2003/WD-css3-syntax-20030813/
- CSS Style Attributes - http://www.w3.org/TR/2010/CR-css-style-attr-20101012/#syntax
