.rsp

// OSTask placed at end of DMEM (IMEM_START - sizeof(OSTask))
.definelabel OSTask_addr, 0xfc0

// OSTask data member offsets
OSTask_flags            equ 0x04
OSTask_ucode            equ 0x10
OSTask_dram_stack       equ 0x20
OSTask_output_buff      equ 0x28
OSTask_output_buff_size equ 0x2c
OSTask_data_ptr         equ 0x30
OSTask_yield_data_ptr   equ 0x38

// OSTask flags
OS_TASK_YIELDED         equ 0x0001

// Stack pointer offsets
sp_n04               equ -0x04
sp_02                equ 0x02
sp_geometrymode      equ 0x04
sp_06                equ 0x06
sp_07                equ 0x07
sp_08                equ 0x08
sp_0c                equ 0x0c
sp_10                equ 0x10
sp_11                equ 0x11
sp_12                equ 0x12
sp_14                equ 0x14
sp_18                equ 0x18
sp_1c                equ 0x1c
sp_dram_stack        equ 0x20
sp_dram_stack_curpos equ 0x24
sp_output_buff       equ 0x40
sp_output_buff_size  equ 0x44
sp_dl_nestlevel      equ 0x4a
sp_dram_stack_end    equ 0x4c
sp_90                equ (addr01a0 - stack)
sp_f8                equ (lightcol + 0x18 - stack)

// RDP status read flags
DPC_STATUS_XBUS_DMA     equ 0x0001
DPC_STATUS_DMA_BUSY     equ 0x0100
DPC_STATUS_START_VALID  equ 0x0400

// RDP status write flags
DPC_STATUS_CLR_XBUS     equ 0x0001

SP_DRAM_STACK_SIZE      equ 0x280

SP_STATUS_YIELD         equ 0x0080 /* SIG0 */
SP_STATUS_SIG5          equ 0x1000
SP_STATUS_SIG7          equ 0x4000

DMA_READ                equ 0
DMA_WRITE               equ 1

.macro jumpTableEntry, addr
    .dh addr & 0xffff
.endmacro

.macro OverlayEntry, loadStart, loadEnd, imemAddr
    .dw loadStart
    .dh (loadEnd - loadStart - 1) & 0xffff
    .dh (imemAddr) & 0xffff
.endmacro

.create DATA_FILE, 0x0000

/* 0000 */
Overlay0Info:
OverlayEntry orga(Overlay0), orga(Overlay0End), Overlay0
Overlay1Info:
OverlayEntry orga(Overlay1), orga(Overlay1End), Overlay1
Overlay2Info:
OverlayEntry orga(Overlay2), orga(Overlay2End), Overlay2
Overlay3Info:
OverlayEntry orga(Overlay3), orga(Overlay3End), Overlay3
Overlay4Info:
OverlayEntry orga(Overlay4), orga(Overlay4End), Overlay4

addr0028:
/* 0028 */ .word 0x0ffaf006, 0x7fff0000

addr0030:
/* 0030 */ .word 0x00000001, 0x0002ffff, 0x40000004, 0x06330200

addr0040:
/* 0040 */ .word 0x7ffffff8, 0x00080040, 0x00208000, 0x01cccccc

addr0050:
/* 0050 */ .word 0x0001ffff, 0x00010001, 0x0001ffff, 0x00010001

addr0060:
/* 0060 */ .word 0x00020002, 0x00020002, 0x00020002, 0x00020002

clip:
.area 0x20, 0
    addr0070:
    /* 0070 */ .word 0x00010000
    .dh 0x0000

    addr0076:
    .dh 0x0001

    .word 0x00000001, 0x00000001

    /* 0080 */ .word 0x00010000, 0x0000ffff, 0x00000001, 0x0000ffff
.endarea

/* 0090 */ .word 0x00000000, 0x0001ffff, 0x00000000, 0x00000001

addr00a0:
/* 00a0 */ .dh load_lighting
/* 00a2 */ .dh 0x7fff
/* 00a4 */ .dh 0x571d

addr00a6:
/* 00a6 */ .dh 0x3a0c
/* 00a6 */ .dh 0x0001
/* 00a6 */ .dh 0x0002
/* 00a6 */ .dh 0x0100
/* 00a6 */ .dh 0x0200
/* 00b0 */ .dh 0x4000
.dh 0x0040

addr00b4:
/* 00b4 */ .dh 0x0000

ptr_yield_with_dma_wait:
/* 00b6 */ .dh yield_with_dma_wait

mask_00ffffff:
/* 00b8 */ .word 0x00ffffff

/* 00bc */
master_dispatch_table:
.dh dispatch_dma
addr00be:
.dh sp_noop
.dh dispatch_imm
.dh dispatch_rdp

/* 00c4 */
dma_dispatch_table:
/* cmd 00 */ .dh sp_noop
/* cmd 01 */ .dh dma_mtx
/* cmd 02 */ .dh sp_noop
/* cmd 03 */ .dh dma_movemem
/* cmd 04 */ .dh dma_vtx
/* cmd 05 */ .dh sp_noop
/* cmd 06 */ .dh dma_dl
/* cmd 07 */ .dh dma_col // new in PD
/* cmd 08 */ .dh sp_noop

/* 00d6 */
imm_dispatch_table:
/* cmd b0 */ .dh sp_noop
/* cmd b1 */ .dh imm_tri4 // new in PD
/* cmd b2 */ .dh imm_rdphalf_cont
/* cmd b3 */ .dh imm_rdphalf_2
/* cmd b4 */ .dh imm_rdphalf_1
/* cmd b5 */ .dh sp_noop
/* cmd b6 */ .dh imm_cleargeometrymode
/* cmd b7 */ .dh imm_setgeometrymode
/* cmd b8 */ .dh imm_enddl
/* cmd b9 */ .dh imm_setothermode_l
/* cmd ba */ .dh imm_setothermode_h
/* cmd bb */ .dh imm_texture
/* cmd bc */ .dh imm_moveword
/* cmd bd */ .dh sp_noop // imm_popmtx removed in PD
/* cmd be */ .dh sp_noop // imm_culldl removed in PD
/* cmd bf */ .dh imm_tri1

/* 00f6 */
addr00f6_table:
.dh found_in

addr00f8:
.dh found_out
.dh found_first_in
.dh found_first_out

addr00fe:
.dh clip_draw_loop

addr0100:
.dh perform_clip

addr0102:
.dh next_clip

addr0104:
.dh dma_wait_dl

addr0106:
.dh 0x0000

yield_data_ptr:
/* 0108 */ .word 0x00000000, 0x00000000

stack:
.area 0x50, 0
    perspnorm:
    /* 0110 */ .word 0x0000ffff, 0x00000000, 0xef080cff, 0x00000000
    /* 0120 */ .word 0x00000000, 0x00000000, 0x00000000

    numlights:
    .word 0x80000040
    /* 0130 */ .word 0x00000000, 0x00000000

    txtatt:
    .word 0x40004000

    .word 0x00000000
    /* 0140 */ .word 0x00000000, 0x00000000, 0x00000000, 0x00000000
    /* 0150 */ .word 0x00000000, 0x00000000

    addr0158:
    .word 0x00000000, 0x00000000
.endarea

segment_table:
/* 0160 */ .fill 16 * 4, 0

addr01a0:
/* 01a0 */ .word 0x80000000, 0x80000000, 0x00000000, 0x00000000

lookaty:
/* 01b0 */ .word 0x00800000, 0x00800000, 0x7f000000, 0x00000000
/* 01c0 */ .word 0x00000000, 0x00000000, 0x00000000, 0x00000000

lookatx:
/* 01d0 */ .word 0x00000000, 0x00000000, 0x007f0000, 0x00000000
/* 01e0 */ .word 0x00000000, 0x00000000, 0x00000000, 0x00000000

lightcol:
light0:
/* 01f0 */ .word 0x00000000, 0x00000000, 0x00000000, 0x00000000
/* 0200 */ .word 0x00000000, 0x00000000, 0xe0011fff, 0x00040000

light1:
/* 0210 */ .word 0xff000000, 0xff000000, 0x00000000, 0x00000000

tens:
/* 0220 */ .byte 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150

/* 0230 */
movemem_table:
.dh viewport
.dh lookaty
.dh lookatx
.dh light0
.dh light1
.dh light0
.dh light0
.dh light0
.dh light0
.dh light0
.dh light0
.dh txtatt
.dh mtx320 + 0x10
.dh mtx320 + 0x20
.dh mtx320 + 0x30

/* 024e */
moveword_table:
.dh mtx320
.dh numlights
.dh clip
.dh segment_table
.dh fog
.dh lightcol
.dh vtx_buffer
.dh perspnorm

.dh 0x0000

viewport:
/* 0260 */ .word 0x00000000, 0x00000000, 0x00000000, 0x00000000

fog:
/* 0270 */ .word 0x01000000

/* 0274 */ .dh 0x00ff

dl_call_stack:
/* 0276 */ .fill 10 * 4, 0
.align 4

mtx2a0:
/* 02a0 */ .fill 0x40, 0

mtx2e0:
/* 02e0 */ .fill 0x40, 0

mtx320:
/* 0320 */ .fill 0x40, 0

vtx_buffer:
/* 0360 */ .fill 16 * 0x28, 0

col_buffer:
/* 05e0 */ .fill 64 * 4, 0

dl_buffer:
/* 06e0 */ .fill (0x800 - orga()), 0

/* 0820 */ tmp_buffer     equ dl_buffer + 40 * 8
/* 0920 */ tri_buffer     equ tmp_buffer + 0x100
/* 0a20 */ out_buffer     equ tri_buffer + 0x100
/* 0e20 */ tridata_buffer equ out_buffer + 0x400
/* 0e70 */ end            equ tridata_buffer + 0x50

// These registers are saved when yielding, and there's no tris
// during that time so they are written into tri_buffer
savedgp  equ tri_buffer + 0x04
savedk1  equ tri_buffer + 0x08
savedk0  equ tri_buffer + 0x0c
saveds7  equ tri_buffer + 0x10

.close

.create CODE_FILE, 0x04001080

Overlay0:
/* 04001080 0000 090005ee */  j     read_task1
/* 04001084 0004 201d0110 */  addi  sp, r0, stack

/**
 * Overlay 1 flows into here.
 */
/* 04001088 0008 0d000447 */  jal   segmented_to_physical
/* 0400108c 000c 03009820 */  add   s3, t8, r0
/* 04001090 0010 0016a020 */  add   s4, r0, s6
/* 04001094 0014 0d00044f */  jal   dma_read_write
/* 04001098 0018 20110000 */  addi  s1, r0, DMA_READ

/**
 * Expects at = 0, 2, 4 or 6 for GBI types 0x00-0x3f, 0x40-0x7f, 0x80-0xbf, 0xc0-0xff respectively
 * Expects k1 = pointer to *next* command
 * Expects t9 = word 0
 * Expects t8 = word 1
 * Sets v0 = upper 9 bits of first word
 */
.execute_command:
/* 0400109c 001c 842200bc */  lh    v0, master_dispatch_table(at)
/* 040010a0 0020 00400008 */  jr    v0
/* 040010a4 0024 001915c2 */  srl   v0, t9, 23

sp_noop:
/* 040010a8 0028 40022000 */  mfc0  v0, SP_STATUS
/* 040010ac 002c 30420080 */  andi  v0, v0, SP_STATUS_YIELD
/* 040010b0 0030 14400006 */  bne   v0, r0, .handle_noop_yield
/* 040010b4 0034 84150026 */  lh    s5, 0x26(r0)

/**
 * Load displaylist commands if needed, then execute the next one in line.
 * Expects gp = size of unread comments in dl_buffer
 */
main_loop:
/* 040010b8 0038 1f80ffe9 */  bgtz  gp, .parse_and_execute_command
/* 040010bc 003c 00000000 */  nop
/* 040010c0 0040 09000435 */  j     load_displaylist
/* 040010c4 0044 841f0104 */  lh    ra, addr0104(r0)

/**
 * Load overlay 4 and jump to it.
 * This overlay enters an infinite loop of copying DMEM to DRAM.
 */
handle_enddl_yield:
/* 040010c8 0048 841500b6 */  lh    s5, ptr_yield_with_dma_wait(r0)
.handle_noop_yield:
/* 040010cc 004c 0900043f */  j     load_overlay
/* 040010d0 0050 341e0020 */  li    s8, Overlay4Info

/**
 * Fetch 40 GBI commands from DRAM and fill the dl_buffer.
 * Return execution to the caller.
 * Expects k0 = DRAM address to load from
 * Returns k1 = pointer to start of dl_buffer in DMEM
 * Returns gp = size remaining in buffer
 */
load_displaylist:
/* 040010d4 0054 201c0140 */  addi  gp, r0, 0x140
/* 040010d8 0058 001fa820 */  add   s5, r0, ra
/* 040010dc 005c 201406e0 */  addi  s4, r0, dl_buffer
/* 040010e0 0060 001a9820 */  add   s3, r0, k0
/* 040010e4 0064 2012013f */  addi  s2, r0, 0x13f
/* 040010e8 0068 0d00044f */  jal   dma_read_write
/* 040010ec 006c 20110000 */  addi  s1, r0, DMA_READ
/* 040010f0 0070 02a00008 */  jr    s5
/* 040010f4 0074 201b06e0 */  addi  k1, r0, dl_buffer

/**
 * Load an overlay and return to the caller's return address.
 */
load_overlay_and_continue:
/* 040010f8 0078 001fa820 */  add   s5, r0, ra

/**
 * Expects s5: Address to jump to once loaded
 * Expects s8: Pointer to entry in overlay table
 */
load_overlay:
/* 040010fc 007c 8fd30000 */  lw    s3, 0x0(s8)
/* 04001100 0080 87d20004 */  lh    s2, 0x4(s8)
/* 04001104 0084 87d40006 */  lh    s4, 0x6(s8)
/* 04001108 0088 0d00044f */  jal   dma_read_write
/* 0400110c 008c 20110000 */  addi  s1, r0, DMA_READ
/* 04001110 0090 0d000459 */  jal   dma_wait
/* 04001114 0094 00000000 */  nop
/* 04001118 0098 02a00008 */  jr    s5

/**
 * Expects s3: segmented address
 * Returns s3: physical address
 */
segmented_to_physical:
/* 0400111c 009c 8c0b00b8 */  lw    t3, mask_00ffffff(r0)
/* 04001120 00a0 00136582 */  srl   t4, s3, 22
/* 04001124 00a4 318c003c */  andi  t4, t4, 0x3c
/* 04001128 00a8 026b9824 */  and   s3, s3, t3
/* 0400112c 00ac 000c6820 */  add   t5, r0, t4
/* 04001130 00b0 8dac0160 */  lw    t4, segment_table(t5)
/* 04001134 00b4 03e00008 */  jr    ra
/* 04001138 00b8 026c9820 */  add   s3, s3, t4

/**
 * Expects s1: Operation: DMA_READ (0) or DMA_WRITE (1)
 * Expects s2: Length to read/write
 * Expects s3: DRAM address (main memory)
 * Expects s4: DMEM address (SP memory)
 */
