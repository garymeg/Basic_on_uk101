                            * = $f800                                                    
    .byte $0b                 // f800   0b          //%00001011                                                   
    sed                       // f801   f8                                             
    .byte $0b                 // f802   0b          //%00001011                                                   
    .byte $0b                 // f803   0b          //%00001011                                                   
    asl                       // f804   0a                                               
    asl                       // f805   0a                                               
    asl                       // f806   0a                                               
    ora $2020                 // f807   0d 20 20                                             
    .byte $0b                 // f80a   0b          //%00001011                                                   
    txa                       // f80b   8a                                             
    pha                       // f80c   48                                             
    tya                       // f80d   98                                             
    pha                       // f80e   48                                             
    lda $e3                   // f80f   a5 e3                                              
    pha                       // f811   48                                             
    lda $e4                   // f812   a5 e4                                              
    pha                       // f814   48                                             
    lda $0207                 // f815   ad 07 02                                             
    sta $0209                 // f818   8d 09 02                                             
    lda $0208                 // f81b   ad 08 02                                             
    sta $020a                 // f81e   8d 0a 02                                             
    ldx #$08                  // f821   a2 08                                                
!Loop:
      
    lda $f802,x             // f823   bd 02 f8                                               
    jsr SUB_1               // f826   20 57 fa                                             
    dex                     // f829   ca                                             
    bpl !Loop-              // f82a   10 f7                                                
!Loop:
    jsr $f9e7                 // f82c   20 e7 f9                                             
    bne !Loop-              // f82f   d0 fb                                                
!Loop:
    dex                       // f831   ca                                             
    bne !Loop-              // f832   d0 fd                                                
!Loop:
    jsr $f9a5                 // f834   20 a5 f9                                             
    and #$ff                // f837   29 ff                                                
    bmi !Loop-              // f839   30 f9                                                
    cmp #$0c                  // f83b   c9 0c                                                
    beq !Loop-                // f83d   f0 f5                                                
    cmp #$1c                  // f83f   c9 1c                                                
    bne !Skip+                 // f841   d0 05                                                
    jsr $f924                 // f843   20 24 f9                                             
    bpl !Loop-                 // f846   10 ec                                                
!Skip:
    cmp #$0d                  // f848   c9 0d                                                
    beq !Skip++                 // f84a   f0 0f                                                
    bpl !Skip+                 // f84c   10 05                                                
    jsr $fa57                 // f84e   20 57 fa                                             
    bpl !Loop-                 // f851   10 e1                                                
!Skip:
    jsr $f903                 // f853   20 03 f9                                             
    jsr $fa57                 // f856   20 57 fa                                             
    bpl !Loop-                 // f859   10 d9                                                
!Skip:
    jsr $fb17                 // f85b   20 17 fb                                             
    dec $0208                 // f85e   ce 08 02                                             
    sty $0207                 // f861   8c 07 02                                             
    jsr $fb8d                 // f864   20 8d fb                                             
!Loop:
    lda ($e3),y               // f867   b1 e3                                                  
    cmp #$20                  // f869   c9 20                                                
    bne !Skip+                 // f86b   d0 08                                                
    iny                       // f86d   c8                                             
    cpy #$30                  // f86e   c0 30                                                
    bne !Loop-                 // f870   d0 f5                                                
    inc $0208                 // f872   ee 08 02                                             
!Skip:
    ldy #$00                  // f875   a0 00                                                
    jsr $fb8d                 // f877   20 8d fb                                             
    lda ($e3),y               // f87a   b1 e3                                                  
    cmp #$20                  // f87c   c9 20                                                
    beq $f896                 // f87e   f0 16                                                
    inc $0208                 // f880   ee 08 02                                             
    lda #$2e                  // f883   a9 2e                                                
    sta $0207                 // f885   8d 07 02                                             
    ldx #$60                  // f888   a2 60                                                
!loop:
    jsr $f8ed                 // f88a   20 ed f8                                             
    dex                       // f88d   ca                                             
    bne !Loop-                 // f88e   d0 fa                                                
    jsr $f9f2                 // f890   20 f2 f9                                             
    jsr $f9f2                 // f893   20 f2 f9                                             
lf896:
    jsr $f9f2                 // f896   20 f2 f9                                             
    lda $0207                 // f899   ad 07 02                                             
    pha                       // f89c   48                                             
    lda $0208                 // f89d   ad 08 02                                             
    pha                       // f8a0   48                                             
    inc $0208                 // f8a1   ee 08 02                                             
    lda #$2f                  // f8a4   a9 2f                                                
    sta $0207                 // f8a6   8d 07 02                                             
    ldx #$5f                  // f8a9   a2 5f                                                
!Loop:
    jsr $fb8d                 // f8ab   20 8d fb                                             
    lda ($e3),y               // f8ae   b1 e3                                                  
    cmp #$20                  // f8b0   c9 20                                                
    bne !Skip+                 // f8b2   d0 07                                                
    jsr $fa05                 // f8b4   20 05 fa                                             
    dex                       // f8b7   ca                                             
    bne !Loop-                 // f8b8   d0 f1                                                
    inx                       // f8ba   e8                                             
!Skip:
    cpx #$48                  // f8bb   e0 48                                                
    bmi !Skip+                 // f8bd   30 02                                                
    ldx #$47                  // f8bf   a2 47                                                
!Skip:
    stx $020b                 // f8c1   8e 0b 02                                             
    pla                       // f8c4   68                                             
    sta $0208                 // f8c5   8d 08 02                                             
    pla                       // f8c8   68                                             
    sta $0207                 // f8c9   8d 07 02                                             
    jsr $fb8d                 // f8cc   20 8d fb                                             
    lda ($e3),y               // f8cf   b1 e3                                                  
    sta $0201                 // f8d1   8d 01 02                                             
    ldx #$03                  // f8d4   a2 03                                                
!Loop:
    lda $ff67,x               // f8d6   bd 67 ff                                               
    sta $0218,x               // f8d9   9d 18 02                                               
    dex                       // f8dc   ca                                             
    bpl !Loop-                 // f8dd   10 f7                                                
    pla                       // f8df   68                                             
    sta $e4                   // f8e0   85 e4                                              
    pla                       // f8e2   68                                             
    sta $e3                   // f8e3   85 e3                                              
    pla                       // f8e5   68                                             
    tay                       // f8e6   a8                                             
    pla                       // f8e7   68                                             
    tax                       // f8e8   aa                                             
    lda $0201                 // f8e9   ad 01 02                                             
    rts                       // f8ec   60                                             

lf8ed:
    jsr $fb8d                 // f8ed   20 8d fb                                             
    lda ($e3),y               // f8f0   b1 e3                                                  
    pha                       // f8f2   48                                             
    jsr $f9f2                 // f8f3   20 f2 f9                                             
    jsr $fb8d                 // f8f6   20 8d fb                                             
    pla                       // f8f9   68                                             
    sta ($e3),y               // f8fa   91 e3                                                  
    jsr $fa05                 // f8fc   20 05 fa                                             
    jsr $fa05                 // f8ff   20 05 fa                                             
    rts                       // f902   60      

lf903:
    pha                       // f903   48                                             
    jsr $fb17                 // f904   20 17 fb                                             
    ldx #$47                  // f907   a2 47                                                
