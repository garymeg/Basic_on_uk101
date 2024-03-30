          * = $e000
          and $55e6
          sbc $33
          nop
          ???             //    %11111111
          inc $16
          sbc #$f4
          cpx $e942
          ldy $ace7
          inc $84
          inc $2f
          ???             //    %11100111
          ora $8fe6,y
          inc $d9
          inc $42
          ???             //    %11100111
          ???             //    %00101011 '+'
          inc $52
          ???             //    %11100111
          ror $25e6
          ???             //    %11110100
          ???             //    %01110100 't'
          ???             //    %11111111
          adc $ff,x
          cmp ($ef),y
          ???             //    %00011100
          ???             //    %11110100
          ???             //    %00100010 '"'
          inx
          ???             //    %01010100 'T'
          inc $b4
          cpx $7f
          inc $60
          cpx $cc
          ???             //    %11110111
          lsr $f8,x
          sbc #$f7
          asl a
          brk
          lda ($ef,x)
          ???             //    %11000010
          ???             //    %11101111
          ldy #$fa
          ldy $fb,x
          lda ($f5),y
          ???             //    %00001111
          ???             //    %11111011
          beq le049
          ???             //    %11110111
          ???             //    %11111011
          rti
          ???             //    %11111100
le052:    sta $12fc
          ???             //    %11110100
          ???             //    %10000000
le057:    ???             //    %11110011
          ???             //    %10000000
          beq le00c
          ???             //    %11110011
          ???             //    %10001111
          ???             //    %11110011
          beq le052
          ???             //    %00000100
          ???             //    %11110011
          bmi le057
          ???             //    %00111011 '//    '
          ???             //    %11110011
          adc $f462,y
          adc $f44b,y
          ???             //    %01111011 '{'
          sbc ($f5),y
          ???             //    %01111011 '{'
          cpy #$f6
          ???             //    %01111111
          lda #$fa
          bvc le0d3
          cpx $5946
          cpx le27d
          ???             //    %11111010
          ???             //    %01011010 'Z'
          ???             //    %11001011
          ???             //    %11101011
          ???             //    %01100100 'd'
          ???             //    %10001001
          cpx $4e45
          cpy $46
          ???             //    %01001111 'O'
          ???             //    %11010010
          lsr $5845
          ???             //    %11010100
          ???             //    %01000100 'D'
          eor ($54,x)
          cmp ($49,x)
          lsr $5550
          ???             //    %11010100
          ???             //    %01000100 'D'
          eor #$cd
          ???             //    %01010010 'R'
          eor $41
          cpy $4c
          eor $d4
          ???             //    %01000111 'G'
          ???             //    %01001111 'O'
          ???             //    %01010100 'T'
          ???             //    %11001111
          ???             //    %01010010 'R'
          eor $ce,x
          eor #$c6
          ???             //    %01010010 'R'
          eor $53
          ???             //    %01010100 'T'
          ???             //    %01001111 'O'
          ???             //    %01010010 'R'
          cmp $47
          ???             //    %01001111 'O'
          ???             //    %01010011 'S'
          eor $c2,x
          ???             //    %01010010 'R'
          eor $54
          eor $52,x
          dec $4552
          cmp $5453
          ???             //    %01001111 'O'
          bne le113
          dec $554e
          jmp $57cc
          eor ($49,x)
          ???             //    %11010100
          jmp $414f
          cpy $53
          eor ($56,x)
          cmp $44
          eor $c6
          bvc le129
          ???             //    %01001011 'K'
          cmp $50
          ???             //    %01010010 'R'
          eor #$4e
          ???             //    %11010100
          ???             //    %01000011 'C'
          ???             //    %01001111 'O'
          lsr $4cd4
          eor #$53
          ???             //    %11010100
          ???             //    %01000011 'C'
          jmp $4145
          ???             //    %11010010
          lsr $d745
          ???             //    %01010100 'T'
          eor ($42,x)
          tay
          ???             //    %01010100 'T'
          ???             //    %11001111
          lsr $ce
          ???             //    %01010011 'S'
          bvc le13f
          tay
          ???             //    %01010100 'T'
          pha
          eor $ce
          lsr $d44f
          ???             //    %01010011 'S'
          ???             //    %01010100 'T'
          eor $d0
          ???             //    %10101011
          lda $afaa
          dec $4e41,x
          cpy $4f
          ???             //    %11010010
          ldx $bcbd,y
          ???             //    %01010011 'S'
          ???             //    %01000111 'G'
          dec $4e49
          ???             //    %11010100
          eor ($42,x)
          ???             //    %11010011
          eor $53,x
          ???             //    %11010010
          lsr $52
          cmp $50
          ???             //    %01001111 'O'
          ???             //    %11010011
          ???             //    %01010011 'S'
          eor ($d2),y
          ???             //    %01010010 'R'
          lsr $4cc4
          ???             //    %01001111 'O'
          ???             //    %11000111
          eor $58
          bne le177
          ???             //    %01001111 'O'
          ???             //    %11010011
          ???             //    %01010011 'S'
          eor #$ce
          ???             //    %01010100 'T'
          eor ($ce,x)
          eor ($54,x)
          dec $4550
          eor $cb
          jmp $ce45
          ???             //    %01010011 'S'
          ???             //    %01010100 'T'
          ???             //    %01010010 'R'
          ldy $56
          eor ($cc,x)
          eor ($53,x)
          ???             //    %11000011
          ???             //    %01000011 'C'
          pha
          ???             //    %01010010 'R'
          ldy $4c
          eor $46
          ???             //    %01010100 'T'
          ldy $52
          eor #$47
          pha
          ???             //    %01010100 'T'
          ldy $4d
          eor #$44
          ldy $00
          lsr $5346
          lsr $4752
          ???             //    %01001111 'O'
          ???             //    %01000100 'D'
          lsr $43
          ???             //    %01001111 'O'
          lsr $4f,x
          eor $5355
          ???             //    %01000010 'B'
          ???             //    %01010011 'S'
          ???             //    %01000100 'D'
le177:    ???             //    %01000100 'D'
          ???             //    %00101111 '/'
          bmi le1c4
          ???             //    %01000100 'D'
          ???             //    %01010100 'T'
          eor $534c
          ???             //    %01010011 'S'
          ???             //    %01010100 'T'
          ???             //    %01000011 'C'
          lsr $4655
          jsr $5245
          ???             //    %01010010 'R'
          ???             //    %01001111 'O'
          ???             //    %01010010 'R'
          brk
          jsr $4e49
          jsr $0d00
          asl a
          ???             //    %01001111 'O'
          ???             //    %01001011 'K'
          ora $000a
          ora $420a
          ???             //    %01010010 'R'
          eor $41
          ???             //    %01001011 'K'
          brk
le1a1:    tsx
          inx
          inx
          inx
          inx
le1a6:    lda $0101,x
          cmp #$81
          bne le1ce
          lda $98
          bne le1bb
          lda $0102,x
          sta $97
          lda $0103,x
          sta $98
le1bb:    cmp $0103,x
          bne le1c7
          lda $97
          cmp $0102,x
          beq le1ce
le1c7:    txa
          clc
          adc #$10
          tax
          bne le1a6
le1ce:    rts
le1cf:    jsr le21f
          sta $7f
          sty $80
le1d6:    sec
          lda $a6
          sbc $aa
          sta $71
          tay
          lda $a7
          sbc $ab
          tax
          inx
          tya
          beq le20a
          lda $a6
          sec
          sbc $71
          sta $a6
          bcs le1f3
          dec $a7
          sec
le1f3:    lda $a4
          sbc $71
          sta $a4
          bcs le203
          dec $a5
          bcc le203
le1ff:    lda ($a6),y
          sta ($a4),y
le203:    dey
          bne le1ff
          lda ($a6),y
          sta ($a4),y
le20a:    dec $a7
          dec $a5
          dex
          bne le203
          rts
le212:    asl a
          adc #$33
          bcs le24c
          sta $71
          tsx
          cpx $71
          bcc le24c
          rts
le21f:    cpy $82
          bcc le24b
          bne le229
          cmp $81
          bcc le24b
le229:    pha
          ldx #$08
          tya
le22d:    pha
          lda $a3,x
          dex
          bpl le22d
          jsr lf13b
          ldx #$f8
le238:    pla
          sta $ac,x
          inx
          bmi le238
          pla
          tay
          pla
          cpy $82
          bcc le24b
          bne le24c
          cmp $81
          bcs le24c
le24b:    rts
le24c:    ldx #$0c
le24e:    lsr $64
          jsr le860
          jsr le8d7
          lda $e164,x
          jsr le8d9
          lda $e165,x
          jsr le8d9
          jsr le491
          lda #$86
          ldy #$e1
le269:    jsr le8b7
          ldy $88
          iny
          beq le274
          jsr lf947
le274:    lsr $64
          lda #$92
          ldy #$e1
          jsr $0003
le27d:    jsr le357
          stx $c3
          sty $c4
          jsr $00bc
          beq le27d
          ldx #$ff
          stx $88
          bcc le295
          jsr le3a6
          jmp le5f6
le295:    jsr le773
          jsr le3a6
          sty $5d
          jsr le432
          bcc le2e6
          ldy #$01
          lda ($aa),y
          sta $72
          lda $7b
          sta $71
          lda $ab
          sta $74
          lda $aa
          dey
          sbc ($aa),y
          clc
          adc $7b
          sta $7b
          sta $73
          lda $7c
          adc #$ff
          sta $7c
          sbc $ab
          tax
          sec
          lda $aa
          sbc $7b
          tay
          bcs le2d0
          inx
          dec $74
le2d0:    clc
          adc $71
          bcc le2d8
          dec $72
          clc
le2d8:    lda ($71),y
          sta ($73),y
          iny
          bne le2d8
          inc $72
          inc $74
          dex
          bne le2d8
le2e6:    lda $13
          beq le319
          lda $85
          ldy $86
          sta $81
          sty $82
          lda $7b
          sta $a6
          adc $5d
          sta $a4
          ldy $7c
          sty $a7
          bcc le301
          iny
le301:    sty $a5
          jsr le1cf
          lda $7f
          ldy $80
          sta $7b
          sty $7c
          ldy $5d
          dey
le311:    lda $000f,y
          sta ($aa),y
          dey
          bpl le311
le319:    jsr le477
          lda $79
          ldy $7a
          sta $71
          sty $72
          clc
le325:    ldy #$01
          lda ($71),y
          bne le32e
          jmp le27d
le32e:    ldy #$04
le330:    iny
          lda ($71),y
          bne le330
          iny
          tya
          adc $71
          tax
          ldy #$00
          sta ($71),y
          lda $72
          adc #$00
          iny
          sta ($71),y
          stx $71
          sta $72
          bcc le325
le34b:    jsr le8d9
          dex
          bpl le359
le351:    jsr le8d9
          jsr le860
le357:    ldx #$00
le359:    jsr le386
          cmp #$07
          beq le374
          cmp #$0d
          beq le383
          cmp #$08
          beq le34b
          cmp #$20
          bcc le359
          cmp #$7d
          bcs le359
          cmp #$40
          beq le351
le374:    cpx #$47
          bcs le37c
          sta $13,x
          inx
          bit $07a9
          jsr le8d9
          bne le359
le383:    jmp le85a
le386:    jsr lff39
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          nop
          and #$7f
          cmp #$0f
          bne le3a5
          pha
          lda $64
          eor #$ff
          sta $64
          pla
le3a5:    rts
le3a6:    ldx $c3
          ldy #$04
          sty $60
le3ac:    lda $00,x
          cmp #$20
          beq le3ec
          sta $5c
          cmp #$22
          beq le410
          bit $60
          bvs le3ec
          cmp #$3f
          bne le3c4
          lda #$97
          bne le3ec
le3c4:    cmp #$30
          bcc le3cc
          cmp #$3c
          bcc le3ec
le3cc:    sty $ba
          ldy #$00
          sty $5d
          dey
          stx $c3
          dex
le3d6:    iny
le3d7:    inx
le3d8:    lda $00,x
          cmp #$20
          beq le3d7
          sec
          sbc $e084,y
          beq le3d6
          cmp #$80
          bne le417
          ora $5d
le3ea:    ldy $ba
le3ec:    inx
          iny
          sta $000e,y
          lda $000e,y
          beq le42a
          sec
          sbc #$3a
          beq le3ff
          cmp #$49
          bne le401
