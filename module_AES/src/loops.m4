divert(-1)
define(`forstep', `pushdef(`$1')_$0(`$1', eval(`$2'), eval(`$3'), eval(`$4'),
  `$5')popdef(`$1')')')
define(`_forstep',
  `define(`$1', `$2')$5`'ifelse(`$2', `$3', `',
  `$0(`$1', eval(`$2 + $4'), `$3', `$4', `$5')')')
define(`for', `forstep(`$1', `$2', `$3', `1', `$4')')
divert(0)dnl