lf909:
    jsr $f9f2                 // f909   20 f2 f9                                             
    dex                       // f90c   ca                                             
    bne $f909                 // f90d   d0 fa                                                
    ldx #$47                  // f90f   a2 47                                                
lf911:
    jsr $f8ed                 // f911   20 ed f8                                             
    dex                       // f914   ca                                             
    bpl $f911                 // f915   10 fa                                                
    jsr $f9f2                 // f917   20 f2 f9                                             
lf91a:
    jsr $fb8d                 // f91a   20 8d fb                                             
    lda ($e3),y               // f91d   b1 e3                                                  
    sta $0201                 // f91f   8d 01 02                                             
    pla                       // f922   68                                             
    rts                       // f923   60    

lf924:
    lda $0207                 // f924   ad 07 02                                             
    pha                       // f927   48                                             
    lda $0208                 // f928   ad 08 02                                             
    pha                       // f92b   48                                             
    jsr $fb17                 // f92c   20 17 fb                                             
    ldx #$47                  // f92f   a2 47                                                
lf931:
    jsr $f9f2                 // f931   20 f2 f9                                             
    jsr $fb8d                 // f934   20 8d fb                                             
    lda ($e3),y               // f937   b1 e3                                                  
    pha                       // f939   48                                             
    jsr $fa05                 // f93a   20 05 fa                                             
    jsr $fb8d                 // f93d   20 8d fb                                             
    pla                       // f940   68                                             
    sta ($e3),y               // f941   91 e3                                                  
    jsr $f9f2                 // f943   20 f2 f9                                             
    dex                       // f946   ca                                             
    bpl $f931                 // f947   10 e8                                                
    pla                       // f949   68                                             
    sta $0208                 // f94a   8d 08 02                                             
    pla                       // f94d   68                                             
    sta $0207                 // f94e   8d 07 02                                             
    pha                       // f951   48                                             
    jmp $f91a                 // f952   4c 1a f9                                             
    cpx $020b                 // f955   ec 0b 02                                             
    beq $f97f                 // f958   f0 25                                                
    txa                       // f95a   8a                                             
    pha                       // f95b   48                                             
    tya                       // f95c   98                                             
    pha                       // f95d   48                                             
    lda $e3                   // f95e   a5 e3                                              
    pha                       // f960   48                                             
    lda $e4                   // f961   a5 e4                                              
    pha                       // f963   48                                             
    jsr $f9f2                 // f964   20 f2 f9                                             
    jsr $fb8d                 // f967   20 8d fb                                             
    ldy #$00                  // f96a   a0 00                                                
    lda ($e3),y               // f96c   b1 e3                                                  
    sta $0200                 // f96e   8d 00 02                                             
lf971:
    pla                       // f971   68                                             
    sta $e4                   // f972   85 e4                                              
    pla                       // f974   68                                             
    sta $e3                   // f975   85 e3                                              
    pla                       // f977   68                                             
    tay                       // f978   a8                                             
    pla                       // f979   68                                             
    tax                       // f97a   aa                                             
    lda $0200                 // f97b   ad 00 02                                             
    rts                       // f97e   60   

lf97f:
    tya                       // f97f   98                                             
    pha                       // f980   48                                             
    lda $0209                 // f981   ad 09 02                                             
    sta $0207                 // f984   8d 07 02                                             
    lda $020a                 // f987   ad 0a 02                                             
    sta $0208                 // f98a   8d 08 02                                             
    dec $0208                 // f98d   ce 08 02                                             
    lda #$20                  // f990   a9 20                                                
    sta $0201                 // f992   8d 01 02                                             
    ldy #$03                  // f995   a0 03                                                
lf997:
    lda $fef0,y               // f997   b9 f0 fe                                               
    sta $0218,y               // f99a   99 18 02                                               
    dey                       // f99d   88                                             
    bpl $f997                 // f99e   10 f7                                                
    pla                       // f9a0   68                                             
    tay                       // f9a1   a8                                             
    lda #$0d                  // f9a2   a9 0d                                                
    rts                       // f9a4   60     

lf9a5:
    ldy #$01                  // f9a5   a0 01                                                
lf9a7:
    sty $e3                   // f9a7   84 e3                                              
    ldy $0210                 // f9a9   ac 10 02                                             
lf9ac:
    ldx #$50                  // f9ac   a2 50                                                
lf9ae:
    jsr $f9e7                 // f9ae   20 e7 f9                                             
    bne $f9d0                 // f9b1   d0 1d                                                
    dex                       // f9b3   ca                                             
    bne $f9ae                 // f9b4   d0 f8                                                
    dey                       // f9b6   88                                             
    bne $f9ac                 // f9b7   d0 f3                                                
    lda $e3                   // f9b9   a5 e3                                              
    bne $f9cb                 // f9bb   d0 0e                                                
    jsr $fb8d                 // f9bd   20 8d fb                                             
    lda ($e3),y               // f9c0   b1 e3                                                  
    sta $0201                 // f9c2   8d 01 02                                             
    lda #$9a                  // f9c5   a9 9a                                                
    sta ($e3),y               // f9c7   91 e3                                                  
    bne $f9a5                 // f9c9   d0 da                                                
lf9cb:
    jsr $fb17                 // f9cb   20 17 fb                                             
    beq $f9a7                 // f9ce   f0 d7                                                
lf9d0:
    jsr $f9e0                 // f9d0   20 e0 f9                                             
lf9d3:
    pha                       // f9d3   48                                             
lf9d4:
    jsr $f9e7                 // f9d4   20 e7 f9                                             
    bne $f9d4                 // f9d7   d0 fb                                                
    ldx #$00                  // f9d9   a2 00                                                
lf9db:
    dex                       // f9db   ca                                             
    bne $f9db                 // f9dc   d0 fd                                                
    pla                       // f9de   68                                             
    rts                       // f9df   60     

lf9e0:
    txa                       // f9e0   8a                                             
    pha                       // f9e1   48                                             
    tya                       // f9e2   98                                             
    pha                       // f9e3   48                                             
    jmp $fd66                 // f9e4   4c 66 fd                                             
lf9e7:
    lda #$01                  // f9e7   a9 01                                                
    sta $df00                 // f9e9   8d 00 df                                             
    lda $df00                 // f9ec   ad 00 df                                             
    eor #$ff                  // f9ef   49 ff                                                
    rts                       // f9f1   60     

lf9f2:
    inc $0207                 // f9f2   ee 07 02                                             
    lda $0207                 // f9f5   ad 07 02                                             
    cmp #$30                  // f9f8   c9 30                                                
    bmi $fa04                 // f9fa   30 08                                                
    inc $0208                 // f9fc   ee 08 02                                             
lf9ff:
    lda #$00                  // f9ff   a9 00                                                
    sta $0207                 // fa01   8d 07 02                                             
lfa04:
    rts                       // fa04   60    

lfa05:
    dec $0207                 // fa05   ce 07 02                                             
    bpl $fa12                 // fa08   10 08                                                
    dec $0208                 // fa0a   ce 08 02                                             
    lda #$2f                  // fa0d   a9 2f                                                
    sta $0207                 // fa0f   8d 07 02                                             
lfa12:
    rts                       // fa12   60     