le3ff:    sta $60
le401:    sec
          sbc #$54
          bne le3ac
          sta $5c
le408:    lda $00,x
          beq le3ec
          cmp $5c
          beq le3ec
le410:    iny
          sta $000e,y
          inx
          bne le408
le417:    ldx $c3
          inc $5d
le41b:    iny
          lda $e083,y
          bpl le41b
          lda $e084,y
          bne le3d8
          lda $00,x
          bpl le3ea
le42a:    sta $0010,y
          lda #$12
          sta $c3
          rts
le432:    lda $79
          ldx $7a
le436:    ldy #$01
          sta $aa
          stx $ab
          lda ($aa),y
          beq le45f
          iny
          iny
          lda $12
          cmp ($aa),y
          bcc le460
          beq le44d
          dey
          bne le456
le44d:    lda $11
          dey
          cmp ($aa),y
          bcc le460
          beq le460
le456:    dey
          lda ($aa),y
          tax
          dey
          lda ($aa),y
          bcs le436
le45f:    clc
le460:    rts
          bne le460
le463:    lda #$00
          tay
          sta ($79),y
          iny
          sta ($79),y
          lda $79
          adc #$02
          sta $7b
          lda $7a
          adc #$00
          sta $7c
le477:    jsr le4a7
le47a:    lda $85
          ldy $86
          sta $81
          sty $82
          lda $7b
          ldy $7c
          sta $7d
          sty $7e
          sta $7f
          sty $80
          jsr le61a
le491:    ldx #$68
          stx $65
          pla
          sta $01fd
          pla
          sta $01fe
          ldx #$fc
          txs
          lda #$00
          sta $8c
          sta $61
le4a6:    rts
le4a7:    clc
          lda $79
          adc #$ff
          sta $c3
          lda $7a
          adc #$ff
          sta $c4
          rts
          bcc le4bd
          beq le4bd
          cmp #$a4
          bne le4a6
le4bd:    jsr le773
          jsr le432
          jsr $00c2
          beq le4d4
          cmp #$a4
          bne le460
          jsr $00bc
          jsr le773
          bne le460
le4d4:    pla
          pla
          lda $11
          ora $12
          bne le4e2
          lda #$ff
          sta $11
          sta $12
le4e2:    ldy #$01
          sty $60
          lda ($aa),y
          beq le52b
          jsr le629
          jsr le860
          iny
          lda ($aa),y
          tax
          iny
          lda ($aa),y
          cmp $12
          bne le4ff
          cpx $11
          beq le501
le4ff:    bcs le52b
le501:    sty $97
          jsr lf952
          lda #$20
le508:    ldy $97
          and #$7f
le50c:    jsr le8d9
          cmp #$22
          bne le519
          lda $60
          eor #$ff
          sta $60
le519:    iny
          lda ($aa),y
          bne le52e
          tay
          lda ($aa),y
          tax
          iny
          lda ($aa),y
          stx $aa
          sta $ab
          bne le4e2
le52b:    jmp le274
le52e:    bpl le50c
          cmp #$ff
          beq le50c
          bit $60
          bmi le50c
          sec
          sbc #$7f
          tax
          sty $97
          ldy #$ff
le540:    dex
          beq le54b
le543:    iny
          lda $e084,y
          bpl le543
          bmi le540
le54b:    iny
          lda $e084,y
          bmi le508
          jsr le8d9
          bne le54b
          lda #$80
          sta $61
          jsr le7ad
          jsr le1a1
          bne le567
          txa
          adc #$0d
          tax
          txs
le567:    pla
          pla
          lda #$08
          jsr le212
          jsr le70e
          clc
          tya
          adc $c3
          pha
          lda $c4
          adc #$00
          pha
          lda $88
          pha
          lda $87
          pha
          lda #$9d
          jsr lebf7
          jsr leaa4
          jsr leaa1
          lda $b0
          ora #$7f
          and $ad
          sta $ad
          lda #$9f
          ldy #$e5
          sta $71
          sty $72
          jmp leb5a
          lda #$90
          ldy #$f5
          jsr lf73f
          jsr $00c2
          cmp #$a2
          bne le5b3
          jsr $00bc
          jsr leaa1
le5b3:    jsr lf7be
          jsr leb4f
          lda $98
          pha
          lda $97
          pha
          lda #$81
          pha
le5c2:    jsr le629
          lda $c3
          ldy $c4
          beq le5d1
          sta $8b
          sty $8c
          ldy #$00
le5d1:    lda ($c3),y
          beq le5dc
          cmp #$3a
          beq le5f6
le5d9:    jmp lec00
le5dc:    ldy #$02
          lda ($c3),y
          clc
          beq le645
          iny
          lda ($c3),y
          sta $87
          iny
          lda ($c3),y
          sta $88
          tya
          adc $c3
          sta $c3
          bcc le5f6
          inc $c4
le5f6:    jsr $00bc
          jsr le5ff
          jmp le5c2
le5ff:    beq le66e
          sec
le602:    sbc #$80
          bcs le609
          jmp le7ad
le609:    cmp #$1c
          bcs le5d9
          asl a
          tay
          lda $e001,y
          pha
          lda $e000,y
          pha
          jmp $00bc
le61a:    sec
          lda $79
          sbc #$01
          ldy $7a
          bcs le624
          dey
le624:    sta $8f
          sty $90
          rts
le629:    jsr lff49
          bcs le62f
          clc
le62f:    bne le66e
          lda $c3
          ldy $c4
          beq le643
          sta $8b
          sty $8c
le63b:    lda $87
          ldy $88
          sta $89
          sty $8a
le643:    pla
          pla
le645:    lda #$99
          ldy #$e1
          ldx #$00
          stx $64
          bcc le652
          jmp le269
le652:    jmp le274
          bne le66e
          ldx #$1e
          ldy $8c
          bne le660
          jmp le24e
le660:    lda $8b
          sta $c3
          sty $c4
          lda $89
          ldy $8a
          sta $87
          sty $88
le66e:    rts
          jsr lf3a2
          bne le66e
          inx
          cpx #$0a
          bcs le67d
          dex
          stx $0d
          rts
le67d:    jmp lee7c
          bne le66e
          jmp le47a
          bne le68a
          jmp le477
le68a:    jsr le47a
          jmp le6a4
          lda #$03
          jsr le212
          lda $c4
          pha
          lda $c3
          pha
          lda $88
          pha
          lda $87
          pha
          lda #$8c
          pha
le6a4:    jsr $00c2
          jsr le6ad
          jmp le5c2
le6ad:    jsr le773
          jsr le711
          lda $88
          cmp $12
          bcs le6c4
          tya
          sec
          adc $c3
          ldx $c4
          bcc le6c8
          inx
          bcs le6c8
le6c4:    lda $79
          ldx $7a
le6c8:    jsr le436
          bcc le6eb
          lda $aa
          sbc #$01
          sta $c3
          lda $ab
          sbc #$00
          sta $c4
le6d9:    rts
          bne le6d9
          lda #$ff
          sta $97
          jsr le1a1
          txs
          cmp #$8c
          beq le6f3
          ldx #$04
          bit $0ea2
          jmp le24e
le6f0:    jmp lec00
le6f3:    pla
          pla
          sta $87
          pla
          sta $88
          pla
          sta $c3
          pla
          sta $c4
le700:    jsr le70e
le703:    tya
          clc
          adc $c3
          sta $c3
          bcc le70d
          inc $c4
le70d:    rts
le70e:    ldx #$3a
          bit $00a2
          stx $5b
          ldy #$00
          sty $5c
le719:    lda $5c
          ldx $5b
          sta $5b
          stx $5c
le721:    lda ($c3),y
          beq le70d
          cmp $5c
          beq le70d
          iny
          cmp #$22
          beq le719
          bne le721
          jsr leab5
          jsr $00c2
          cmp #$88
          beq le73f
          lda #$a0
          jsr lebf7
le73f:    lda $ac
          bne le748
          jsr le711
          beq le703
le748:    jsr $00c2
          bcs le750
          jmp le6ad
le750:    jmp le5ff
          jsr lf3a2
          pha
          cmp #$8c
          beq le75f
le75b:    cmp #$88
          bne le6f0
le75f:    dec $af
          bne le767
          pla
          jmp le602
le767:    jsr $00bc
          jsr le773
          cmp #$2c
          beq le75f
          pla
le772:    rts
le773:    ldx #$00
          stx $11
          stx $12
le779:    bcs le772
          sbc #$2f
          sta $5b
          lda $12
          sta $71
          cmp #$19
          bcs le75b
          lda $11
          asl a
          rol $71
          asl a
          rol $71
          adc $11
          sta $11
          lda $71
          adc $12
          sta $12
          asl $11
          rol $12
          lda $11
          adc $5b
          sta $11
          bcc le7a7
          inc $12
le7a7:    jsr $00bc
          jmp le779
le7ad:    jsr lecff
          sta $97
          sty $98
          lda #$ab
          jsr lebf7
          lda $5f
          pha
          jsr leab5
          pla
          rol a
          jsr leaa7
          bne le7c9
          jmp lf768
le7c9:    ldy #$02
          lda ($ae),y
          cmp $82
          bcc le7e8
          bne le7da
          dey
          lda ($ae),y
          cmp $81
          bcc le7e8
le7da:    ldy $af
          cpy $7c
          bcc le7e8
          bne le7ef
          lda $ae
          cmp $7b
          bcs le7ef
le7e8:    lda $ae
          ldy $af
          jmp le805
le7ef:    ldy #$00
          lda ($ae),y
          jsr lf090
          lda $9e
          ldy $9f
          sta $b8
          sty $b9
          jsr lf27e
          lda #$ac
          ldy #$00
le805:    sta $9e
          sty $9f
          jsr lf2df
          ldy #$00
          lda ($9e),y
          sta ($97),y
          iny
          lda ($9e),y
          sta ($97),y
          iny
          lda ($9e),y
          sta ($97),y
          rts
le81d:    jsr le8ba
le820:    jsr $00c2
          beq le860
le825:    beq le87e
          cmp #$9c
          beq le896
          cmp #$9f
          beq le896
          cmp #$2c
          beq le87f
          cmp #$3b
          beq le8b1
          jsr leab5
          bit $5f
          bmi le81d
          jsr lf962
          jsr lf0a2
          ldy #$00
          lda ($ae),y
          clc
          adc $0e
          cmp $0f
          bcc le852
          jsr le860
le852:    jsr le8ba
          jsr le8d4
          bne le820
le85a:    ldy #$00
          sty $13,x
          ldx #$12
le860:    lda #$0d
          sta $0e
          jsr le8d9
          lda #$0a
          jsr le8d9
le86c:    txa
          pha
          ldx $0d
          beq le87a
          lda #$00
le874:    jsr le8d9
          dex
          bne le874
le87a:    stx $0e
          pla
          tax
le87e:    rts
le87f:    lda $0e
          cmp $10
          bcc le88b
          jsr le860
          jmp le8b1
le88b:    sec
le88c:    sbc #$0e
          bcs le88c
          eor #$ff
          adc #$01
          bne le8aa
le896:    pha
          jsr lf39f
          cmp #$29
          bne le904
          pla
          cmp #$9c
          bne le8ab
          txa
          sbc $0e
          bcc le8b1
          beq le8b1
le8aa:    tax
le8ab:    jsr le8d4
          dex
          bne le8ab
le8b1:    jsr $00bc
          jmp le825
le8b7:    jsr lf0a2
le8ba:    jsr lf2aa
          tax
          ldy #$00
          inx
le8c1:    dex
          beq le87e
          lda ($71),y
          jsr le8d9
          iny
          cmp #$0d
          bne le8c1
          jsr le86c
          jmp le8c1
le8d4:    lda #$20
          bit $3fa9
le8d9:    bit $64
          bmi le8f5
          pha
          cmp #$20
          bcc le8ed
          lda $0e
          cmp $0f
          bne le8eb
          jsr le860
le8eb:    inc $0e
le8ed:    pla
          jsr lff2a
          nop
          nop
          nop
          nop
le8f5:    and #$ff
          rts
le8f8:    lda $62
          beq le907
          lda $8d
          ldy $8e
          sta $87
          sty $88
le904:    jmp lec00
le907:    lda #$21
          ldy #$ea
          jsr le8b7
          lda $8b
          ldy $8c
          sta $c3
          sty $c4
          rts
          lsr $64
          cmp #$22
          bne le928
          jsr lebb5
          lda #$3b
          jsr lebf7
          jsr le8ba