dma_read_write:
/* 0400113c 00bc 400b2800 */  mfc0  t3, SP_DMA_FULL
/* 04001140 00c0 1560fffe */  bne   t3, r0, dma_read_write
/* 04001144 00c4 00000000 */  nop
/* 04001148 00c8 40940000 */  mtc0  s4, SP_MEM_ADDR
/* 0400114c 00cc 1e200003 */  bgtz  s1, .dma_write
/* 04001150 00d0 40930800 */  mtc0  s3, SP_DRAM_ADDR
/* 04001154 00d4 03e00008 */  jr    ra
/* 04001158 00d8 40921000 */  mtc0  s2, SP_RD_LEN
.dma_write:
/* 0400115c 00dc 03e00008 */  jr    ra
/* 04001160 00e0 40921800 */  mtc0  s2, SP_WR_LEN

dma_wait:
/* 04001164 00e4 400b3000 */  mfc0  t3, SP_DMA_BUSY
/* 04001168 00e8 1560fffe */  bne   t3, r0, dma_wait
/* 0400116c 00ec 00000000 */  nop
/* 04001170 00f0 03e00008 */  jr    ra
/* 04001174 00f4 00000000 */  nop

write_to_output_buff:
/* 04001178 00f8 001fa820 */  add   s5, r0, ra
/* 0400117c 00fc 8fb30018 */  lw    s3, sp_18(sp)
/* 04001180 0100 22f2f5e0 */  addi  s2, s7, -(out_buffer)
/* 04001184 0104 8fb70044 */  lw    s7, sp_output_buff_size(sp)
/* 04001188 0108 1a40001a */  blez  s2, .nothing_to_write
/* 0400118c 010c 0272a020 */  add   s4, s3, s2
/* 04001190 0110 02f4a022 */  sub   s4, s7, s4
/* 04001194 0114 06810008 */  bgez  s4, .L040011b8
.L04001198:
/* 04001198 0118 40145800 */  mfc0  s4, DPC_STATUS
/* 0400119c 011c 32940400 */  andi  s4, s4, DPC_STATUS_START_VALID
/* 040011a0 0120 1680fffd */  bne   s4, r0, .L04001198
.L040011a4:
/* 040011a4 0124 40175000 */  mfc0  s7, DPC_CURRENT
/* 040011a8 0128 8fb30040 */  lw    s3, sp_output_buff(sp)
/* 040011ac 012c 12f3fffd */  beq   s7, s3, .L040011a4
/* 040011b0 0130 00000000 */  nop
/* 040011b4 0134 40934000 */  mtc0  s3, DPC_START
.L040011b8:
/* 040011b8 0138 40175000 */  mfc0  s7, DPC_CURRENT
/* 040011bc 013c 0277a022 */  sub   s4, s3, s7
/* 040011c0 0140 06810004 */  bgez  s4, .L040011d4
/* 040011c4 0144 0272a020 */  add   s4, s3, s2
/* 040011c8 0148 0297a022 */  sub   s4, s4, s7
/* 040011cc 014c 0681fffa */  bgez  s4, .L040011b8
/* 040011d0 0150 00000000 */  nop
.L040011d4:
/* 040011d4 0154 0272b820 */  add   s7, s3, s2
/* 040011d8 0158 2252ffff */  addi  s2, s2, -1
/* 040011dc 015c 20140a20 */  addi  s4, r0, out_buffer
/* 040011e0 0160 0d00044f */  jal   dma_read_write
/* 040011e4 0164 20110001 */  addi  s1, r0, DMA_WRITE
/* 040011e8 0168 0d000459 */  jal   dma_wait
/* 040011ec 016c afb70018 */  sw    s7, sp_18(sp)
/* 040011f0 0170 40974800 */  mtc0  s7, DPC_END
.nothing_to_write:
/* 040011f4 0174 02a00008 */  jr    s5
/* 040011f8 0178 20170a20 */  addi  s7, r0, out_buffer

/**
 * Expects v0 = upper 9 bits of first word, shifted right to 0.
 * By masking it with 0xfe, the 0x80 bit is dropped
 * Eg. G_TRI4 has byte value 0xb1 (b1000000)
 * v0 will be 0x162
 * v0 & 0xfe = 0x62
 * Hence subtracting 0x60 to calculate the correct offset in the dispatch table.
 */
dispatch_imm:
/* 040011fc 017c 304200fe */  andi  v0, v0, 0xfe
/* 04001200 0180 84420076 */  lh    v0, (imm_dispatch_table - 0x60)(v0)
/* 04001204 0184 00400008 */  jr    v0
/* 04001208 0188 9361ffff */  lbu   at, -1(k1)

imm_tri4:
/* 0400120c 018c 1300ffa6 */  beq   t8, r0, sp_noop
/* 04001210 0190 3301000f */  andi  at, t8, 0xf
/* 04001214 0194 0018c102 */  srl   t8, t8, 4
/* 04001218 0198 3302000f */  andi  v0, t8, 0xf
/* 0400121c 019c 0018c102 */  srl   t8, t8, 4
/* 04001220 01a0 3323000f */  andi  v1, t9, 0xf
/* 04001224 01a4 0019c902 */  srl   t9, t9, 4
/* 04001228 01a8 235afff8 */  addi  k0, k0, -8
/* 0400122c 01ac 237bfff8 */  addi  k1, k1, -8
/* 04001230 01b0 239c0008 */  addi  gp, gp, 8
/* 04001234 01b4 a7790002 */  sh    t9, 0x2(k1)
/* 04001238 01b8 af780004 */  sw    t8, 0x4(k1)
/* 0400123c 01bc 90210220 */  lbu   at, tens(at)
/* 04001240 01c0 90420220 */  lbu   v0, tens(v0)
/* 04001244 01c4 09000496 */  j     .tri
/* 04001248 01c8 90630220 */  lbu   v1, tens(v1)

imm_tri1:
/* 0400124c 01cc 9361fffd */  lbu   at, -3(k1)
/* 04001250 01d0 9362fffe */  lbu   v0, -2(k1)
/* 04001254 01d4 9363ffff */  lbu   v1, -1(k1)

.tri:
/* 04001258 01d8 00010880 */  sll   at, at, 2
/* 0400125c 01dc 00021080 */  sll   v0, v0, 2
/* 04001260 01e0 00031880 */  sll   v1, v1, 2
/* 04001264 01e4 20210360 */  addi  at, at, vtx_buffer
/* 04001268 01e8 20420360 */  addi  v0, v0, vtx_buffer
/* 0400126c 01ec 20630360 */  addi  v1, v1, vtx_buffer
/* 04001270 01f0 ac010e20 */  sw    at, (tridata_buffer + 0)(r0)
/* 04001274 01f4 ac020e24 */  sw    v0, (tridata_buffer + 4)(r0)
/* 04001278 01f8 ac030e28 */  sw    v1, (tridata_buffer + 8)(r0)
/* 0400127c 01fc 09000670 */  j     gsp_tri
/* 04001280 0200 841e00be */  lh    s8, addr00be(r0)

imm_moveword:
/* 04001284 0204 9361fffb */  lbu   at, -5(k1)
/* 04001288 0208 9762fff9 */  lhu   v0, -7(k1)
/* 0400128c 020c 8425024e */  lh    a1, moveword_table(at)
/* 04001290 0210 00a22820 */  add   a1, a1, v0
/* 04001294 0214 0900042a */  j     sp_noop
/* 04001298 0218 acb80000 */  sw    t8, 0x0(a1)

imm_texture:
/* 0400129c 021c afb90010 */  sw    t9, sp_10(sp)
/* 040012a0 0220 afb80014 */  sw    t8, sp_14(sp)
/* 040012a4 0224 87a20006 */  lh    v0, sp_06(sp)
/* 040012a8 0228 3042fffd */  andi  v0, v0, 0xfffd
/* 040012ac 022c 33230001 */  andi  v1, t9, 0x1
/* 040012b0 0230 00031840 */  sll   v1, v1, 1
/* 040012b4 0234 00431025 */  or    v0, v0, v1
/* 040012b8 0238 0900042a */  j     sp_noop
/* 040012bc 023c a7a20006 */  sh    v0, sp_06(sp)

imm_setothermode_h:
/* 040012c0 0240 090004b3 */  j     .setothermode
/* 040012c4 0244 23a70008 */  addi  a3, sp, sp_08

imm_setothermode_l:
/* 040012c8 0248 23a7000c */  addi  a3, sp, sp_0c

.setothermode:
/* 040012cc 024c 8ce30000 */  lw    v1, 0x0(a3)
/* 040012d0 0250 2008ffff */  addi  t0, r0, -1
/* 040012d4 0254 9365fffb */  lbu   a1, -5(k1)
/* 040012d8 0258 9366fffa */  lbu   a2, -6(k1)
/* 040012dc 025c 20020001 */  addi  v0, r0, 1
/* 040012e0 0260 00a21004 */  sllv  v0, v0, a1
/* 040012e4 0264 2042ffff */  addi  v0, v0, -1
/* 040012e8 0268 00c21004 */  sllv  v0, v0, a2
/* 040012ec 026c 00481026 */  xor   v0, v0, t0
/* 040012f0 0270 00431024 */  and   v0, v0, v1
/* 040012f4 0274 00581825 */  or    v1, v0, t8
/* 040012f8 0278 ace30000 */  sw    v1, 0x0(a3)
/* 040012fc 027c 8fb90008 */  lw    t9, sp_08(sp)
/* 04001300 0280 090004e0 */  j     dispatch_rdp_novirtaddr
/* 04001304 0284 8fb8000c */  lw    t8, sp_0c(sp)

imm_enddl:
/* 04001308 0288 83a2004a */  lb    v0, sp_dl_nestlevel(sp)
/* 0400130c 028c 2042fffc */  addi  v0, v0, -4
/* 04001310 0290 0440ff6d */  bltz  v0, handle_enddl_yield
/* 04001314 0294 20430276 */  addi  v1, v0, dl_call_stack
/* 04001318 0298 8c7a0000 */  lw    k0, 0x0(v1)
/* 0400131c 029c a3a2004a */  sb    v0, sp_dl_nestlevel(sp)
/* 04001320 02a0 0900042a */  j     sp_noop
/* 04001324 02a4 201c0000 */  addi  gp, r0, 0x0

imm_setgeometrymode:
/* 04001328 02a8 8fa20004 */  lw    v0, sp_geometrymode(sp)
/* 0400132c 02ac 00581025 */  or    v0, v0, t8
/* 04001330 02b0 0900042a */  j     sp_noop
/* 04001334 02b4 afa20004 */  sw    v0, sp_geometrymode(sp)

imm_cleargeometrymode:
/* 04001338 02b8 8fa20004 */  lw    v0, sp_geometrymode(sp)
/* 0400133c 02bc 2003ffff */  addi  v1, r0, -1
/* 04001340 02c0 00781826 */  xor   v1, v1, t8
/* 04001344 02c4 00431024 */  and   v0, v0, v1
/* 04001348 02c8 0900042a */  j     sp_noop
/* 0400134c 02cc afa20004 */  sw    v0, sp_geometrymode(sp)

imm_rdphalf_1:
/* 04001350 02d0 0900042e */  j     main_loop
/* 04001354 02d4 afb8fffc */  sw    t8, sp_n04(sp)

imm_rdphalf_cont:
/* 04001358 02d8 34020000 */  li    v0, 0

imm_rdphalf_2:
/* 0400135c 02dc 090004e0 */  j     dispatch_rdp_novirtaddr
/* 04001360 02e0 8fb9fffc */  lw    t9, sp_n04(sp)

/**
 * Expects t9 = word 0
 * Expects t8 = word 1
 *
 * The SETIMG commands (0xfd-0xff) have their segmented addresses converted here.
 * The v0 + 0x18 operation is converting the negative commands into (mostly)
 * positive ones.
 *
 * eg. 0xff (-1) + 3 + 0x18 = 26
 * eg. 0xe4 (-28) + 3 + 0x18 = -1
 */
dispatch_rdp:
/* 04001364 02e4 00191603 */  sra   v0, t9, 24
/* 04001368 02e8 20420003 */  addi  v0, v0, 0x3
/* 0400136c 02ec 04400004 */  bltz  v0, dispatch_rdp_novirtaddr
/* 04001370 02f0 20420018 */  addi  v0, v0, 0x18
/* 04001374 02f4 0d000447 */  jal   segmented_to_physical
/* 04001378 02f8 03009820 */  add   s3, t8, r0
/* 0400137c 02fc 0260c020 */  add   t8, s3, r0

dispatch_rdp_novirtaddr:
/* 04001380 0300 aef90000 */  sw    t9, 0x0(s7)
/* 04001384 0304 aef80004 */  sw    t8, 0x4(s7)
/* 04001388 0308 0d00045e */  jal   write_to_output_buff
/* 0400138c 030c 22f70008 */  addi  s7, s7, 0x8
/* 04001390 0310 1c40ff45 */  bgtz  v0, sp_noop
/* 04001394 0314 00000000 */  nop
/* 04001398 0318 0900042e */  j     main_loop

/**
 * Expects v0 = upper 17 bits of first word, shifted right to 0.
 * Sets at = first word second byte
 * Sets a2 = first word second byte masked with 0xf
 */
dispatch_dma:
/* 0400139c 031c 304201fe */  andi  v0, v0, 0x1fe
/* 040013a0 0320 844200c4 */  lh    v0, dma_dispatch_table(v0)
/* 040013a4 0324 0d000459 */  jal   dma_wait
/* 040013a8 0328 9361fff9 */  lbu   at, -7(k1)
/* 040013ac 032c 00400008 */  jr    v0
/* 040013b0 0330 3026000f */  andi  a2, at, 0xf

dma_mtx:
/* 040013b4 0334 ebbf031c */  sbv   $v31[6], sp_1c(sp)
/* 040013b8 0338 30280001 */  andi  t0, at, 0x1
/* 040013bc 033c 1500001b */  bne   t0, r0, .L0400142c
/* 040013c0 0340 30270002 */  andi  a3, at, 0x2
/* 040013c4 0344 201402a0 */  addi  s4, r0, mtx2a0
/* 040013c8 0348 30280004 */  andi  t0, at, 0x4
/* 040013cc 034c 1100000a */  beq   t0, r0, gsp_040013f8
/* 040013d0 0350 cada2003 */  lqv   $v26[0], 0x30(s6)
/* 040013d4 0354 8fb30024 */  lw    s3, sp_dram_stack_curpos(sp)
/* 040013d8 0358 8fa8004c */  lw    t0, sp_dram_stack_end(sp)
/* 040013dc 035c 20110001 */  addi  s1, r0, DMA_WRITE
/* 040013e0 0360 22610040 */  addi  at, s3, 0x40
/* 040013e4 0364 12680004 */  beq   s3, t0, gsp_040013f8
/* 040013e8 0368 200c003f */  addi  t4, r0, 0x3f
/* 040013ec 036c 0d00044f */  jal   dma_read_write
/* 040013f0 0370 afa10024 */  sw    at, sp_dram_stack_curpos(sp)
/* 040013f4 0374 0d000459 */  jal   dma_wait