lfa13:
    jsr $ffba                 // fa13   20 ba ff                                             
    cmp #$05                  // fa16   c9 05                                                
    bne $fa1d                 // fa18   d0 03                                                
    jmp $ff53                 // fa1a   4c 53 ff                                             
lfa1d:
    cmp #$1c                  // fa1d   c9 1c                                                
    beq $fa2a                 // fa1f   f0 09                                                
    cmp #$0c                  // fa21   c9 0c                                                
    bne $fa2e                 // fa23   d0 09                                                
    jsr $fa57                 // fa25   20 57 fa                                             
    bpl $fa13                 // fa28   10 e9                                                
lfa2a:
    dex                       // fa2a   ca                                             
    bpl $fa2f                 // fa2b   10 02                                                
    inx                       // fa2d   e8                                             
lfa2e:
    rts                       // fa2e   60    

lfa2f:
    dec $0e                   // fa2f   c6 0e                                              
    tya                       // fa31   98                                             
    pha                       // fa32   48                                             
    lda $e3                   // fa33   a5 e3                                              
    pha                       // fa35   48                                             
    lda $e4                   // fa36   a5 e4                                              
    pha                       // fa38   48                                             
    jsr $fb8d                 // fa39   20 8d fb                                             
    lda #$20                  // fa3c   a9 20                                                
    jsr $fb1d                 // fa3e   20 1d fb                                             
    jsr $fa05                 // fa41   20 05 fa                                             
    jsr $fb8d                 // fa44   20 8d fb                                             
    lda #$9a                  // fa47   a9 9a                                                
    jsr $fb1d                 // fa49   20 1d fb                                             
    pla                       // fa4c   68                                             
    sta $e4                   // fa4d   85 e4                                              
    pla                       // fa4f   68                                             
    sta $e3                   // fa50   85 e3                                              
    pla                       // fa52   68                                             
    tay                       // fa53   a8                                             
    clc                       // fa54   18                                             
    bcc $fa13                 // fa55   90 bc                                                
SUB_1:
    sta $0202                 // fa57   8d 02 02                                             
    txa                       // fa5a   8a                                             
    pha                       // fa5b   48                                             
    tya                       // fa5c   98                                             
    pha                       // fa5d   48                                             
    ldx #$04                  // fa5e   a2 04                                                
lfa60:
    lda $e2,x                 // fa60   b5 e2                                                
    pha                       // fa62   48                                             
    dex                       // fa63   ca                                             
    bne $fa60                 // fa64   d0 fa                                                
    lda $0202                 // fa66   ad 02 02                                             
    bne $fa6e                 // fa69   d0 03                                                
    jmp $fb05                 // fa6b   4c 05 fb                                             
lfa6e:
    ldy $0206                 // fa6e   ac 06 02                                             
    beq $fa7b                 // fa71   f0 08                                                
lfa73:
    ldx #$40                  // fa73   a2 40                                                
lfa75:
    dex                       // fa75   ca                                             
    bne $fa75                 // fa76   d0 fd                                                
    dey                       // fa78   88                                             
    bne $fa73                 // fa79   d0 f8                                                
lfa7b:
    cmp #$09                  // fa7b   c9 09                                                
    bne $fa8e                 // fa7d   d0 0f                                                
    jsr $fb17                 // fa7f   20 17 fb                                             
    lda #$2f                  // fa82   a9 2f                                                
    cmp $0207                 // fa84   cd 07 02                                             
    beq $fa8c                 // fa87   f0 03                                                
    inc $0207                 // fa89   ee 07 02                                             
lfa8c:
    bpl $faf7                 // fa8c   10 69                                                
lfa8e:
    cmp #$08                  // fa8e   c9 08                                                
    bne $fa9f                 // fa90   d0 0d                                                
    jsr $fb17                 // fa92   20 17 fb                                             
    lda $0207                 // fa95   ad 07 02                                             
    beq $fa9d                 // fa98   f0 03                                                
    dec $0207                 // fa9a   ce 07 02                                             
lfa9d:
    bpl $faf7                 // fa9d   10 58                                                
lfa9f:
    cmp #$0b                  // fa9f   c9 0b                                                
    bne $fab0                 // faa1   d0 0d                                                
    jsr $fb17                 // faa3   20 17 fb                                             
    lda $0208                 // faa6   ad 08 02                                             
    beq $faae                 // faa9   f0 03                                                
    dec $0208                 // faab   ce 08 02                                             
lfaae:
    bpl $faf7                 // faae   10 47                                                
lfab0:
    cmp #$0d                  // fab0   c9 0d                                                
    bne $fabc                 // fab2   d0 08                                                
    jsr $fb17                 // fab4   20 17 fb                                             
    jsr $f9ff                 // fab7   20 ff f9                                             
    bpl $faf7                 // faba   10 3b                                                
lfabc:
    cmp #$0a                  // fabc   c9 0a                                                
    bne $fad2                 // fabe   d0 12                                                
    jsr $fb17                 // fac0   20 17 fb                                             
    inc $0208                 // fac3   ee 08 02                                             
    ldx $0208                 // fac6   ae 08 02                                             
    cpx #$10                  // fac9   e0 10                                                
    bmi $faf7                 // facb   30 2a                                                
    jsr $fb3a                 // facd   20 3a fb                                             
    beq $faf7                 // fad0   f0 25                                                
lfad2:
    cmp #$0c                  // fad2   c9 0c                                                
    bne $fae1                 // fad4   d0 0b                                                
    jsr $fb22                 // fad6   20 22 fb                                             
    jsr $f9ff                 // fad9   20 ff f9                                             
    sta $0208                 // fadc   8d 08 02                                             
    beq $faf7                 // fadf   f0 16                                                
lfae1:
    jsr $fb8d                 // fae1   20 8d fb                                             
    lda $0202                 // fae4   ad 02 02                                             
    jsr $fb1d                 // fae7   20 1d fb                                             
    jsr $f9f2                 // faea   20 f2 f9                                             
    ldx $0208                 // faed   ae 08 02                                             
    cpx #$10                  // faf0   e0 10                                                
    bmi $faf7                 // faf2   30 03                                                
    jsr $fb3a                 // faf4   20 3a fb                                             
lfaf7:
    jsr $fb8d                 // faf7   20 8d fb                                             
    ldy #$00                  // fafa   a0 00                                                
    lda ($e3),y               // fafc   b1 e3                                                  
    sta $0201                 // fafe   8d 01 02                                             
    lda #$9a                  // fb01   a9 9a                                                
    sta ($e3),y               // fb03   91 e3                                                  
lfb05:
    ldx #$01                  // fb05   a2 01                                                
lfb07:
    pla                       // fb07   68                                             
    sta $e2,x                 // fb08   95 e2                                                
    inx                       // fb0a   e8                                             
    cpx #$05                  // fb0b   e0 05                                                
    bne $fb07                 // fb0d   d0 f8                                                
    pla                       // fb0f   68                                             
    tay                       // fb10   a8                                             
    pla                       // fb11   68                                             
    tax                       // fb12   aa                                             
    lda $0202                 // fb13   ad 02 02                                             
    rts                       // fb16   60 

lfb17:
    jsr $fb8d                 // fb17   20 8d fb                                             
    lda $0201                 // fb1a   ad 01 02                                             
lfb1d:
    ldy #$00                  // fb1d   a0 00                                                
    sta ($e3),y               // fb1f   91 e3                                                  
    rts                       // fb21   60 