le928:    jsr lefc8
          lda #$2c
          sta $12
          jsr le93a
          lda $13
          bne le948
          clc
          jmp le63b
le93a:    jsr le8d7
          jsr le8d4
          jmp le357
          ldx $8f
          ldy $90
          lda #$98
          sta $62
          stx $91
          sty $92
le94f:    jsr lecff
          sta $97
          sty $98
          lda $c3
          ldy $c4
          sta $11
          sty $12
          ldx $91
          ldy $92
          stx $c3
          sty $c4
          jsr $00c2
          bne le979
          bit $62
          bmi le9d1
          jsr le8d7
          jsr le93a
          stx $c3
          sty $c4
le979:    jsr $00bc
          bit $5f
          bpl le9a4
          sta $5b
          cmp #$22
          beq le98d
          lda #$3a
          sta $5b
          lda #$2c
          clc
le98d:    sta $5c
          lda $c3
          ldy $c4
          adc #$00
          bcc le998
          iny
le998:    jsr lf0a8
          jsr lf3e7
          jsr le7c9
          jmp le9aa
le9a4:    jsr lf87b
          jsr lf768
le9aa:    jsr $00c2
          beq le9b6
          cmp #$2c
          beq le9b6
          jmp le8f8
le9b6:    lda $c3
          ldy $c4
          sta $91
          sty $92
          lda $11
          ldy $12
          sta $c3
          sty $c4
          jsr $00c2
          beq le9f7
          jsr lebf5
          jmp le94f
le9d1:    jsr le70e
          iny
          tax
          bne le9ea
          ldx #$06
          iny
          lda ($c3),y
          beq lea48
          iny
          lda ($c3),y
          sta $8d
          iny
          lda ($c3),y
          iny
          sta $8e
le9ea:    lda ($c3),y
          tax
          jsr le703
          cpx #$83
          bne le9d1
          jmp le979
le9f7:    lda $91
          ldy $92
          ldx $62
          beq lea02
          jmp le624
lea02:    ldy #$00
          lda ($91),y
          beq lea0f
          lda #$10
          ldy #$ea
          jmp le8b7
lea0f:    rts
          ???             //    %00111111 '?'
          eor $58
          ???             //    %01010100 'T'
          ???             //    %01010010 'R'
          eor ($20,x)
          eor #$47
          lsr $524f
          eor $44
          ora $000a
          ???             //    %00111111 '?'
          ???             //    %01010010 'R'
          eor $44
          ???             //    %01001111 'O'
          jsr $5246
          ???             //    %01001111 'O'
          eor $5320
          ???             //    %01010100 'T'
          eor ($52,x)
          ???             //    %01010100 'T'
          ora $000a
          bne lea3a
          ldy #$00
          beq lea3d
lea3a:    jsr lecff
lea3d:    sta $97
          sty $98
          jsr le1a1
          beq lea4a
          ldx #$00
lea48:    beq leab2
lea4a:    txs
          inx
          inx
          inx
          inx
          txa
          inx
          inx
          inx
          inx
          inx
          stx $73
          ldy #$01
          jsr lf73f
          tsx
          lda $0108,x
          sta $b0
          lda $97
          ldy $98
          jsr lf460
          jsr lf768
          ldy #$01
          jsr lf7ee
          tsx
          sec
          sbc $0108,x
          beq lea8f
          lda $010d,x
          sta $87
          lda $010e,x
          sta $88
          lda $0110,x
          sta $c3
          lda $010f,x
          sta $c4
lea8c:    jmp le5c2
lea8f:    txa
          adc #$0f
          tax
          txs
          jsr $00c2
          cmp #$2c
          bne lea8c
          jsr $00bc
          jsr lea3a
leaa1:    jsr leab5
leaa4:    clc
          bit $38
leaa7:    bit $5f
          bmi leaae
          bcs leab0
leaad:    rts
leaae:    bcs leaad
leab0:    ldx #$18
leab2:    jmp le24e
leab5:    ldx $c3
          bne leabb
          dec $c4
leabb:    dec $c3
          ldx #$00
          bit $48
          txa
          pha
          lda #$01
          jsr le212
          jsr leb94
          lda #$00
          sta $9b
leacf:    jsr $00c2
lead2:    sec
          sbc #$aa
          bcc leaee
          cmp #$03
          bcs leaee
          cmp #$01
          rol a
          eor #$01
          eor $9b
          cmp $9b
          bcc leb47
          sta $9b
          jsr $00bc
          jmp lead2
leaee:    ldx $9b
          bne leb1e
          bcs leb6c
          adc #$07
          bcc leb6c
          adc $5f
          bne leaff
          jmp lf241
leaff:    adc #$ff
          sta $71
          asl a
          adc $71
          tay
leb07:    pla
          cmp $e066,y
          bcs leb71
          jsr leaa4
leb10:    pha
leb11:    jsr leb37
          pla
          ldy $99
          bpl leb30
          tax
          beq leb6f
          bne leb7a
leb1e:    lsr $5f
          txa
          rol a
          ldx $c3
          bne leb28
          dec $c4
leb28:    dec $c3
          ldy #$1b
          sta $9b
          bne leb07
leb30:    cmp $e066,y
          bcs leb7a
          bcc leb10
leb37:    lda $e068,y
          pha
          lda $e067,y
          pha
          jsr leb4a
          lda $9b
          jmp leac0
leb47:    jmp lec00
leb4a:    lda $b0
          ldx $e066,y
leb4f:    tay
          pla
          sta $71
          inc $71
          pla
          sta $72
          tya
          pha
leb5a:    jsr lf7ae
          lda $af
          pha
          lda $ae
          pha
          lda $ad
          pha
          lda $ac
          pha
          jmp ($0071)
leb6c:    ldy #$ff
          pla
leb6f:    beq leb91
leb71:    cmp #$64
          beq leb78
          jsr leaa4
leb78:    sty $99
leb7a:    pla
          lsr a
          sta $63
          pla
          sta $b3
          pla
          sta $b4
          pla
          sta $b5
          pla
          sta $b6
          pla
          sta $b7
          eor $b0
          sta $b8
leb91:    lda $ac
          rts
leb94:    lda #$00
          sta $5f
leb98:    jsr $00bc
          bcs leba0
leb9d:    jmp lf87b
leba0:    jsr led75
          bcs lec0c
          cmp #$2e
          beq leb9d
          cmp #$a4
          beq lec05
          cmp #$a3
          beq leb98
          cmp #$22
          bne lebc4
lebb5:    lda $c3
          ldy $c4
          adc #$00
          bcc lebbe
          iny
lebbe:    jsr lf0a2
          jmp lf3e7
lebc4:    cmp #$a1
          bne lebdb
          ldy #$18
          bne lec07
          jsr ledf9
          lda $af
          eor #$ff
          tay
          lda $ae
          eor #$ff
          jmp lefb5
lebdb:    cmp #$9e
          bne lebe2
          jmp lf012
lebe2:    cmp #$ad
          bcc lebe9
          jmp lec1b
lebe9:    jsr lebf2
          jsr leab5
lebef:    lda #$29
          bit $28a9
          bit $2ca9
lebf7:    ldy #$00
          cmp ($c3),y
          bne lec00
          jmp $00bc
lec00:    ldx #$02
          jmp le24e
lec05:    ldy #$15
lec07:    pla
          pla
          jmp leb11
lec0c:    jsr lecff
          sta $ae
          sty $af
          ldx $5f
          beq lec18
          rts
lec18:    jmp lf73f
lec1b:    asl a
          pha
          tax
          jsr $00bc
          cpx #$81
          bcc lec45
          jsr lebf2
          jsr leab5
          jsr lebf5
          jsr leaa6
          pla
          tax
          lda $af
          pha
          lda $ae
          pha
          txa
          pha
          jsr lf3a2
          pla
          tay
          txa
          pha
          jmp lec4a
lec45:    jsr lebe9
          pla
          tay
lec4a:    lda $dfde,y
          sta $a2
          lda $dfdf,y
          sta $a3
          jsr $00a1
          jmp leaa4
          ldy #$ff
          bit $00a0
          sty $5d
          jsr ledf9
          lda $ae
          eor $5d
          sta $5b
          lda $af
          eor $5d
          sta $5c
          jsr lf78f
          jsr ledf9
          lda $af
          eor $5d
          and $5c
          eor $5d
          tay
          lda $ae
          eor $5d
          and $5b
          eor $5d
          jmp lefb5
          jsr leaa7
          bcs leca2
          lda $b7
          ora #$7f
          and $b4
          sta $b4
          lda #$b3
          ldy #$00
          jsr lf7ec
          tax
          jmp lecd5
leca2:    lda #$00
          sta $5f
          dec $9b
          jsr lf2aa
          sta $ac
          stx $ad
          sty $ae
          lda $b5
          ldy $b6
          jsr lf2ae
          stx $b5
          sty $b6
          tax
          sec
          sbc $ac
          beq lecca
          lda #$01
          bcc lecca
          ldx $ac
          lda #$ff
lecca:    sta $b0
          ldy #$ff
          inx
leccf:    iny
          dex
          bne lecda
          ldx $b0
lecd5:    bmi lece6
          clc
          bcc lece6
lecda:    lda ($b5),y
          cmp ($ad),y
          beq leccf
          ldx #$ff
          bcs lece6
          ldx #$01
lece6:    inx
          txa
          rol a
          and $63
          beq lecef
          lda #$ff
lecef:    jmp lf7cf
lecf2:    jsr lebf5
          tax
          jsr led04
          jsr $00c2
          bne lecf2
          rts
lecff:    ldx #$00
          jsr $00c2
led04:    stx $5e
led06:    sta $93
          jsr $00c2
          jsr led75
          bcs led13
          jmp lec00
led13:    ldx #$00
          stx $5f
          jsr $00bc
          bcc led21
          jsr led75
          bcc led2c
led21:    tax
led22:    jsr $00bc
          bcc led22
          jsr led75
          bcs led22
led2c:    cmp #$24
          bne led3b
          lda #$ff
          sta $5f
          txa
          ora #$80
          tax
          jsr $00bc
led3b:    stx $94
          sec
          ora $61
          sbc #$28
          bne led47
          jmp lee0b
led47:    lda #$00
          sta $61
          lda $7b
          ldx $7c
          ldy #$00
led51:    stx $ab
led53:    sta $aa
          cpx $7e
          bne led5d
          cmp $7d
          beq led7f
led5d:    lda $93
          cmp ($aa),y
          bne led6b
          lda $94
          iny
          cmp ($aa),y
          beq ledcb
          dey
led6b:    clc
          lda $aa
          adc #$06
          bcc led53
          inx
          bne led51
led75:    cmp #$41
          bcc led7e
          sbc #$5b
          sec
          sbc #$a5
led7e:    rts
led7f:    pla
          pha
          cmp #$0e
          bne led8c
          lda #$8a
          ldy #$ed
          rts
          brk
          brk
led8c:    lda $7d
          ldy $7e
          sta $aa
          sty $ab
          lda $7f
          ldy $80
          sta $a6
          sty $a7
          clc
          adc #$06
          bcc leda2
          iny
leda2:    sta $a4
          sty $a5
          jsr le1cf
          lda $a4
          ldy $a5
          iny
          sta $7d
          sty $7e
          ldy #$00
          lda $93
          sta ($aa),y
          iny
          lda $94
          sta ($aa),y
          lda #$00
          iny
          sta ($aa),y
          iny
          sta ($aa),y
          iny
          sta ($aa),y
          iny
          sta ($aa),y
ledcb:    lda $aa
          clc
          adc #$02
          ldy $ab
          bcc ledd5
          iny
ledd5:    sta $95
          sty $96
          rts
ledda:    lda $5d
          asl a
          adc #$05
          adc $aa
          ldy $ab
          bcc lede6
          iny
lede6:    sta $a4
          sty $a5
          rts
          bcc led6d
          brk
          brk
ledef:    jsr $00bc
          jsr leaa1
ledf5:    lda $b0
          bmi lee06
ledf9:    lda $ac
          cmp #$90
          bcc lee08
          lda #$eb
          ldy #$ed
          jsr lf7ec
lee06:    bne lee7c
lee08:    jmp lf825
lee0b:    lda $5e
          pha
          lda $5f
          pha
          ldy #$00
