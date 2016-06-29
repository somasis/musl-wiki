all
rule 'MD003', :style => :atx            # atx style headers
rule 'MD004', :style => :dash           # enforce dashes for unordered lists
rule 'MD007', :indent => 4              # four spaces for indentation
rule 'MD013', :code_blocks => false     # don't check line length in code blocks
rule 'MD013', :tables => false          # don't check line length in tables
rule 'MD026', :punctuation => ".,;:"    # allow !? at header end
rule 'MD029', :style => :ordered        # enforce incremental ordered lists

exclude_rule 'MD025'    # allow multiple top level, for gollum h1 title