lfb22:
    ldy #$00                  // fb22   a0 00                                                
    sty $e3                   // fb24   84 e3                                              
    lda #$d0                  // fb26   a9 d0                                                
    sta $e4                   // fb28   85 e4                                              
    lda #$20                  // fb2a   a9 20                                                
    ldx #$d4                  // fb2c   a2 d4                                                
lfb2e:
    sta ($e3),y               // fb2e   91 e3                                                  
    iny                       // fb30   c8                                             
    bne $fb2e                 // fb31   d0 fb                                                
    inc $e4                   // fb33   e6 e4                                              
    cpx $e4                   // fb35   e4 e4                                              
    bne $fb2e                 // fb37   d0 f5                                                
    rts                       // fb39   60 

lfb3a:
    jsr $fb60                 // fb3a   20 60 fb                                             
    jsr $fb4c                 // fb3d   20 4c fb                                             
    ldy $0208                 // fb40   ac 08 02                                             
    cpy #$00                  // fb43   c0 00                                                
    beq $fb4b                 // fb45   f0 04                                                
    dex                       // fb47   ca                                             
    inx                       // fb48   e8                                             
    bne $fb3a                 // fb49   d0 ef                                                
lfb4b:
    rts                       // fb4b   60 

lfb4c:
    ldx #$00                  // fb4c   a2 00                                                
lfb4e:
    lda $d000,x               // fb4e   bd 00 d0                                               
    cmp #$20                  // fb51   c9 20                                                
    bne $fb5d                 // fb53   d0 08                                                
    inx                       // fb55   e8                                             
    cpx #$40                  // fb56   e0 40                                                
    bne $fb4e                 // fb58   d0 f4                                                
    ldx #$ff                  // fb5a   a2 ff                                                
    rts                       // fb5c   60   

lfb5d:
    ldx #$00                  // fb5d   a2 00                                                
    rts                       // fb5f   60   

lfb60:
    ldx #$d4                  // fb60   a2 d4                                                
    ldy #$00                  // fb62   a0 00                                                
    sty $e3                   // fb64   84 e3                                              
    lda #$d0                  // fb66   a9 d0                                                
    sta $e4                   // fb68   85 e4                                              
    sta $e6                   // fb6a   85 e6                                              
    lda #$40                  // fb6c   a9 40                                                
    sta $e5                   // fb6e   85 e5                                              
lfb70:
    lda ($e5),y               // fb70   b1 e5                                                  
    sta ($e3),y               // fb72   91 e3                                                  
    iny                       // fb74   c8                                             
    bne $fb70                 // fb75   d0 f9                                                
    inc $e4                   // fb77   e6 e4                                              
    inc $e6                   // fb79   e6 e6                                              
    cpx $e6                   // fb7b   e4 e6                                              
    bne $fb70                 // fb7d   d0 f1                                                
    ldx #$40                  // fb7f   a2 40                                                
    lda #$20                  // fb81   a9 20                                                
lfb83:
    sta $d3bf,x               // fb83   9d bf d3                                               
    dex                       // fb86   ca                                             
    bne $fb83                 // fb87   d0 fa                                                
    dec $0208                 // fb89   ce 08 02                                             
    rts                       // fb8c   60

lfb8d:
    lda #$00                  // fb8d   a9 00                                                
    sta $e4                   // fb8f   85 e4                                              
    lda $0208                 // fb91   ad 08 02                                             
    asl                       // fb94   0a                                               
    asl                       // fb95   0a                                               
    asl                       // fb96   0a                                               
    asl                       // fb97   0a                                               
    asl                       // fb98   0a                                               
    rol $e4                   // fb99   26 e4                                              
    asl                       // fb9b   0a                                               
    rol $e4                   // fb9c   26 e4                                              
    adc $0207                 // fb9e   6d 07 02                                             
    adc #$0d                  // fba1   69 0d                                                
    sta $e3                   // fba3   85 e3                                              
    lda $e4                   // fba5   a5 e4                                              
    adc #$d0                  // fba7   69 d0                                                
    sta $e4                   // fba9   85 e4                                              
    rts                       // fbab   60   

    lda $020e                 // fbac   ad 0e 02                                             
    bne $fbc3                 // fbaf   d0 12                                                
    lda $020d                 // fbb1   ad 0d 02                                             
    bne $fbb9                 // fbb4   d0 03                                                
    jmp $fa13                 // fbb6   4c 13 fa                                             
lfbb9:
    inc $020e                 // fbb9   ee 0e 02                                             
lfbbc:
    jsr $fe6d                 // fbbc   20 6d fe                                             
    cmp #$02                  // fbbf   c9 02                                                
    bne $fbbc                 // fbc1   d0 f9                                                
lfbc3:
    jsr $fe6d                 // fbc3   20 6d fe                                             
    cmp #$03                  // fbc6   c9 03                                                
    beq $fbcb                 // fbc8   f0 01                                                
    rts                       // fbca   60    

lfbcb:
    lda #$0d                  // fbcb   a9 0d                                                
    dec $020e                 // fbcd   ce 0e 02                                             
    dec $020d                 // fbd0   ce 0d 02                                             
    rts                       // fbd3   60     

    cmp #$0d                  // fbd4   c9 0d                                                
    beq $fc03                 // fbd6   f0 2b                                                
    cmp #$01                  // fbd8   c9 01                                                
    beq $fc23                 // fbda   f0 47                                                
    cmp #$02                  // fbdc   c9 02                                                
    bne $fbfd                 // fbde   d0 1d                                                
    pha                       // fbe0   48                                             
    txa                       // fbe1   8a                                             
    pha                       // fbe2   48                                             
    tsx                       // fbe3   ba                                             
    lda $0104,x               // fbe4   bd 04 01                                               
    cmp #$a8                  // fbe7   c9 a8                                                
    bne $fbfa                 // fbe9   d0 0f                                                
    lda $0e                   // fbeb   a5 0e                                              
    bne $fbfa                 // fbed   d0 0b                                                
    inc $0205                 // fbef   ee 05 02                                             
    inc $020c                 // fbf2   ee 0c 02                                             
    pla                       // fbf5   68                                             
    tax                       // fbf6   aa                                             
    pla                       // fbf7   68                                             
    bne $fc00                 // fbf8   d0 06                                                
lfbfa:
    pla                       // fbfa   68                                             
    tax                       // fbfb   aa                                             
lfbfc:
    pla                       // fbfc   68                                             
lfbfd:
    jsr $fa57                 // fbfd   20 57 fa                                             
lfc00:
    jmp $ff6c                 // fc00   4c 6c ff                                             
lfc03:
    pha                       // fc03   48                                             
    lda $020c                 // fc04   ad 0c 02                                             
    bne $fc0b                 // fc07   d0 02                                                
    beq $fbfc                 // fc09   f0 f1                                                
lfc0b:
    dec $0205                 // fc0b   ce 05 02                                             
    dec $020c                 // fc0e   ce 0c 02                                             
    lda #$03                  // fc11   a9 03                                                
    jsr $fcb1                 // fc13   20 b1 fc                                             
    pla                       // fc16   68                                             
    jsr $ff73                 // fc17   20 73 ff                                             
    pha                       // fc1a   48                                             
    lda #$0a                  // fc1b   a9 0a                                                
    jsr $fcb1                 // fc1d   20 b1 fc                                             
    pla                       // fc20   68                                             
    bne $fbfd                 // fc21   d0 da                                                
