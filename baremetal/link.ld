/* https://cirosantilli.com/linux-kernel-module-cheat#baremetal-linker-script */
ENTRY(_start)
SECTIONS
{
  .text : {
    */bootloader.o(.text)
    *(.text)
    *(.rodata)
    *(.data)
    *(COMMON)
  }
  /* gem5 uses the bss as a measure of the kernel size. */
  .bss : { *(.bss) }
  /* Fix the addresses of everything that comes after, no matter
   * the exact size of the code present in .text. This allows us to
   * place CLI arguments in memory at a known location! */
  /* TODO would be better like this with --section-start=.lkmc_memory= on CLI,
   * so that Python controls this value, but I can't that fucking working.
   * baremetal_max_size from the Python must match  this offset for now.
   */
  /*. = SEGMENT_START(.lkmc_memory, .);*/
  . = ADDR(.text) + 0x1000000;
  lkmc_heap_low = .;
  . = . + 0x1000000;
  lkmc_heap_top = .;
  . = . + 0x1000000;
  lkmc_stack_top = .;
  lkmc_argc = .;
  . = . + 0x4;
  lkmc_argv = .;
}

