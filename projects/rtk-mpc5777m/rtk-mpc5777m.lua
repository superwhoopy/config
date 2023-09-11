-- set CPP options for ALE
vim.g.ale_c_cc_options = '-Wall -Wextra -DAST_K2_ -D_DIAB_TOOL -Ibundle/include -Ibundle/lib/include -Isources_bundle/include -Isources_bundle/lib/include'

-- disable linting of assembly files
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.inc",},
  command = "set filetype=asm",
})

vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"asm",},
  command = "ALEDisableBuffer",
})

-- Component identification
local components_table = {
  ["Start-up"] = {
    "bundle/src/startup/asm/_start_procedure.S",
    "bundle/src/startup/asm/_start_procedure_secondary.S",
    "bundle/src/startup/asm/boot_table.S",
    "bundle/src/startup/asm/dcache_init.S",
    "bundle/src/startup/asm/icache_init.S",
    "bundle/src/startup/asm/lmem_config.S",
    "bundle/src/startup/asm/mk_stack_init.S",
    "bundle/src/startup/arch_init.c",
    "bundle/src/startup/arch_init_secondary.c",
    "bundle/src/startup/arch_relocate.c",
    "bundle/src/startup/boot_config.c",
    "bundle/src/startup/k2_init.c",
    "bundle/src/hal/hal_system_check.c",
    "bundle/src/hal/hal_app.c",
    "bundle/src/services/md5.c",
    "bundle/src/chunks_checksum.c",
    "bundle/src/root_checksum.c",
    "sources_bundle/src/sources/xt_source/md5_memory_chunks.c",
    "sources_bundle/src/sources/xt_source/md5_root_checksum.c",
  },

  ["RSF Scheduler"] = {
    "bundle/src/scheduler/rsf_scheduler_wa.c",
  },

  ["Quota"] = {
    "bundle/src/quota/hal_quota.c",
  },

  ["Source"] = {
    "sources_bundle/src/sources/xt_source/binary_bridge.c",
    "sources_bundle/src/sources/xt_source/xt_source_gpio.c",
    "sources_bundle/src/sources/xt_source/xt_source_timer.c",
    "sources_bundle/src/sources/xt_source/xt_source_watchdog.c",
    "sources_bundle/src/sources/xt_source/xt_source_errors.c",
    "sources_bundle/src/sources/xt_source/source_xt_source.c",
  },

  ["Alarm"] = {
    "bundle/src/hal/hal_alarm.c",
  },

  ["Trap"] = {
    "bundle/src/trap/asm/hal_trap.S",
    "bundle/src/trap/asm/hal_trap_agent.S",
    "bundle/src/trap/asm/syscall_handler.S",
    "bundle/src/trap/syscall.c",
  },

  ["Context Manager"] = {
    "bundle/include/context/asm/context.inc",
    "bundle/src/mk/mk.c",
    "bundle/src/context/asm/context_restore.S",
    "bundle/src/context/asm/hwctx_restore.S",
    "bundle/src/context/asm/hwctx_freshstart.S",
    "bundle/src/context/idle_init.c",
    "bundle/src/context/stack_init.c",
    "bundle/src/context/idle_stack_core0.c",
    "bundle/src/context/idle_stack_core1.c",
    "bundle/src/context/idle_stack_core2.c",
    "bundle/src/context/idle_task_core0.c",
    "bundle/src/context/idle_task_core1.c",
    "bundle/src/context/idle_task_core2.c",
    "bundle/src/context/idle_main.c",
    "bundle/src/context/mk_stack_core0.c",
    "bundle/src/context/mk_stack_core1.c",
    "bundle/src/context/mk_stack_core2.c",
    "bundle/src/context/mk_stacks.c",
    "bundle/src/context/hwctx.c",
    "bundle/src/context/hwctx_manager.c",
  },


  ["Exception Handler"] = {
    "bundle/src/interrupts/asm/int_init.S",
    "bundle/src/interrupts/asm/mpc5777m_vectors.S",
    "bundle/src/interrupts/asm/irq_set_enable.S",
    "bundle/src/interrupts/asm/irq_get_handler.S",
    "bundle/src/interrupts/asm/ext_it_handler.S",
    "bundle/src/interrupts/asm/fault_handler.S",
    "bundle/src/interrupts/intc_irq_enable.c",
    "bundle/src/interrupts/irq_get_ext_handler.c",
    "bundle/src/interrupts/intc_softirq_broadcast.c",
    "bundle/src/interrupts/arch_fault_handler.c",
  },

  ["Memory Management"] = {
    "bundle/src/mpu/asm/mpu_enable.S",
    "bundle/src/mpu/asm/mpu_set_entry.S",
    "bundle/src/mpu/asm/mpu_invalidate.S",
    "bundle/src/mpu/asm/mpu_supervisor_read_bypass.S",
    "bundle/src/mpu/k2_spatial_protection_table.c",
    "bundle/src/mpu/mpu_init.c",
    "bundle/src/mpu/mpu_load_descriptors.c",
    "bundle/src/mpu/hal_spatial.c",
  },

  ["Clock"] = {
    "bundle/src/psyslayer/clock.c",
  },

  ["Agent Cadencing"] = {
    "bundle/src/psyslayer/init.c",
    "bundle/src/psyslayer/core.c",
    "bundle/src/psyslayer/advance.c",
  },

  ["Job Cadencing"] = {
    " bundle/src/job/worker_init.c",
    " bundle/src/job/job.c",
  },

  ["Temporal Variable Management"] = {
    "bundle/src/psyslayer/temporal_init.c",
    "bundle/src/psyslayer/temporal.c",
  },

  ["Stream Management"] = {
    "bundle/src/psyslayer/stream.c",
  },

  ["Psy Library"] = {
    "bundle/lib/src/libpsy.c",
    "bundle/lib/src/libpsy_job.c",
    "bundle/lib/src/libpsy_tv.c",
    "bundle/lib/src/libpsy_stream.c",
    "bundle/lib/src/libpsy_error.c",
    "bundle/lib/src/libpsy_error_worker_init.c",
  },

  ["Error Management"] = {
    "bundle/src/em/asm/em_broadcast_irq_handler.S",
    "bundle/src/em/arch_em_helper.c",
    "bundle/src/em/em_helper_mk.c",
    "bundle/src/em/em_helper_libpsy.c",
    "bundle/src/em/em_util.c",
    "bundle/src/em/hal_em.c",
    "bundle/src/em/em_request.c",
    "bundle/src/em/em_early.c",
    "bundle/src/em/em_raise.c",
    "bundle/src/em/em_fatal.c",
    "bundle/src/em/em_non_fatal.c",
    "bundle/src/em/em_idle_run.c",
  },

  ["Profiling"] = {
    "bundle/src/services/profiling_init.c",
    "bundle/src/services/profiling.c",
  },

  ["Services"] = {
    "bundle/src/services/kmemory.c",
  },
}

local reversed_components_table = (function()
  local ans = {}
  for comp, files in pairs(components_table) do
    for _, file in ipairs(files) do
      ans[file] = comp
    end
  end
  return ans
end)()

lualine = require('lualine')

local _lc = lualine.get_config().sections.lualine_c
table.insert(_lc, 1, function()
                       local ans = reversed_components_table[
                                vim.fn.expand('%'):gsub('\\','/')]
                       if ans == nil then
                         ans = ''
                       end
                       return ans
                     end)
lualine.setup {
  sections = {
    lualine_c = _lc
  }
}