lfc23:
    pha                       // fc23   48                                             
    txa                       // fc24   8a                                             
    pha                       // fc25   48                                             
    tsx                       // fc26   ba                                             
    lda $0104,x               // fc27   bd 04 01                                               
    cmp #$a8                  // fc2a   c9 a8                                                
    bne $fbfa                 // fc2c   d0 cc                                                
    lda $0e                   // fc2e   a5 0e                                              
    bne $fbfa                 // fc30   d0 c8                                                
    inc $020d                 // fc32   ee 0d 02                                             
    pla                       // fc35   68                                             
    tax                       // fc36   aa                                             
    pla                       // fc37   68                                             
    rts                       // fc38   60    

lfc39:
    lda $fcac,x               // fc39   bd ac fc                                               
    beq $fc43                 // fc3c   f0 05                                                
    sta $13,x                 // fc3e   95 13                                                
    inx                       // fc40   e8                                             
    bne $fc39                 // fc41   d0 f6                                                
lfc43:
    jsr $ffeb                 // fc43   20 eb ff                                             
    cmp #$0d                  // fc46   c9 0d                                                
    beq $fc5a                 // fc48   f0 10                                                
    jsr $ffee                 // fc4a   20 ee ff                                             
    sta $13,x                 // fc4d   95 13                                                
    cmp #$30                  // fc4f   c9 30                                                
    bmi $fc73                 // fc51   30 20                                                
    cmp #$3a                  // fc53   c9 3a                                                
    bpl $fc73                 // fc55   10 1c                                                
    inx                       // fc57   e8                                             
    bne $fc43                 // fc58   d0 e9                                                
lfc5a:
    cpx #$04                  // fc5a   e0 04                                                
    beq $fc73                 // fc5c   f0 15                                                
    lda $f800                 // fc5e   ad 00 f8                                             
    sta $0218                 // fc61   8d 18 02                                             
    lda $f801                 // fc64   ad 01 f8                                             
    sta $0219                 // fc67   8d 19 02                                             
lfc6a:
    pla                       // fc6a   68                                             
    lda #$20                  // fc6b   a9 20                                                
    sta $0210                 // fc6d   8d 10 02                                             
    lda #$0d                  // fc70   a9 0d                                                
    rts                       // fc72   60     

lfc73:
    ldx #$00                  // fc73   a2 00                                                
    beq $fc6a                 // fc75   f0 f3                                                
    asl                       // fc77   0a                                               
    asl                       // fc78   0a                                               
    asl                       // fc79   0a                                               
    jsr $2820                 // fc7a   20 20 28                                             
    eor $6f29                 // fc7d   4d 29 6f                                             
    ror $7469                 // fc80   6e 69 74                                             
    .byte $6f                 // fc83   6f          //%01101111 'o'                                                   
    .byte $72                 // fc84   72          //%01110010 'r'                                                   
    jsr $2820                 // fc85   20 20 28                                             
    .byte $43                 // fc88   43          //%01000011 'C'                                                   
    and #$6f                  // fc89   29 6f                                                
    jmp ($2064)               // fc8b   6c 64 20                                               
    .byte $53                 // fc8e   53          //%01010011 'S'                                                   
    .byte $74                 // fc8f   74          //%01110100 't'                                                   
    adc ($72,x)               // fc90   61 72                                                  
    .byte $74                 // fc92   74          //%01110100 't'                                                   
    jsr $2820                 // fc93   20 20 28                                             
    .byte $57                 // fc96   57          //%01010111 'W'                                                   
    and #$61                  // fc97   29 61                                                
    .byte $72                 // fc99   72          //%01110010 'r'                                                   
    adc $5320                 // fc9a   6d 20 53                                             
    .byte $74                 // fc9d   74          //%01110100 't'                                                   
    adc ($72,x)               // fc9e   61 72                                                  
    .byte $74                 // fca0   74          //%01110100 't'                                                   
    ora $0a0a                 // fca1   0d 0a 0a                                             
    asl                       // fca4   0a                                               
    .byte $53                 // fca5   53          //%01010011 'S'                                                   
    adc $6c                   // fca6   65 6c                                              
    adc $63                   // fca8   65 63                                              
    .byte $74                 // fcaa   74          //%01110100 't'                                                   
    brk                       // fcab   00                                             
    jmp $5349                 // fcac   4c 49 53                                             
    .byte $54                 // fcaf   54          //%01010100 'T'                                                   
    brk                       // fcb0   00                                             
lfcb1:
    pha                       // fcb1   48                                             
lfcb2:
    lda $f000                 // fcb2   ad 00 f0                                             
    lsr                       // fcb5   4a                                               
    lsr                       // fcb6   4a                                               
    bcc $fcb2                 // fcb7   90 f9                                                
    pla                       // fcb9   68                                             
    sta $f001                 // fcba   8d 01 f0                                             
    rts                       // fcbd   60   

lfcbe:
    eor #$ff                  // fcbe   49 ff                                                
    sta $df00                 // fcc0   8d 00 df                                             
    eor #$ff                  // fcc3   49 ff                                                
    rts                       // fcc5   60    

lfcc6:
    pha                       // fcc6   48                                             
    jsr $fccf                 // fcc7   20 cf fc                                             
    tax                       // fcca   aa                                             
    pla                       // fccb   68                                             
    dex                       // fccc   ca                                             
    inx                       // fccd   e8                                             
    rts                       // fcce   60   

lfccf:
    lda $df00                 // fccf   ad 00 df                                             
    eor #$ff                  // fcd2   49 ff                                                
    rts                       // fcd4   60   

    cmp #$1c                  // fcd5   c9 1c                                                
    beq $fcdc                 // fcd7   f0 03                                                
    jmp $a374                 // fcd9   4c 74 a3                                             
lfcdc:
    jmp $a359                 // fcdc   4c 59 a3                                             
lfcdf:
    lda #$03                  // fcdf   a9 03                                                
    sta $f000                 // fce1   8d 00 f0                                             
    lda #$11                  // fce4   a9 11                                                
    sta $f000                 // fce6   8d 00 f0                                             
    rts                       // fce9   60    

lfcea:
    txa                       // fcea   8a                                             
    pha                       // fceb   48                                             
    tya                       // fcec   98                                             
    pha                       // fced   48                                             
    lda $e3                   // fcee   a5 e3                                              
    pha                       // fcf0   48                                             
    lda $e4                   // fcf1   a5 e4                                              
    pha                       // fcf3   48                                             
    jsr $f9d3                 // fcf4   20 d3 f9                                             
    jsr $f9a5                 // fcf7   20 a5 f9                                             
    sta $0200                 // fcfa   8d 00 02                                             
    jmp $f971                 // fcfd   4c 71 f9                                             
lfd00:
    txa                       // fd00   8a                                             
    pha                       // fd01   48                                             
    tya                       // fd02   98                                             
    pha                       // fd03   48                                             
lfd04:
    lda #$01                  // fd04   a9 01                                                
lfd06:
    jsr $fcbe                 // fd06   20 be fc                                             
    jsr $fcc6                 // fd09   20 c6 fc                                             
    bne $fd13                 // fd0c   d0 05                                                
