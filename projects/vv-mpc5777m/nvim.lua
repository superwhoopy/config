-- set CPP options for ALE
vim.g.ale_c_cc_options = table.concat({
  '-std=c99',
  '-Wall',
  '-Wextra',
  '-Wno-override-init',
  '-Wno-int-to-void-pointer-cast',
  '-DAST_K2_',
  '-D_DIAB_TOOL',
  '-Irtk-mpc5777m/bundle/include',
  '-Irtk-mpc5777m/bundle/lib/include',
  '-Irtk-mpc5777m/sources_bundle/include',
  '-Irtk-mpc5777m/sources_bundle/lib/include',
  '-Icomponent_tests/lib/kunit/include',
  '-Icomponent_tests/lib/helpers',
  '-DMAIN_CORE=0',
  '-DWRITER_CORE=0',
  '-DREADER_CORE=1',
  '-DREADER_CORE_A=2',
}, ' ')

-- command to regenerate Tags
local function runCtags(args)
  vim.api.nvim_command("!ctags -R --languages=C,C++,Python " .. table.concat({
      "rtk-mpc5777m",
      "_pylib",
      "include",
      "software_tests/procedures/common",
      "software_tests/procedures/multicore/lib",
      "component_tests/lib"
    }, " "))
end
vim.api.nvim_create_user_command('MkTags', runCtags, {bang = true})

-- autocommands (auto-clears the group if it exists)
local augroup_id = vim.api.nvim_create_augroup("vvmpc5777m", {})

-- better editing of template files
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  group   = augroup_id,
  pattern = {"*/testproc-template/*.c",},
  command = "set filetype=c.jinja",
})
vim.api.nvim_create_autocmd({"FileType"}, {
  group   = augroup_id,
  pattern = {"c.jinja",},
  command = "ALEDisableBuffer",
})

-- set makeprg for toml files
vim.api.nvim_create_autocmd({"FileType"}, {
  group   = augroup_id,
  pattern = { "toml" },
  callback = function(ev)
    local toml_file = '"' .. vim.fn.expand('%') .. '"'
    local toml_basedir = '"' .. vim.fn.expand('%:h') .. '"'
    local testproc_tpl = '"' .. vim.fn.expand('%:h') .. '\\testproc-template"'
    vim.opt_local.makeprg = table.concat({
      ".venv\\Scripts\\python",
      "component_tests\\misc\\tpgen.py",
      "--output",
      toml_basedir,
      toml_file,
      testproc_tpl
    }, " ")
  end,
})