gsp_040013f8:
/* 040013f8 0378 cadc2001 */  lqv   $v28[0], 0x10(s6)
/* 040013fc 037c 10e0000e */  beq   a3, r0, .L04001438
/* 04001400 0380 cadb2002 */  lqv   $v27[0], 0x20(s6)
/* 04001404 0384 ea9a2003 */  sqv   $v26[0], 0x30(s4)
/* 04001408 0388 cadd2000 */  lqv   $v29[0], 0x0(s6)
/* 0400140c 038c ea9c2001 */  sqv   $v28[0], 0x10(s4)

gsp_04001410:
/* 04001410 0390 20030320 */  addi  v1, r0, mtx320
/* 04001414 0394 ea9b2002 */  sqv   $v27[0], 0x20(s4)
/* 04001418 0398 ea9d2000 */  sqv   $v29[0], 0x0(s4)
/* 0400141c 039c 200102a0 */  addi  at, r0, mtx2a0
/* 04001420 03a0 200202e0 */  addi  v0, r0, mtx2e0
/* 04001424 03a4 09000517 */  j     gsp_0400145c
/* 04001428 03a8 841f00be */  lh    ra, addr00be(r0)
.L0400142c:
/* 0400142c 03ac cada2003 */  lqv   $v26[0], 0x30(s6)
/* 04001430 03b0 090004fe */  j     gsp_040013f8
/* 04001434 03b4 201402e0 */  addi  s4, r0, mtx2e0
.L04001438:
/* 04001438 03b8 24030e20 */  addiu v1, r0, tridata_buffer
/* 0400143c 03bc 00160821 */  addu  at, r0, s6
/* 04001440 03c0 0d000517 */  jal   gsp_0400145c
/* 04001444 03c4 00141021 */  addu  v0, r0, s4
/* 04001448 03c8 ea862003 */  sqv   $v6[0], 0x30(s4)
/* 0400144c 03cc ea852001 */  sqv   $v5[0], 0x10(s4)
/* 04001450 03d0 c87b2000 */  lqv   $v27[0], 0x0(v1)
/* 04001454 03d4 09000504 */  j     gsp_04001410
/* 04001458 03d8 c87d207e */  lqv   $v29[0], -0x20(v1)

gsp_0400145c:
/* 0400145c 03dc 20730010 */  addi  s3, v1, 0x10
.L04001460:
/* 04001460 03e0 4b1ff947 */  vmudh $v5, $v31, $v31[0]
/* 04001464 03e4 20320008 */  addi  s2, at, 0x8
.L04001468:
/* 04001468 03e8 c8431800 */  ldv   $v3[0], 0x0(v0)
/* 0400146c 03ec c8441804 */  ldv   $v4[0], 0x20(v0)
/* 04001470 03f0 c8212000 */  lqv   $v1[0], 0x0(at)
/* 04001474 03f4 c8222002 */  lqv   $v2[0], 0x20(at)
/* 04001478 03f8 c8431c00 */  ldv   $v3[8], 0x0(v0)
/* 0400147c 03fc c8441c04 */  ldv   $v4[8], 0x20(v0)
/* 04001480 0400 4a82218c */  vmadl $v6, $v4, $v2[0h]
/* 04001484 0404 20210002 */  addi  at, at, 0x2
/* 04001488 0408 4a82198d */  vmadm $v6, $v3, $v2[0h]
/* 0400148c 040c 20420008 */  addi  v0, v0, 0x8
/* 04001490 0410 4a81218e */  vmadn $v6, $v4, $v1[0h]
/* 04001494 0414 4a81194f */  vmadh $v5, $v3, $v1[0h]
/* 04001498 0418 1432fff3 */  bne   at, s2, .L04001468
/* 0400149c 041c 4b1ff98e */  vmadn $v6, $v31, $v31[0]
/* 040014a0 0420 2042ffe0 */  addi  v0, v0, -32
/* 040014a4 0424 20210008 */  addi  at, at, 8
/* 040014a8 0428 e8652000 */  sqv   $v5[0], 0x0(v1)
/* 040014ac 042c e8662002 */  sqv   $v6[0], 0x20(v1)
/* 040014b0 0430 1473ffeb */  bne   v1, s3, .L04001460
/* 040014b4 0434 20630010 */  addi  v1, v1, 0x10
/* 040014b8 0438 03e00008 */  jr    ra
/* 040014bc 043c 00000000 */  nop

gsp_040014c0:
/* 040014c0 0440 20080260 */  addi  t0, r0, viewport
/* 040014c4 0444 c8032005 */  lqv   $v3[0], addr0050(r0)
/* 040014c8 0448 cbb30801 */  lsv   $v19[0], 0x2(sp)
/* 040014cc 044c 87a30004 */  lh    v1, sp_geometrymode(sp)
/* 040014d0 0450 c9001800 */  ldv   $v0[0], 0x0(t0)
/* 040014d4 0454 c9011801 */  ldv   $v1[0], 0x8(t0)
/* 040014d8 0458 c9001c00 */  ldv   $v0[8], 0x0(t0)
/* 040014dc 045c c9011c01 */  ldv   $v1[8], 0x8(t0)
/* 040014e0 0460 03e00008 */  jr    ra
/* 040014e4 0464 4a030007 */  vmudh $v0, $v0, $v3

gsp_040014e8:
/* 040014e8 0468 20080320 */  addi  t0, r0, mtx320
/* 040014ec 046c c90b1803 */  ldv   $v11[0], 0x18(t0)
/* 040014f0 0470 c90b1c03 */  ldv   $v11[8], 0x18(t0)
/* 040014f4 0474 c90f1807 */  ldv   $v15[0], 0x38(t0)
/* 040014f8 0478 c90f1c07 */  ldv   $v15[8], 0x38(t0)

gsp_040014fc:
/* 040014fc 047c c9081800 */  ldv   $v8[0], 0x0(t0)
/* 04001500 0480 c9091801 */  ldv   $v9[0], 0x8(t0)
/* 04001504 0484 c90a1802 */  ldv   $v10[0], 0x10(t0)
/* 04001508 0488 c90c1804 */  ldv   $v12[0], 0x20(t0)
/* 0400150c 048c c90d1805 */  ldv   $v13[0], 0x28(t0)
/* 04001510 0490 c90e1806 */  ldv   $v14[0], 0x30(t0)
/* 04001514 0494 c9081c00 */  ldv   $v8[8], 0x0(t0)
/* 04001518 0498 c9091c01 */  ldv   $v9[8], 0x8(t0)
/* 0400151c 049c c90a1c02 */  ldv   $v10[8], 0x10(t0)
/* 04001520 04a0 c90c1c04 */  ldv   $v12[8], 0x20(t0)
/* 04001524 04a4 c90d1c05 */  ldv   $v13[8], 0x28(t0)
/* 04001528 04a8 03e00008 */  jr    ra
/* 0400152c 04ac c90e1c06 */  ldv   $v14[8], 0x30(t0)

dma_movemem:
/* 04001530 04b0 cac02000 */  lqv   $v0[0], 0x0(s6)
/* 04001534 04b4 842501b0 */  lh    a1, (movemem_table - 0x80)(at)
/* 04001538 04b8 0900042a */  j     sp_noop
/* 0400153c 04bc e8a02000 */  sqv   $v0[0], 0x0(a1)

/**
 * Expects at = first word second byte
 * Expects a2 = index in vtx buffer to load to
 * Expects k1 = pointer to *next* GBI command
 * Expects s6 = pointer to input vertices (size 0x0c each)
 *
 * This function is converting input vertices (size 0xc) into RDP vertices (size 0x28).
 * Vertices are processed two at a time.
 */
dma_vtx:
/* 04001540 04c0 840800be */  lh    t0, addr00be(r0)
/* 04001544 04c4 a4080106 */  sh    t0, addr0106(r0)
/* 04001548 04c8 00010902 */  srl   at, at, 4
/* 0400154c 04cc 20250001 */  addi  a1, at, 0x1       /* a1 = num vertices */
/* 04001550 04d0 8f68fffc */  lw    t0, -4(k1)        /* t0 = load address */
/* 04001554 04d4 31080004 */  andi  t0, t0, 0x4
/* 04001558 04d8 02c8b020 */  add   s6, s6, t0
/* 0400155c 04dc 20a90000 */  addi  t1, a1, 0x0
/* 04001560 04e0 cac21000 */  llv   $v2[0], 0x0(s6)   /* load vtx0 x/y */
/* 04001564 04e4 cac21201 */  llv   $v2[4], 0x4(s6)   /* load vtx0 z/flags/col*/
/* 04001568 04e8 cac21403 */  llv   $v2[8], 0xc(s6)   /* load vtx1 x/y */
/* 0400156c 04ec cac21604 */  llv   $v2[12], 0x10(s6) /* load vtx1 z/flags/col */
/* 04001570 04f0 20070360 */  addi  a3, r0, vtx_buffer
/* 04001574 04f4 00064140 */  sll   t0, a2, 5
/* 04001578 04f8 000630c0 */  sll   a2, a2, 3
/* 0400157c 04fc 00c84020 */  add   t0, a2, t0        /* t0 = a2 * 0x28 */
/* 04001580 0500 0d000530 */  jal   gsp_040014c0
/* 04001584 0504 00e83820 */  add   a3, a3, t0        /* a3 = dst in vtx_buffer */
/* 04001588 0508 cbb11005 */  llv   $v17[0], 0x14(sp)
/* 0400158c 050c 0d00053a */  jal   gsp_040014e8
/* 04001590 0510 cbb11405 */  llv   $v17[8], 0x14(sp)
.L04001594:
/* 04001594 0514 4a826706 */  vmudn $v28, $v12, $v2[0h]
/* 04001598 0518 cad21002 */  llv   $v18[0], 0x8(s6)
/* 0400159c 051c 4a82470f */  vmadh $v28, $v8, $v2[0h]
/* 040015a0 0520 92cf0007 */  lbu   t7, 0x7(s6)          /* t7 = vtx0 colour index */
/* 040015a4 0524 4aa26f0e */  vmadn $v28, $v13, $v2[1h]
/* 040015a8 0528 92d00013 */  lbu   s0, 0x13(s6)         /* s0 = vtx1 colour index */
/* 040015ac 052c 4aa24f0f */  vmadh $v28, $v9, $v2[1h]
/* 040015b0 0530 8def05e0 */  lw    t7, col_buffer(t7)
/* 040015b4 0534 4ac2770e */  vmadn $v28, $v14, $v2[2h]
/* 040015b8 0538 8e1005e0 */  lw    s0, col_buffer(s0)
/* 040015bc 053c 4ac2570f */  vmadh $v28, $v10, $v2[2h]
/* 040015c0 0540 30610002 */  andi  at, v1, 0x2
/* 040015c4 0544 4b3f7f0e */  vmadn $v28, $v15, $v31[1]
/* 040015c8 0548 cad21405 */  llv   $v18[8], 0x14(s6)
/* 040015cc 054c 4b3f5f4f */  vmadh $v29, $v11, $v31[1]
/* 040015d0 0550 14200076 */  bne   at, r0, load_lighting
/* 040015d4 0554 22d60018 */  addi  s6, s6, 0x18

gsp_040015d8:
/* 040015d8 0558 4a119485 */  vmudm $v18, $v18, $v17