lfd0e:
    asl                       // fd0e   0a                                               
    bne $fd06                 // fd0f   d0 f5                                                
    beq $fd66                 // fd11   f0 53                                                
lfd13:
    lsr                       // fd13   4a                                               
    bcc $fd1f                 // fd14   90 09                                                
    rol                       // fd16   2a                                               
    cpx #$21                  // fd17   e0 21                                                
    bne $fd0e                 // fd19   d0 f3                                                
    lda #$1b                  // fd1b   a9 1b                                                
    bne $fd40                 // fd1d   d0 21                                                
lfd1f:
    jsr $fdc8                 // fd1f   20 c8 fd                                             
    tya                       // fd22   98                                             
    sta $0213                 // fd23   8d 13 02                                             
    asl                       // fd26   0a                                               
    asl                       // fd27   0a                                               
    asl                       // fd28   0a                                               
    sec                       // fd29   38                                             
    sbc $0213                 // fd2a   ed 13 02                                             
    sta $0213                 // fd2d   8d 13 02                                             
    txa                       // fd30   8a                                             
    lsr                       // fd31   4a                                               
    jsr $fdc8                 // fd32   20 c8 fd                                             
    bne $fd66                 // fd35   d0 2f                                                
    clc                       // fd37   18                                             
    tya                       // fd38   98                                             
    adc $0213                 // fd39   6d 13 02                                             
    tay                       // fd3c   a8                                             
    lda $fdcf,y               // fd3d   b9 cf fd                                               
lfd40:
    cmp $0215                 // fd40   cd 15 02                                             
    bne $fd6b                 // fd43   d0 26                                                
    dec $0214                 // fd45   ce 14 02                                             
    beq $fd75                 // fd48   f0 2b                                                
    ldy #$05                  // fd4a   a0 05                                                
lfd4c:
    ldx #$c8                  // fd4c   a2 c8                                                
lfd4e:
    dex                       // fd4e   ca                                             
    bne $fd4e                 // fd4f   d0 fd                                                
    dey                       // fd51   88                                             
    bne $fd4c                 // fd52   d0 f8                                                
    beq $fd04                 // fd54   f0 ae                                                
lfd56:
    cmp #$01                  // fd56   c9 01                                                
    beq $fd8f                 // fd58   f0 35                                                
    ldy #$00                  // fd5a   a0 00                                                
    cmp #$02                  // fd5c   c9 02                                                
    beq $fda7                 // fd5e   f0 47                                                
    ldy #$c0                  // fd60   a0 c0                                                
    cmp #$20                  // fd62   c9 20                                                
    beq $fda7                 // fd64   f0 41                                                
lfd66:
    lda #$00                  // fd66   a9 00                                                
    sta $0216                 // fd68   8d 16 02                                             
lfd6b:
    sta $0215                 // fd6b   8d 15 02                                             
    lda #$02                  // fd6e   a9 02                                                
    sta $0214                 // fd70   8d 14 02                                             
    bne $fd04                 // fd73   d0 8f                                                
lfd75:
    ldx #$96                  // fd75   a2 96                                                
    cmp $0216                 // fd77   cd 16 02                                             
    bne $fd7e                 // fd7a   d0 02                                                
    ldx #$14                  // fd7c   a2 14                                                
lfd7e:
    stx $0214                 // fd7e   8e 14 02                                             
    sta $0216                 // fd81   8d 16 02                                             
    lda #$01                  // fd84   a9 01                                                
    jsr $fcbe                 // fd86   20 be fc                                             
    jsr $fccf                 // fd89   20 cf fc                                             
lfd8c:
    lsr                       // fd8c   4a                                               
    bcc $fdc2                 // fd8d   90 33                                                
lfd8f:
    tax                       // fd8f   aa                                             
    and #$03                  // fd90   29 03                                                
    beq $fd9f                 // fd92   f0 0b                                                
    ldy #$10                  // fd94   a0 10                                                
    lda $0215                 // fd96   ad 15 02                                             
    bpl $fda7                 // fd99   10 0c                                                
    ldy #$f0                  // fd9b   a0 f0                                                
    bne $fda7                 // fd9d   d0 08                                                
lfd9f:
    ldy #$00                  // fd9f   a0 00                                                
    cpx #$20                  // fda1   e0 20                                                
    bne $fda7                 // fda3   d0 02                                                
    ldy #$c0                  // fda5   a0 c0                                                
lfda7:
    lda $0215                 // fda7   ad 15 02                                             
    and #$7f                  // fdaa   29 7f                                                
    cmp #$20                  // fdac   c9 20                                                
    beq $fdb7                 // fdae   f0 07                                                
    sty $0213                 // fdb0   8c 13 02                                             
    clc                       // fdb3   18                                             
    adc $0213                 // fdb4   6d 13 02                                             
lfdb7:
    sta $0213                 // fdb7   8d 13 02                                             
    pla                       // fdba   68                                             
    tay                       // fdbb   a8                                             
    pla                       // fdbc   68                                             
    tax                       // fdbd   aa                                             
    lda $0213                 // fdbe   ad 13 02                                             
    rts                       // fdc1   60   

lfdc2:
    bne $fd56                 // fdc2   d0 92                                                
    ldy #$20                  // fdc4   a0 20                                                
    bne $fda7                 // fdc6   d0 df                                                
lfdc8:
    ldy #$08                  // fdc8   a0 08                                                
lfdca:
    dey                       // fdca   88                                             
    asl                       // fdcb   0a                                               
    bcc $fdca                 // fdcc   90 fc                                                
    rts                       // fdce   60  

    bne $fd8c                 // fdcf   d0 bb                                                
    .byte $2f                 // fdd1   2f          //%00101111 '/'                                                   
    jsr $415a                 // fdd2   20 5a 41                                             
    eor ($2c),y               // fdd5   51 2c                                                  
    eor $424e                 // fdd7   4d 4e 42                                             
    lsr $43,x                 // fdda   56 43                                                
    cli                       // fddc   58                                             
    .byte $4b                 // fddd   4b          //%01001011 'K'                                                   
    lsr                       // fdde   4a                                               
    pha                       // fddf   48                                             
    .byte $47                 // fde0   47          //%01000111 'G'                                                   
    lsr $44                   // fde1   46 44                                              
    .byte $53                 // fde3   53          //%01010011 'S'                                                   
    eor #$55                  // fde4   49 55                                                
    eor $5254,y               // fde6   59 54 52                                               
    eor $57                   // fde9   45 57                                              
    brk                       // fdeb   00                                             
    brk                       // fdec   00                                             
    ora $4f5e                 // fded   0d 5e 4f                                             
    jmp $002e                 // fdf0   4c 2e 00                                             
    .byte $1c                 // fdf3   1c          //%00011100                                                   
    and $30ba                 // fdf4   2d ba 30                                             
    lda $b7b8,y               // fdf7   b9 b8 b7                                               
    ldx $b5,y                 // fdfa   b6 b5                                                
    ldy $b3,x                 // fdfc   b4 b3                                                
    .byte $b2                 // fdfe   b2          //%10110010                                                   
    lda ($a2),y               // fdff   b1 a2                                                  
    .byte $ff                 // fe01   ff          //%11111111                                                   
    txs                       // fe02   9a                                             
    cld                       // fe03   d8                                             
    nop                       // fe04   ea                                             
    jsr $ff4e                 // fe05   20 4e ff                                             
    lda #$20                  // fe08   a9 20                                                
    sta $d00d                 // fe0a   8d 0d d0                                             
    ldy #$00                  // fe0d   a0 00                                                
    sty $fb                   // fe0f   84 fb                                              
    sty $fe                   // fe11   84 fe                                              
    sty $ff                   // fe13   84 ff                                              
    beq $fe30                 // fe15   f0 19                                                