lee13:    tya
          pha
          lda $94
          pha
          lda $93
          pha
          jsr ledef
          pla
          sta $93
          pla
          sta $94
          pla
          tay
          tsx
          lda $0102,x
          pha
          lda $0101,x
          pha
          lda $ae
          sta $0102,x
          lda $af
          sta $0101,x
          iny
          jsr $00c2
          cmp #$2c
          beq lee13
          sty $5d
          jsr lebef
          pla
          sta $5f
          pla
          sta $5e
          ldx $7d
          lda $7e
lee50:    stx $aa
          sta $ab
          cmp $80
          bne lee5c
          cpx $7f
          beq lee95
lee5c:    ldy #$00
          lda ($aa),y
          iny
          cmp $93
          bne lee6b
          lda $94
          cmp ($aa),y
          beq lee81
lee6b:    iny
          lda ($aa),y
          clc
          adc $aa
          tax
          iny
          lda ($aa),y
          adc $ab
          bcc lee50
lee79:    ldx #$10
          bit $08a2
lee7e:    jmp le24e
lee81:    ldx #$12
          lda $5e
          bne lee7e
          jsr ledda
          lda $5d
          ldy #$04
          cmp ($aa),y
          bne lee79
          jmp lef18
lee95:    jsr ledda
          jsr le21f
          lda #$00
          tay
          sta $bb
          ldx #$04
          stx $ba
          lda $93
          sta ($aa),y
          iny
          lda $94
          sta ($aa),y
          lda $5d
          iny
          iny
          iny
          sta ($aa),y
leeb4:    ldx #$0b
          lda #$00
          bit $5e
          bvc leec4
          pla
          clc
          adc #$01
          tax
          pla
          adc #$00
leec4:    iny
          sta ($aa),y
          iny
          txa
          sta ($aa),y
          jsr lef70
          stx $ba
          sta $bb
          ldy $71
          dec $5d
          bne leeb4
          adc $a5
          bcs lef39
          sta $a5
          tay
          txa
          adc $a4
          bcc leee7
          iny
          beq lef39
leee7:    jsr le21f
          sta $7f
          sty $80
          lda #$00
          inc $bb
          ldy $ba
          beq leefb
leef6:    dey
          sta ($a4),y
          bne leef6
leefb:    dec $a5
          dec $bb
          bne leef6
          inc $a5
          sec
          lda $7f
          sbc $aa
          ldy #$02
          sta ($aa),y
          lda $80
          iny
          sbc $ab
          sta ($aa),y
          lda $5e
          bne lef6f
          iny
lef18:    lda ($aa),y
          sta $5d
          lda #$00
          sta $ba
lef20:    sta $bb
          iny
          pla
          tax
          sta $ae
          pla
          sta $af
          cmp ($aa),y
          bcc lef3c
          bne lef36
          iny
          txa
          cmp ($aa),y
          bcc lef3d
lef36:    jmp lee79
lef39:    jmp le24c
lef3c:    iny
lef3d:    lda $bb
          ora $ba
          clc
          beq lef4e
          jsr lef70
          txa
          adc $ae
          tax
          tya
          ldy $71
lef4e:    adc $af
          stx $ba
          dec $5d
          bne lef20
          asl $ba
          rol a
          bcs lef36
          asl $ba
          rol a
          bcs lef36
          tay
          lda $ba
          adc $a4
          sta $95
          tya
          adc $a5
          sta $96
          tay
          lda $95
lef6f:    rts
lef70:    sty $71
          lda ($aa),y
          sta $76
          dey
          lda ($aa),y
          sta $77
          lda #$10
          sta $a8
          ldx #$00
          ldy #$00
lef83:    txa
          asl a
          tax
          tya
          rol a
          tay
          bcs lef39
          asl $ba
          rol $bb
          bcc lef9c
          clc
          txa
          adc $76
          tax
          tya
          adc $77
          tay
          bcs lef39
lef9c:    dec $a8
          bne lef83
          rts
          lda $5f
          beq lefa8
          jsr lf2aa
lefa8:    jsr lf13b
          sec
          lda $81
          sbc $7f
          tay
          lda $82
          sbc $80
lefb5:    ldx #$00
          stx $5f
          sta $ad
          sty $ae
          ldx #$90
          jmp lf7d7
          ldy $0e
lefc4:    lda #$00
          beq lefb5
lefc8:    ldx $88
          inx
          bne lef6f
          ldx #$16
lefcf:    jmp le24e
          jsr lefff
          jsr lefc8
          jsr lebf2
          lda #$80
          sta $61
          jsr lecff
          jsr leaa4
          jsr lebef
          lda #$ab
          jsr lebf7
          lda $96
          pha
          lda $95
          pha
          lda $c4
          pha
          lda $c3
          pha
          jsr le700
          jmp lf06e
lefff:    lda #$9e
          jsr lebf7
          ora #$80
          sta $61
          jsr led06
          sta $9c
          sty $9d
          jmp leaa4
lf012:    jsr lefff
          lda $9d
          pha
          lda $9c
          pha
          jsr lebe9
          jsr leaa4
          pla
          sta $9c
          pla
          sta $9d
          ldy #$02
          ldx #$20
          lda ($9c),y
          beq lefcf
          sta $95
          tax
          iny
          lda ($9c),y
          sta $96
lf037:    lda ($95),y
          pha
          dey
          bpl lf037
          ldy $96
          jsr lf76c
          lda $c4
          pha
          lda $c3
          pha
          lda ($9c),y
          sta $c3
          iny
          lda ($9c),y
          sta $c4
          lda $96
          pha
          lda $95
          pha
          jsr leaa1
          pla
          sta $9c
          pla
          sta $9d
          jsr $00c2
          beq lf068
          jmp lec00
lf068:    pla
          sta $c3
          pla
          sta $c4
lf06e:    ldy #$00
          pla
          sta ($9c),y
          pla
          iny
          sta ($9c),y
          pla
          iny
          sta ($9c),y
          pla
          iny
          sta ($9c),y
          rts
          jsr leaa4
          ldy #$00
          jsr lf964
          pla
          pla
          lda #$ff
          ldy #$00
          beq lf0a2
lf090:    ldx $ae
          ldy $af
          stx $9e
          sty $9f
lf098:    jsr lf109
          stx $ad
          sty $ae
          sta $ac
          rts
lf0a2:    ldx #$22
          stx $5b
          stx $5c
lf0a8:    sta $b8
          sty $b9
          sta $ad
          sty $ae
          ldy #$ff
lf0b2:    iny
          lda ($b8),y
          beq lf0c3
          cmp $5b
          beq lf0bf
          cmp $5c
          bne lf0b2
lf0bf:    cmp #$22
          beq lf0c4
lf0c3:    clc
lf0c4:    sty $ac
          tya
          adc $b8
          sta $ba
          ldx $b9
          bcc lf0d0
          inx
lf0d0:    stx $bb
          lda $b9
          bne lf0e1
          tya
          jsr lf090
          ldx $b8
          ldy $b9
          jsr lf28c
lf0e1:    ldx $65
          cpx #$71
          bne lf0ec
          ldx #$1c
lf0e9:    jmp le24e
lf0ec:    lda $ac
          sta $00,x
          lda $ad
          sta $01,x
          lda $ae
          sta $02,x
          ldy #$00
          stx $ae
          sty $af
          dey
          sty $5f
          stx $66
          inx
          inx
          inx
          stx $65
          rts
lf109:    lsr $60
lf10b:    pha
          eor #$ff
          sec
          adc $81
          ldy $82
          bcs lf116
          dey
lf116:    cpy $80
          bcc lf12b
          bne lf120
          cmp $7f
          bcc lf12b
lf120:    sta $81
          sty $82
          sta $83
          sty $84
          tax
          pla
          rts
lf12b:    ldx #$0c
          lda $60
          bmi lf0e9
          jsr lf13b
          lda #$80
          sta $60
          pla
          bne lf10b
lf13b:    ldx $85
          lda $86
lf13f:    stx $81
          sta $82
          ldy #$00
          sty $9d
          lda $7f
          ldx $80
          sta $aa
          stx $ab
          lda #$68
          ldx #$00
          sta $71
          stx $72
lf157:    cmp $65
          beq lf160
          jsr lf1cd
          beq lf157
lf160:    lda #$06
          sta $a0
          lda $7b
          ldx $7c
          sta $71
          stx $72
lf16c:    cpx $7e
          bne lf174
          cmp $7d
          beq lf179
lf174:    jsr lf1c7
          beq lf16c
lf179:    sta $a4
          stx $a5
          lda #$03
          sta $a0
lf181:    lda $a4
          ldx $a5
lf185:    cpx $80
          bne lf190
          cmp $7f
          bne lf190
          jmp lf20c
lf190:    sta $71
          stx $72
          ldy #$01
          lda ($71),y
          php
          iny
          lda ($71),y
          adc $a4
          sta $a4
          iny
          lda ($71),y
          adc $a5
          sta $a5
          plp
          bpl lf181
          iny
          lda ($71),y
          asl a
          adc #$05
          adc $71
          sta $71
          bcc lf1b8
          inc $72
lf1b8:    ldx $72
lf1ba:    cpx $a5
          bne lf1c2
          cmp $a4
          beq lf185
lf1c2:    jsr lf1cd
          beq lf1ba
lf1c7:    iny
          lda ($71),y
          bpl lf1fc
          iny
lf1cd:    lda ($71),y
          beq lf1fc
          iny
          lda ($71),y
          tax
          iny
          lda ($71),y
          cmp $82
          bcc lf1e2
          bne lf1fc
          cpx $81
          bcs lf1fc
lf1e2:    cmp $ab
          bcc lf1fc
          bne lf1ec
          cpx $aa
          bcc lf1fc
lf1ec:    stx $aa
          sta $ab
          lda $71
          ldx $72
          sta $9c
          stx $9d
          lda $a0
          sta $a2
lf1fc:    lda $a0
          clc
          adc $71
          sta $71
          bcc lf207
          inc $72
lf207:    ldx $72
          ldy #$00
          rts
lf20c:    ldx $9d
          beq lf207
          lda $a2
          and #$04
          lsr a
          tay
          sta $a2
          lda ($9c),y
          adc $aa
          sta $a6
          lda $ab
          adc #$00
          sta $a7
          lda $81
          ldx $82
          sta $a4
          stx $a5
          jsr le1d6
          ldy $a2
          iny
          lda $a4
          sta ($9c),y
          tax
          inc $a5
          lda $a5
          iny
          sta ($9c),y
          jmp lf13f
lf241:    lda $af
          pha
          lda $ae
          pha
          jsr leb94
          jsr leaa6
          pla
          sta $b8
          pla
          sta $b9
          ldy #$00
          lda ($b8),y
          clc
          adc ($ae),y
          bcc lf261
          ldx #$1a
          jmp le24e
lf261:    jsr lf090
          jsr lf27e
          lda $9e
          ldy $9f
          jsr lf2ae
          jsr lf290
          lda $b8
          ldy $b9
          jsr lf2ae
          jsr lf0e1
          jmp leacf
lf27e:    ldy #$00
          lda ($b8),y
          pha
          iny
          lda ($b8),y
          tax
          iny
          lda ($b8),y
          tay
          pla
lf28c:    stx $71
          sty $72
lf290:    tay
          beq lf29d
          pha
lf294:    dey
          lda ($71),y
          sta ($83),y
          tya
          bne lf294
          pla
lf29d:    clc
          adc $83
          sta $83
          bcc lf2a6
          inc $84
lf2a6:    rts
lf2a7:    jsr leaa6
lf2aa:    lda $ae
          ldy $af
lf2ae:    sta $71
          sty $72
          jsr lf2df
          php
          ldy #$00
          lda ($71),y
          pha
          iny
          lda ($71),y
          tax
          iny
          lda ($71),y
          tay
          pla
          plp
          bne lf2da
          cpy $82
          bne lf2da
          cpx $81
          bne lf2da
          pha
          clc
          adc $81
          sta $81
          bcc lf2d9
          inc $82
lf2d9:    pla
lf2da:    stx $71
          sty $72
          rts
lf2df:    cpy $67
          bne lf2ef
          cmp $66
          bne lf2ef
          sta $65
          sbc #$03
          sta $66
          ldy #$00
lf2ef:    rts
          jsr lf3a5
          txa
          pha
          lda #$01
          jsr lf098
          pla
          ldy #$00
          sta ($ad),y
          pla
          pla
          jmp lf0e1
          jsr lf363
          cmp ($9e),y
          tya
lf30a:    bcc lf310
          lda ($9e),y
          tax
          tya