gsp_040015dc:
/* 040015dc 055c c815083b */  lsv   $v21[0], addr0076(r0)
/* 040015e0 0560 4b15e506 */  vmudn $v20, $v28, $v21[0]
/* 040015e4 0564 480deb00 */  mfc2  t5, $v29[6]
/* 040015e8 0568 31ad8000 */  andi  t5, t5, 0x8000
/* 040015ec 056c 000d6b42 */  srl   t5, t5, 13
/* 040015f0 0570 4b15ed4f */  vmadh $v21, $v29, $v21[0]
/* 040015f4 0574 480eef00 */  mfc2  t6, $v29[14]
/* 040015f8 0578 31ce8000 */  andi  t6, t6, 0x8000
/* 040015fc 057c 000e7242 */  srl   t6, t6, 9
/* 04001600 0580 4afde8e5 */  vch   $v3, $v29, $v29[3h]
/* 04001604 0584 01cd7025 */  or    t6, t6, t5
/* 04001608 0588 4afce0e4 */  vcl   $v3, $v28, $v28[3h]
/* 0400160c 058c 484d0800 */  cfc2  t5, $vcc
/* 04001610 0590 4af5e8e5 */  vch   $v3, $v29, $v21[3h]
/* 04001614 0594 4af4e0e4 */  vcl   $v3, $v28, $v20[3h]
/* 04001618 0598 31a80703 */  andi  t0, t5, 0x703
/* 0400161c 059c 31ad7030 */  andi  t5, t5, 0x7030
/* 04001620 05a0 01ae6825 */  or    t5, t5, t6
/* 04001624 05a4 00084100 */  sll   t0, t0, 4
/* 04001628 05a8 000d6c00 */  sll   t5, t5, 16
/* 0400162c 05ac 01a86825 */  or    t5, t5, t0
/* 04001630 05b0 484e0800 */  cfc2  t6, $vcc
/* 04001634 05b4 31c80707 */  andi  t0, t6, 0x707
/* 04001638 05b8 4b1fed50 */  vadd  $v21, $v29, $v31[0]
/* 0400163c 05bc 31ce7070 */  andi  t6, t6, 0x7070
/* 04001640 05c0 4b1fe510 */  vadd  $v20, $v28, $v31[0]
/* 04001644 05c4 000e7300 */  sll   t6, t6, 12
/* 04001648 05c8 4b13e704 */  vmudl $v28, $v28, $v19[0]
/* 0400164c 05cc 010e4025 */  or    t0, t0, t6
/* 04001650 05d0 4b13ef4d */  vmadm $v29, $v29, $v19[0]
/* 04001654 05d4 010d4025 */  or    t0, t0, t5
/* 04001658 05d8 4b1fff0e */  vmadn $v28, $v31, $v31[0]
/* 0400165c 05dc a4e80024 */  sh    t0, 0x24(a3)
/* 04001660 05e0 0d000400 */  jal   gsp_04001000
/* 04001664 05e4 86cdffee */  lh    t5, -0x12(s6)
/* 04001668 05e8 4b1fd9a3 */  vge   $v6, $v27, $v31[0]
/* 0400166c 05ec e8f51800 */  sdv   $v21[0], 0x0(a3)
/* 04001670 05f0 4b1ed9a7 */  vmrg  $v6, $v27, $v30[0]
/* 04001674 05f4 e8f41801 */  sdv   $v20[0], 0x8(a3)
/* 04001678 05f8 4afaa144 */  vmudl $v5, $v20, $v26[3h]
/* 0400167c 05fc 4afaa94d */  vmadm $v5, $v21, $v26[3h]
/* 04001680 0600 4ae6a14e */  vmadn $v5, $v20, $v6[3h]
/* 04001684 0604 4ae6a90f */  vmadh $v4, $v21, $v6[3h]
/* 04001688 0608 2129ffff */  addi  t1, t1, -1
/* 0400168c 060c 4b132944 */  vmudl $v5, $v5, $v19[0]
/* 04001690 0610 4b13210d */  vmadm $v4, $v4, $v19[0]
/* 04001694 0614 4b1ff94e */  vmadn $v5, $v31, $v31[0]
/* 04001698 0618 306c0001 */  andi  t4, v1, 0x1
/* 0400169c 061c cac21000 */  llv   $v2[0], 0x0(s6)
/* 040016a0 0620 cac21201 */  llv   $v2[4], 0x4(s6)
/* 040016a4 0624 4b3f09c7 */  vmudh $v7, $v1, $v31[1]
/* 040016a8 0628 cac21403 */  llv   $v2[8], 0xc(s6)
/* 040016ac 062c cac21604 */  llv   $v2[12], 0x10(s6)
/* 040016b0 0630 4a0029ce */  vmadn $v7, $v5, $v0
/* 040016b4 0634 c81d1805 */  ldv   $v29[0], addr0028(r0)
/* 040016b8 0638 4a00218f */  vmadh $v6, $v4, $v0
/* 040016bc 063c c81d1c05 */  ldv   $v29[8], addr0028(r0)
/* 040016c0 0640 4b1ff9ce */  vmadn $v7, $v31, $v31[0]
/* 040016c4 0644 4a7d31a3 */  vge   $v6, $v6, $v29[1q]
/* 040016c8 0648 acef0010 */  sw    t7, 0x10(a3)
/* 040016cc 064c 1180000b */  beq   t4, r0, .L040016fc
/* 040016d0 0650 4a5d31a0 */  vlt   $v6, $v6, $v29[0q]
/* 040016d4 0654 c8032027 */  lqv   $v3[0], fog(r0)
/* 040016d8 0658 4b032946 */  vmudn $v5, $v5, $v3[0]
/* 040016dc 065c 4b03210f */  vmadh $v4, $v4, $v3[0]
/* 040016e0 0660 4b232110 */  vadd  $v4, $v4, $v3[1]
/* 040016e4 0664 4b1f2123 */  vge   $v4, $v4, $v31[0]
/* 040016e8 0668 4b432120 */  vlt   $v4, $v4, $v3[2]
/* 040016ec 066c e8e40293 */  sbv   $v4[5], 0x13(a3)
/* 040016f0 0670 acf00018 */  sw    s0, 0x18(a3)
/* 040016f4 0674 e8e4069b */  sbv   $v4[13], 0x1b(a3)
/* 040016f8 0678 8cf00018 */  lw    s0, 0x18(a3)
.L040016fc:
/* 040016fc 067c e8f21005 */  slv   $v18[0], 0x14(a3)
/* 04001700 0680 e8e61803 */  sdv   $v6[0], 0x18(a3)
/* 04001704 0684 e8e70a0f */  ssv   $v7[4], 0x1e(a3)
/* 04001708 0688 e8fb0b10 */  ssv   $v27[6], 0x20(a3)
/* 0400170c 068c e8fa0b11 */  ssv   $v26[6], 0x22(a3)
/* 04001710 0690 1920000c */  blez  t1, .L04001744
/* 04001714 0694 2129ffff */  addi  t1, t1, -1
/* 04001718 0698 e8f51c05 */  sdv   $v21[8], 0x28(a3)
/* 0400171c 069c e8f41c06 */  sdv   $v20[8], 0x30(a3)
/* 04001720 06a0 e8f2140f */  slv   $v18[8], 0x3c(a3)
/* 04001724 06a4 acf00038 */  sw    s0, 0x38(a3)
/* 04001728 06a8 e8e61c08 */  sdv   $v6[8], 0x40(a3)
/* 0400172c 06ac e8e70e23 */  ssv   $v7[12], 0x46(a3)
/* 04001730 06b0 e8fb0f24 */  ssv   $v27[14], 0x48(a3)
/* 04001734 06b4 e8fa0f25 */  ssv   $v26[14], 0x4a(a3)
/* 04001738 06b8 ace8004c */  sw    t0, 0x4c(a3)
/* 0400173c 06bc 20e70050 */  addi  a3, a3, 0x50
/* 04001740 06c0 1d20ff94 */  bgtz  t1, .L04001594
.L04001744:
/* 04001744 06c4 84080106 */  lh    t0, addr0106(r0)
/* 04001748 06c8 01000008 */  jr    t0
/* 0400174c 06cc 00000000 */  nop

dma_dl:
/* 04001750 06d0 1c200007 */  bgtz  at, .L04001770
/* 04001754 06d4 83a2004a */  lb    v0, sp_dl_nestlevel(sp)
/* 04001758 06d8 2044ffdc */  addi  a0, v0, -0x24
/* 0400175c 06dc 1c80fe52 */  bgtz  a0, sp_noop
/* 04001760 06e0 20430276 */  addi  v1, v0, dl_call_stack
/* 04001764 06e4 20420004 */  addi  v0, v0, 0x4
/* 04001768 06e8 ac7a0000 */  sw    k0, 0x0(v1)
/* 0400176c 06ec a3a2004a */  sb    v0, sp_dl_nestlevel(sp)
.L04001770:
/* 04001770 06f0 0d000447 */  jal   segmented_to_physical
/* 04001774 06f4 03009820 */  add   s3, t8, r0
/* 04001778 06f8 0260d020 */  add   k0, s3, r0
/* 0400177c 06fc 0900042a */  j     sp_noop
/* 04001780 0700 201c0000 */  addi  gp, r0, 0x0

/**
 * The requested colour list has been loaded to tmp_buffer,
 * so this copies them into col_buffer.
 */
dma_col:
/* 04001784 0704 8c240820 */  lw    a0, tmp_buffer(at)
/* 04001788 0708 ac2405e0 */  sw    a0, col_buffer(at)
/* 0400178c 070c 1c20fffd */  bgtz  at, dma_col
/* 04001790 0710 2021fffc */  addi  at, at, -4
/* 04001794 0714 0900042a */  j     sp_noop
/* 04001798 0718 00000000 */  nop
/* 0400179c 071c 00000000 */  nop
.L040017a0:
/* 040017a0 0720 341e0010 */  li    s8, Overlay2Info
/* 040017a4 0724 1000fe55 */  b     load_overlay
/* 040017a8 0728 84150100 */  lh    s5, addr0100(r0)

load_lighting:
/* 040017ac 072c 341e0018 */  li    s8, Overlay3Info
/* 040017b0 0730 1000fe52 */  b     load_overlay
/* 040017b4 0734 841500a0 */  lh    s5, addr00a0(r0)

read_task1:
/* 040017b8 0738 c81f2003 */  lqv   $v31[0], addr0030(r0)
/* 040017bc 073c c81e2004 */  lqv   $v30[0], addr0040(r0)
/* 040017c0 0740 8c040fc4 */  lw    a0, (OSTask_addr + OSTask_flags)(r0)
/* 040017c4 0744 30840001 */  andi  a0, a0, OS_TASK_YIELDED
/* 040017c8 0748 14800035 */  bne   a0, r0, .resume_yielded_task
/* 040017cc 074c 00000000 */  nop
/* 040017d0 0750 8c370028 */  lw    s7, OSTask_output_buff(at)
/* 040017d4 0754 8c23002c */  lw    v1, OSTask_output_buff_size(at)
/* 040017d8 0758 afb70040 */  sw    s7, sp_output_buff(sp)
/* 040017dc 075c afa30044 */  sw    v1, sp_output_buff_size(sp)
/* 040017e0 0760 40045800 */  mfc0  a0, DPC_STATUS
/* 040017e4 0764 30840001 */  andi  a0, a0, DPC_STATUS_XBUS_DMA
/* 040017e8 0768 1480000a */  bne   a0, r0, .L04001814
/* 040017ec 076c 40044800 */  mfc0  a0, DPC_END
/* 040017f0 0770 02e4b822 */  sub   s7, s7, a0
/* 040017f4 0774 1ee00007 */  bgtz  s7, .L04001814
/* 040017f8 0778 40055000 */  mfc0  a1, DPC_CURRENT
/* 040017fc 077c 10a00005 */  beq   a1, r0, .L04001814
/* 04001800 0780 00000000 */  nop
/* 04001804 0784 10a40003 */  beq   a1, a0, .L04001814
/* 04001808 0788 00000000 */  nop
/* 0400180c 078c 0900060c */  j     read_task2
/* 04001810 0790 34830000 */  ori   v1, a0, 0x0
.L04001814:
/* 04001814 0794 40045800 */  mfc0  a0, DPC_STATUS
/* 04001818 0798 30840400 */  andi  a0, a0, DPC_STATUS_START_VALID
/* 0400181c 079c 1480fffd */  bne   a0, r0, .L04001814
/* 04001820 07a0 20040001 */  addi  a0, r0, DPC_STATUS_CLR_XBUS
/* 04001824 07a4 40845800 */  mtc0  a0, DPC_STATUS
/* 04001828 07a8 40834000 */  mtc0  v1, DPC_START
/* 0400182c 07ac 40834800 */  mtc0  v1, DPC_END

read_task2:
/* 04001830 07b0 afa30018 */  sw    v1, sp_18(sp)
/* 04001834 07b4 20170a20 */  addi  s7, r0, out_buffer
/* Promote overlay table offsets to pointers */
/* 04001838 07b8 8c250010 */  lw    a1, OSTask_ucode(at)
/* 0400183c 07bc 8c020008 */  lw    v0, Overlay1Info
/* 04001840 07c0 8c030010 */  lw    v1, Overlay2Info
/* 04001844 07c4 8c040018 */  lw    a0, Overlay3Info
/* 04001848 07c8 8c060020 */  lw    a2, Overlay4Info
/* 0400184c 07cc 00451020 */  add   v0, v0, a1
/* 04001850 07d0 00651820 */  add   v1, v1, a1
/* 04001854 07d4 00852020 */  add   a0, a0, a1
/* 04001858 07d8 00c53020 */  add   a2, a2, a1
/* 0400185c 07dc ac020008 */  sw    v0, Overlay1Info
/* 04001860 07e0 ac030010 */  sw    v1, Overlay2Info
/* 04001864 07e4 ac040018 */  sw    a0, Overlay3Info
/* 04001868 07e8 ac060020 */  sw    a2, Overlay4Info
/* Load overlay 1 */
/* 0400186c 07ec 0d00043e */  jal   load_overlay_and_continue
/* 04001870 07f0 201e0008 */  addi  s8, r0, Overlay1Info
/* 04001874 07f4 0d000435 */  jal   load_displaylist
/* 04001878 07f8 8c3a0030 */  lw    k0, OSTask_data_ptr(at)
/* 0400187c 07fc 8c220020 */  lw    v0, OSTask_dram_stack(at)
/* 04001880 0800 afa20020 */  sw    v0, sp_dram_stack (sp)
/* 04001884 0804 afa20024 */  sw    v0, sp_dram_stack_curpos(sp)
/* 04001888 0808 20420280 */  addi  v0, v0, SP_DRAM_STACK_SIZE
/* 0400188c 080c afa2004c */  sw    v0, sp_dram_stack_end(sp)
.L04001890:
/* 04001890 0810 8c02fff8 */  lw    v0, -8(r0)
/* 04001894 0814 ac020108 */  sw    v0, yield_data_ptr(r0)
/* 04001898 0818 09000416 */  j     dma_wait_dl
/* 0400189c 081c 00000000 */  nop
.resume_yielded_task:
/* 040018a0 0820 0d00043e */  jal   load_overlay_and_continue
/* 040018a4 0824 201e0008 */  addi  s8, r0, Overlay1Info
/* 040018a8 0828 8c170930 */  lw    s7, saveds7(r0)
/* 040018ac 082c 8c1c0924 */  lw    gp, savedgp(r0)
/* 040018b0 0830 8c1b0928 */  lw    k1, savedk1(r0)
/* 040018b4 0834 0900042a */  j     sp_noop
/* 040018b8 0838 8c1a092c */  lw    k0, savedk0(r0)

/* 040018bc 083c through 040019bc 093c */
.fill 0x104, 0

gsp_tri:
/* 040019c0 0940 846b0024 */  lh    t3, 0x24(v1)
/* 040019c4 0944 84480024 */  lh    t0, 0x24(v0)
/* 040019c8 0948 84290024 */  lh    t1, 0x24(at)
/* 040019cc 094c 01686024 */  and   t4, t3, t0
/* 040019d0 0950 01685825 */  or    t3, t3, t0
/* 040019d4 0954 01896024 */  and   t4, t4, t1
/* 040019d8 0958 318c7030 */  andi  t4, t4, 0x7030
/* 040019dc 095c 1580fdb2 */  bne   t4, r0, sp_noop
/* 040019e0 0960 01695825 */  or    t3, t3, t1
/* 040019e4 0964 316b4343 */  andi  t3, t3, 0x4343
/* 040019e8 0968 1560ff6d */  bne   t3, r0, .L040017a0
.L040019ec:
/* 040019ec 096c c82d1006 */  llv   $v13[0], 0x18(at)
/* 040019f0 0970 c84e1006 */  llv   $v14[0], 0x18(v0)
/* 040019f4 0974 c86f1006 */  llv   $v15[0], 0x18(v1)
/* 040019f8 0978 8fad0004 */  lw    t5, sp_geometrymode(sp)
/* 040019fc 097c 20080920 */  addi  t0, r0, tri_buffer
/* 04001a00 0980 cbb50801 */  lsv   $v21[0], 0x2(sp)
/* 04001a04 0984 c8250803 */  lsv   $v5[0], 0x6(at)
/* 04001a08 0988 4a0d7291 */  vsub  $v10, $v14, $v13
/* 04001a0c 098c c8260807 */  lsv   $v6[0], 0xe(at)
/* 04001a10 0990 4a0d7a51 */  vsub  $v9, $v15, $v13
/* 04001a14 0994 c8450903 */  lsv   $v5[2], 0x6(v0)
/* 04001a18 0998 4a0e6b11 */  vsub  $v12, $v13, $v14
/* 04001a1c 099c c8460907 */  lsv   $v6[2], 0xe(v0)
/* 04001a20 09a0 c8650a03 */  lsv   $v5[4], 0x6(v1)
/* 04001a24 09a4 c8660a07 */  lsv   $v6[4], 0xe(v1)
/* 04001a28 09a8 4b2a4c07 */  vmudh $v16, $v9, $v10[1]
/* 04001a2c 09ac 8429001a */  lh    t1, 0x1a(at)
/* 04001a30 09b0 4b32949d */  vsar  $v18, $v18, $v18[1]
/* 04001a34 09b4 844a001a */  lh    t2, 0x1a(v0)
/* 04001a38 09b8 4b118c5d */  vsar  $v17, $v17, $v17[0]
/* 04001a3c 09bc 846b001a */  lh    t3, 0x1a(v1)
/* 04001a40 09c0 4b296407 */  vmudh $v16, $v12, $v9[1]
/* 04001a44 09c4 31ae1000 */  andi  t6, t5, 0x1000
/* 04001a48 09c8 4b34a51d */  vsar  $v20, $v20, $v20[1]
/* 04001a4c 09cc 31af2000 */  andi  t7, t5, 0x2000
/* 04001a50 09d0 4b139cdd */  vsar  $v19, $v19, $v19[0]
/* 04001a54 09d4 200c0000 */  addi  t4, r0, 0x0