lfe17:
    jsr $fee9                 // fe17   20 e9 fe                                             
    cmp #$2f                  // fe1a   c9 2f                                                
    beq $fe3c                 // fe1c   f0 1e                                                
    cmp #$47                  // fe1e   c9 47                                                
    beq $fe39                 // fe20   f0 17                                                
    cmp #$4c                  // fe22   c9 4c                                                
    beq $fe69                 // fe24   f0 43                                                
    jsr $fe93                 // fe26   20 93 fe                                             
    bmi $fe17                 // fe29   30 ec                                                
    ldx #$02                  // fe2b   a2 02                                                
    jsr $feda                 // fe2d   20 da fe                                             
lfe30:
    lda ($fe),y               // fe30   b1 fe                                                  
    sta $fc                   // fe32   85 fc                                              
    jsr $feac                 // fe34   20 ac fe                                             
    bne $fe17                 // fe37   d0 de                                                
lfe39:
    jmp $fe79                 // fe39   4c 79 fe                                             
lfe3c:
    jsr $fee9                 // fe3c   20 e9 fe                                             
    cmp #$2e                  // fe3f   c9 2e                                                
    beq $fe17                 // fe41   f0 d4                                                
    cmp #$0d                  // fe43   c9 0d                                                
    bne $fe56                 // fe45   d0 0f                                                
    inc $fe                   // fe47   e6 fe                                              
    bne $fe4d                 // fe49   d0 02                                                
    inc $ff                   // fe4b   e6 ff                                              
lfe4d:
    ldy #$00                  // fe4d   a0 00                                                
    lda ($fe),y               // fe4f   b1 fe                                                  
    sta $fc                   // fe51   85 fc                                              
    jmp $fe64                 // fe53   4c 64 fe                                             
lfe56:
    jsr $fe93                 // fe56   20 93 fe                                             
    bmi $fe3c                 // fe59   30 e1                                                
    ldx #$00                  // fe5b   a2 00                                                
    jsr $feda                 // fe5d   20 da fe                                             
    lda $fc                   // fe60   a5 fc                                              
    sta ($fe),y               // fe62   91 fe                                                  
lfe64:
    jsr $feac                 // fe64   20 ac fe                                             
    bne $fe3c                 // fe67   d0 d3                                                
lfe69:
    sta $fb                   // fe69   85 fb                                              
    beq $fe3c                 // fe6b   f0 cf                                                
lfe6d:
    lda $f000                 // fe6d   ad 00 f0                                             
    lsr                       // fe70   4a                                               
    bcc $fe6d                 // fe71   90 fa                                                
    lda $f001                 // fe73   ad 01 f0                                             
    and #$7f                  // fe76   29 7f                                                
    rts                       // fe78   60   

lfe79:
    jsr $ff4e                 // fe79   20 4e ff                                             
    jmp ($00fe)               // fe7c   6c fe 00                                               
lfe7f:
    lda $fe8a,x               // fe7f   bd 8a fe                                               
    jsr $ffee                 // fe82   20 ee ff                                             
    dex                       // fe85   ca                                             
    bne $fe7f                 // fe86   d0 f7                                                
    jmp $fc39                 // fe88   4c 39 fc                                             
    jsr $4954                 // fe8b   20 54 49                                             
    .byte $44                 // fe8e   44          //%01000100 'D'                                                   
    eor $ff                   // fe8f   45 ff                                              
    .byte $ff                 // fe91   ff          //%11111111                                                   
    .byte $ff                 // fe92   ff          //%11111111                                                   
lfe93:
    cmp #$30                  // fe93   c9 30                                                
    bmi $fea9                 // fe95   30 12                                                
    cmp #$3a                  // fe97   c9 3a                                                
    bmi $fea6                 // fe99   30 0b                                                
    cmp #$41                  // fe9b   c9 41                                                
    bmi $fea9                 // fe9d   30 0a                                                
    cmp #$47                  // fe9f   c9 47                                                
    bpl $fea9                 // fea1   10 06                                                
    sec                       // fea3   38                                             
    sbc #$07                  // fea4   e9 07                                                
lfea6:
    and #$0f                  // fea6   29 0f                                                
    rts                       // fea8   60   

lfea9:
    lda #$80                  // fea9   a9 80                                                
    rts                       // feab   60    

lfeac:
    ldx #$03                  // feac   a2 03                                                
    ldy #$00                  // feae   a0 00                                                
lfeb0:
    lda $fc,x                 // feb0   b5 fc                                                
    lsr                       // feb2   4a                                               
    lsr                       // feb3   4a                                               
    lsr                       // feb4   4a                                               
    lsr                       // feb5   4a                                               
    jsr $feca                 // feb6   20 ca fe                                             
    lda $fc,x                 // feb9   b5 fc                                                
    jsr $feca                 // febb   20 ca fe                                             
    dex                       // febe   ca                                             
    bpl $feb0                 // febf   10 ef                                                
    lda #$20                  // fec1   a9 20                                                
    sta $d162                 // fec3   8d 62 d1                                             
    sta $d163                 // fec6   8d 63 d1                                             
    rts                       // fec9   60 

lfeca:
    and #$0f                  // feca   29 0f                                                
    ora #$30                  // fecc   09 30                                                
    cmp #$3a                  // fece   c9 3a                                                
    bmi $fed5                 // fed0   30 03                                                
    clc                       // fed2   18                                             
    adc #$07                  // fed3   69 07                                                
lfed5:
    sta $d15e,y               // fed5   99 5e d1                                               
    iny                       // fed8   c8                                             
    rts                       // fed9   60  

lfeda:
    ldy #$04                  // feda   a0 04                                                
    asl                       // fedc   0a                                               
    asl                       // fedd   0a                                               
    asl                       // fede   0a                                               
    asl                       // fedf   0a                                               
lfee0:
    rol                       // fee0   2a                                               
    rol $fc,x                 // fee1   36 fc                                                
    rol $fd,x                 // fee3   36 fd                                                
    dey                       // fee5   88                                             
    bne $fee0                 // fee6   d0 f8                                                
    rts                       // fee8   60   

lfee9:
    lda $fb                   // fee9   a5 fb                                              
    bne $fe6d                 // feeb   d0 80                                                
    jmp $fd00                 // feed   4c 00 fd                                             
    ldy $d4fb                 // fef0   ac fb d4                                             
    .byte $fb                 // fef3   fb          //%11111011                                                   
    .byte $9b                 // fef4   9b          //%10011011                                                   
    .byte $ff                 // fef5   ff          //%11111111                                                   
    .byte $8b                 // fef6   8b          //%10001011                                                   
    .byte $ff                 // fef7   ff          //%11111111                                                   
    stx $ff,y                 // fef8   96 ff                                                
    jmp $0130                 // fefa   4c 30 01                                             
    jmp $01c0                 // fefd   4c c0 01                                             
