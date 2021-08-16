; ================================================================
;   Simple Replacement Boot ROM for Interact
;
;   Displays bitmap "BOOT.ROM MISSING" on a blue background
;
;   Block RAM memory for the ROM is pre-initialized with this and
;   it's overwritten when the core loads if a boot.rom file
;   is present on the SD card.  Otherwise this program runs
;   and user is alerted that a boot.rom file is needed.
;
;   Building:
;     zasm --8080 boot.asm
;     srec_cat boot.rom -binary -o boot.mif -mif
;
;   Tools:
;     zasm - https://github.com/Megatokio/zasm
;     srecord - http://srecord.sourceforge.net/
;
; ================================================================

#target rom

_rom_start::        equ 0
_rom_end::          equ 0x1000

; ================================================================
; Define ordering of code segments in ram:
; these segments produce code in the output file!
; ================================================================

#code   _HEADER,_rom_start
#code   _ROM_PADDING        ; pad rom file up to rom end
        defs  _rom_end-$$

; ================================================================
;   _HEADER segment:
;   starts at 0x0000
; ================================================================

;   reset vector
;   RST vectors
;   INT vector (IM 1)

#CODE _HEADER

; reset vector
RST0::  di
        jp      begin
        defs    0x08-$

RST1::  ret
        defs    0x10-$

RST2::  ret
        defs    0x18-$

RST3::  ret
        defs    0x20-$

RST4::  ret
        defs    0x28-$

RST5::  ret
        defs    0x30-$

RST6::  ret
        defs    0x38-$

; maskable interrupt handler in interrupt mode 1:
RST7::  ei
        ret


; begin:

begin:  ld  a,$24
        ld  ($1000),a
        ld  a,$3C
        ld  ($1800),a

        ld  bc,$09FF 
        ld  hl,$4000
clrl:   ld  a,$00
        ld (hl),a
        inc hl
        dec bc
        ld a, b
        or c
        jp nz,clrl

        ld  bc,160 
        ld  de,bitmap
        ld  hl,$4400
blit:   ld  a,(de)
        ld (hl),a
        inc hl
        inc de
        dec bc
        ld a, b
        or c
        jp nz,blit

wait:   jp wait

bitmap: dm $0000fccffffccfff00c0fffccfc000c0c0f0c3fffc0f3f0cccff000000000000
        dm $00000cccc00c0c0c00c0c00cccf300c0f3c0c0000c000c3ccc00000000000000
        dm $0000fcc3c00c0c0c00c0ff0ccccc00c0ccc0c0fffc0f0cccccf0000000000000
        dm $00000cccc00c0c0c00c0300cccc000c0c0c000c0000c0c0ccfc0000000000000
        dm $0000fccffffc0f0cc0c0c0fccfc000c0c0f0c3fffc0f3f0cccff000000000000