gsp_04001a58:
/* 04001a58 09d8 0149382a */  slt   a3, t2, t1
/* 04001a5c 09dc 18e00008 */  blez  a3, .L04001a80
/* 04001a60 09e0 01403820 */  add   a3, t2, r0
/* 04001a64 09e4 01205020 */  add   t2, t1, r0
/* 04001a68 09e8 00e04820 */  add   t1, a3, r0
/* 04001a6c 09ec 00403821 */  addu  a3, v0, r0
/* 04001a70 09f0 00201021 */  addu  v0, at, r0
/* 04001a74 09f4 00e00821 */  addu  at, a3, r0
/* 04001a78 09f8 398c0001 */  xori  t4, t4, 0x1
/* 04001a7c 09fc 00000000 */  nop
.L04001a80:
/* 04001a80 0a00 4a149714 */  vaddc $v28, $v18, $v20
/* 04001a84 0a04 016a382a */  slt   a3, t3, t2
/* 04001a88 0a08 4a138f50 */  vadd  $v29, $v17, $v19
/* 04001a8c 0a0c 18e00008 */  blez  a3, .L04001ab0
/* 04001a90 0a10 01603820 */  add   a3, t3, r0
/* 04001a94 0a14 01405820 */  add   t3, t2, r0
/* 04001a98 0a18 00e05020 */  add   t2, a3, r0
/* 04001a9c 0a1c 00603821 */  addu  a3, v1, r0
/* 04001aa0 0a20 00401821 */  addu  v1, v0, r0
/* 04001aa4 0a24 00e01021 */  addu  v0, a3, r0
/* 04001aa8 0a28 09000696 */  j     gsp_04001a58
/* 04001aac 0a2c 398c0001 */  xori  t4, t4, 0x1
.L04001ab0:
/* 04001ab0 0a30 4b1feee0 */  vlt   $v27, $v29, $v31[0]
/* 04001ab4 0a34 c86f1006 */  llv   $v15[0], 0x18(v1)
/* 04001ab8 0a38 4a1ceeaa */  vor   $v26, $v29, $v28
/* 04001abc 0a3c c84e1006 */  llv   $v14[0], 0x18(v0)
/* 04001ac0 0a40 c82d1006 */  llv   $v13[0], 0x18(at)
/* 04001ac4 0a44 19800004 */  blez  t4, .L04001ad8
/* 04001ac8 0a48 4a0e7911 */  vsub  $v4, $v15, $v14
/* 04001acc 0a4c 4b7fe706 */  vmudn $v28, $v28, $v31[3]
/* 04001ad0 0a50 4b7fef4f */  vmadh $v29, $v29, $v31[3]
/* 04001ad4 0a54 4b1fff0e */  vmadn $v28, $v31, $v31[0]
.L04001ad8:
/* 04001ad8 0a58 4a0d7291 */  vsub  $v10, $v14, $v13
/* 04001adc 0a5c 4811d800 */  mfc2  s1, $v27[0]
/* 04001ae0 0a60 4a0d7a51 */  vsub  $v9, $v15, $v13
/* 04001ae4 0a64 4810d000 */  mfc2  s0, $v26[0]
/* 04001ae8 0a68 00118fc3 */  sra   s1, s1, 31
/* 04001aec 0a6c 4b1d5f73 */  vmov  $v29[3], $v29[0]
/* 04001af0 0a70 01f17824 */  and   t7, t7, s1
/* 04001af4 0a74 4b1c5f33 */  vmov  $v28[3], $v28[0]
/* 04001af8 0a78 4b0a5133 */  vmov  $v4[2], $v10[0]
/* 04001afc 0a7c 12000139 */  beq   s0, r0, .L04001fe4
/* 04001b00 0a80 3a31ffff */  xori  s1, s1, 0xffff
/* 04001b04 0a84 4b1feee0 */  vlt   $v27, $v29, $v31[0]
/* 04001b08 0a88 01d17024 */  and   t6, t6, s1
/* 04001b0c 0a8c 4b2a5933 */  vmov  $v4[3], $v10[1]
/* 04001b10 0a90 01ee8025 */  or    s0, t7, t6
/* 04001b14 0a94 4b096133 */  vmov  $v4[4], $v9[0]
/* 04001b18 0a98 1e000132 */  bgtz  s0, .L04001fe4
/* 04001b1c 0a9c 4b296933 */  vmov  $v4[5], $v9[1]
/* 04001b20 0aa0 4807d800 */  mfc2  a3, $v27[0]
/* 04001b24 0aa4 0d000400 */  jal   gsp_04001000
/* 04001b28 0aa8 20060080 */  addi  a2, r0, 0x80
/* 04001b2c 0aac 04e00002 */  bltz  a3, .L04001b38
/* 04001b30 0ab0 83a50007 */  lb    a1, sp_07(sp)
/* 04001b34 0ab4 20060000 */  addi  a2, r0, 0x0
.L04001b38:
/* 04001b38 0ab8 4b9f2245 */  vmudm $v9, $v4, $v31[4]
/* 04001b3c 0abc 4b1ffa8e */  vmadn $v10, $v31, $v31[0]
/* 04001b40 0ac0 4b244a30 */  vrcp  $v8[1], $v4[1]
/* 04001b44 0ac4 4b1f49f2 */  vrcph $v7[1], $v31[0]
/* 04001b48 0ac8 34a500c8 */  ori   a1, a1, 0xc8
/* 04001b4c 0acc 83a70012 */  lb    a3, sp_12(sp)
/* 04001b50 0ad0 4b645a30 */  vrcp  $v8[3], $v4[3]
/* 04001b54 0ad4 4b1f59f2 */  vrcph $v7[3], $v31[0]
/* 04001b58 0ad8 4ba46a30 */  vrcp  $v8[5], $v4[5]
/* 04001b5c 0adc 4b1f69f2 */  vrcph $v7[5], $v31[0]
/* 04001b60 0ae0 00c73025 */  or    a2, a2, a3
/* 04001b64 0ae4 4b9e4204 */  vmudl $v8, $v8, $v30[4]
/* 04001b68 0ae8 a2e50000 */  sb    a1, 0x0(s7)
/* 04001b6c 0aec 4b9e39cd */  vmadm $v7, $v7, $v30[4]
/* 04001b70 0af0 a2e60001 */  sb    a2, 0x1(s7)
/* 04001b74 0af4 4b1ffa0e */  vmadn $v8, $v31, $v31[0]
/* 04001b78 0af8 4bbf2107 */  vmudh $v4, $v4, $v31[5]
/* 04001b7c 0afc c84c080c */  lsv   $v12[0], 0x18(v0)
/* 04001b80 0b00 4b153184 */  vmudl $v6, $v6, $v21[0]
/* 04001b84 0b04 c82c0a0c */  lsv   $v12[4], 0x18(at)
/* 04001b88 0b08 4b15294d */  vmadm $v5, $v5, $v21[0]
/* 04001b8c 0b0c c82c0c0c */  lsv   $v12[8], 0x18(at)
/* 04001b90 0b10 4b1ff98e */  vmadn $v6, $v31, $v31[0]
/* 04001b94 0b14 00093b80 */  sll   a3, t1, 14
/* 04001b98 0b18 4a4a4044 */  vmudl $v1, $v8, $v10[0q]
/* 04001b9c 0b1c 4a4a384d */  vmadm $v1, $v7, $v10[0q]
/* 04001ba0 0b20 4a49404e */  vmadn $v1, $v8, $v9[0q]
/* 04001ba4 0b24 4a49380f */  vmadh $v0, $v7, $v9[0q]
/* 04001ba8 0b28 48871000 */  mtc2  a3, $v2[0]
/* 04001bac 0b2c 4b1ff84e */  vmadn $v1, $v31, $v31[0]
/* 04001bb0 0b30 ad030000 */  sw    v1, 0x0(t0)
/* 04001bb4 0b34 4b9f4204 */  vmudl $v8, $v8, $v31[4]
/* 04001bb8 0b38 4b9f39cd */  vmadm $v7, $v7, $v31[4]
/* 04001bbc 0b3c 4b1ffa0e */  vmadn $v8, $v31, $v31[0]
/* 04001bc0 0b40 4b9f0844 */  vmudl $v1, $v1, $v31[4]
/* 04001bc4 0b44 4b9f000d */  vmadm $v0, $v0, $v31[4]
/* 04001bc8 0b48 4b1ff84e */  vmadn $v1, $v31, $v31[0]
/* 04001bcc 0b4c a6eb0002 */  sh    t3, 0x2(s7)
/* 04001bd0 0b50 4b3e0c28 */  vand  $v16, $v1, $v30[1]
/* 04001bd4 0b54 a6e90006 */  sh    t1, 0x6(s7)
/* 04001bd8 0b58 4b9f6305 */  vmudm $v12, $v12, $v31[4]
/* 04001bdc 0b5c ad020004 */  sw    v0, 0x4(t0)
/* 04001be0 0b60 4b1ffb4e */  vmadn $v13, $v31, $v31[0]
/* 04001be4 0b64 ad010008 */  sw    at, 0x8(t0)
/* 04001be8 0b68 a6ea0004 */  sh    t2, 0x4(s7)
/* 04001bec 0b6c 4bde0026 */  vcr   $v0, $v0, $v30[6]
/* 04001bf0 0b70 eaec0804 */  ssv   $v12[0], 0x8(s7)
/* 04001bf4 0b74 4b0282c4 */  vmudl $v11, $v16, $v2[0]
/* 04001bf8 0b78 eaed0805 */  ssv   $v13[0], 0xa(s7)
/* 04001bfc 0b7c 4b02028d */  vmadm $v10, $v0, $v2[0]
/* 04001c00 0b80 eae00906 */  ssv   $v0[2], 0xc(s7)
/* 04001c04 0b84 4b1fface */  vmadn $v11, $v31, $v31[0]
/* 04001c08 0b88 eae10907 */  ssv   $v1[2], 0xe(s7)
/* 04001c0c 0b8c 30a70002 */  andi  a3, a1, 0x2
/* 04001c10 0b90 210f0008 */  addi  t7, t0, 0x8
/* 04001c14 0b94 21100010 */  addi  s0, t0, 0x10
/* 04001c18 0b98 4a6b68d5 */  vsubc $v3, $v13, $v11[1q]
/* 04001c1c 0b9c eae00d0a */  ssv   $v0[10], 0x14(s7)
/* 04001c20 0ba0 4a6a6251 */  vsub  $v9, $v12, $v10[1q]
/* 04001c24 0ba4 eae10d0b */  ssv   $v1[10], 0x16(s7)
/* 04001c28 0ba8 4b263555 */  vsubc $v21, $v6, $v6[1]
/* 04001c2c 0bac eae00b0e */  ssv   $v0[6], 0x1c(s7)
/* 04001c30 0bb0 4b252ce0 */  vlt   $v19, $v5, $v5[1]
/* 04001c34 0bb4 eae10b0f */  ssv   $v1[6], 0x1e(s7)
/* 04001c38 0bb8 4b263527 */  vmrg  $v20, $v6, $v6[1]
/* 04001c3c 0bbc eae90c08 */  ssv   $v9[8], 0x10(s7)
/* 04001c40 0bc0 4b46a555 */  vsubc $v21, $v20, $v6[2]
/* 04001c44 0bc4 eae30c09 */  ssv   $v3[8], 0x12(s7)
/* 04001c48 0bc8 4b459ce0 */  vlt   $v19, $v19, $v5[2]
/* 04001c4c 0bcc eae90a0c */  ssv   $v9[4], 0x18(s7)
/* 04001c50 0bd0 4b46a527 */  vmrg  $v20, $v20, $v6[2]
/* 04001c54 0bd4 eae30a0d */  ssv   $v3[4], 0x1a(s7)
/* 04001c58 0bd8 22f70020 */  addi  s7, s7, 0x20
/* 04001c5c 0bdc 18e00031 */  blez  a3, .L04001d24
/* 04001c60 0be0 4bbea504 */  vmudl $v20, $v20, $v30[5]
/* 04001c64 0be4 8dee0000 */  lw    t6, 0x0(t7)
/* 04001c68 0be8 4bbe9ccd */  vmadm $v19, $v19, $v30[5]
/* 04001c6c 0bec 8df1fffc */  lw    s1, -4(t7)
/* 04001c70 0bf0 4b1ffd0e */  vmadn $v20, $v31, $v31[0]
/* 04001c74 0bf4 8df2fff8 */  lw    s2, -8(t7)
/* 04001c78 0bf8 c9c91005 */  llv   $v9[0], 0x14(t6)
/* 04001c7c 0bfc ca291405 */  llv   $v9[8], 0x14(s1)
/* 04001c80 0c00 ca561005 */  llv   $v22[0], 0x14(s2)
/* 04001c84 0c04 c9cb0811 */  lsv   $v11[0], 0x22(t6)
/* 04001c88 0c08 c9cc0810 */  lsv   $v12[0], 0x20(t6)
/* 04001c8c 0c0c ca2b0c11 */  lsv   $v11[8], 0x22(s1)
/* 04001c90 0c10 4b1e5273 */  vmov  $v9[2], $v30[0]
/* 04001c94 0c14 ca2c0c10 */  lsv   $v12[8], 0x20(s1)
/* 04001c98 0c18 4b1e7273 */  vmov  $v9[6], $v30[0]
/* 04001c9c 0c1c ca580811 */  lsv   $v24[0], 0x22(s2)
/* 04001ca0 0c20 4b1e55b3 */  vmov  $v22[2], $v30[0]
/* 04001ca4 0c24 ca590810 */  lsv   $v25[0], 0x20(s2)
/* 04001ca8 0c28 4b145984 */  vmudl $v6, $v11, $v20[0]
/* 04001cac 0c2c 4b14618d */  vmadm $v6, $v12, $v20[0]
/* 04001cb0 0c30 e9130822 */  ssv   $v19[0], 0x44(t0)
/* 04001cb4 0c34 4b13598e */  vmadn $v6, $v11, $v19[0]
/* 04001cb8 0c38 e9140826 */  ssv   $v20[0], 0x4c(t0)
/* 04001cbc 0c3c 4b13614f */  vmadh $v5, $v12, $v19[0]
/* 04001cc0 0c40 4b14c404 */  vmudl $v16, $v24, $v20[0]
/* 04001cc4 0c44 4b14cc0d */  vmadm $v16, $v25, $v20[0]
/* 04001cc8 0c48 4b13c50e */  vmadn $v20, $v24, $v19[0]
/* 04001ccc 0c4c 4b13cccf */  vmadh $v19, $v25, $v19[0]
/* 04001cd0 0c50 4a864c05 */  vmudm $v16, $v9, $v6[0h]
/* 04001cd4 0c54 4a854a4f */  vmadh $v9, $v9, $v5[0h]
/* 04001cd8 0c58 4b1ffa8e */  vmadn $v10, $v31, $v31[0]
/* 04001cdc 0c5c 4b14b405 */  vmudm $v16, $v22, $v20[0]
/* 04001ce0 0c60 4b13b58f */  vmadh $v22, $v22, $v19[0]
/* 04001ce4 0c64 4b1ffdce */  vmadn $v23, $v31, $v31[0]
/* 04001ce8 0c68 ea091c02 */  sdv   $v9[8], 0x10(s0)
/* 04001cec 0c6c ea0a1c03 */  sdv   $v10[8], 0x18(s0)
/* 04001cf0 0c70 ea091800 */  sdv   $v9[0], 0x0(s0)
/* 04001cf4 0c74 ea0a1801 */  sdv   $v10[0], 0x8(s0)
/* 04001cf8 0c78 ea161804 */  sdv   $v22[0], 0x20(s0)
/* 04001cfc 0c7c ea171805 */  sdv   $v23[0], 0x28(s0)
/* 04001d00 0c80 4a094a53 */  vabs  $v9, $v9, $v9
/* 04001d04 0c84 ca131004 */  llv   $v19[0], 0x10(s0)
/* 04001d08 0c88 4a16b593 */  vabs  $v22, $v22, $v22
/* 04001d0c 0c8c ca141006 */  llv   $v20[0], 0x18(s0)
/* 04001d10 0c90 4a139cd3 */  vabs  $v19, $v19, $v19
/* 04001d14 0c94 4a164c63 */  vge   $v17, $v9, $v22
/* 04001d18 0c98 4a1754a7 */  vmrg  $v18, $v10, $v23
/* 04001d1c 0c9c 4a138c63 */  vge   $v17, $v17, $v19
/* 04001d20 0ca0 4a1494a7 */  vmrg  $v18, $v18, $v20
.L04001d24:
/* 04001d24 0ca4 e9111010 */  slv   $v17[0], 0x40(t0)
/* 04001d28 0ca8 e9121012 */  slv   $v18[0], 0x48(t0)
/* 04001d2c 0cac 30a70007 */  andi  a3, a1, 0x7
/* 04001d30 0cb0 18e000ab */  blez  a3, .L04001fe0
/* 04001d34 0cb4 4a1ffcac */  vxor  $v18, $v31, $v31
/* 04001d38 0cb8 c8793802 */  luv   $v25[0], 0x10(v1)
/* 04001d3c 0cbc 4bbe9410 */  vadd  $v16, $v18, $v30[5]
/* 04001d40 0cc0 c82f3802 */  luv   $v15[0], 0x10(at)
/* 04001d44 0cc4 4bbe9610 */  vadd  $v24, $v18, $v30[5]
/* 04001d48 0cc8 c8573802 */  luv   $v23[0], 0x10(v0)
/* 04001d4c 0ccc 4bbe9150 */  vadd  $v5, $v18, $v30[5]
/* 04001d50 0cd0 4bffce45 */  vmudm $v25, $v25, $v31[7]
/* 04001d54 0cd4 4bff7bc5 */  vmudm $v15, $v15, $v31[7]
/* 04001d58 0cd8 4bffbdc5 */  vmudm $v23, $v23, $v31[7]
/* 04001d5c 0cdc c9101c03 */  ldv   $v16[8], 0x18(t0)
/* 04001d60 0ce0 c90f1c02 */  ldv   $v15[8], 0x10(t0)
/* 04001d64 0ce4 c9181c05 */  ldv   $v24[8], 0x28(t0)
/* 04001d68 0ce8 c9171c04 */  ldv   $v23[8], 0x20(t0)
/* 04001d6c 0cec c9051c07 */  ldv   $v5[8], 0x38(t0)
/* 04001d70 0cf0 c9191c06 */  ldv   $v25[8], 0x30(t0)
/* 04001d74 0cf4 c8300f0f */  lsv   $v16[14], 0x1e(at)
/* 04001d78 0cf8 c82f0f0e */  lsv   $v15[14], 0x1c(at)
/* 04001d7c 0cfc c8580f0f */  lsv   $v24[14], 0x1e(v0)
/* 04001d80 0d00 c8570f0e */  lsv   $v23[14], 0x1c(v0)
/* 04001d84 0d04 c8650f0f */  lsv   $v5[14], 0x1e(v1)
/* 04001d88 0d08 c8790f0e */  lsv   $v25[14], 0x1c(v1)
/* 04001d8c 0d0c 4a10c315 */  vsubc $v12, $v24, $v16
/* 04001d90 0d10 4a0fbad1 */  vsub  $v11, $v23, $v15
/* 04001d94 0d14 4a058515 */  vsubc $v20, $v16, $v5
/* 04001d98 0d18 4a197cd1 */  vsub  $v19, $v15, $v25
/* 04001d9c 0d1c 4a102a95 */  vsubc $v10, $v5, $v16
/* 04001da0 0d20 4a0fca51 */  vsub  $v9, $v25, $v15
/* 04001da4 0d24 4a188595 */  vsubc $v22, $v16, $v24
/* 04001da8 0d28 4a177d51 */  vsub  $v21, $v15, $v23
/* 04001dac 0d2c 4b645186 */  vmudn $v6, $v10, $v4[3]
/* 04001db0 0d30 4b64498f */  vmadh $v6, $v9, $v4[3]
/* 04001db4 0d34 4ba4b18e */  vmadn $v6, $v22, $v4[5]
/* 04001db8 0d38 4ba4a98f */  vmadh $v6, $v21, $v4[5]
/* 04001dbc 0d3c 4b094a5d */  vsar  $v9, $v9, $v9[0]
/* 04001dc0 0d40 4b2a529d */  vsar  $v10, $v10, $v10[1]
/* 04001dc4 0d44 4b846186 */  vmudn $v6, $v12, $v4[4]
/* 04001dc8 0d48 4b84598f */  vmadh $v6, $v11, $v4[4]
/* 04001dcc 0d4c 4b44a18e */  vmadn $v6, $v20, $v4[2]
/* 04001dd0 0d50 4b44998f */  vmadh $v6, $v19, $v4[2]
/* 04001dd4 0d54 4b0b5add */  vsar  $v11, $v11, $v11[0]
/* 04001dd8 0d58 4b2c631d */  vsar  $v12, $v12, $v12[1]
/* 04001ddc 0d5c 4b7a5184 */  vmudl $v6, $v10, $v26[3]
/* 04001de0 0d60 4b7a498d */  vmadm $v6, $v9, $v26[3]
/* 04001de4 0d64 4b7b528e */  vmadn $v10, $v10, $v27[3]
/* 04001de8 0d68 4b7b4a4f */  vmadh $v9, $v9, $v27[3]
/* 04001dec 0d6c 4b7a6184 */  vmudl $v6, $v12, $v26[3]
/* 04001df0 0d70 4b7a598d */  vmadm $v6, $v11, $v26[3]
/* 04001df4 0d74 4b7b630e */  vmadn $v12, $v12, $v27[3]
/* 04001df8 0d78 eae91801 */  sdv   $v9[0], 0x8(s7)
/* 04001dfc 0d7c 4b7b5acf */  vmadh $v11, $v11, $v27[3]
/* 04001e00 0d80 eaea1803 */  sdv   $v10[0], 0x18(s7)
/* 04001e04 0d84 4b3f6186 */  vmudn $v6, $v12, $v31[1]
/* 04001e08 0d88 4b3f598f */  vmadh $v6, $v11, $v31[1]
/* 04001e0c 0d8c 4ba1518c */  vmadl $v6, $v10, $v1[5]
/* 04001e10 0d90 4ba1498d */  vmadm $v6, $v9, $v1[5]
/* 04001e14 0d94 4ba0538e */  vmadn $v14, $v10, $v0[5]
/* 04001e18 0d98 eaeb1805 */  sdv   $v11[0], 0x28(s7)
/* 04001e1c 0d9c 4ba04b4f */  vmadh $v13, $v9, $v0[5]
/* 04001e20 0da0 eaec1807 */  sdv   $v12[0], 0x38(s7)
/* 04001e24 0da4 4b027704 */  vmudl $v28, $v14, $v2[0]
/* 04001e28 0da8 eaed1804 */  sdv   $v13[0], 0x20(s7)
/* 04001e2c 0dac 4b02698d */  vmadm $v6, $v13, $v2[0]
/* 04001e30 0db0 eaee1806 */  sdv   $v14[0], 0x30(s7)
/* 04001e34 0db4 4b1fff0e */  vmadn $v28, $v31, $v31[0]
/* 04001e38 0db8 4a1c8495 */  vsubc $v18, $v16, $v28
/* 04001e3c 0dbc 4a067c51 */  vsub  $v17, $v15, $v6
/* 04001e40 0dc0 30a70004 */  andi  a3, a1, 0x4
/* 04001e44 0dc4 18e00004 */  blez  a3, .L04001e58
/* 04001e48 0dc8 30a70002 */  andi  a3, a1, 0x2
/* 04001e4c 0dcc 22f70040 */  addi  s7, s7, 0x40
/* 04001e50 0dd0 eaf11878 */  sdv   $v17[0], -0x40(s7)
/* 04001e54 0dd4 eaf2187a */  sdv   $v18[0], -0x30(s7)
.L04001e58:
/* 04001e58 0dd8 18e00040 */  blez  a3, .L04001f5c
/* 04001e5c 0ddc 30a70001 */  andi  a3, a1, 0x1
/* 04001e60 0de0 20100800 */  addi  s0, r0, 0x800
/* 04001e64 0de4 48909800 */  mtc2  s0, $v19[0]
/* 04001e68 0de8 4a094e13 */  vabs  $v24, $v9, $v9
/* 04001e6c 0dec c9141c08 */  ldv   $v20[8], 0x40(t0)
/* 04001e70 0df0 4a0b5e53 */  vabs  $v25, $v11, $v11
/* 04001e74 0df4 c9151c09 */  ldv   $v21[8], 0x48(t0)
/* 04001e78 0df8 4b13c605 */  vmudm $v24, $v24, $v19[0]
/* 04001e7c 0dfc 4b1ffe8e */  vmadn $v26, $v31, $v31[0]
/* 04001e80 0e00 4b13ce45 */  vmudm $v25, $v25, $v19[0]
/* 04001e84 0e04 4b1ffece */  vmadn $v27, $v31, $v31[0]
/* 04001e88 0e08 4b13ad44 */  vmudl $v21, $v21, $v19[0]
/* 04001e8c 0e0c 4b13a50d */  vmadm $v20, $v20, $v19[0]
/* 04001e90 0e10 4b1ffd4e */  vmadn $v21, $v31, $v31[0]
/* 04001e94 0e14 4b5fd686 */  vmudn $v26, $v26, $v31[2]
/* 04001e98 0e18 4b5fc60f */  vmadh $v24, $v24, $v31[2]
/* 04001e9c 0e1c 4b1ffe8e */  vmadn $v26, $v31, $v31[0]
/* 04001ea0 0e20 4b3fddce */  vmadn $v23, $v27, $v31[1]
/* 04001ea4 0e24 4b3fcd8f */  vmadh $v22, $v25, $v31[1]
/* 04001ea8 0e28 20100040 */  addi  s0, r0, 0x40
/* 04001eac 0e2c 4b3fa98e */  vmadn $v6, $v21, $v31[1]
/* 04001eb0 0e30 48909800 */  mtc2  s0, $v19[0]
/* 04001eb4 0e34 4b3fa14f */  vmadh $v5, $v20, $v31[1]
/* 04001eb8 0e38 4ba635d5 */  vsubc $v23, $v6, $v6[5]
/* 04001ebc 0e3c 4ba52963 */  vge   $v5, $v5, $v5[5]
/* 04001ec0 0e40 4ba631a7 */  vmrg  $v6, $v6, $v6[5]
/* 04001ec4 0e44 4bc635d5 */  vsubc $v23, $v6, $v6[6]
/* 04001ec8 0e48 4bc52963 */  vge   $v5, $v5, $v5[6]
/* 04001ecc 0e4c 4bc631a7 */  vmrg  $v6, $v6, $v6[6]
/* 04001ed0 0e50 4b133184 */  vmudl $v6, $v6, $v19[0]
/* 04001ed4 0e54 4b13294d */  vmadm $v5, $v5, $v19[0]
/* 04001ed8 0e58 4b1ff98e */  vmadn $v6, $v31, $v31[0]
/* 04001edc 0e5c 4b8545f2 */  vrcph $v23[0], $v5[4]
/* 04001ee0 0e60 4b8641b1 */  vrcpl $v6[0], $v6[4]
/* 04001ee4 0e64 4b1f4172 */  vrcph $v5[0], $v31[0]
/* 04001ee8 0e68 4b5f3186 */  vmudn $v6, $v6, $v31[2]
/* 04001eec 0e6c 4b5f294f */  vmadh $v5, $v5, $v31[2]
/* 04001ef0 0e70 4b3f2960 */  vlt   $v5, $v5, $v31[1]
/* 04001ef4 0e74 4b1f31a7 */  vmrg  $v6, $v6, $v31[0]
/* 04001ef8 0e78 4b069504 */  vmudl $v20, $v18, $v6[0]
/* 04001efc 0e7c 4b068d0d */  vmadm $v20, $v17, $v6[0]
/* 04001f00 0e80 4b05950e */  vmadn $v20, $v18, $v5[0]
/* 04001f04 0e84 4b058ccf */  vmadh $v19, $v17, $v5[0]
/* 04001f08 0e88 4b065584 */  vmudl $v22, $v10, $v6[0]
/* 04001f0c 0e8c 4b064d8d */  vmadm $v22, $v9, $v6[0]
/* 04001f10 0e90 4b05558e */  vmadn $v22, $v10, $v5[0]
/* 04001f14 0e94 eaf31c00 */  sdv   $v19[8], 0x0(s7)
/* 04001f18 0e98 4b054d4f */  vmadh $v21, $v9, $v5[0]
/* 04001f1c 0e9c eaf41c02 */  sdv   $v20[8], 0x10(s7)
/* 04001f20 0ea0 4b066604 */  vmudl $v24, $v12, $v6[0]
/* 04001f24 0ea4 4b065e0d */  vmadm $v24, $v11, $v6[0]
/* 04001f28 0ea8 4b05660e */  vmadn $v24, $v12, $v5[0]
/* 04001f2c 0eac eaf51c01 */  sdv   $v21[8], 0x8(s7)
/* 04001f30 0eb0 4b055dcf */  vmadh $v23, $v11, $v5[0]
/* 04001f34 0eb4 eaf61c03 */  sdv   $v22[8], 0x18(s7)
/* 04001f38 0eb8 4b067684 */  vmudl $v26, $v14, $v6[0]
/* 04001f3c 0ebc 4b066e8d */  vmadm $v26, $v13, $v6[0]
/* 04001f40 0ec0 4b05768e */  vmadn $v26, $v14, $v5[0]
/* 04001f44 0ec4 eaf71c05 */  sdv   $v23[8], 0x28(s7)
/* 04001f48 0ec8 4b056e4f */  vmadh $v25, $v13, $v5[0]
/* 04001f4c 0ecc eaf81c07 */  sdv   $v24[8], 0x38(s7)
/* 04001f50 0ed0 22f70040 */  addi  s7, s7, 0x40
/* 04001f54 0ed4 eaf91c7c */  sdv   $v25[8], -0x20(s7)
/* 04001f58 0ed8 eafa1c7e */  sdv   $v26[8], -0x10(s7)
.L04001f5c:
/* 04001f5c 0edc 18e00020 */  blez  a3, .L04001fe0
/* 04001f60 0ee0 4b9e7386 */  vmudn $v14, $v14, $v30[4]
/* 04001f64 0ee4 4b9e6b4f */  vmadh $v13, $v13, $v30[4]
/* 04001f68 0ee8 4b1ffb8e */  vmadn $v14, $v31, $v31[0]
/* 04001f6c 0eec 4b9e8406 */  vmudn $v16, $v16, $v30[4]
/* 04001f70 0ef0 4b9e7bcf */  vmadh $v15, $v15, $v30[4]
/* 04001f74 0ef4 4b1ffc0e */  vmadn $v16, $v31, $v31[0]
/* 04001f78 0ef8 eaed0f04 */  ssv   $v13[14], 0x8(s7)
/* 04001f7c 0efc 4b9e5286 */  vmudn $v10, $v10, $v30[4]
/* 04001f80 0f00 eaee0f05 */  ssv   $v14[14], 0xa(s7)
/* 04001f84 0f04 4b9e4a4f */  vmadh $v9, $v9, $v30[4]
/* 04001f88 0f08 4b1ffa8e */  vmadn $v10, $v31, $v31[0]
/* 04001f8c 0f0c 4b9e6306 */  vmudn $v12, $v12, $v30[4]
/* 04001f90 0f10 4b9e5acf */  vmadh $v11, $v11, $v30[4]
/* 04001f94 0f14 4b1ffb0e */  vmadn $v12, $v31, $v31[0]
/* 04001f98 0f18 93a70011 */  lbu   a3, sp_11(sp)
/* 04001f9c 0f1c 00073822 */  sub   a3, r0, a3
/* 04001fa0 0f20 10e00003 */  beq   a3, r0, .L04001fb0
/* 04001fa4 0f24 48873000 */  mtc2  a3, $v6[0]
/* 04001fa8 0f28 4b065ae5 */  vch   $v11, $v11, $v6[0]
/* 04001fac 0f2c 4b1f6324 */  vcl   $v12, $v12, $v31[0]
.L04001fb0:
/* 04001fb0 0f30 eae90f02 */  ssv   $v9[14], 0x4(s7)
/* 04001fb4 0f34 4b027704 */  vmudl $v28, $v14, $v2[0]
/* 04001fb8 0f38 eaea0f03 */  ssv   $v10[14], 0x6(s7)
/* 04001fbc 0f3c 4b02698d */  vmadm $v6, $v13, $v2[0]
/* 04001fc0 0f40 eaeb0f06 */  ssv   $v11[14], 0xc(s7)
/* 04001fc4 0f44 4b1fff0e */  vmadn $v28, $v31, $v31[0]
/* 04001fc8 0f48 eaec0f07 */  ssv   $v12[14], 0xe(s7)
/* 04001fcc 0f4c 4a1c8495 */  vsubc $v18, $v16, $v28
/* 04001fd0 0f50 4a067c51 */  vsub  $v17, $v15, $v6
/* 04001fd4 0f54 22f70010 */  addi  s7, s7, 0x10
/* 04001fd8 0f58 eaf10f78 */  ssv   $v17[14], -0x10(s7)
/* 04001fdc 0f5c eaf20f79 */  ssv   $v18[14], -0xe(s7)
.L04001fe0:
/* 04001fe0 0f60 0d00045e */  jal   write_to_output_buff
.L04001fe4:
/* 04001fe4 0f64 00000000 */  nop
/* 04001fe8 0f68 03c00008 */  jr    s8
/* 04001fec 0f6c 00000000 */  nop
Overlay0End:

