-- set CPP options for ALE
vim.g.ale_c_cc_options = '-Wall -Wextra -DAST_K2_ -D_DIAB_TOOL -DAST_ARCH_E500 -Ibundle/include -Ibundle/lib/include -Ibundle/include/arch/e500 -Isources_bundle/include -Isources_bundle/include/sources/xt_source'

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
    "bundle/include/bsp/asterios_configuration.h",
    "bundle/include/k2/checksum.h",
    "bundle/include/k2/hal_app.h",
    "bundle/include/k2/hal_relocate.h",
    "bundle/include/k2/hal_system_check.h",
    "bundle/include/k2/md5.h",
    "bundle/include/startup/arch_init.h",
    "bundle/include/startup/k2_init.h",
    "bundle/src/arch/e500/asm/_start_procedure.s",
    "bundle/src/arch/e500/asm/stack_init.s",
    "bundle/src/hal/hal_app.c",
    "bundle/src/hal/hal_relocate.c",
    "bundle/src/hal/hal_system_check.c",
    "bundle/src/startup/arch_init.c",
    "bundle/src/startup/boot_config.c",
    "bundle/src/startup/copy_table.c",
    "bundle/src/startup/k2_init.c",
    "bundle/src/services/md5.c",
    "bundle/src/chunks_checksum.c",
    "bundle/src/clear_table.c",
    "bundle/src/root_checksum.c",
    "source_bundle/include/sources/xt_source/k2/checksum_source.h",
    "source_bundle/src/sources/xt_source/md5_memory_chunks.c",
    "source_bundle/src/sources/xt_source/md5_root_checksum.c",
  },

  ["RSF Scheduler"] = {
    "bundle/include/k2/scheduler.h",
    "bundle/src/scheduler/rsf_scheduler_wa.c",
  },

  ["Quota"] = {
    "bundle/include/asm/timer_bits.inc",
    "bundle/include/k2/hal_quota.h",
    "bundle/include/quota/cpu_helper.h",
    "bundle/include/quota/decrementer.h",
    "bundle/include/quota/quota_tick_handler.h",
    "bundle/include/quota/profiling_mark.h",
    "bundle/src/arch/e500/asm/dec_get_timebase.s",
    "bundle/src/arch/e500/asm/dec_timebase_enable.s",
    "bundle/src/quota/asm/cpu_external_irq_enable.s",
    "bundle/src/quota/asm/dec_implem.s",
    "bundle/src/quota/decrementer.c",
    "bundle/src/quota/hal_profiling_get_elapsed_time.c",
    "bundle/src/quota/hal_quota.c",
  },

  ["Source"] = {
    "source_bundle/include/sources/xt_source/source_xt_source.h",
    "source_bundle/include/sources/xt_source/xt_source_arch.h",
    "source_bundle/include/sources/xt_source/xt_source_errors.h",
    "source_bundle/include/sources/xt_source/xt_source_gpio.h",
    "source_bundle/include/sources/xt_source/xt_source_parameters.h",
    "source_bundle/include/sources/xt_source/xt_source_timer.h",
    "source_bundle/include/sources/xt_source/xt_source_watchdog.h",
    "source_bundle/include/sources/xt_source/bsp/far_jump_functions.h",
    "source_bundle/src/sources/xt_source/binary_bridge.c",
    "source_bundle/src/sources/xt_source/xt_source.c",
    "source_bundle/src/sources/xt_source/xt_source_errors.c",
    "source_bundle/src/sources/xt_source/xt_source_gpio.c",
    "source_bundle/src/sources/xt_source/xt_source_parameters.c",
    "source_bundle/src/sources/xt_source/xt_source_timer.c",
    "source_bundle/src/sources/xt_source/xt_source_watchdog.c",
  },

  ["Alarm"] = {
    "bundle/include/k2/hal_alarm.h",
    "bundle/src/hal/hal_alarm.c",
  },

  ["Trap"] = {
    "bundle/include/asm/syscall.inc",
    "bundle/include/k2/hal_trap.h",
    "bundle/include/trap/syscall.h",
    "bundle/src/arch/e500/asm/syscall_handler.s",
    "bundle/src/trap/asm/hal_trap.s",
    "bundle/src/trap/asm/hal_trap_agent.s",
    "bundle/src/trap/asm/hal_trap_idle.s",
    "bundle/src/trap/arch_em_invalid_syscall.c",
    "bundle/src/trap/syscall.c",
  },

  ["Context Manager"] = {
    "bundle/include/arch/e500/asm/cache_csr_bits.inc",
    "bundle/include/k2/mk.h",
    "bundle/include/arch/e500/context/hwctx_def.h",
    "bundle/include/arch/e500/context/idle_hwctx.h",
    "bundle/include/context/arch_em_recursive_exception.h",
    "bundle/include/context/cache_helper.h",
    "bundle/include/context/hwctx_management.h",
    "bundle/include/context/idle.h",
    "bundle/include/context/mk_stacks.h",
    "bundle/src/arch/e500/asm/ctx_freshstart.s",
    "bundle/src/arch/e500/asm/ctx_restore.s",
    "bundle/src/arch/e500/asm/ctx_save.s",
    "bundle/src/arch/e500/asm/run_on_stack.s",
    "bundle/src/arch/e500/hwctx_init_context.c",
    "bundle/src/arch/e500/hwctx_init_idle.c",
    "bundle/src/arch/e500/hwctx_init_task_job.c",
    "bundle/src/arch/e500/hwctx_init_task_system.c",
    "bundle/src/arch/e500/hwctx_init_task_user.c",
    "bundle/src/context/asm/idle_main.s",
    "bundle/src/context/arch_em_recursive_exception.c",
    "bundle/src/context/hal_ctx_freshstart.c",
    "bundle/src/context/hal_run_on_stack.c",
    "bundle/src/context/hwctx_init.c",
    "bundle/src/context/idle_stack_core0.c",
    "bundle/src/context/idle_task_core0.c",
    "bundle/src/context/mk_hwctx.c",
    "bundle/src/context/mk_stack_core0.c",
    "bundle/src/context/mk_stacks.c",
    "bundle/src/mk/mk.c",
  },


  ["Exception Handler"] = {
    "bundle/include/asm/fault.inc",
    "bundle/include/asm/ivor.inc",
    "bundle/include/interrupts/arch_em_invalid_interrupts.h",
    "bundle/include/interrupts/arch_fault_handler.h",
    "bundle/include/interrupts/pic_irq_controller.h",
    "bundle/src/arch/e500/hw_fault_analyze.c",
    "bundle/src/interrupts/asm/fault_handlers.s",
    "bundle/src/interrupts/asm/ivors.s",
    "bundle/src/interrupts/asm/ivor_init.s",
    "bundle/src/interrupts/arch_em_invalid_interrupts.c",
    "bundle/src/interrupts/ext_irq_init.c",
    "bundle/src/interrupts/hw_fault_raise.c",
    "bundle/src/interrupts/pic_init.c",
    "bundle/src/interrupts/pic_irq_handler.c",
    "bundle/src/interrupts/pic_irq_set_vector.c",
  },

  ["Memory Management"] = {
    "bundle/include/asm/mas_bits.inc",
    "bundle/include/k2/hal_spatial.h",
    "bundle/include/mmu/mmu.h",
    "bundle/include/mmu/mmu_helper.h",
    "bundle/src/k2_spatial_protection_table.c",
    "bundle/src/mmu/asm/irq_mask_save.s",
    "bundle/src/mmu/asm/irq_restore.s",
    "bundle/src/mmu/asm/mmu_invalidate.s",
    "bundle/src/mmu/asm/mmu_set_address_space.s",
    "bundle/src/mmu/asm/mmu_set_entry.s",
    "bundle/src/mmu/asm/mmu_tlb1_clear_selected.s",
    "bundle/src/mmu/asm/mmu_tlb1_set_init_mapping.s",
    "bundle/src/mmu/hal_spatial.c",
    "bundle/src/mmu/mmu_init.c",
    "bundle/src/mmu/mmu_load_descriptors.c",
  },

  ["Clock"] = {
    "bundle/include/k2/clock.h",
    "bundle/src/psyslayer/clock.c",
  },

  ["Agent Cadencing"] = {
    "bundle/include/k2/core.h",
    "bundle/include/k2/psyslayer.h",
    "bundle/src/psyslayer/advance.c",
    "bundle/src/psyslayer/core.c",
    "bundle/src/psyslayer/init.c",
  },

  ["Job Cadencing"] = {
    "bundle/include/k2/job.h",
    "bundle/src/job/job.c",
    "bundle/src/job/worker_init.c",
  },

  ["Temporal Variable Management"] = {
    "bundle/include/k2/temporal.h",
    "bundle/include/k2/temporal_circular_buffer.h",
    "bundle/src/psyslayer/temporal.c",
    "bundle/src/psyslayer/temporal_init.c",
  },

  ["Stream Management"] = {
    "bundle/include/k2/stream.h",
    "bundle/src/psyslayer/stream.c",
  },

  ["Psy Library"] = {
    "bundle/lib/include/k2/libpsy.h",
    "bundle/lib/include/k2/libpsy_internal.h",
    "bundle/lib/src/libpsy.c",
    "bundle/lib/src/libpsy_job.c",
    "bundle/lib/src/libpsy_tv.c",
    "bundle/lib/src/libpsy_stream.c",
    "bundle/lib/src/libpsy_error.c",
    "bundle/lib/src/libpsy_error_worker_init.c",
  },

  ["Error Management"] = {
    "bundle/include/k2/em.h",
    "bundle/include/k2/em_helper_private.h",
    "bundle/include/k2/em_private.h",
    "bundle/include/k2/hal_em.h",
    "bundle/src/em/em_early.c",
    "bundle/src/em/em_fatal.c",
    "bundle/src/em/em_helper_libpsy.c",
    "bundle/src/em/em_helper_mk.c",
    "bundle/src/em/em_idle_run.c",
    "bundle/src/em/em_non_fatal.c",
    "bundle/src/em/em_raise.c",
    "bundle/src/em/em_request.c",
    "bundle/src/em/em_util.c",
    "bundle/src/em/hal_em_board.c",
    "bundle/src/em/hal_em_memory.c",
  },

  ["Profiling"] = {
    "bundle/include/k2/hal_profiling.h",
    "bundle/include/k2/profiling.h",
    "bundle/include/k2/profiling_init.h",
    "bundle/src/services/profiling_init.c",
    "bundle/src/services/profiling.c",
  },

  ["Services"] = {
    "bundle/include/k2/kmemory.h",
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