lff00:
    cld                       // ff00   d8                                             
    ldx #$ff                  // ff01   a2 ff                                                
    txs                       // ff03   9a                                             
    ldy #$10                  // ff04   a0 10                                                
lff06:
    lda $feef,y               // ff06   b9 ef fe                                               
    sta $0217,y               // ff09   99 17 02                                               
    dey                       // ff0c   88                                             
    bne $ff06                 // ff0d   d0 f7                                                
    jsr $fcdf                 // ff0f   20 df fc                                             
    ldx #$17                  // ff12   a2 17                                                
    lda #$00                  // ff14   a9 00                                                
lff16:
    sta $0200,x               // ff16   9d 00 02                                               
    dex                       // ff19   ca                                             
    bpl $ff16                 // ff1a   10 fa                                                
    jsr $ff4e                 // ff1c   20 4e ff                                             
lff1f:
    lda $fc77,y               // ff1f   b9 77 fc                                               
    beq $ff2a                 // ff22   f0 06                                                
    jsr $fa57                 // ff24   20 57 fa                                             
    iny                       // ff27   c8                                             
    bne $ff1f                 // ff28   d0 f5                                                
lff2a:
    jsr $ffeb                 // ff2a   20 eb ff                                             
    cmp #$43                  // ff2d   c9 43                                                
    bne $ff37                 // ff2f   d0 06                                                
    jsr $ff4e                 // ff31   20 4e ff                                             
    jmp $bd11                 // ff34   4c 11 bd                                             
lff37:
    cmp #$57                  // ff37   c9 57                                                
    bne $ff41                 // ff39   d0 06                                                
    jsr $ff4e                 // ff3b   20 4e ff                                             
    jmp $0000                 // ff3e   4c 00 00                                             
lff41:
    cmp #$4d                  // ff41   c9 4d                                                
    bne $ff4b                 // ff43   d0 06                                                
    jsr $ff4e                 // ff45   20 4e ff                                             
    jmp $fe00                 // ff48   4c 00 fe                                             
lff4b:
    jmp $ff00                 // ff4b   4c 00 ff                                             
lff4e:
    lda #$0c                  // ff4e   a9 0c                                                
    jmp $fa57                 // ff50   4c 57 fa                                             
lff53:
    txa                       // ff53   8a                                             
    pha                       // ff54   48                                             
    tsx                       // ff55   ba                                             
    lda $0103,x               // ff56   bd 03 01                                               
    cmp #$a3                  // ff59   c9 a3                                                
    beq $ff62                 // ff5b   f0 05                                                
    pla                       // ff5d   68                                             
    tax                       // ff5e   aa                                             
    jmp $ffeb                 // ff5f   4c eb ff                                             
lff62:
    ldx #$05                  // ff62   a2 05                                                
          jmp $fe7f                 // ff64   4c 7f fe                                             
          eor $f9,x                 // ff67   55 f9                                                
          ror $fff9,x               // ff69   7e f9 ff                                               
lff6c:
    pha                       // ff6c   48                                             
          lda $0205                 // ff6d   ad 05 02                                             
          beq $ff94                 // ff70   f0 22                                                
          pla                       // ff72   68                                             
lff73:
    jsr $fcb1                 // ff73   20 b1 fc                                             
          cmp #$0d                  // ff76   c9 0d                                                
          bne $ff95                 // ff78   d0 1b                                                
          pha                       // ff7a   48                                             
          txa                       // ff7b   8a                                             
          pha                       // ff7c   48                                             
          ldx #$0a                  // ff7d   a2 0a                                                
          lda #$00                  // ff7f   a9 00                                                
lff81:
    jsr $fcb1                 // ff81   20 b1 fc                                             
          dex                       // ff84   ca                                             
          bne $ff81                 // ff85   d0 fa                                                
          pla                       // ff87   68                                             
          tax                       // ff88   aa                                             
          pla                       // ff89   68                                             
          rts                       // ff8a   60 

          pha                       // ff8b   48                                             
          dec $0203                 // ff8c   ce 03 02                                             
          lda #$00                  // ff8f   a9 00                                                
lff91:
    sta $0205                 // ff91   8d 05 02                                             
lff94:
    pla                       // ff94   68                                             
lff95:
    rts                       // ff95   60 

          pha                       // ff96   48                                             
          lda #$01                  // ff97   a9 01                                                
          bne $ff91                 // ff99   d0 f6                                                
          lda $0212                 // ff9b   ad 12 02                                             
          bne $ffb9                 // ff9e   d0 19                                                
          lda #$fe                  // ffa0   a9 fe                                                
          sta $df00                 // ffa2   8d 00 df                                             
          bit $df00                 // ffa5   2c 00 df                                             
          bvs $ffb9                 // ffa8   70 0f                                                
          lda #$fb                  // ffaa   a9 fb                                                
          sta $df00                 // ffac   8d 00 df                                             
          bit $df00                 // ffaf   2c 00 df                                             
          bvs $ffb9                 // ffb2   70 05                                                
          lda #$03                  // ffb4   a9 03                                                
          jmp $a636                 // ffb6   4c 36 a6                                             
lffb9:
    rts                       // ffb9   60  

lffba:
    bit $0203                 // ffba   2c 03 02                                             
          bpl $ffd8                 // ffbd   10 19                                                
lffbf:
    lda #$fd                  // ffbf   a9 fd                                                
          sta $df00                 // ffc1   8d 00 df                                             
          lda #$10                  // ffc4   a9 10                                                
          bit $df00                 // ffc6   2c 00 df                                             
          beq $ffd5                 // ffc9   f0 0a                                                
          lda $f000                 // ffcb   ad 00 f0                                             
          lsr                       // ffce   4a                                               
          bcc $ffbf                 // ffcf   90 ee                                                
          lda $f001                 // ffd1   ad 01 f0                                             
          rts                       // ffd4   60  
                                                     
lffd5:
    inc $0203                 // ffd5   ee 03 02                                             
lffd8:
    lda $020f                 // ffd8   ad 0f 02                                             
          beq $ffe0                 // ffdb   f0 03                                                
          jmp $fd00                 // ffdd   4c 00 fd                                             
lffe0:
    lda #$50                  // ffe0   a9 50                                                
          sta $0210                 // ffe2   8d 10 02                                             
          jmp $fcea                 // ffe5   4c ea fc                                             
          .byte $ff                 // ffe8   ff          //%11111111                                                   
          .byte $ff                 // ffe9   ff          //%11111111                                                   
          .byte $ff                 // ffea   ff          //%11111111                                                   
lffeb:
    jmp ($0218)               // ffeb   6c 18 02                                               
lffee:
    jmp ($021a)               // ffee   6c 1a 02                                               
          jmp ($021c)               // fff1   6c 1c 02                                               
          jmp ($021e)               // fff4   6c 1e 02                                               
          jmp ($0220)               // fff7   6c 20 02                                               
          .byte $22                 // fffa   22          //%00100010 '"'                                                   
          .byte $02                 // fffb   02          //%00000010                                                   
          brk                       // fffc   00                                             
          .byte $ff                 // fffd   ff          //%11111111                                                   
          and $02                   // fffe   25 02                                                                                      
                










































































































































