.headersize 0x04001000 - orga()

Overlay1:
gsp_04001000:
/* 04001000 0f70 4b7d5ef2 */  vrcph $v27[3], $v29[3]
/* 04001004 0f74 4b7c5eb1 */  vrcpl $v26[3], $v28[3]
/* 04001008 0f78 4bfd5ef2 */  vrcph $v27[3], $v29[7]
/* 0400100c 0f7c 4bfc7eb1 */  vrcpl $v26[7], $v28[7]
/* 04001010 0f80 4b1f7ef2 */  vrcph $v27[7], $v31[0]
/* 04001014 0f84 4b5fd686 */  vmudn $v26, $v26, $v31[2]
/* 04001018 0f88 4b5fdecf */  vmadh $v27, $v27, $v31[2]
/* 0400101c 0f8c 4b1ffe8e */  vmadn $v26, $v31, $v31[0]
/* 04001020 0f90 c8172006 */  lqv   $v23[0], addr0060(r0)
/* 04001024 0f94 4a1ffdac */  vxor  $v22, $v31, $v31
/* 04001028 0f98 4a1cd604 */  vmudl $v24, $v26, $v28
/* 0400102c 0f9c 4a1cde0d */  vmadm $v24, $v27, $v28
/* 04001030 0fa0 4a1dd60e */  vmadn $v24, $v26, $v29
/* 04001034 0fa4 4a1dde4f */  vmadh $v25, $v27, $v29
/* 04001038 0fa8 4a18b615 */  vsubc $v24, $v22, $v24
/* 0400103c 0fac 4a19be51 */  vsub  $v25, $v23, $v25
/* 04001040 0fb0 4a18d584 */  vmudl $v22, $v26, $v24
/* 04001044 0fb4 4a18ddcd */  vmadm $v23, $v27, $v24
/* 04001048 0fb8 4a19d68e */  vmadn $v26, $v26, $v25
/* 0400104c 0fbc 4a19decf */  vmadh $v27, $v27, $v25
/* 04001050 0fc0 03e00008 */  jr    ra
/* 04001054 0fc4 00000000 */  nop

