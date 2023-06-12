print('Sourcing file ' .. vim.fn.expand('<sfile>:t'))

-- set CPP options for ALE
vim.g.ale_c_cc_options = '-std=c99 -Wall -Wextra -Wno-override-init -DAST_K2_ -D_DIAB_TOOL -Irtk-mpc5777m/bundle/include -Irtk-mpc5777m/bundle/lib/include -Irtk-mpc5777m/sources_bundle/include -Irtk-mpc5777m/sources_bundle/lib/include -Icomponent_tests/lib/kunit/include'