lf310:    pha
lf311:    txa
lf312:    pha
          jsr lf098
          lda $9e
          ldy $9f
          jsr lf2ae
          pla
          tay
          pla
          clc
          adc $71
          sta $71
          bcc lf329
          inc $72
lf329:    tya
          jsr lf290
          jmp lf0e1
          jsr lf363
          clc
          sbc ($9e),y
          eor #$ff
          jmp lf30a
          lda #$ff
          sta $af
          jsr $00c2
          cmp #$29
          beq lf34c
          jsr lebf5
          jsr lf3a2
lf34c:    jsr lf363
          dex
          txa
          pha
          clc
          ldx #$00
          sbc ($9e),y
          bcs lf311
          eor #$ff
          cmp $af
          bcc lf312
          lda $af
          bcs lf312
lf363:    jsr lebef
          pla
          sta $a2
          pla
          sta $a3
          pla
          pla
          pla
          tax
          pla
          sta $9e
          pla
          sta $9f
          ldy #$00
          txa
          beq lf39c
          inc $a2
          jmp ($00a2)
          jsr lf386
lf383:    jmp lefc4
lf386:    jsr lf2a7
          ldx #$00
          stx $5f
          tay
          rts
          jsr lf386
          beq lf39c
          ldy #$00
          lda ($71),y
          tay
          jmp lf383
lf39c:    jmp lee7c
lf39f:    jsr $00bc
lf3a2:    jsr leaa1
lf3a5:    jsr ledf5
          ldx $ae
          bne lf39c
          ldx $af
          jmp $00c2
          jsr lf386
          bne lf3b9
          jmp lf4e5
lf3b9:    ldx $c3
          ldy $c4
          stx $ba
          sty $bb
          ldx $71
          stx $c3
          clc
          adc $71
          sta $73
          ldx $72
          stx $c4
          bcc lf3d1
          inx
lf3d1:    stx $74
          ldy #$00
          lda ($73),y
          pha
          lda #$00
          sta ($73),y
          jsr $00c2
          jsr lf87b
          pla
          ldy #$00
          sta ($73),y
lf3e7:    ldx $ba
          ldy $bb
          stx $c3
          sty $c4
          rts
lf3f0:    jsr leaa1
          jsr lf3fc
lf3f6:    jsr lebf5
          jmp lf3a2
lf3fc:    lda $b0
          bmi lf39c
          lda $ac
          cmp #$91
          bcs lf39c
          jsr lf825
          lda $ae
          ldy $af
          sty $11
          sta $12
          rts
          jsr lf3fc
          ldy #$00
          lda ($11),y
          tay
          jmp lefc4
          jsr lf3f0
          txa
          ldy #$00
          sta ($11),y
          rts
          jsr lf3f0
          stx $97
          ldx #$00
          jsr $00c2
          beq lf435
          jsr lf3f6
lf435:    stx $98
          ldy #$00
lf439:    lda ($11),y
          eor $98
          and $97
          beq lf439
lf441:    rts
lf442:    lda #$8a
          ldy #$fa
          jmp lf460
lf449:    jsr lf641
lf44c:    lda $b0
          eor #$ff
          sta $b0
          eor $b7
          sta $b8
          lda $ac
          jmp lf463
lf45b:    jsr lf56f
          bcc lf49c
lf460:    jsr lf641
lf463:    bne lf468
          jmp lf78f
lf468:    ldx $b9
          stx $a3
          ldx #$b3
          lda $b3
lf470:    tay
          beq lf441
          sec
          sbc $ac
          beq lf49c
          bcc lf48c
          sty $ac
          ldy $b7
          sty $b0
          eor #$ff
          adc #$00
          ldy #$00
          sty $a3
          ldx #$ac
          bne lf490
lf48c:    ldy #$00
          sty $b9
lf490:    cmp #$f9
          bmi lf45b
          tay
          lda $b9
          lsr $01,x
          jsr lf586
lf49c:    bit $b8
          bpl lf4ec
          ldy #$ac
          cpx #$b3
          beq lf4a8
          ldy #$b3
lf4a8:    sec
          eor #$ff
          adc $a3
          sta $b9
          lda $0003,y
          sbc $03,x
          sta $af
          lda $0002,y
          sbc $02,x
          sta $ae
          lda $0001,y
          sbc $01,x
          sta $ad
lf4c4:    bcs lf4c9
          jsr lf52b
lf4c9:    ldy #$00
          tya
          clc
lf4cd:    ldx $ad
          bne lf50f
          ldx $ae
          stx $ad
          ldx $af
          stx $ae
          ldx $b9
          stx $af
          sty $b9
          adc #$08
          cmp #$18
          bne lf4cd
lf4e5:    lda #$00
lf4e7:    sta $ac
lf4e9:    sta $b0
          rts
lf4ec:    adc $a3
          sta $b9
          lda $af
          adc $b6
          sta $af
          lda $ae
          adc $b5
          sta $ae
          lda $ad
          adc $b4
          sta $ad
          jmp lf51c
lf505:    adc #$01
          asl $b9
          rol $af
          rol $ae
          rol $ad
lf50f:    bpl lf505
          sec
          sbc $ac
          bcs lf4e5
          eor #$ff
          adc #$01
          sta $ac
lf51c:    bcc lf52a
lf51e:    inc $ac
          beq lf558
          ror $ad
          ror $ae
          ror $af
          ror $b9
lf52a:    rts
lf52b:    lda $b0
          eor #$ff
          sta $b0
lf531:    lda $ad
          eor #$ff
          sta $ad
          lda $ae
          eor #$ff
          sta $ae
          lda $af
          eor #$ff
          sta $af
          lda $b9
          eor #$ff
          sta $b9
          inc $b9
          bne lf557
lf54d:    inc $af
          bne lf557
          inc $ae
          bne lf557
          inc $ad
lf557:    rts
lf558:    ldx #$0a
          jmp le24e
lf55d:    ldx #$74
lf55f:    ldy $03,x
          sty $b9
          ldy $02,x
          sty $03,x
          ldy $01,x
          sty $02,x
          ldy $b2
          sty $01,x
lf56f:    adc #$08
          bmi lf55f
          beq lf55f
          sbc #$08
          tay
          lda $b9
          bcs lf58e
lf57c:    asl $01,x
          bcc lf582
          inc $01,x
lf582:    ror $01,x
          ror $01,x
lf586:    ror $02,x
          ror $03,x
          ror a
          iny
          bne lf57c
lf58e:    clc
          rts
          sta ($00,x)
          brk
          brk
          ???             //    %00000010
          ???             //    %10000000
          ora $6256,y
          ???             //    %10000000
          ror $22,x
          ???             //    %11110011
          ???             //    %10000010
          sec
          tax
          rti
          ???             //    %10000000
          and $04,x
          ???             //    %11110011
          sta ($35,x)
          ???             //    %00000100
          ???             //    %11110011
          ???             //    %10000000
          ???             //    %10000000
          brk
          brk
          ???             //    %10000000
          and ($72),y
          clc
lf5b1:    jsr lf7be
          beq lf5b8
          bpl lf5bb
lf5b8:    jmp lee7c
lf5bb:    lda $ac
          sbc #$7f
          pha
          lda #$80
          sta $ac
          lda #$a1
          ldy #$f5
          jsr lf460
          lda #$a5
          ldy #$f5
          jsr lf6be
          lda #$90
          ldy #$f5
          jsr lf449
          lda #$94
          ldy #$f5
          jsr lfb62
          lda #$a9
          ldy #$f5
          jsr lf460
          pla
          jsr lf906
          lda #$ad
          ldy #$f5
lf5ef:    jsr lf641
          beq lf640
          jsr lf667
          lda #$00
          sta $75
          sta $76
          sta $77
          lda $b9
          jsr lf616
          lda $af
          jsr lf616
          lda $ae
          jsr lf616
          lda $ad
          jsr lf61b
          jmp lf730
lf616:    bne lf61b
          jmp lf55d
lf61b:    lsr a
          ora #$80
lf61e:    tay
          bcc lf634
          clc
          lda $77
          adc $b6
          sta $77
          lda $76
          adc $b5
          sta $76
          lda $75
          adc $b4
          sta $75
lf634:    ror $75
          ror $76
          ror $77
          ror $b9
          tya
          lsr a
          bne lf61e
lf640:    rts
lf641:    sta $71
          sty $72
          ldy #$03
          lda ($71),y
          sta $b6
          dey
          lda ($71),y
          sta $b5
          dey
          lda ($71),y
          sta $b7
          eor $b0
          sta $b8
          lda $b7
          ora #$80
          sta $b4
          dey
          lda ($71),y
          sta $b3
          lda $ac
          rts
lf667:    lda $b3
lf669:    beq lf68a
          clc
          adc $ac
          bcc lf674
          bmi lf68f
          clc
          bit $1410
          adc #$80
          sta $ac
          bne lf67f
          jmp lf4e9
lf67f:    lda $b8
          sta $b0
          rts
lf684:    lda $b0
          eor #$ff
          bmi lf68f
lf68a:    pla
          pla
          jmp lf4e5
lf68f:    jmp lf558
lf692:    jsr lf79f
          tax
          beq lf6a8
          clc
          adc #$02
          bcs lf68f
          ldx #$00
          stx $b8
          jsr lf470
          inc $ac
          beq lf68f
lf6a8:    rts
          sty $20
          brk
          brk
lf6ad:    jsr lf79f
          lda #$a9
          ldy #$f6
          ldx #$00
lf6b6:    stx $b8
          jsr lf73f
          jmp lf6c1
lf6be:    jsr lf641
lf6c1:    beq lf72b
          jsr lf7ae
          lda #$00
          sec
          sbc $ac
          sta $ac
          jsr lf667
          inc $ac
          beq lf68f
          ldx #$fd
          lda #$01
lf6d8:    ldy $b4
          cpy $ad
          bne lf6e8
          ldy $b5
          cpy $ae
          bne lf6e8
          ldy $b6
          cpy $af
lf6e8:    php
          rol a
          bcc lf6f5
          inx
          sta $77,x
          beq lf71b
          bpl lf71f
          lda #$01
lf6f5:    plp
          bcs lf704
lf6f8:    asl $b6
          rol $b5
          rol $b4
          bcs lf6e8
          bmi lf6d8
          bpl lf6e8
lf704:    tay
          lda $b6
          sbc $af
          sta $b6
          lda $b5
          sbc $ae
          sta $b5
          lda $b4
          sbc $ad
          sta $b4
          tya
          jmp lf6f8
lf71b:    lda #$40
          bne lf6f5
lf71f:    asl a
          asl a
          asl a
          asl a
          asl a
          asl a
          sta $b9
          plp
          jmp lf730
lf72b:    ldx #$14
          jmp le24e
lf730:    lda $75
          sta $ad
          lda $76
          sta $ae
          lda $77
          sta $af
          jmp lf4c9
lf73f:    sta $71
          sty $72
          ldy #$03
          lda ($71),y
          sta $af
          dey
          lda ($71),y
          sta $ae
          dey
          lda ($71),y
          sta $b0
          ora #$80
          sta $ad
          dey
          lda ($71),y
          sta $ac
          sty $b9
          rts
lf75f:    ldx #$a8
          bit $a4a2
          ldy #$00
          beq lf76c
lf768:    ldx $97
          ldy $98
lf76c:    jsr lf7ae
          stx $71
          sty $72
          ldy #$03
          lda $af
          sta ($71),y
          dey
          lda $ae
          sta ($71),y
          dey
          lda $b0
          ora #$7f
          and $ad
          sta ($71),y
          dey
          lda $ac
          sta ($71),y
          sty $b9
          rts
lf78f:    lda $b7
lf791:    sta $b0
          ldx #$04
lf795:    lda $b2,x
          sta $ab,x
          dex
          bne lf795
          stx $b9
          rts
lf79f:    jsr lf7ae
lf7a2:    ldx #$05
lf7a4:    lda $ab,x
          sta $b2,x
          dex
          bne lf7a4
          stx $b9
lf7ad:    rts
lf7ae:    lda $ac
          beq lf7ad
          asl $b9
          bcc lf7ad
lf7b6:    jsr lf54d
          bne lf7ad
          jmp lf51e
lf7be:    lda $ac
          beq lf7cb
lf7c2:    lda $b0
lf7c4:    rol a
          lda #$ff
          bcs lf7cb
          lda #$01
lf7cb:    rts
          jsr lf7be