dma_wait_dl:
/* 04001058 0fc8 0d000459 */  jal   dma_wait
/* 0400105c 0fcc 201b06e0 */  addi  k1, r0, dl_buffer

/**
 * Expects k1 = pointer to command
 */
.parse_and_execute_command:
/* 04001060 0fd0 8f790000 */  lw    t9, 0x0(k1)
/* 04001064 0fd4 8f780004 */  lw    t8, 0x4(k1)
/* 04001068 0fd8 00190f42 */  srl   at, t9, 29
/* 0400106c 0fdc 30210006 */  andi  at, at, 0x6
/* 04001070 0fe0 235a0008 */  addi  k0, k0, 0x8
/* 04001074 0fe4 237b0008 */  addi  k1, k1, 0x8
/* 04001078 0fe8 239cfff8 */  addi  gp, gp, -8
/* 0400107c 0fec 1c200007 */  bgtz  at, .execute_command
/* 04001080 0ff0 333201ff */  andi  s2, t9, 0x1ff

/**
 * This statement is reached by DMA commands (0x00-0x3f).
 * It runs off the end of overlay 1 and continues at 1088,
 * which is near the start of overlay 0 (they overlap).
 */
/* 04001084 0ff4 20160820 */  addi  s6, r0, tmp_buffer
Overlay1End:

.headersize 0x040017a0 - orga()

Overlay2:
/* 040017a0 0ff8 10000006 */  b     perform_clip
/* 040017a4 0ffc a41f0158 */  sh    ra, addr0158(r0)
/* 040017a8 1000 00000000 */  nop
/* 040017ac 1004 00000000 */  nop
/* 040017b0 1008 341e0018 */  li    s8, Overlay3Info
/* 040017b4 100c 1000fe51 */  b     load_overlay
/* 040017b8 1010 841500a0 */  lh    s5, addr00a0(r0)

perform_clip:
/* 040017bc 1014 a4030980 */  sh    v1, 0x980(r0)
/* 040017c0 1018 a4020982 */  sh    v0, 0x982(r0)
/* 040017c4 101c a4010984 */  sh    at, 0x984(r0)
/* 040017c8 1020 a4000986 */  sh    r0, 0x986(r0)
/* 040017cc 1024 34070df8 */  li    a3, 0xdf8
/* 040017d0 1028 341e0980 */  li    s8, 0x980
/* 040017d4 102c 3406000c */  li    a2, 0xc

next_clip:
/* 040017d8 1030 03de2825 */  or    a1, s8, s8
/* 040017dc 1034 3bde0014 */  xori  s8, s8, 0x14
.L040017e0:
/* 040017e0 1038 10c0006a */  beq   a2, r0, .L0400198c
/* 040017e4 103c 84cb00a6 */  lh    t3, addr00a6(a2)
/* 040017e8 1040 20c6fffe */  addi  a2, a2, -2
/* 040017ec 1044 34110000 */  li    s1, 0
/* 040017f0 1048 00009025 */  or    s2, r0, r0

found_in:
/* 040017f4 104c 34a20000 */  ori   v0, a1, 0x0

found_out:
/* 040017f8 1050 09000603 */  j     gsp_0400180c
/* 040017fc 1054 23ce0002 */  addi  t6, s8, 0x2
.L04001800:
/* 04001800 1058 010b4024 */  and   t0, t0, t3
/* 04001804 105c 1112000d */  beq   t0, s2, .L0400183c
/* 04001808 1060 20420002 */  addi  v0, v0, 0x2

gsp_0400180c:
/* 0400180c 1064 0140a025 */  or    s4, t2, r0
/* 04001810 1068 a5ca0000 */  sh    t2, 0x0(t6)
/* 04001814 106c 21ce0002 */  addi  t6, t6, 0x2
.L04001818:
/* 04001818 1070 844a0000 */  lh    t2, 0x0(v0)
/* 0400181c 1074 1540fff8 */  bne   t2, r0, .L04001800
/* 04001820 1078 85480024 */  lh    t0, 0x24(t2)
/* 04001824 107c 2228fffe */  addi  t0, s1, -2
/* 04001828 1080 1d00fffb */  bgtz  t0, .L04001818
/* 0400182c 1084 34a20000 */  ori   v0, a1, 0x0
/* 04001830 1088 1100ffeb */  beq   t0, r0, .L040017e0
/* 04001834 108c 00000000 */  nop
/* 04001838 1090 0900066e */  j     gsp_040019b8
.L0400183c:
/* 0400183c 1094 024b9026 */  xor   s2, s2, t3
/* 04001840 1098 862800f6 */  lh    t0, addr00f6_table(s1)
/* 04001844 109c 22310002 */  addi  s1, s1, 0x2
/* 04001848 10a0 01000008 */  jr    t0
/* 0400184c 10a4 84080102 */  lh    t0, addr0102(r0)

found_first_in:
/* 04001850 10a8 488a6800 */  mtc2  t2, $v13[0]
/* 04001854 10ac 02805025 */  or    t2, s4, r0
/* 04001858 10b0 48146800 */  mfc2  s4, $v13[0]
/* 0400185c 10b4 37ce0000 */  ori   t6, s8, 0x0
/* 04001860 10b8 840800f8 */  lh    t0, addr00f8(r0)

found_first_out:
/* 04001864 10bc a4080106 */  sh    t0, addr0106(r0)
/* 04001868 10c0 20e70028 */  addi  a3, a3, 0x28
/* 0400186c 10c4 a5c70000 */  sh    a3, 0x0(t6)
/* 04001870 10c8 a5c00002 */  sh    r0, 0x2(t6)
/* 04001874 10cc c9491800 */  ldv   $v9[0], 0x0(t2)
/* 04001878 10d0 c94a1801 */  ldv   $v10[0], 0x8(t2)
/* 0400187c 10d4 ca841800 */  ldv   $v4[0], 0x0(s4)
/* 04001880 10d8 ca851801 */  ldv   $v5[0], 0x8(s4)
/* 04001884 10dc 00064080 */  sll   t0, a2, 2
/* 04001888 10e0 c901180e */  ldv   $v1[0], addr0070(t0)
/* 0400188c 10e4 4b7f0807 */  vmudh $v0, $v1, $v31[3]
/* 04001890 10e8 4a012b06 */  vmudn $v12, $v5, $v1
/* 04001894 10ec 4a0122cf */  vmadh $v11, $v4, $v1
/* 04001898 10f0 4b1ffb0e */  vmadn $v12, $v31, $v31[0]
/* 0400189c 10f4 4a00570e */  vmadn $v28, $v10, $v0
/* 040018a0 10f8 4a004f4f */  vmadh $v29, $v9, $v0
/* 040018a4 10fc 4b1fff0e */  vmadn $v28, $v31, $v31[0]
/* 040018a8 1100 4a5ce694 */  vaddc $v26, $v28, $v28[0q]
/* 040018ac 1104 4a5deed0 */  vadd  $v27, $v29, $v29[0q]
/* 040018b0 1108 4abad714 */  vaddc $v28, $v26, $v26[1h]
/* 040018b4 110c 4abbdf50 */  vadd  $v29, $v27, $v27[1h]
/* 040018b8 1110 4808eb00 */  mfc2  t0, $v29[6]
/* 040018bc 1114 4b7d59f2 */  vrcph $v7[3], $v29[3]
/* 040018c0 1118 4b7c58f1 */  vrcpl $v3[3], $v28[3]
/* 040018c4 111c 4b1f59f2 */  vrcph $v7[3], $v31[0]
/* 040018c8 1120 4b5f18c6 */  vmudn $v3, $v3, $v31[2]
/* 040018cc 1124 05010003 */  bgez  t0, .L040018dc
/* 040018d0 1128 4b5f39cf */  vmadh $v7, $v7, $v31[2]
/* 040018d4 112c 4b7f18c6 */  vmudn $v3, $v3, $v31[3]
/* 040018d8 1130 4b7f39cf */  vmadh $v7, $v7, $v31[3]
.L040018dc:
/* 040018dc 1134 4b1f39e1 */  veq   $v7, $v7, $v31[0]
/* 040018e0 1138 4b7f18e7 */  vmrg  $v3, $v3, $v31[3]
/* 040018e4 113c 4b63e704 */  vmudl $v28, $v28, $v3[3]
/* 040018e8 1140 4b63ef4d */  vmadm $v29, $v29, $v3[3]
/* 040018ec 1144 0d000400 */  jal   gsp_04001000
/* 040018f0 1148 4b1fff0e */  vmadn $v28, $v31, $v31[0]
/* 040018f4 114c 4a4c6714 */  vaddc $v28, $v12, $v12[0q]
/* 040018f8 1150 4a4b5f50 */  vadd  $v29, $v11, $v11[0q]
/* 040018fc 1154 4abce314 */  vaddc $v12, $v28, $v28[1h]
/* 04001900 1158 4abdead0 */  vadd  $v11, $v29, $v29[1h]
/* 04001904 115c 4a1a63c4 */  vmudl $v15, $v12, $v26
/* 04001908 1160 4a1a5bcd */  vmadm $v15, $v11, $v26
/* 0400190c 1164 4a1b63ce */  vmadn $v15, $v12, $v27
/* 04001910 1168 4a1b5a0f */  vmadh $v8, $v11, $v27
/* 04001914 116c 4bbfff04 */  vmudl $v28, $v31, $v31[5]
/* 04001918 1170 4b637bcc */  vmadl $v15, $v15, $v3[3]
/* 0400191c 1174 4b63420d */  vmadm $v8, $v8, $v3[3]
/* 04001920 1178 4b1ffbce */  vmadn $v15, $v31, $v31[0]
/* 04001924 117c 4b1f4221 */  veq   $v8, $v8, $v31[0]
/* 04001928 1180 4b7f7be7 */  vmrg  $v15, $v15, $v31[3]
/* 0400192c 1184 4b1f7be2 */  vne   $v15, $v15, $v31[0]
/* 04001930 1188 4b3f7be7 */  vmrg  $v15, $v15, $v31[1]
/* 04001934 118c 4b1f7a2d */  vnxor $v8, $v15, $v31[0]
/* 04001938 1190 4b3f4214 */  vaddc $v8, $v8, $v31[1]
/* 0400193c 1194 4a1def50 */  vadd  $v29, $v29, $v29
/* 04001940 1198 4ae82f04 */  vmudl $v28, $v5, $v8[3h]
/* 04001944 119c 4ae8274d */  vmadm $v29, $v4, $v8[3h]
/* 04001948 11a0 4aef570c */  vmadl $v28, $v10, $v15[3h]
/* 0400194c 11a4 4aef4f4d */  vmadm $v29, $v9, $v15[3h]
/* 04001950 11a8 4b1fff0e */  vmadn $v28, $v31, $v31[0]
/* 04001954 11ac c94c3802 */  luv   $v12[0], 0x10(t2)
/* 04001958 11b0 ca8b3802 */  luv   $v11[0], 0x10(s4)
/* 0400195c 11b4 c94c1405 */  llv   $v12[8], 0x14(t2)
/* 04001960 11b8 ca8b1405 */  llv   $v11[8], 0x14(s4)
/* 04001964 11bc 4b6f6485 */  vmudm $v18, $v12, $v15[3]
/* 04001968 11c0 4b685c8d */  vmadm $v18, $v11, $v8[3]
/* 0400196c 11c4 e8f23800 */  suv   $v18[0], 0x0(a3)
/* 04001970 11c8 e8f21c01 */  sdv   $v18[8], 0x8(a3)
/* 04001974 11cc c8f21801 */  ldv   $v18[0], 0x8(a3)
/* 04001978 11d0 0d000530 */  jal   gsp_040014c0
/* 0400197c 11d4 8cef0000 */  lw    t7, 0x0(a3)
/* 04001980 11d8 480a6800 */  mfc2  t2, $v13[0]
/* 04001984 11dc 09000577 */  j     gsp_040015dc
/* 04001988 11e0 34090001 */  li    t1, 1
.L0400198c:
/* 0400198c 11e4 84a80000 */  lh    t0, 0x0(a1)
/* 04001990 11e8 a40800b4 */  sh    t0, addr00b4(r0)
/* 04001994 11ec a4050106 */  sh    a1, addr0106(r0)
/* 04001998 11f0 841e00fe */  lh    s8, addr00fe(r0)

