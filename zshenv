# unmatched globs stay literal, like bash, instead of "no matches found"
unsetopt nomatch
# allow "# comments" in interactive/pasted commands, like bash
setopt interactive_comments
# no "!" history expansion
setopt no_bang_hist