lf7cf:    sta $ad
          lda #$00
          sta $ae
          ldx #$88
lf7d7:    lda $ad
          eor #$ff
          rol a
lf7dc:    lda #$00
          sta $af
          stx $ac
          sta $b9
          sta $b0
          jmp lf4c4
          lsr $b0
          rts
lf7ec:    sta $73
lf7ee:    sty $74
          ldy #$00
          lda ($73),y
          iny
          tax
          beq lf7be
          lda ($73),y
          eor $b0
          bmi lf7c2
          cpx $ac
          bne lf81c
          lda ($73),y
          ora #$80
          cmp $ad
          bne lf81c
          iny
          lda ($73),y
          cmp $ae
          bne lf81c
          iny
          lda #$7f
          cmp $b9
          lda ($73),y
          sbc $af
          beq lf844
lf81c:    lda $b0
          bcc lf822
          eor #$ff
lf822:    jmp lf7c4
lf825:    lda $ac
          beq lf873
          sec
          sbc #$98
          bit $b0
          bpl lf839
          tax
          lda #$ff
          sta $b2
          jsr lf531
          txa
lf839:    ldx #$ac
          cmp #$f9
          bpl lf845
          jsr lf56f
          sty $b2
lf844:    rts
lf845:    tay
          lda $b0
          and #$80
          lsr $ad
          ora $ad
          sta $ad
          jsr lf586
          sty $b2
          rts
lf856:    lda $ac
          cmp #$98
          bcs lf87a
          jsr lf825
          sty $b9
          lda $b0
          sty $b0
          eor #$80
          rol a
          lda #$98
          sta $ac
          lda $af
          sta $5b
          jmp lf4c4
lf873:    sta $ad
          sta $ae
          sta $af
          tay
lf87a:    rts
lf87b:    ldy #$00
          ldx #$09
lf87f:    sty $a8,x
          dex
          bpl lf87f
          bcc lf895
          cmp #$2d
          bne lf88e
          stx $b1
          beq lf892
lf88e:    cmp #$2b
          bne lf897
lf892:    jsr $00bc
lf895:    bcc lf8f2
lf897:    cmp #$2e
          beq lf8c9
          cmp #$45
          bne lf8cf
          jsr $00bc
          bcc lf8bb
          cmp #$a4
          beq lf8b6
          cmp #$2d
          beq lf8b6
          cmp #$a3
          beq lf8b8
          cmp #$2b
          beq lf8b8
          bne lf8bd
lf8b6:    ror $ab
lf8b8:    jsr $00bc
lf8bb:    bcc lf919
lf8bd:    bit $ab
          bpl lf8cf
          lda #$00
          sec
          sbc $a9
          jmp lf8d1
lf8c9:    ror $aa
          bit $aa
          bvc lf892
lf8cf:    lda $a9
lf8d1:    sec
          sbc $a8
          sta $a9
          beq lf8ea
          bpl lf8e3
lf8da:    jsr lf6ad
          inc $a9
          bne lf8da
          beq lf8ea
lf8e3:    jsr lf692
          dec $a9
          bne lf8e3
lf8ea:    lda $b1
          bmi lf8ef
          rts
lf8ef:    jmp lfae3
lf8f2:    pha
          bit $aa
          bpl lf8f9
          inc $a8
lf8f9:    jsr lf692
          pla
          sec
          sbc #$30
          jsr lf906
          jmp lf892
lf906:    pha
          jsr lf79f
          pla
          jsr lf7cf
          lda $b7
          eor $b0
          sta $b8
          ldx $ac
          jmp lf463
lf919:    lda $a9
          cmp #$0a
          bcc lf928
          lda #$64
          bit $ab
          bmi lf936
          jmp lf558
lf928:    asl a
          asl a
          clc
          adc $a9
          asl a
          clc
          ldy #$00
          adc ($c3),y
          sec
          sbc #$30
lf936:    sta $a9
          jmp lf8b8
          sta ($43),y
          ???             //    %01001111 'O'
          sed
          sty $74,x
          ???             //    %00100011 '#'
          ???             //    %11110111
          sty $74,x
          bit $00
lf947:    lda #$8d
          ldy #$e1
          jsr lf95f
          lda $88
          ldx $87
lf952:    sta $ad
          stx $ae
          ldx #$90
          sec
          jsr lf7dc
          jsr lf962
lf95f:    jmp le8b7
lf962:    ldy #$01
lf964:    lda #$20
          bit $b0
          bpl lf96c
          lda #$2d
lf96c:    sta $00ff,y
          sta $b0
          sty $ba
          iny
          lda #$30
          ldx $ac
          bne lf97d
          jmp lfa7d
lf97d:    lda #$00
          cpx #$80
          beq lf985
          bcs lf98e
lf985:    lda #$43
          ldy #$f9
          jsr lf5ef
          lda #$fa
lf98e:    sta $a8
lf990:    lda #$3f
          ldy #$f9
          jsr lf7ec
          beq lf9b7
          bpl lf9ad
lf99b:    lda #$3b
          ldy #$f9
          jsr lf7ec
          beq lf9a6
          bpl lf9b4
lf9a6:    jsr lf692
          dec $a8
          bne lf99b
lf9ad:    jsr lf6ad
          inc $a8
          bne lf990
lf9b4:    jsr lf442
lf9b7:    jsr lf825
          ldx #$01
          lda $a8
          clc
          adc #$07
          bmi lf9cc
          cmp #$08
          bcs lf9cd
          adc #$ff
          tax
          lda #$02
lf9cc:    sec
lf9cd:    sbc #$02
          sta $a9
          stx $a8
          txa
          beq lf9d8
          bpl lf9eb
lf9d8:    ldy $ba
          lda #$2e
          iny
          sta $00ff,y
          txa
          beq lf9e9
          lda #$30
          iny
          sta $00ff,y
lf9e9:    sty $ba
lf9eb:    ldy #$00
          ldx #$80
lf9ef:    lda $af
          clc
          adc $fa90,y
          sta $af
          lda $ae
          adc $fa8f,y
          sta $ae
          lda $ad
          adc $fa8e,y
          sta $ad
          inx
          bcs lfa0c
          bpl lf9ef
          bmi lfa0e
lfa0c:    bmi lf9ef
lfa0e:    txa
          bcc lfa15
          eor #$ff
          adc #$0a
lfa15:    adc #$2f
          iny
          iny
          iny
          sty $95
          ldy $ba
          iny
          tax
          and #$7f
          sta $00ff,y
          dec $a8
          bne lfa2f
          lda #$2e
          iny
          sta $00ff,y
lfa2f:    sty $ba
          ldy $95
          txa
          eor #$ff
          and #$80
          tax
          cpy #$12
          bne lf9ef
          ldy $ba
lfa3f:    lda $00ff,y
          dey
          cmp #$30
          beq lfa3f
          cmp #$2e
          beq lfa4c
          iny
lfa4c:    lda #$2b
          ldx $a9
          beq lfa80
          bpl lfa5c
          lda #$00
          sec
          sbc $a9
          tax
          lda #$2d
lfa5c:    sta $0101,y
          lda #$45
          sta $0100,y
          txa
          ldx #$2f
          sec
lfa68:    inx
          sbc #$0a
          bcs lfa68
          adc #$3a
          sta $0103,y
          txa
          sta $0102,y
          lda #$00
          sta $0104,y
          beq lfa85
lfa7d:    sta $00ff,y
lfa80:    lda #$00
          sta $0100,y
lfa85:    lda #$00
          ldy #$01
          rts
          ???             //    %10000000
          brk
          brk
          brk
          inc $6079,x
          brk
          ???             //    %00100111 '''
          bpl lfa94
          ???             //    %11111100
          clc
          brk
          brk
          ???             //    %01100100 'd'
          ???             //    %11111111
          ???             //    %11111111
          inc $00,x
          brk
          ora ($20,x)
          ???             //    %10011111
          ???             //    %11110111
          lda #$8a
          ldy #$fa
          jsr lf73f
          beq lfb0f
          lda $b3
          bne lfab3
          jmp lf4e7
lfab3:    ldx #$9c
          ldy #$00
          jsr lf76c
          lda $b7
          bpl lfacd
          jsr lf856
          lda #$9c
          ldy #$00
          jsr lf7ec
          bne lfacd
          tya
          ldy $5b
lfacd:    jsr lf791
          tya
          pha
          jsr lf5b1
          lda #$9c
          ldy #$00
          jsr lf5ef
          jsr lfb0f
          pla
          lsr a
          bcc lfaed
lfae3:    lda $ac
          beq lfaed
          lda $b0
          eor #$ff
          sta $b0
lfaed:    rts
          sta ($38,x)
          tax
          ???             //    %00111011 '//    '
          asl $74
          ???             //    %01100011 'c'
          bcc lfa83
          ???             //    %01110111 'w'
          ???             //    %00100011 '#'
          ???             //    %00001100
          ???             //    %10101011
          ???             //    %01111010 'z'
          asl $0094,x
          ???             //    %01111100 '|'
          ???             //    %01100011 'c'
          ???             //    %01000010 'B'
          ???             //    %10000000
          ror $fe75,x
          bne lfa88
          and ($72),y
          ora $81,x
          brk
          brk
          brk
lfb0f:    lda #$ee
          ldy #$fa
          jsr lf5ef
          lda $b9
          adc #$50
          bcc lfb1f
          jsr lf7b6
lfb1f:    sta $a3
          jsr lf7a2
          lda $ac
          cmp #$88
          bcc lfb2d
lfb2a:    jsr lf684
lfb2d:    jsr lf856
          lda $5b
          clc
          adc #$81
          beq lfb2a
          sec
          sbc #$01
          pha
          ldx #$04
lfb3d:    lda $b3,x
          ldy $ac,x
          sta $ac,x
          sty $b3,x
          dex
          bpl lfb3d
          lda $a3
          sta $b9
          jsr lf44c
          jsr lfae3
          lda #$f2
          ldy #$fa
          jsr lfb78
          lda #$00
          sta $b8
          pla
          jsr lf669
          rts
lfb62:    sta $ba
          sty $bb
          jsr lf762
          lda #$a4
          jsr lf5ef
          jsr lfb7c
          lda #$a4
          ldy #$00
          jmp lf5ef
lfb78:    sta $ba
          sty $bb
lfb7c:    jsr lf75f
          lda ($ba),y
          sta $b1
          ldy $ba
          iny
          tya
          bne lfb8b
          inc $bb
lfb8b:    sta $ba
          ldy $bb
lfb8f:    jsr lf5ef
          lda $ba
          ldy $bb
          clc
          adc #$04
          bcc lfb9c
          iny
lfb9c:    sta $ba
          sty $bb
          jsr lf460
          lda #$a8
          ldy #$00
          dec $b1
          bne lfb8f
lfbab:    rts
          tya
          and $44,x
          ???             //    %01111010 'z'
          pla
          plp
          lda ($46),y
          jsr lf7be
          tax
          bmi lfbd2
          lda #$d4
          ldy #$00
          jsr lf73f
          txa
          beq lfbab
          lda #$ac
          ldy #$fb
          jsr lf5ef
          lda #$b0
          ldy #$fb
          jsr lf460
lfbd2:    ldx $af
          lda $ad
          sta $af
          stx $ad
          lda #$00
          sta $b0
          lda $ac
          sta $b9
          lda #$80
          sta $ac
          jsr lf4c9
          ldx #$d4
          ldy #$00
lfbed:    jmp lf76c
          lda #$6c
          ldy #$fc
          jsr lf460
lfbf7:    jsr lf79f
          lda #$70
          ldy #$fc
          ldx $b7
          jsr lf6b6
          jsr lf79f
          jsr lf856
          lda #$00
          sta $b8
          jsr lf44c
          lda #$74
          ldy #$fc
          jsr lf449
          lda $b0
          pha
          bpl lfc29
          jsr lf442
          lda $b0
          bmi lfc2c
          lda $63
          eor #$ff
          sta $63
lfc29:    jsr lfae3
lfc2c:    lda #$74
          ldy #$fc
          jsr lf460
          pla
          bpl lfc39
          jsr lfae3
lfc39:    lda #$78
          ldy #$fc
          jmp lfb62
          jsr lf762
          lda #$00
          sta $63
          jsr lfbf7
          ldx #$9c
          ldy #$00
          jsr lfbed
          lda #$a4
          ldy #$00
          jsr lf73f
          lda #$00
          sta $b0
          lda $63
          jsr lfc68
          lda #$9c
          ldy #$00
          jmp lf6be