clip_draw_loop:
/* 0400199c 11f4 84080106 */  lh    t0, addr0106(r0)
/* 040019a0 11f8 840300b4 */  lh    v1, addr00b4(r0)
/* 040019a4 11fc 85020002 */  lh    v0, 0x2(t0)
/* 040019a8 1200 85010004 */  lh    at, 0x4(t0)
/* 040019ac 1204 21080002 */  addi  t0, t0, 0x2
/* 040019b0 1208 1420000e */  bne   at, r0, .L040019ec
/* 040019b4 120c a4080106 */  sh    t0, addr0106(r0)

gsp_040019b8:
/* 040019b8 1210 0900042a */  j     sp_noop
/* 040019bc 1214 00000000 */  nop
Overlay2End:

.headersize 0x040017a0 - orga()

Overlay3:
/* 040017a0 1218 341e0010 */  li    s8, Overlay2Info
/* 040017a4 121c 1000fe55 */  b     load_overlay
/* 040017a8 1220 84150100 */  lh    s5, addr0100(r0)
/* 040017ac 1224 8c01012c */  lw    at, numlights(r0)
/* 040017b0 1228 acef0000 */  sw    t7, 0x0(a3)
/* 040017b4 122c acf00004 */  sw    s0, 0x4(a3)
/* 040017b8 1230 04200022 */  bltz  at, .L04001844
/* 040017bc 1234 c8e43000 */  lpv   $v4[0], 0x0(a3)
/* 040017c0 1238 c827383a */  luv   $v7[0], lookatx(at)
/* 040017c4 123c 4a1bdeec */  vxor  $v27, $v27, $v27
.L040017c8:
/* 040017c8 1240 4b1f39e3 */  vge   $v7, $v7, $v31[0]
/* 040017cc 1244 c8253038 */  lpv   $v5[0], (lookaty+0x10)(at)
/* 040017d0 1248 4a07ded0 */  vadd  $v27, $v27, $v7
/* 040017d4 124c c8273836 */  luv   $v7[0], lookaty(at)
/* 040017d8 1250 4b1f352a */  vor   $v20, $v6, $v31[0]
/* 040017dc 1254 4a052180 */  vmulf $v6, $v4, $v5
/* 040017e0 1258 4a6630d0 */  vadd  $v3, $v6, $v6[1q]
/* 040017e4 125c 4ac61990 */  vadd  $v6, $v3, $v6[2h]
/* 040017e8 1260 4a8639c0 */  vmulf $v7, $v7, $v6[0h]
/* 040017ec 1264 1c20fff6 */  bgtz  at, .L040017c8
/* 040017f0 1268 2021ffe0 */  addi  at, at, -0x20
/* 040017f4 126c e8fb3800 */  suv   $v27[0], 0x0(a3)
/* 040017f8 1270 30680004 */  andi  t0, v1, 0x4
/* 040017fc 1274 a0ef0003 */  sb    t7, 0x3(a3)
/* 04001800 1278 a0f00007 */  sb    s0, 0x7(a3)
/* 04001804 127c 8cef0000 */  lw    t7, 0x0(a3)
/* 04001808 1280 1100ff73 */  beq   t0, r0, gsp_040015d8
/* 0400180c 1284 8cf00004 */  lw    s0, 0x4(a3)
/* 04001810 1288 30680008 */  andi  t0, v1, 0x8
/* 04001814 128c cba73012 */  lpv   $v7[0], sp_90(sp)
/* 04001818 1290 c8061814 */  ldv   $v6[0], addr00a0(r0)
/* 0400181c 1294 4a943d0e */  vmadn $v20, $v7, $v20[0h]
/* 04001820 1298 11000006 */  beq   t0, r0, .L0400183c
/* 04001824 129c 4b1ffc8d */  vmadm $v18, $v31, $v31[0]
/* 04001828 12a0 4a1291c0 */  vmulf $v7, $v18, $v18
/* 0400182c 12a4 4a1239c0 */  vmulf $v7, $v7, $v18
/* 04001830 12a8 4b263d00 */  vmulf $v20, $v7, $v6[1]
/* 04001834 12ac 4b663d08 */  vmacf $v20, $v7, $v6[3]
/* 04001838 12b0 4b469488 */  vmacf $v18, $v18, $v6[2]
/* 0400183c 12b4 09000576 */  j     gsp_040015d8
/* 04001840 12b8 4b9f9490 */  vadd  $v18, $v18, $v31[4]
.L04001844:
/* 04001844 12bc 30210fff */  andi  at, at, 0xfff
/* 04001848 12c0 ac01012c */  sw    at, numlights(r0)
/* 0400184c 12c4 0d00053f */  jal   gsp_040014fc
/* 04001850 12c8 200802a0 */  addi  t0, r0, mtx2a0
/* 04001854 12cc 34080e20 */  li    t0, tridata_buffer
/* 04001858 12d0 e9085901 */  stv   $v8[2], 0x10(t0)
/* 0400185c 12d4 e9085a02 */  stv   $v8[4], 0x20(t0)
/* 04001860 12d8 e9085e03 */  stv   $v8[12], 0x30(t0)
/* 04001864 12dc e9085f04 */  stv   $v8[14], 0x40(t0)
/* 04001868 12e0 c9085f01 */  ltv   $v8[14], 0x10(t0)
/* 0400186c 12e4 c9085e02 */  ltv   $v8[12], 0x20(t0)
/* 04001870 12e8 c9085a03 */  ltv   $v8[4], 0x30(t0)
/* 04001874 12ec c9085904 */  ltv   $v8[2], 0x40(t0)
/* 04001878 12f0 e90c1c02 */  sdv   $v12[8], 0x10(t0)
/* 0400187c 12f4 e90d1c04 */  sdv   $v13[8], 0x20(t0)
/* 04001880 12f8 e90e1c06 */  sdv   $v14[8], 0x30(t0)
/* 04001884 12fc c90c1802 */  ldv   $v12[0], 0x10(t0)
/* 04001888 1300 c90d1804 */  ldv   $v13[0], 0x20(t0)
/* 0400188c 1304 c90e1806 */  ldv   $v14[0], 0x30(t0)
/* 04001890 1308 c8253037 */  lpv   $v5[0], (lookaty+0x08)(at)
/* 04001894 130c 4b9f2940 */  vmulf $v5, $v5, $v31[4]
/* 04001898 1310 4a856186 */  vmudn $v6, $v12, $v5[0h]
/* 0400189c 1314 4aa5698e */  vmadn $v6, $v13, $v5[1h]
/* 040018a0 1318 4ac5718e */  vmadn $v6, $v14, $v5[2h]
/* 040018a4 131c 4b1ff8cd */  vmadm $v3, $v31, $v31[0]
/* 040018a8 1320 4b5f1985 */  vmudm $v6, $v3, $v31[2]
/* 040018ac 1324 4a8540c8 */  vmacf $v3, $v8, $v5[0h]
/* 040018b0 1328 4aa548c8 */  vmacf $v3, $v9, $v5[1h]
/* 040018b4 132c 4ac550c8 */  vmacf $v3, $v10, $v5[2h]
/* 040018b8 1330 4b1ff98e */  vmadn $v6, $v31, $v31[0]
/* 040018bc 1334 4a063144 */  vmudl $v5, $v6, $v6
/* 040018c0 1338 4a06194d */  vmadm $v5, $v3, $v6
/* 040018c4 133c 4a03314e */  vmadn $v5, $v6, $v3
/* 040018c8 1340 4a031e8f */  vmadh $v26, $v3, $v3
/* 040018cc 1344 4a6529d4 */  vaddc $v7, $v5, $v5[1q]
/* 040018d0 1348 4a7ad110 */  vadd  $v4, $v26, $v26[1q]
/* 040018d4 134c 4a8729d4 */  vaddc $v7, $v5, $v7[0h]
/* 040018d8 1350 4a84d110 */  vadd  $v4, $v26, $v4[0h]
/* 040018dc 1354 4b4442f6 */  vrsqh $v11[0], $v4[2]
/* 040018e0 1358 4b4743f5 */  vrsql $v15[0], $v7[2]
/* 040018e4 135c 4b1f42f6 */  vrsqh $v11[0], $v31[0]
/* 040018e8 1360 4b7e7bc4 */  vmudl $v15, $v15, $v30[3]
/* 040018ec 1364 4b7e5acd */  vmadm $v11, $v11, $v30[3]
/* 040018f0 1368 4b1ffbce */  vmadn $v15, $v31, $v31[0]
/* 040018f4 136c 4b0f31c4 */  vmudl $v7, $v6, $v15[0]
/* 040018f8 1370 4b0f19cd */  vmadm $v7, $v3, $v15[0]
/* 040018fc 1374 4b0b31ce */  vmadn $v7, $v6, $v11[0]
/* 04001900 1378 4b0b190f */  vmadh $v4, $v3, $v11[0]
/* 04001904 137c 4b1ff9ce */  vmadn $v7, $v31, $v31[0]
/* 04001908 1380 cba2181f */  ldv   $v2[0], sp_f8(sp)
/* 0400190c 1384 4b0239e3 */  vge   $v7, $v7, $v2[0]
/* 04001910 1388 4b2239e0 */  vlt   $v7, $v7, $v2[1]
/* 04001914 138c 4b4239c6 */  vmudn $v7, $v7, $v2[2]
/* 04001918 1390 e8273038 */  spv   $v7[0], (lookaty+0x10)(at)
/* 0400191c 1394 8c2801c0 */  lw    t0, (lookaty+0x10)(at)
/* 04001920 1398 ac2801c4 */  sw    t0, (lookaty+0x14)(at)
/* 04001924 139c 1c20ffda */  bgtz  at, .L04001890
/* 04001928 13a0 2021ffe0 */  addi  at, at, -0x20
/* 0400192c 13a4 0900053a */  j     gsp_040014e8
/* 04001930 13a8 841f00a0 */  lh    ra, addr00a0(r0)
/* 04001934 13ac 00000000 */  nop
Overlay3End:

.headersize 0x040017a0 - orga()

/**
 * Overlay 4 (yield handler)
 *
 * Copies DMEM range 0-0x940 to yield_data_ptr,
 * then enters an infinite loop of reloading the overlay and copying.
 *
 * The SP's status is set to SIG7 when dumping, and SIG5 when between dumps.
 */
Overlay4:
/* 040017a0 13b0 090005f0 */  j     write_yield_data
/* 040017a4 13b4 00000000 */  nop

yield_with_dma_wait:
/* 040017a8 13b8 00000000 */  nop
/* 040017ac 13bc 0d000459 */  jal   dma_wait
/* 040017b0 13c0 34024000 */  li    v0, SP_STATUS_SIG7
/* 040017b4 13c4 40822000 */  mtc0  v0, SP_STATUS
/* 040017b8 13c8 0000000d */  break 0
/* 040017bc 13cc 00000000 */  nop

write_yield_data:
/* 040017c0 13d0 34021000 */  li    v0, SP_STATUS_SIG5
/* 040017c4 13d4 ac1c0924 */  sw    gp, savedgp(r0)
/* 040017c8 13d8 ac1b0928 */  sw    k1, savedk1(r0)
/* 040017cc 13dc ac1a092c */  sw    k0, savedk0(r0)
/* 040017d0 13e0 ac170930 */  sw    s7, saveds7(r0)
/* 040017d4 13e4 8c130108 */  lw    s3, yield_data_ptr(r0)
/* 040017d8 13e8 34140000 */  li    s4, 0
/* 040017dc 13ec 3412093f */  li    s2, 0x93f
/* 040017e0 13f0 0d00044f */  jal   dma_read_write
/* 040017e4 13f4 34110001 */  li    s1, DMA_WRITE
/* 040017e8 13f8 0d000459 */  jal   dma_wait
/* 040017ec 13fc 00000000 */  nop
/* 040017f0 1400 09000432 */  j     handle_enddl_yield
/* 040017f4 1404 40822000 */  mtc0  v0, SP_STATUS
/* 040017f8 1408 00000000 */  nop
/* 040017fc 140c 00000000 */  nop
/* 04001800 1410 2400beef */  addiu r0, r0, 0xbeef
/* 04001804 1414 00000000 */  nop
Overlay4End:

.close
