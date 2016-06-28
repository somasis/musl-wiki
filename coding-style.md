# Coding Style

At present, musl does not have a strict coding style policy. The best short
description of the coding style used in musl is "very similar to the Linux
kernel style". The style guidelines which follow are descriptive rather than
prescriptive; they document what's currently in use in musl, and hopefully give
a feel for how new code should look.

[[_TOC_]]

# Indention

The indention style in musl distinguishes between "indention" and "alignment".
Indention is leading whitespace that serves as a visual indicator of the block
structure of the code. Alignment is initial or internal whitespace used to line
up content on consecutive lines (e.g. a sequence of macro definitions or
typedefs or array initializers) or continuations of a line or statement onto
additional physical lines.

Indention is purely tabs, no spaces. Alignment is purely spaces, no tabs. A line
may have initial tabs followed by initial spaces if it's subject to both
indention and alignment. When a statement is split onto multiple lines, either
indention (1 additional level) or alignment (to align with some meaningful
location in the first line) may be used.

This style permits the code to be viewed correctly with any tab width setting.

# Column width

Code should aim to fit within 80 columns, with the default tab setting of 8
spaces. Breaking this rule is encouraged if the overflow is minimal and the
content that would be cut off when viewing at 80 columns is mostly uninteresting
or obvious.

# Spacing

Spaces are not used after casts or before the opening parenthesis of a function
call. Aside from these rules, spacing is one of the most flexible parts of the
coding style. It is desirable to adjust spacing to avoid breaking lines or going
over 80 columns, and to reflect grouping and operator precedence.

# Redundant type specifiers

The shortest possible name of a type should be used, especially in public
headers. Redundant type specifiers should not be used. This means "short" is
preferred over "short int" or "signed short int".

# Goto

Goto should be used sparingly, mainly to unify handling of errors that occur at
different points with common error handling code. In some cases it's also used
for adding "retry" logic to a function non-invasively, where it's undesirable
for the structure of the function to be shaped around the possibility of having
to retry. In a few cases, it's also used for starting the first iteration of a
loop in the middle of the loop body. The only thing goto should NOT be used for
is complex flow control logic.

# Variable names

Variable names are usually made up of lowercase letters; occasionally, digits
and underscores are used when there's a good reason. Variable names should not
be overly verbose.

Single-letter variable names are not frowned upon as long as their scope is
reasonably short. For a function less than 20 lines, it's very reasonable for
all local variables to have single-letter names. It's also reasonable for larger
functions to use single-letter variable names for the main object they're
working with for the whole duration of the function (e.g. "s" for a function
that's processing a string).