lfc68:    pha
          jmp lfc29
          sta ($49,x)
          ???             //    %00001111
          ???             //    %11011011
          ???             //    %10000011
          eor #$0f
          ???             //    %11011011
          ???             //    %01111111
          brk
          brk
          brk
          ???             //    %00000100
          stx $1e
          ???             //    %11010111
          ???             //    %11111011
          ???             //    %10000111
          sta $6526,y
          ???             //    %10000111
          ???             //    %00100011 '#'
          ???             //    %00110100 '4'
          cli
          stx $a5
          eor $83e1,x
          eor #$0f
          ???             //    %11011011
          lda $b0
          pha
          bpl lfc95
          jsr lfae3
lfc95:    lda $ac
          pha
          cmp #$81
          bcc lfca3
          lda #$90
          ldy #$f5
          jsr lf6be
lfca3:    lda #$bd
          ldy #$fc
          jsr lfb62
          pla
          cmp #$81
          bcc lfcb6
          lda #$6c
          ldy #$fc
          jsr lf449
lfcb6:    pla
          bpl lfcbc
          jmp lfae3
lfcbc:    rts
          php
          sei
          ???             //    %00111010 ':'
          cmp $37
          ???             //    %01111011 '{'
          ???             //    %10000011
          ldx #$5c
          ???             //    %01111100 '|'
          rol $4ddd
          adc $b099,x
          asl $597d,x
          sbc $7e24
          sta ($72),y
          brk
          ror $b94c,x
          ???             //    %01110011 's'
          ???             //    %01111111
          tax
          tax
          ???             //    %01010011 'S'
          sta ($00,x)
          brk
          brk
lfce2:    inc $c3
          bne lfce8
          inc $c4
lfce8:    lda $ea60
          cmp #$3a
          bcs lfcf9
          cmp #$20
          beq lfce2
          sec
          sbc #$30
          sec
          sbc #$d0
lfcf9:    rts
          ???             //    %10000000
          ???             //    %01001111 'O'
          ???             //    %11000111
          ???             //    %01010010 'R'
lfcfe:    lda #$42
          ldy #$fe
          jsr le8b7
lfd05:    ldx #$ff
          stx $88
          txs
          lda #$05
          ldy #$fd
          sta $01
          sty $02
          sta $04
          sty $05
          lda #$f9
          ldy #$ed
          sta $06
          sty $07
          lda #$b5
          ldy #$ef
          sta $08
          sty $09
          lda #$4c
          sta $00
          sta $03
          sta $a1
          sta $0a
          lda #$7c
          ldy #$ee
          sta $0b
          sty $0c
          lda #$48
          sta $0f
          lda #$38
          sta $10
          ldx #$1c
lfd42:    lda $fce1,x
          sta $bb,x
          dex
          bne lfd42
          txa
          sta $b2
          sta $67
          sta $0d
          sta $0e
          pha
          sta $64
          lda #$03
          sta $a0
          lda #$2c
          sta $12
          jsr le860
          ldx #$68
          stx $65
          lda #$66
          ldy #$fe
          jsr le8b7
          jsr le93a
          stx $c3
          sty $c4
          jsr $00bc
          cmp #$41
          beq lfcfe
          tay
          bne lfd9e
          lda #$00
          ldy #$02
          sta $11
          sty $12
          ldy #$00
lfd87:    inc $11
          bne lfd8d
          inc $12
lfd8d:    lda #$92
          sta ($11),y
          cmp ($11),y
          bne lfdaa
          asl a
          sta ($11),y
          cmp ($11),y
          beq lfd87
          bne lfdaa
lfd9e:    jsr $00c2
          jsr le773
          tay
          beq lfdaa
          jmp lec00
lfdaa:    lda $11
          ldy $12
          sta $85
          sty $86
          sta $81
          sty $82
lfdb6:    lda #$72
          ldy #$fe
          jsr le8b7
          jsr le93a
          stx $c3
          sty $c4
          jsr $00bc
          tay
          beq lfde6
          jsr le773
          lda $12
          bne lfdb6
          lda $11
          cmp #$10
          bcc lfdb6
          sta $0f
lfdd9:    sbc #$0e
          bcs lfdd9
          eor #$ff
          sbc #$0c
          clc
          adc $0f
          sta $10
lfde6:    ldx #$00
          ldy #$02
          stx $79
          sty $7a
          ldy #$00
          tya
          sta ($79),y
          inc $79
          bne lfdf9
          inc $7a
lfdf9:    lda $79
          ldy $7a
          jsr le21f
          jsr le860
          lda $85
          sec
          sbc $79
          tax
          lda $86
          sbc $7a
          jsr lf952
          lda #$81
          ldy #$fe
          jsr le8b7
          lda #$b7
          ldy #$e8
          sta $04
          sty $05
          jsr le463
          lda #$74
          ldy #$e2
          sta $01
          sty $02
          jmp ($0001)
          ???             //    %01010111 'W'
          eor ($4e,x)
          ???             //    %01010100 'T'
          jsr $4953
          lsr $432d
          ???             //    %01001111 'O'
          ???             //    %01010011 'S'
          and $4154
          lsr $412d
          ???             //    %01010100 'T'
          lsr $0d00
          asl a
          ???             //    %00001100
          ???             //    %01010111 'W'
          ???             //    %01010010 'R'
          eor #$54
          ???             //    %01010100 'T'
          eor $4e
          jsr $5942
          jsr $4952
          ???             //    %01000011 'C'
          pha
          eor ($52,x)
          ???             //    %01000100 'D'
          jsr $2e57
          jsr $4557
          eor #$4c
          eor ($4e,x)
          ???             //    %01000100 'D'
          rol $0a0d
          brk
          eor $4d45
          ???             //    %01001111 'O'
          ???             //    %01010010 'R'
          eor $5320,y
          eor #$5a
          eor $00
          ???             //    %01010100 'T'
          eor $52
          eor $4e49
          eor ($4c,x)
          jsr $4957
          ???             //    %01000100 'D'
          ???             //    %01010100 'T'
          pha
          brk
          jsr $5942
          ???             //    %01010100 'T'
          eor $53
          jsr $5246
          eor $45
          ora $0d0a
          asl a
          ???             //    %01001111 'O'
          ???             //    %01010011 'S'
          eor #$20
          rol $35,x
          bmi lfeca
          jsr $4142
          ???             //    %01010011 'S'
          eor #$43
          jsr $4556
          ???             //    %01010010 'R'
          ???             //    %01010011 'S'
          eor #$4f
          lsr $3120
          rol $2030
          ???             //    %01010010 'R'
          eor $56
          jsr $2e33
          ???             //    %00110010 '2'
          ora $430a
          ???             //    %01001111 'O'
          bvc lff11
          ???             //    %01010010 'R'
          eor #$47
          pha
          ???             //    %01010100 'T'
          jsr $3931
          ???             //    %00110111 '7'
          ???             //    %00110111 '7'
          jsr $5942
          jsr $494d
          ???             //    %01000011 'C'
          ???             //    %01010010 'R'
lfeca:    ???             //    %01001111 'O'
          ???             //    %01010011 'S'
          ???             //    %01001111 'O'
          lsr $54
          jsr $4f43
          rol $0a0d
          brk
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
lff00:    ldx #$fc
          txs
          lda #$95
          sta $ffd0
          ldy #$00
lff0a:    lda $ff56,y
          beq lff15
          jsr lff2a
          iny
          bne lff0a
lff15:    jsr lff39
          bcc lff15
          and #$df
          cmp #$57
          beq lff27
          cmp #$43
          bne lff00
          jmp lfd05
lff27:    jmp le274
lff2a:    pha
lff2b:    lda $ffd0
          and #$02
          cmp #$02
          bne lff2b
          pla
          sta $ffd1
          rts
lff39:    lda $ffd0
          and #$01
          cmp #$01
          bne lff47
          lda $ffd1
          sec
          rts
lff47:    clc
          rts
lff49:    jsr lff39
          bcc lff54
          cmp #$03
          bne lff54
          sec
          rts
lff54:    clc
          rts
          ???             //    %00001100
          ???             //    %01000011 'C'
          ???             //    %01101111 'o'
          jmp ($2064)
          ???             //    %01011011 '['
          ???             //    %01000011 'C'
          eor $6f20,x
          ???             //    %01110010 'r'
          jsr $6177
          ???             //    %01110010 'r'
          adc $5b20
          ???             //    %01010111 'W'
          eor $7320,x
          ???             //    %01110100 't'
          adc ($72,x)
          ???             //    %01110100 't'
          ???             //    %00111111 '?'
          ora $000a
          rts
          rts
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          ???             //    %11111111
          brk
          ???             //    %11111111
          brk
          ???             //    %11111111
          brk
          ???             //    %11111111
          .end

