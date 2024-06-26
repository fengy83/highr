library(testit)

assert('hi_latex() works without prompts', {
  (hi_latex('1+1') %==% '\\hlnum{1}\\hlopt{+}\\hlnum{1}')
  (hi_latex('  1 +    1') %==% '  \\hlnum{1} \\hlopt{+}    \\hlnum{1}')
  (hi_latex(c('  if (TRUE ){', 'foo && bar}')) %==% c(
    '  \\hlkwa{if} \\hldef{(}\\hlnum{TRUE} \\hldef{)\\{}',
    '\\hldef{foo} \\hlopt{&&} \\hldef{bar\\}}'
  ))
})


assert('hi_latex() works with prompts', {
  (hi_latex('1+1', prompt=TRUE) %==% '\\hldef{> }\\hlnum{1}\\hlopt{+}\\hlnum{1}')
  (hi_latex(c('  if (TRUE ){', 'foo && bar}'), prompt = TRUE) %==% paste(
    '\\hldef{> }  \\hlkwa{if} \\hldef{(}\\hlnum{TRUE} \\hldef{)\\{}',
    '\\hldef{+ }\\hldef{foo} \\hlopt{&&} \\hldef{bar\\}}', sep = '\n'
  ))
})

assert('hi_latex() preserves blank lines', {
  (hi_latex(c('1+1','','foo(x=3) # comm')) %==% c(
    '\\hlnum{1}\\hlopt{+}\\hlnum{1}\n',
    '\\hlkwd{foo}\\hldef{(}\\hlkwc{x}\\hldef{=}\\hlnum{3}\\hldef{)} \\hlcom{# comm}'
  ))
})

assert('the fallback method recognizes comments, functions and strings', {
  (hi_latex('1+1 # a comment', fallback = TRUE) %==% '1+1 \\hlcom{# a comment}')
  (hi_latex('paste("STRING", \'string\')', fallback = TRUE) %==%
            '\\hlkwd{paste}(\\hlsng{"STRING"}, \\hlsng{\'string\'})')
})

assert('the fallback mode is used when the code does not parse', {
  (has_warning(res <- hi_latex('1+1+ # comment')))
  (res %==% '1+1+ \\hlcom{# comment}')
})

assert('hilight() works even if code only contains comments', {
  (hi_latex('# only comments') %==% '\\hlcom{# only comments}')
})

assert('the right arrow -> is preserved', {
  (hi_latex('1 ->x # foo') %==% '\\hlnum{1} \\hlkwb{->}\\hldef{x} \\hlcom{# foo}')
})

assert('blank lines before/after code are preserved', {
  (hi_latex(c('', '', '1')) %==% c('\n', '\\hlnum{1}'))
  (hi_latex(c('', '', '1', '')) %==% c('\n', '\\hlnum{1}', ''))
})

# define one's own markup data frame
my_cmd = cmd_html
my_cmd['NUM_CONST', 1] = '<span class="my num">'

assert('custom markup also works', {
  (hi_html('1+ 1') %==%
    '<span class="hl num">1</span><span class="hl opt">+</span> <span class="hl num">1</span>')
  (hi_html('1+ 1', markup = my_cmd) %==%
    '<span class="my num">1</span><span class="hl opt">+</span> <span class="my num">1</span>')
})

rm(my_cmd)