//    auto-generated symbols and labels
 le049     $e049
 le00c     $e00c
 le052     $e052
 le057     $e057
 le0d3     $e0d3
 le113     $e113
 le129     $e129
 le13f     $e13f
 le177     $e177
 le1c4     $e1c4
 le1ce     $e1ce
 le1bb     $e1bb
 le1c7     $e1c7
 le1a6     $e1a6
 le21f     $e21f
 le20a     $e20a
 le1f3     $e1f3
 le203     $e203
 le1ff     $e1ff
 le24c     $e24c
 le24b     $e24b
 le229     $e229
 le22d     $e22d
 lf13b     $f13b
 le238     $e238
 le860     $e860
 le8d7     $e8d7
 le8d9     $e8d9
 le491     $e491
 le8b7     $e8b7
 le274     $e274
 lf947     $f947
 le357     $e357
 le27d     $e27d
 le295     $e295
 le3a6     $e3a6
 le5f6     $e5f6
 le773     $e773
 le432     $e432
 le2e6     $e2e6
 le2d0     $e2d0
 le2d8     $e2d8
 le319     $e319
 le301     $e301
 le1cf     $e1cf
 le311     $e311
 le477     $e477
 le32e     $e32e
 le330     $e330
 le325     $e325
 le359     $e359
 le386     $e386
 le374     $e374
 le383     $e383
 le34b     $e34b
 le351     $e351
 le37c     $e37c
 le85a     $e85a
 lff39     $ff39
 le3a5     $e3a5
 le3ec     $e3ec
 le410     $e410
 le3c4     $e3c4
 le3cc     $e3cc
 le3d7     $e3d7
 le3d6     $e3d6
 le417     $e417
 le42a     $e42a
 le3ff     $e3ff
 le401     $e401
 le3ac     $e3ac
 le408     $e408
 le41b     $e41b
 le3d8     $e3d8
 le3ea     $e3ea
 le45f     $e45f
 le460     $e460
 le44d     $e44d
 le456     $e456
 le436     $e436
 le4a7     $e4a7
 le61a     $e61a
 le4bd     $e4bd
 le4a6     $e4a6
 le4d4     $e4d4
 le4e2     $e4e2
 le52b     $e52b
 le629     $e629
 le4ff     $e4ff
 le501     $e501
 lf952     $f952
 le519     $e519
 le52e     $e52e
 le50c     $e50c
 le54b     $e54b
 le543     $e543
 le540     $e540
 le508     $e508
 le7ad     $e7ad
 le1a1     $e1a1
 le567     $e567
 le212     $e212
 le70e     $e70e
 lebf7     $ebf7
 leaa4     $eaa4
 leaa1     $eaa1
 leb5a     $eb5a
 lf73f     $f73f
 le5b3     $e5b3
 lf7be     $f7be
 leb4f     $eb4f
 le5d1     $e5d1
 le5dc     $e5dc
 lec00     $ec00
 le645     $e645
 le5ff     $e5ff
 le5c2     $e5c2
 le66e     $e66e
 le609     $e609
 le5d9     $e5d9
 le624     $e624
 lff49     $ff49
 le62f     $e62f
 le643     $e643
 le652     $e652
 le269     $e269
 le660     $e660
 le24e     $e24e
 lf3a2     $f3a2
 le67d     $e67d
 lee7c     $ee7c
 le47a     $e47a
 le68a     $e68a
 le6a4     $e6a4
 le6ad     $e6ad
 le711     $e711
 le6c4     $e6c4
 le6c8     $e6c8
 le6eb     $e6eb
 le6d9     $e6d9
 le6f3     $e6f3
 le70d     $e70d
 le719     $e719
 le721     $e721
 leab5     $eab5
 le73f     $e73f
 le748     $e748
 le703     $e703
 le750     $e750
 le75f     $e75f
 le6f0     $e6f0
 le767     $e767
 le602     $e602
 le772     $e772
 le75b     $e75b
 le7a7     $e7a7
 le779     $e779
 lecff     $ecff
 leaa7     $eaa7
 le7c9     $e7c9
 lf768     $f768
 le7e8     $e7e8
 le7da     $e7da
 le7ef     $e7ef
 le805     $e805
 lf090     $f090
 lf27e     $f27e
 lf2df     $f2df
 le8ba     $e8ba
 le87e     $e87e
 le896     $e896
 le87f     $e87f
 le8b1     $e8b1
 le81d     $e81d
 lf962     $f962
 lf0a2     $f0a2
 le852     $e852
 le8d4     $e8d4
 le820     $e820
 le87a     $e87a
 le874     $e874
 le88b     $e88b
 le88c     $e88c
 le8aa     $e8aa
 lf39f     $f39f
 le904     $e904
 le8ab     $e8ab
 le825     $e825
 lf2aa     $f2aa
 le8c1     $e8c1
 le86c     $e86c
 le8f5     $e8f5
 le8ed     $e8ed
 le8eb     $e8eb
 lff2a     $ff2a
 le907     $e907
 le928     $e928
 lebb5     $ebb5
 lefc8     $efc8
 le93a     $e93a
 le948     $e948
 le63b     $e63b
 le979     $e979
 le9d1     $e9d1
 le9a4     $e9a4
 le98d     $e98d
 le998     $e998
 lf0a8     $f0a8
 lf3e7     $f3e7
 le9aa     $e9aa
 lf87b     $f87b
 le9b6     $e9b6
 le8f8     $e8f8
 le9f7     $e9f7
 lebf5     $ebf5
 le94f     $e94f
 le9ea     $e9ea
 lea48     $ea48
 lea02     $ea02
 lea0f     $ea0f
 lea3a     $ea3a
 lea3d     $ea3d
 lea4a     $ea4a
 leab2     $eab2
 lf460     $f460
 lf7ee     $f7ee
 lea8f     $ea8f
 lea8c     $ea8c
 leaae     $eaae
 leab0     $eab0
 leaad     $eaad
 leabb     $eabb
 leb94     $eb94
 leaee     $eaee
 leb47     $eb47
 lead2     $ead2
 leb1e     $eb1e
 leb6c     $eb6c
 leaff     $eaff
 lf241     $f241
 leb71     $eb71
 leb37     $eb37
 leb30     $eb30
 leb6f     $eb6f
 leb7a     $eb7a
 leb28     $eb28
 leb07     $eb07
 leb10     $eb10
 leb4a     $eb4a
 leac0     $eac0
 lf7ae     $f7ae
 leb91     $eb91
 leb78     $eb78
 leba0     $eba0
 led75     $ed75
 lec0c     $ec0c
 leb9d     $eb9d
 lec05     $ec05
 leb98     $eb98
 lebc4     $ebc4
 lebbe     $ebbe
 lebdb     $ebdb
 lec07     $ec07
 ledf9     $edf9
 lefb5     $efb5
 lebe2     $ebe2
 lf012     $f012
 lebe9     $ebe9
 lec1b     $ec1b
 lebf2     $ebf2
 leb11     $eb11
 lec18     $ec18
 lec45     $ec45
 leaa6     $eaa6
 lec4a     $ec4a
 lf78f     $f78f
 leca2     $eca2
 lf7ec     $f7ec
 lecd5     $ecd5
 lf2ae     $f2ae
 lecca     $ecca
 lecda     $ecda
 lece6     $ece6
 leccf     $eccf
 lecef     $ecef
 lf7cf     $f7cf
 led04     $ed04
 lecf2     $ecf2
 led13     $ed13
 led21     $ed21
 led2c     $ed2c
 led22     $ed22
 led3b     $ed3b
 led47     $ed47
 lee0b     $ee0b
 led5d     $ed5d
 led7f     $ed7f
 led6b     $ed6b
 ledcb     $edcb
 led53     $ed53
 led51     $ed51
 led7e     $ed7e
 led8c     $ed8c
 leda2     $eda2
 ledd5     $edd5
 lede6     $ede6
 led6d     $ed6d
 lee06     $ee06
 lee08     $ee08
 lf825     $f825
 ledef     $edef
 lee13     $ee13
 lebef     $ebef
 lee5c     $ee5c
 lee95     $ee95
 lee6b     $ee6b
 lee81     $ee81
 lee50     $ee50
 lee7e     $ee7e
 ledda     $edda
 lee79     $ee79
 lef18     $ef18
 leec4     $eec4
 lef70     $ef70
 leeb4     $eeb4
 lef39     $ef39
 leee7     $eee7
 leefb     $eefb
 leef6     $eef6
 lef6f     $ef6f
 lef3c     $ef3c
 lef36     $ef36
 lef3d     $ef3d
 lef4e     $ef4e
 lef20     $ef20
 lef9c     $ef9c
 lef83     $ef83
 lefa8     $efa8
 lf7d7     $f7d7
 lefff     $efff
 le700     $e700
 lf06e     $f06e
 led06     $ed06
 lefcf     $efcf
 lf037     $f037
 lf76c     $f76c
 lf068     $f068
 lf964     $f964
 lf109     $f109
 lf0c3     $f0c3
 lf0bf     $f0bf
 lf0b2     $f0b2
 lf0c4     $f0c4
 lf0d0     $f0d0
 lf0e1     $f0e1
 lf28c     $f28c
 lf0ec     $f0ec
 lf116     $f116
 lf12b     $f12b
 lf120     $f120
 lf0e9     $f0e9
 lf10b     $f10b
 lf160     $f160
 lf1cd     $f1cd
 lf157     $f157
 lf174     $f174
 lf179     $f179
 lf1c7     $f1c7
 lf16c     $f16c
 lf190     $f190
 lf20c     $f20c
 lf181     $f181
 lf1b8     $f1b8
 lf1c2     $f1c2
 lf185     $f185
 lf1ba     $f1ba
 lf1fc     $f1fc
 lf1e2     $f1e2
 lf1ec     $f1ec
 lf207     $f207
 le1d6     $e1d6
 lf13f     $f13f
 lf261     $f261
 lf290     $f290
 leacf     $eacf
 lf29d     $f29d
 lf294     $f294
 lf2a6     $f2a6
 lf2da     $f2da
 lf2d9     $f2d9
 lf2ef     $f2ef
 lf3a5     $f3a5
 lf098     $f098
 lf363     $f363
 lf310     $f310
 lf329     $f329
 lf30a     $f30a
 lf34c     $f34c
 lf311     $f311
 lf312     $f312
 lf39c     $f39c
 lf386     $f386
 lefc4     $efc4
 lf2a7     $f2a7
 lf383     $f383
 ledf5     $edf5
 lf3b9     $f3b9
 lf4e5     $f4e5
 lf3d1     $f3d1
 lf3fc     $f3fc
 lf3f0     $f3f0
 lf435     $f435
 lf3f6     $f3f6
 lf439     $f439
 lf641     $f641
 lf463     $f463
 lf56f     $f56f
 lf49c     $f49c
 lf468     $f468
 lf441     $f441
 lf48c     $f48c
 lf490     $f490
 lf45b     $f45b
 lf586     $f586
 lf4ec     $f4ec
 lf4a8     $f4a8
 lf4c9     $f4c9
 lf52b     $f52b
 lf50f     $f50f
 lf4cd     $f4cd
 lf51c     $f51c
 lf505     $f505
 lf52a     $f52a
 lf558     $f558
 lf557     $f557
 lf55f     $f55f
 lf58e     $f58e
 lf582     $f582
 lf57c     $f57c
 lf5b8     $f5b8
 lf5bb     $f5bb
 lf6be     $f6be
 lf449     $f449
 lfb62     $fb62
 lf906     $f906
 lf640     $f640
 lf667     $f667
 lf616     $f616
 lf61b     $f61b
 lf730     $f730
 lf55d     $f55d
 lf634     $f634
 lf61e     $f61e
 lf68a     $f68a
 lf674     $f674
 lf68f     $f68f
 lf67f     $f67f
 lf4e9     $f4e9
 lf79f     $f79f
 lf6a8     $f6a8
 lf470     $f470
 lf6c1     $f6c1
 lf72b     $f72b
 lf6e8     $f6e8
 lf6f5     $f6f5
 lf71b     $f71b
 lf71f     $f71f
 lf704     $f704
 lf6d8     $f6d8
 lf6f8     $f6f8
 lf795     $f795
 lf7a4     $f7a4
 lf7ad     $f7ad
 lf54d     $f54d
 lf51e     $f51e
 lf7cb     $f7cb
 lf4c4     $f4c4
 lf7c2     $f7c2
 lf81c     $f81c
 lf844     $f844
 lf822     $f822
 lf7c4     $f7c4
 lf873     $f873
 lf839     $f839
 lf531     $f531
 lf845     $f845
 lf87a     $f87a
 lf87f     $f87f
 lf895     $f895
 lf88e     $f88e
 lf892     $f892
 lf897     $f897
 lf8f2     $f8f2
 lf8c9     $f8c9
 lf8cf     $f8cf
 lf8bb     $f8bb
 lf8b6     $f8b6
 lf8b8     $f8b8
 lf8bd     $f8bd
 lf919     $f919
 lf8d1     $f8d1
 lf8ea     $f8ea
 lf8e3     $f8e3
 lf6ad     $f6ad
 lf8da     $f8da
 lf692     $f692
 lf8ef     $f8ef
 lfae3     $fae3
 lf8f9     $f8f9
 lf928     $f928
 lf936     $f936
 lf95f     $f95f
 lf7dc     $f7dc
 lf96c     $f96c
 lf97d     $f97d
 lfa7d     $fa7d
 lf985     $f985
 lf98e     $f98e
 lf5ef     $f5ef
 lf9b7     $f9b7
 lf9ad     $f9ad
 lf9a6     $f9a6
 lf9b4     $f9b4
 lf99b     $f99b
 lf990     $f990
 lf442     $f442
 lf9cc     $f9cc
 lf9cd     $f9cd
 lf9d8     $f9d8
 lf9eb     $f9eb
 lf9e9     $f9e9
 lfa0c     $fa0c
 lf9ef     $f9ef
 lfa0e     $fa0e
 lfa15     $fa15
 lfa2f     $fa2f
 lfa3f     $fa3f
 lfa4c     $fa4c
 lfa80     $fa80
 lfa5c     $fa5c
 lfa68     $fa68
 lfa85     $fa85
 lfa94     $fa94
 lfb0f     $fb0f
 lfab3     $fab3
 lf4e7     $f4e7
 lfacd     $facd
 lf856     $f856
 lf791     $f791
 lf5b1     $f5b1
 lfaed     $faed
 lfa83     $fa83
 lfa88     $fa88
 lfb1f     $fb1f
 lf7b6     $f7b6
 lf7a2     $f7a2
 lfb2d     $fb2d
 lf684     $f684
 lfb2a     $fb2a
 lfb3d     $fb3d
 lf44c     $f44c
 lfb78     $fb78
 lf669     $f669
 lf762     $f762
 lfb7c     $fb7c
 lf75f     $f75f
 lfb8b     $fb8b
 lfb9c     $fb9c
 lfb8f     $fb8f
 lfbd2     $fbd2
 lfbab     $fbab
 lf6b6     $f6b6
 lfc29     $fc29
 lfc2c     $fc2c
 lfc39     $fc39
 lfbf7     $fbf7
 lfbed     $fbed
 lfc68     $fc68
 lfc95     $fc95
 lfca3     $fca3
 lfcb6     $fcb6
 lfcbc     $fcbc
 lfce8     $fce8
 lfcf9     $fcf9
 lfce2     $fce2
 lfd42     $fd42
 lfcfe     $fcfe
 lfd9e     $fd9e
 lfd8d     $fd8d
 lfdaa     $fdaa
 lfd87     $fd87
 lfde6     $fde6
 lfdb6     $fdb6
 lfdd9     $fdd9
 lfdf9     $fdf9
 le463     $e463
 lfeca     $feca
 lff11     $ff11
 lff15     $ff15
 lff0a     $ff0a
 lff27     $ff27
 lff00     $ff00
 lfd05     $fd05
 lff2b     $ff2b
 lff47     $ff47
 lff54     $ff54
