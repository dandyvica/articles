GAS LISTING /tmp/cczEardo.s 			page 1


   1              		.file	"call_asm.c"
   2              		.intel_syntax noprefix
   3              		.text
   4              	.Ltext0:
   5              		.globl	ss
   6              		.section	.rodata
   7              	.LC0:
   8 ???? 30313233 		.string	"0123456789"
   8      34353637 
   8      383900
   9              		.section	.data.rel.local,"aw",@progbits
  10              		.align 8
  11              		.type	ss, @object
  12              		.size	ss, 8
  13              	ss:
  14 ???? 00000000 		.quad	.LC0
  14      00000000 
  15              		.section	.rodata
  16              	.LC1:
  17 ???? 63616C6C 		.string	"call_asm.c"
  17      5F61736D 
  17      2E6300
  18              	.LC2:
  19 ???? 69203D3D 		.string	"i == 11"
  19      20313100 
  20              	.LC3:
  21 ???? 61736D5F 		.string	"asm_add_one_by_val(10) == 11"
  21      6164645F 
  21      6F6E655F 
  21      62795F76 
  21      616C2831 
  22              	.LC4:
  23 ???? 61736D5F 		.string	"asm_strlen(s) == 10"
  23      7374726C 
  23      656E2873 
  23      29203D3D 
  23      20313000 
  24              	.LC5:
  25 ???? 61736D5F 		.string	"asm_add_return(&a, &b) == 20"
  25      6164645F 
  25      72657475 
  25      726E2826 
  25      612C2026 
  26              	.LC6:
  27 ???? 72657375 		.string	"result == 20"
  27      6C74203D 
  27      3D203230 
  27      00
  28              	.LC7:
  29 ???? 31313131 		.string	"1111111111"
  29      31313131 
  29      313100
  30 ???? 00000000 		.align 8
  31              	.LC8:
  32 ???? 73747263 		.string	"strcmp(digits, \"1111111111\") == 0"
  32      6D702864 
  32      69676974 
GAS LISTING /tmp/cczEardo.s 			page 2


  32      732C2022 
  32      31313131 
  33              	.LC9:
  34 ???? 61736D5F 		.string	"asm_sum(numbers, 4) == 11110"
  34      73756D28 
  34      6E756D62 
  34      6572732C 
  34      20342920 
  35              		.text
  36              		.globl	main
  37              		.type	main, @function
  38              	main:
  39              	.LFB0:
  40              		.file 1 "call_asm.c"
   1:call_asm.c    **** // this is example of how to call ASM from C
   2:call_asm.c    **** // 
   3:call_asm.c    **** 
   4:call_asm.c    ****  // compile by: gcc call_asm.c asmlib.o
   5:call_asm.c    **** 
   6:call_asm.c    **** #include <stdio.h>
   7:call_asm.c    **** #include <assert.h>
   8:call_asm.c    **** #include <string.h>
   9:call_asm.c    **** #include <inttypes.h>
  10:call_asm.c    **** 
  11:call_asm.c    **** // add 1 to the value passed by reference (pointer)
  12:call_asm.c    **** void asm_add_one_by_ref(int64_t* i);
  13:call_asm.c    **** 
  14:call_asm.c    **** // add 1 to the value passed by value
  15:call_asm.c    **** int64_t asm_add_one_by_val(int64_t i);
  16:call_asm.c    **** 
  17:call_asm.c    **** // add 2 numbers and return the result: use pointers
  18:call_asm.c    **** int64_t asm_add_return(int64_t* a, int64_t* b);
  19:call_asm.c    **** void asm_add_void(int64_t* a, int64_t* b, int64_t* result);
  20:call_asm.c    **** 
  21:call_asm.c    **** // strlen() copycat
  22:call_asm.c    **** int64_t asm_strlen(char *s);
  23:call_asm.c    **** 
  24:call_asm.c    **** // strcmp() copycat
  25:call_asm.c    **** int64_t asm_strcmp(char *s1, char *s2);
  26:call_asm.c    **** 
  27:call_asm.c    **** // memset copycat
  28:call_asm.c    **** void asm_memset(char *s, char c, size_t n);
  29:call_asm.c    **** 
  30:call_asm.c    **** // sum of integer arrays
  31:call_asm.c    **** int64_t asm_sum(int64_t *tab, int64_t n);
  32:call_asm.c    **** 
  33:call_asm.c    **** char *ss = "0123456789";
  34:call_asm.c    **** 
  35:call_asm.c    **** // thi
  36:call_asm.c    **** int main() {
  41              		.loc 1 36 0
  42              		.cfi_startproc
  43 ???? 55       		push	rbp
  44              		.cfi_def_cfa_offset 16
  45              		.cfi_offset 6, -16
  46 ???? 4889E5   		mov	rbp, rsp
  47              		.cfi_def_cfa_register 6
GAS LISTING /tmp/cczEardo.s 			page 3


  48 ???? 4883EC70 		sub	rsp, 112
  49              		.loc 1 36 0
  50 ???? 64488B04 		mov	rax, QWORD PTR fs:40
  50      25280000 
  50      00
  51 ???? 488945F8 		mov	QWORD PTR -8[rbp], rax
  52 ???? 31C0     		xor	eax, eax
  37:call_asm.c    ****     // pass one argument: an integer pointer and add one
  38:call_asm.c    ****     int64_t i = 10;
  53              		.loc 1 38 0
  54 ???? 48C74598 		mov	QWORD PTR -104[rbp], 10
  54      0A000000 
  39:call_asm.c    ****     asm_add_one_by_ref(&i);
  55              		.loc 1 39 0
  56 ???? 488D4598 		lea	rax, -104[rbp]
  57 ???? 4889C7   		mov	rdi, rax
  58 ???? E8000000 		call	asm_add_one_by_ref@PLT
  58      00
  40:call_asm.c    ****     assert(i == 11);
  59              		.loc 1 40 0
  60 ???? 488B4598 		mov	rax, QWORD PTR -104[rbp]
  61 ???? 4883F80B 		cmp	rax, 11
  62 ???? 741F     		je	.L2
  63              		.loc 1 40 0 is_stmt 0 discriminator 1
  64 ???? 488D0D00 		lea	rcx, __PRETTY_FUNCTION__.2522[rip]
  64      000000
  65 ???? BA280000 		mov	edx, 40
  65      00
  66 ???? 488D3500 		lea	rsi, .LC1[rip]
  66      000000
  67 ???? 488D3D00 		lea	rdi, .LC2[rip]
  67      000000
  68 ???? E8000000 		call	__assert_fail@PLT
  68      00
  69              	.L2:
  41:call_asm.c    **** 
  42:call_asm.c    ****     assert(asm_add_one_by_val(10) == 11);
  70              		.loc 1 42 0 is_stmt 1
  71 ???? BF0A0000 		mov	edi, 10
  71      00
  72 ???? E8000000 		call	asm_add_one_by_val@PLT
  72      00
  73 ???? 4883F80B 		cmp	rax, 11
  74 ???? 741F     		je	.L3
  75              		.loc 1 42 0 is_stmt 0 discriminator 1
  76 ???? 488D0D00 		lea	rcx, __PRETTY_FUNCTION__.2522[rip]
  76      000000
  77 ???? BA2A0000 		mov	edx, 42
  77      00
  78 ???? 488D3500 		lea	rsi, .LC1[rip]
  78      000000
  79 ???? 488D3D00 		lea	rdi, .LC3[rip]
  79      000000
  80 ???? E8000000 		call	__assert_fail@PLT
  80      00
  81              	.L3:
  43:call_asm.c    **** 
GAS LISTING /tmp/cczEardo.s 			page 4


  44:call_asm.c    ****     // pass a string
  45:call_asm.c    ****     char *s = "0123456789";
  82              		.loc 1 45 0 is_stmt 1
  83 ???? 488D0500 		lea	rax, .LC0[rip]
  83      000000
  84 ???? 488945B8 		mov	QWORD PTR -72[rbp], rax
  46:call_asm.c    ****     assert(asm_strlen(s) == 10);
  85              		.loc 1 46 0
  86 ???? 488B45B8 		mov	rax, QWORD PTR -72[rbp]
  87 ???? 4889C7   		mov	rdi, rax
  88 ???? E8000000 		call	asm_strlen@PLT
  88      00
  89 ???? 4883F80A 		cmp	rax, 10
  90 ???? 741F     		je	.L4
  91              		.loc 1 46 0 is_stmt 0 discriminator 1
  92 ???? 488D0D00 		lea	rcx, __PRETTY_FUNCTION__.2522[rip]
  92      000000
  93 ???? BA2E0000 		mov	edx, 46
  93      00
  94 ???? 488D3500 		lea	rsi, .LC1[rip]
  94      000000
  95 ???? 488D3D00 		lea	rdi, .LC4[rip]
  95      000000
  96 ???? E8000000 		call	__assert_fail@PLT
  96      00
  97              	.L4:
  47:call_asm.c    **** 
  48:call_asm.c    ****     // add 2 numbers and get result
  49:call_asm.c    ****     int64_t a = 10, b = 10;
  98              		.loc 1 49 0 is_stmt 1
  99 ???? 48C745A0 		mov	QWORD PTR -96[rbp], 10
  99      0A000000 
 100 ???? 48C745A8 		mov	QWORD PTR -88[rbp], 10
 100      0A000000 
  50:call_asm.c    ****     assert(asm_add_return(&a, &b) == 20);
 101              		.loc 1 50 0
 102 ???? 488D55A8 		lea	rdx, -88[rbp]
 103 ???? 488D45A0 		lea	rax, -96[rbp]
 104 ???? 4889D6   		mov	rsi, rdx
 105 ???? 4889C7   		mov	rdi, rax
 106 ???? E8000000 		call	asm_add_return@PLT
 106      00
 107 ???? 4883F814 		cmp	rax, 20
 108 ???? 741F     		je	.L5
 109              		.loc 1 50 0 is_stmt 0 discriminator 1
 110 ???? 488D0D00 		lea	rcx, __PRETTY_FUNCTION__.2522[rip]
 110      000000
 111 ???? BA320000 		mov	edx, 50
 111      00
 112 ???? 488D3500 		lea	rsi, .LC1[rip]
 112      000000
 113 ???? 488D3D00 		lea	rdi, .LC5[rip]
 113      000000
 114 ???? E8000000 		call	__assert_fail@PLT
 114      00
 115              	.L5:
  51:call_asm.c    **** 
GAS LISTING /tmp/cczEardo.s 			page 5


  52:call_asm.c    ****     // add 2 numbers and store result into 3rd parameter
  53:call_asm.c    ****     int64_t result;
  54:call_asm.c    ****     asm_add_void(&a, &b, &result);
 116              		.loc 1 54 0 is_stmt 1
 117 ???? 488D55B0 		lea	rdx, -80[rbp]
 118 ???? 488D4DA8 		lea	rcx, -88[rbp]
 119 ???? 488D45A0 		lea	rax, -96[rbp]
 120 ???? 4889CE   		mov	rsi, rcx
 121 ???? 4889C7   		mov	rdi, rax
 122 ???? E8000000 		call	asm_add_void@PLT
 122      00
  55:call_asm.c    ****     assert(result == 20);
 123              		.loc 1 55 0
 124 ???? 488B45B0 		mov	rax, QWORD PTR -80[rbp]
 125 ???? 4883F814 		cmp	rax, 20
 126 ???? 741F     		je	.L6
 127              		.loc 1 55 0 is_stmt 0 discriminator 1
 128 ???? 488D0D00 		lea	rcx, __PRETTY_FUNCTION__.2522[rip]
 128      000000
 129 ???? BA370000 		mov	edx, 55
 129      00
 130 ???? 488D3500 		lea	rsi, .LC1[rip]
 130      000000
 131 ???? 488D3D00 		lea	rdi, .LC6[rip]
 131      000000
 132 ???? E8000000 		call	__assert_fail@PLT
 132      00
 133              	.L6:
  56:call_asm.c    **** 
  57:call_asm.c    ****     // compare strings
  58:call_asm.c    ****     //printf("%ld\n", strcmp("Hello", "Hello1"));
  59:call_asm.c    ****     //assert(asm_strcmp("Hello world1", "Hello") == 1);
  60:call_asm.c    **** 
  61:call_asm.c    ****     // memset
  62:call_asm.c    ****     char digits[] = "0123456789";
 134              		.loc 1 62 0 is_stmt 1
 135 ???? 48B83031 		movabs	rax, 3978425819141910832
 135      32333435 
 135      3637
 136 ???? 488945ED 		mov	QWORD PTR -19[rbp], rax
 137 ???? 66C745F5 		mov	WORD PTR -11[rbp], 14648
 137      3839
 138 ???? C645F700 		mov	BYTE PTR -9[rbp], 0
  63:call_asm.c    ****     asm_memset(digits, '1', strlen(digits));
 139              		.loc 1 63 0
 140 ???? 488D45ED 		lea	rax, -19[rbp]
 141 ???? 4889C7   		mov	rdi, rax
 142 ???? E8000000 		call	strlen@PLT
 142      00
 143 ???? 4889C2   		mov	rdx, rax
 144 ???? 488D45ED 		lea	rax, -19[rbp]
 145 ???? BE310000 		mov	esi, 49
 145      00
 146 ???? 4889C7   		mov	rdi, rax
 147 ???? E8000000 		call	asm_memset@PLT
 147      00
  64:call_asm.c    ****     assert(strcmp(digits, "1111111111") == 0);
GAS LISTING /tmp/cczEardo.s 			page 6


 148              		.loc 1 64 0
 149 ???? 488D45ED 		lea	rax, -19[rbp]
 150 ???? 488D3500 		lea	rsi, .LC7[rip]
 150      000000
 151 ???? 4889C7   		mov	rdi, rax
 152 ???? E8000000 		call	strcmp@PLT
 152      00
 153 ???? 85C0     		test	eax, eax
 154 ???? 741F     		je	.L7
 155              		.loc 1 64 0 is_stmt 0 discriminator 1
 156 ???? 488D0D00 		lea	rcx, __PRETTY_FUNCTION__.2522[rip]
 156      000000
 157 ???? BA400000 		mov	edx, 64
 157      00
 158 ???? 488D3500 		lea	rsi, .LC1[rip]
 158      000000
 159 ???? 488D3D00 		lea	rdi, .LC8[rip]
 159      000000
 160 ???? E8000000 		call	__assert_fail@PLT
 160      00
 161              	.L7:
  65:call_asm.c    **** 
  66:call_asm.c    ****     // integer array
  67:call_asm.c    ****     int64_t numbers[] = {10,100,1000,10000};
 162              		.loc 1 67 0 is_stmt 1
 163 ???? 48C745C0 		mov	QWORD PTR -64[rbp], 10
 163      0A000000 
 164 ???? 48C745C8 		mov	QWORD PTR -56[rbp], 100
 164      64000000 
 165 ???? 48C745D0 		mov	QWORD PTR -48[rbp], 1000
 165      E8030000 
 166 ???? 48C745D8 		mov	QWORD PTR -40[rbp], 10000
 166      10270000 
  68:call_asm.c    ****     assert(asm_sum(numbers, 4) == 11110);
 167              		.loc 1 68 0
 168 ???? 488D45C0 		lea	rax, -64[rbp]
 169 ???? BE040000 		mov	esi, 4
 169      00
 170 ???? 4889C7   		mov	rdi, rax
 171 ???? E8000000 		call	asm_sum@PLT
 171      00
 172 ???? 483D662B 		cmp	rax, 11110
 172      0000
 173 ???? 741F     		je	.L8
 174              		.loc 1 68 0 is_stmt 0 discriminator 1
 175 ???? 488D0D00 		lea	rcx, __PRETTY_FUNCTION__.2522[rip]
 175      000000
 176 ???? BA440000 		mov	edx, 68
 176      00
 177 ???? 488D3500 		lea	rsi, .LC1[rip]
 177      000000
 178 ???? 488D3D00 		lea	rdi, .LC9[rip]
 178      000000
 179 ???? E8000000 		call	__assert_fail@PLT
 179      00
 180              	.L8:
  69:call_asm.c    **** 
GAS LISTING /tmp/cczEardo.s 			page 7


  70:call_asm.c    ****     return 0;
 181              		.loc 1 70 0 is_stmt 1
 182 ???? B8000000 		mov	eax, 0
 182      00
  71:call_asm.c    **** }
 183              		.loc 1 71 0
 184 ???? 488B4DF8 		mov	rcx, QWORD PTR -8[rbp]
 185 ???? 6448330C 		xor	rcx, QWORD PTR fs:40
 185      25280000 
 185      00
 186 ???? 7405     		je	.L10
 187 ???? E8000000 		call	__stack_chk_fail@PLT
 187      00
 188              	.L10:
 189 ???? C9       		leave
 190              		.cfi_def_cfa 7, 8
 191 ???? C3       		ret
 192              		.cfi_endproc
 193              	.LFE0:
 194              		.size	main, .-main
 195              		.section	.rodata
 196              		.type	__PRETTY_FUNCTION__.2522, @object
 197              		.size	__PRETTY_FUNCTION__.2522, 5
 198              	__PRETTY_FUNCTION__.2522:
 199 ???? 6D61696E 		.string	"main"
 199      00
 200              		.text
 201              	.Letext0:
 202              		.file 2 "/usr/lib/gcc/x86_64-linux-gnu/7/include/stddef.h"
 203              		.file 3 "/usr/include/x86_64-linux-gnu/bits/types.h"
 204              		.file 4 "/usr/include/x86_64-linux-gnu/bits/libio.h"
 205              		.file 5 "/usr/include/stdio.h"
 206              		.file 6 "/usr/include/x86_64-linux-gnu/bits/sys_errlist.h"
 207              		.file 7 "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h"
 208              		.section	.debug_info,"",@progbits
 209              	.Ldebug_info0:
 210 ???? EC030000 		.long	0x3ec
 211 ???? 0400     		.value	0x4
 212 ???? 00000000 		.long	.Ldebug_abbrev0
 213 ???? 08       		.byte	0x8
 214 ???? 01       		.uleb128 0x1
 215 ???? 00000000 		.long	.LASF58
 216 ???? 0C       		.byte	0xc
 217 ???? 00000000 		.long	.LASF59
 218 ???? 00000000 		.long	.LASF60
 219 ???? 00000000 		.quad	.Ltext0
 219      00000000 
 220 ???? 28020000 		.quad	.Letext0-.Ltext0
 220      00000000 
 221 ???? 00000000 		.long	.Ldebug_line0
 222 ???? 02       		.uleb128 0x2
 223 ???? 00000000 		.long	.LASF6
 224 ???? 02       		.byte	0x2
 225 ???? D8       		.byte	0xd8
 226 ???? 38000000 		.long	0x38
 227 ???? 03       		.uleb128 0x3
 228 ???? 08       		.byte	0x8
GAS LISTING /tmp/cczEardo.s 			page 8


 229 ???? 07       		.byte	0x7
 230 ???? 00000000 		.long	.LASF0
 231 ???? 03       		.uleb128 0x3
 232 ???? 01       		.byte	0x1
 233 ???? 08       		.byte	0x8
 234 ???? 00000000 		.long	.LASF1
 235 ???? 03       		.uleb128 0x3
 236 ???? 02       		.byte	0x2
 237 ???? 07       		.byte	0x7
 238 ???? 00000000 		.long	.LASF2
 239 ???? 03       		.uleb128 0x3
 240 ???? 04       		.byte	0x4
 241 ???? 07       		.byte	0x7
 242 ???? 00000000 		.long	.LASF3
 243 ???? 03       		.uleb128 0x3
 244 ???? 01       		.byte	0x1
 245 ???? 06       		.byte	0x6
 246 ???? 00000000 		.long	.LASF4
 247 ???? 03       		.uleb128 0x3
 248 ???? 02       		.byte	0x2
 249 ???? 05       		.byte	0x5
 250 ???? 00000000 		.long	.LASF5
 251 ???? 04       		.uleb128 0x4
 252 ???? 04       		.byte	0x4
 253 ???? 05       		.byte	0x5
 254 ???? 696E7400 		.string	"int"
 255 ???? 02       		.uleb128 0x2
 256 ???? 00000000 		.long	.LASF7
 257 ???? 03       		.byte	0x3
 258 ???? 2B       		.byte	0x2b
 259 ???? 74000000 		.long	0x74
 260 ???? 03       		.uleb128 0x3
 261 ???? 08       		.byte	0x8
 262 ???? 05       		.byte	0x5
 263 ???? 00000000 		.long	.LASF8
 264 ???? 02       		.uleb128 0x2
 265 ???? 00000000 		.long	.LASF9
 266 ???? 03       		.byte	0x3
 267 ???? 8C       		.byte	0x8c
 268 ???? 74000000 		.long	0x74
 269 ???? 02       		.uleb128 0x2
 270 ???? 00000000 		.long	.LASF10
 271 ???? 03       		.byte	0x3
 272 ???? 8D       		.byte	0x8d
 273 ???? 74000000 		.long	0x74
 274 ???? 05       		.uleb128 0x5
 275 ???? 08       		.byte	0x8
 276 ???? 06       		.uleb128 0x6
 277 ???? 08       		.byte	0x8
 278 ???? 99000000 		.long	0x99
 279 ???? 03       		.uleb128 0x3
 280 ???? 01       		.byte	0x1
 281 ???? 06       		.byte	0x6
 282 ???? 00000000 		.long	.LASF11
 283 ???? 07       		.uleb128 0x7
 284 ???? 99000000 		.long	0x99
 285 ???? 08       		.uleb128 0x8
GAS LISTING /tmp/cczEardo.s 			page 9


 286 ???? 00000000 		.long	.LASF41
 287 ???? D8       		.byte	0xd8
 288 ???? 04       		.byte	0x4
 289 ???? F5       		.byte	0xf5
 290 ???? 25020000 		.long	0x225
 291 ???? 09       		.uleb128 0x9
 292 ???? 00000000 		.long	.LASF12
 293 ???? 04       		.byte	0x4
 294 ???? F6       		.byte	0xf6
 295 ???? 62000000 		.long	0x62
 296 ???? 00       		.byte	0
 297 ???? 09       		.uleb128 0x9
 298 ???? 00000000 		.long	.LASF13
 299 ???? 04       		.byte	0x4
 300 ???? FB       		.byte	0xfb
 301 ???? 93000000 		.long	0x93
 302 ???? 08       		.byte	0x8
 303 ???? 09       		.uleb128 0x9
 304 ???? 00000000 		.long	.LASF14
 305 ???? 04       		.byte	0x4
 306 ???? FC       		.byte	0xfc
 307 ???? 93000000 		.long	0x93
 308 ???? 10       		.byte	0x10
 309 ???? 09       		.uleb128 0x9
 310 ???? 00000000 		.long	.LASF15
 311 ???? 04       		.byte	0x4
 312 ???? FD       		.byte	0xfd
 313 ???? 93000000 		.long	0x93
 314 ???? 18       		.byte	0x18
 315 ???? 09       		.uleb128 0x9
 316 ???? 00000000 		.long	.LASF16
 317 ???? 04       		.byte	0x4
 318 ???? FE       		.byte	0xfe
 319 ???? 93000000 		.long	0x93
 320 ???? 20       		.byte	0x20
 321 ???? 09       		.uleb128 0x9
 322 ???? 00000000 		.long	.LASF17
 323 ???? 04       		.byte	0x4
 324 ???? FF       		.byte	0xff
 325 ???? 93000000 		.long	0x93
 326 ???? 28       		.byte	0x28
 327 ???? 0A       		.uleb128 0xa
 328 ???? 00000000 		.long	.LASF18
 329 ???? 04       		.byte	0x4
 330 ???? 0001     		.value	0x100
 331 ???? 93000000 		.long	0x93
 332 ???? 30       		.byte	0x30
 333 ???? 0A       		.uleb128 0xa
 334 ???? 00000000 		.long	.LASF19
 335 ???? 04       		.byte	0x4
 336 ???? 0101     		.value	0x101
 337 ???? 93000000 		.long	0x93
 338 ???? 38       		.byte	0x38
 339 ???? 0A       		.uleb128 0xa
 340 ???? 00000000 		.long	.LASF20
 341 ???? 04       		.byte	0x4
 342 ???? 0201     		.value	0x102
GAS LISTING /tmp/cczEardo.s 			page 10


 343 ???? 93000000 		.long	0x93
 344 ???? 40       		.byte	0x40
 345 ???? 0A       		.uleb128 0xa
 346 ???? 00000000 		.long	.LASF21
 347 ???? 04       		.byte	0x4
 348 ???? 0401     		.value	0x104
 349 ???? 93000000 		.long	0x93
 350 ???? 48       		.byte	0x48
 351 ???? 0A       		.uleb128 0xa
 352 ???? 00000000 		.long	.LASF22
 353 ???? 04       		.byte	0x4
 354 ???? 0501     		.value	0x105
 355 ???? 93000000 		.long	0x93
 356 ???? 50       		.byte	0x50
 357 ???? 0A       		.uleb128 0xa
 358 ???? 00000000 		.long	.LASF23
 359 ???? 04       		.byte	0x4
 360 ???? 0601     		.value	0x106
 361 ???? 93000000 		.long	0x93
 362 ???? 58       		.byte	0x58
 363 ???? 0A       		.uleb128 0xa
 364 ???? 00000000 		.long	.LASF24
 365 ???? 04       		.byte	0x4
 366 ???? 0801     		.value	0x108
 367 ???? 5D020000 		.long	0x25d
 368 ???? 60       		.byte	0x60
 369 ???? 0A       		.uleb128 0xa
 370 ???? 00000000 		.long	.LASF25
 371 ???? 04       		.byte	0x4
 372 ???? 0A01     		.value	0x10a
 373 ???? 63020000 		.long	0x263
 374 ???? 68       		.byte	0x68
 375 ???? 0A       		.uleb128 0xa
 376 ???? 00000000 		.long	.LASF26
 377 ???? 04       		.byte	0x4
 378 ???? 0C01     		.value	0x10c
 379 ???? 62000000 		.long	0x62
 380 ???? 70       		.byte	0x70
 381 ???? 0A       		.uleb128 0xa
 382 ???? 00000000 		.long	.LASF27
 383 ???? 04       		.byte	0x4
 384 ???? 1001     		.value	0x110
 385 ???? 62000000 		.long	0x62
 386 ???? 74       		.byte	0x74
 387 ???? 0A       		.uleb128 0xa
 388 ???? 00000000 		.long	.LASF28
 389 ???? 04       		.byte	0x4
 390 ???? 1201     		.value	0x112
 391 ???? 7B000000 		.long	0x7b
 392 ???? 78       		.byte	0x78
 393 ???? 0A       		.uleb128 0xa
 394 ???? 00000000 		.long	.LASF29
 395 ???? 04       		.byte	0x4
 396 ???? 1601     		.value	0x116
 397 ???? 46000000 		.long	0x46
 398 ???? 80       		.byte	0x80
 399 ???? 0A       		.uleb128 0xa
GAS LISTING /tmp/cczEardo.s 			page 11


 400 ???? 00000000 		.long	.LASF30
 401 ???? 04       		.byte	0x4
 402 ???? 1701     		.value	0x117
 403 ???? 54000000 		.long	0x54
 404 ???? 82       		.byte	0x82
 405 ???? 0A       		.uleb128 0xa
 406 ???? 00000000 		.long	.LASF31
 407 ???? 04       		.byte	0x4
 408 ???? 1801     		.value	0x118
 409 ???? 69020000 		.long	0x269
 410 ???? 83       		.byte	0x83
 411 ???? 0A       		.uleb128 0xa
 412 ???? 00000000 		.long	.LASF32
 413 ???? 04       		.byte	0x4
 414 ???? 1C01     		.value	0x11c
 415 ???? 79020000 		.long	0x279
 416 ???? 88       		.byte	0x88
 417 ???? 0A       		.uleb128 0xa
 418 ???? 00000000 		.long	.LASF33
 419 ???? 04       		.byte	0x4
 420 ???? 2501     		.value	0x125
 421 ???? 86000000 		.long	0x86
 422 ???? 90       		.byte	0x90
 423 ???? 0A       		.uleb128 0xa
 424 ???? 00000000 		.long	.LASF34
 425 ???? 04       		.byte	0x4
 426 ???? 2D01     		.value	0x12d
 427 ???? 91000000 		.long	0x91
 428 ???? 98       		.byte	0x98
 429 ???? 0A       		.uleb128 0xa
 430 ???? 00000000 		.long	.LASF35
 431 ???? 04       		.byte	0x4
 432 ???? 2E01     		.value	0x12e
 433 ???? 91000000 		.long	0x91
 434 ???? A0       		.byte	0xa0
 435 ???? 0A       		.uleb128 0xa
 436 ???? 00000000 		.long	.LASF36
 437 ???? 04       		.byte	0x4
 438 ???? 2F01     		.value	0x12f
 439 ???? 91000000 		.long	0x91
 440 ???? A8       		.byte	0xa8
 441 ???? 0A       		.uleb128 0xa
 442 ???? 00000000 		.long	.LASF37
 443 ???? 04       		.byte	0x4
 444 ???? 3001     		.value	0x130
 445 ???? 91000000 		.long	0x91
 446 ???? B0       		.byte	0xb0
 447 ???? 0A       		.uleb128 0xa
 448 ???? 00000000 		.long	.LASF38
 449 ???? 04       		.byte	0x4
 450 ???? 3201     		.value	0x132
 451 ???? 2D000000 		.long	0x2d
 452 ???? B8       		.byte	0xb8
 453 ???? 0A       		.uleb128 0xa
 454 ???? 00000000 		.long	.LASF39
 455 ???? 04       		.byte	0x4
 456 ???? 3301     		.value	0x133
GAS LISTING /tmp/cczEardo.s 			page 12


 457 ???? 62000000 		.long	0x62
 458 ???? C0       		.byte	0xc0
 459 ???? 0A       		.uleb128 0xa
 460 ???? 00000000 		.long	.LASF40
 461 ???? 04       		.byte	0x4
 462 ???? 3501     		.value	0x135
 463 ???? 7F020000 		.long	0x27f
 464 ???? C4       		.byte	0xc4
 465 ???? 00       		.byte	0
 466 ???? 0B       		.uleb128 0xb
 467 ???? 00000000 		.long	.LASF61
 468 ???? 04       		.byte	0x4
 469 ???? 9A       		.byte	0x9a
 470 ???? 08       		.uleb128 0x8
 471 ???? 00000000 		.long	.LASF42
 472 ???? 18       		.byte	0x18
 473 ???? 04       		.byte	0x4
 474 ???? A0       		.byte	0xa0
 475 ???? 5D020000 		.long	0x25d
 476 ???? 09       		.uleb128 0x9
 477 ???? 00000000 		.long	.LASF43
 478 ???? 04       		.byte	0x4
 479 ???? A1       		.byte	0xa1
 480 ???? 5D020000 		.long	0x25d
 481 ???? 00       		.byte	0
 482 ???? 09       		.uleb128 0x9
 483 ???? 00000000 		.long	.LASF44
 484 ???? 04       		.byte	0x4
 485 ???? A2       		.byte	0xa2
 486 ???? 63020000 		.long	0x263
 487 ???? 08       		.byte	0x8
 488 ???? 09       		.uleb128 0x9
 489 ???? 00000000 		.long	.LASF45
 490 ???? 04       		.byte	0x4
 491 ???? A6       		.byte	0xa6
 492 ???? 62000000 		.long	0x62
 493 ???? 10       		.byte	0x10
 494 ???? 00       		.byte	0
 495 ???? 06       		.uleb128 0x6
 496 ???? 08       		.byte	0x8
 497 ???? 2C020000 		.long	0x22c
 498 ???? 06       		.uleb128 0x6
 499 ???? 08       		.byte	0x8
 500 ???? A5000000 		.long	0xa5
 501 ???? 0C       		.uleb128 0xc
 502 ???? 99000000 		.long	0x99
 503 ???? 79020000 		.long	0x279
 504 ???? 0D       		.uleb128 0xd
 505 ???? 38000000 		.long	0x38
 506 ???? 00       		.byte	0
 507 ???? 00       		.byte	0
 508 ???? 06       		.uleb128 0x6
 509 ???? 08       		.byte	0x8
 510 ???? 25020000 		.long	0x225
 511 ???? 0C       		.uleb128 0xc
 512 ???? 99000000 		.long	0x99
 513 ???? 8F020000 		.long	0x28f
GAS LISTING /tmp/cczEardo.s 			page 13


 514 ???? 0D       		.uleb128 0xd
 515 ???? 38000000 		.long	0x38
 516 ???? 13       		.byte	0x13
 517 ???? 00       		.byte	0
 518 ???? 0E       		.uleb128 0xe
 519 ???? 00000000 		.long	.LASF62
 520 ???? 0F       		.uleb128 0xf
 521 ???? 00000000 		.long	.LASF46
 522 ???? 04       		.byte	0x4
 523 ???? 3F01     		.value	0x13f
 524 ???? 8F020000 		.long	0x28f
 525 ???? 0F       		.uleb128 0xf
 526 ???? 00000000 		.long	.LASF47
 527 ???? 04       		.byte	0x4
 528 ???? 4001     		.value	0x140
 529 ???? 8F020000 		.long	0x28f
 530 ???? 0F       		.uleb128 0xf
 531 ???? 00000000 		.long	.LASF48
 532 ???? 04       		.byte	0x4
 533 ???? 4101     		.value	0x141
 534 ???? 8F020000 		.long	0x28f
 535 ???? 06       		.uleb128 0x6
 536 ???? 08       		.byte	0x8
 537 ???? A0000000 		.long	0xa0
 538 ???? 07       		.uleb128 0x7
 539 ???? B8020000 		.long	0x2b8
 540 ???? 10       		.uleb128 0x10
 541 ???? 00000000 		.long	.LASF49
 542 ???? 05       		.byte	0x5
 543 ???? 87       		.byte	0x87
 544 ???? 63020000 		.long	0x263
 545 ???? 10       		.uleb128 0x10
 546 ???? 00000000 		.long	.LASF50
 547 ???? 05       		.byte	0x5
 548 ???? 88       		.byte	0x88
 549 ???? 63020000 		.long	0x263
 550 ???? 10       		.uleb128 0x10
 551 ???? 00000000 		.long	.LASF51
 552 ???? 05       		.byte	0x5
 553 ???? 89       		.byte	0x89
 554 ???? 63020000 		.long	0x263
 555 ???? 10       		.uleb128 0x10
 556 ???? 00000000 		.long	.LASF52
 557 ???? 06       		.byte	0x6
 558 ???? 1A       		.byte	0x1a
 559 ???? 62000000 		.long	0x62
 560 ???? 0C       		.uleb128 0xc
 561 ???? BE020000 		.long	0x2be
 562 ???? FA020000 		.long	0x2fa
 563 ???? 11       		.uleb128 0x11
 564 ???? 00       		.byte	0
 565 ???? 07       		.uleb128 0x7
 566 ???? EF020000 		.long	0x2ef
 567 ???? 10       		.uleb128 0x10
 568 ???? 00000000 		.long	.LASF53
 569 ???? 06       		.byte	0x6
 570 ???? 1B       		.byte	0x1b
GAS LISTING /tmp/cczEardo.s 			page 14


 571 ???? FA020000 		.long	0x2fa
 572 ???? 02       		.uleb128 0x2
 573 ???? 00000000 		.long	.LASF54
 574 ???? 07       		.byte	0x7
 575 ???? 1B       		.byte	0x1b
 576 ???? 69000000 		.long	0x69
 577 ???? 12       		.uleb128 0x12
 578 ???? 737300   		.string	"ss"
 579 ???? 01       		.byte	0x1
 580 ???? 21       		.byte	0x21
 581 ???? 93000000 		.long	0x93
 582 ???? 09       		.uleb128 0x9
 583 ???? 03       		.byte	0x3
 584 ???? 53000000 		.quad	ss
****  Erreur: invalid use of register
****  Avertissement: valeur de registre utilisée comme expression
 584      00000000 
 585 ???? 13       		.uleb128 0x13
 586 ???? 00000000 		.long	.LASF63
 587 ???? 01       		.byte	0x1
 588 ???? 24       		.byte	0x24
 589 ???? 62000000 		.long	0x62
 590 ???? 00000000 		.quad	.LFB0
 590      00000000 
 591 ???? 28020000 		.quad	.LFE0-.LFB0
 591      00000000 
 592 ???? 01       		.uleb128 0x1
 593 ???? 9C       		.byte	0x9c
 594 ???? BE030000 		.long	0x3be
 595 ???? 14       		.uleb128 0x14
 596 ???? 6900     		.string	"i"
 597 ???? 01       		.byte	0x1
 598 ???? 26       		.byte	0x26
 599 ???? 0A030000 		.long	0x30a
 600 ???? 03       		.uleb128 0x3
 601 ???? 91       		.byte	0x91
 602 ???? 887F     		.sleb128 -120
 603 ???? 15       		.uleb128 0x15
 604 ???? 00000000 		.long	.LASF64
 605 ???? CE030000 		.long	0x3ce
 606 ???? 09       		.uleb128 0x9
 607 ???? 03       		.byte	0x3
 608 ???? 00000000 		.quad	__PRETTY_FUNCTION__.2522
 608      00000000 
 609 ???? 14       		.uleb128 0x14
 610 ???? 7300     		.string	"s"
 611 ???? 01       		.byte	0x1
 612 ???? 2D       		.byte	0x2d
 613 ???? 93000000 		.long	0x93
 614 ???? 03       		.uleb128 0x3
 615 ???? 91       		.byte	0x91
 616 ???? A87F     		.sleb128 -88
 617 ???? 14       		.uleb128 0x14
 618 ???? 6100     		.string	"a"
 619 ???? 01       		.byte	0x1
 620 ???? 31       		.byte	0x31
 621 ???? 0A030000 		.long	0x30a
GAS LISTING /tmp/cczEardo.s 			page 15


 622 ???? 03       		.uleb128 0x3
 623 ???? 91       		.byte	0x91
 624 ???? 907F     		.sleb128 -112
 625 ???? 14       		.uleb128 0x14
 626 ???? 6200     		.string	"b"
 627 ???? 01       		.byte	0x1
 628 ???? 31       		.byte	0x31
 629 ???? 0A030000 		.long	0x30a
 630 ???? 03       		.uleb128 0x3
 631 ???? 91       		.byte	0x91
 632 ???? 987F     		.sleb128 -104
 633 ???? 16       		.uleb128 0x16
 634 ???? 00000000 		.long	.LASF55
 635 ???? 01       		.byte	0x1
 636 ???? 35       		.byte	0x35
 637 ???? 0A030000 		.long	0x30a
 638 ???? 03       		.uleb128 0x3
 639 ???? 91       		.byte	0x91
 640 ???? A07F     		.sleb128 -96
 641 ???? 16       		.uleb128 0x16
 642 ???? 00000000 		.long	.LASF56
 643 ???? 01       		.byte	0x1
 644 ???? 3E       		.byte	0x3e
 645 ???? D3030000 		.long	0x3d3
 646 ???? 02       		.uleb128 0x2
 647 ???? 91       		.byte	0x91
 648 ???? 5D       		.sleb128 -35
 649 ???? 16       		.uleb128 0x16
 650 ???? 00000000 		.long	.LASF57
 651 ???? 01       		.byte	0x1
 652 ???? 43       		.byte	0x43
 653 ???? E3030000 		.long	0x3e3
 654 ???? 03       		.uleb128 0x3
 655 ???? 91       		.byte	0x91
 656 ???? B07F     		.sleb128 -80
 657 ???? 00       		.byte	0
 658 ???? 0C       		.uleb128 0xc
 659 ???? A0000000 		.long	0xa0
 660 ???? CE030000 		.long	0x3ce
 661 ???? 0D       		.uleb128 0xd
 662 ???? 38000000 		.long	0x38
 663 ???? 04       		.byte	0x4
 664 ???? 00       		.byte	0
 665 ???? 07       		.uleb128 0x7
 666 ???? BE030000 		.long	0x3be
 667 ???? 0C       		.uleb128 0xc
 668 ???? 99000000 		.long	0x99
 669 ???? E3030000 		.long	0x3e3
 670 ???? 0D       		.uleb128 0xd
 671 ???? 38000000 		.long	0x38
 672 ???? 0A       		.byte	0xa
 673 ???? 00       		.byte	0
 674 ???? 17       		.uleb128 0x17
 675 ???? 0A030000 		.long	0x30a
 676 ???? 0D       		.uleb128 0xd
 677 ???? 38000000 		.long	0x38
 678 ???? 03       		.byte	0x3
GAS LISTING /tmp/cczEardo.s 			page 16


 679 ???? 00       		.byte	0
 680 ???? 00       		.byte	0
 681              		.section	.debug_abbrev,"",@progbits
 682              	.Ldebug_abbrev0:
 683 ???? 01       		.uleb128 0x1
 684 ???? 11       		.uleb128 0x11
 685 ???? 01       		.byte	0x1
 686 ???? 25       		.uleb128 0x25
 687 ???? 0E       		.uleb128 0xe
 688 ???? 13       		.uleb128 0x13
 689 ???? 0B       		.uleb128 0xb
 690 ???? 03       		.uleb128 0x3
 691 ???? 0E       		.uleb128 0xe
 692 ???? 1B       		.uleb128 0x1b
 693 ???? 0E       		.uleb128 0xe
 694 ???? 11       		.uleb128 0x11
 695 ???? 01       		.uleb128 0x1
 696 ???? 12       		.uleb128 0x12
 697 ???? 07       		.uleb128 0x7
 698 ???? 10       		.uleb128 0x10
 699 ???? 17       		.uleb128 0x17
 700 ???? 00       		.byte	0
 701 ???? 00       		.byte	0
 702 ???? 02       		.uleb128 0x2
 703 ???? 16       		.uleb128 0x16
 704 ???? 00       		.byte	0
 705 ???? 03       		.uleb128 0x3
 706 ???? 0E       		.uleb128 0xe
 707 ???? 3A       		.uleb128 0x3a
 708 ???? 0B       		.uleb128 0xb
 709 ???? 3B       		.uleb128 0x3b
 710 ???? 0B       		.uleb128 0xb
 711 ???? 49       		.uleb128 0x49
 712 ???? 13       		.uleb128 0x13
 713 ???? 00       		.byte	0
 714 ???? 00       		.byte	0
 715 ???? 03       		.uleb128 0x3
 716 ???? 24       		.uleb128 0x24
 717 ???? 00       		.byte	0
 718 ???? 0B       		.uleb128 0xb
 719 ???? 0B       		.uleb128 0xb
 720 ???? 3E       		.uleb128 0x3e
 721 ???? 0B       		.uleb128 0xb
 722 ???? 03       		.uleb128 0x3
 723 ???? 0E       		.uleb128 0xe
 724 ???? 00       		.byte	0
 725 ???? 00       		.byte	0
 726 ???? 04       		.uleb128 0x4
 727 ???? 24       		.uleb128 0x24
 728 ???? 00       		.byte	0
 729 ???? 0B       		.uleb128 0xb
 730 ???? 0B       		.uleb128 0xb
 731 ???? 3E       		.uleb128 0x3e
 732 ???? 0B       		.uleb128 0xb
 733 ???? 03       		.uleb128 0x3
 734 ???? 08       		.uleb128 0x8
 735 ???? 00       		.byte	0
GAS LISTING /tmp/cczEardo.s 			page 17


 736 ???? 00       		.byte	0
 737 ???? 05       		.uleb128 0x5
 738 ???? 0F       		.uleb128 0xf
 739 ???? 00       		.byte	0
 740 ???? 0B       		.uleb128 0xb
 741 ???? 0B       		.uleb128 0xb
 742 ???? 00       		.byte	0
 743 ???? 00       		.byte	0
 744 ???? 06       		.uleb128 0x6
 745 ???? 0F       		.uleb128 0xf
 746 ???? 00       		.byte	0
 747 ???? 0B       		.uleb128 0xb
 748 ???? 0B       		.uleb128 0xb
 749 ???? 49       		.uleb128 0x49
 750 ???? 13       		.uleb128 0x13
 751 ???? 00       		.byte	0
 752 ???? 00       		.byte	0
 753 ???? 07       		.uleb128 0x7
 754 ???? 26       		.uleb128 0x26
 755 ???? 00       		.byte	0
 756 ???? 49       		.uleb128 0x49
 757 ???? 13       		.uleb128 0x13
 758 ???? 00       		.byte	0
 759 ???? 00       		.byte	0
 760 ???? 08       		.uleb128 0x8
 761 ???? 13       		.uleb128 0x13
 762 ???? 01       		.byte	0x1
 763 ???? 03       		.uleb128 0x3
 764 ???? 0E       		.uleb128 0xe
 765 ???? 0B       		.uleb128 0xb
 766 ???? 0B       		.uleb128 0xb
 767 ???? 3A       		.uleb128 0x3a
 768 ???? 0B       		.uleb128 0xb
 769 ???? 3B       		.uleb128 0x3b
 770 ???? 0B       		.uleb128 0xb
 771 ???? 01       		.uleb128 0x1
 772 ???? 13       		.uleb128 0x13
 773 ???? 00       		.byte	0
 774 ???? 00       		.byte	0
 775 ???? 09       		.uleb128 0x9
 776 ???? 0D       		.uleb128 0xd
 777 ???? 00       		.byte	0
 778 ???? 03       		.uleb128 0x3
 779 ???? 0E       		.uleb128 0xe
 780 ???? 3A       		.uleb128 0x3a
 781 ???? 0B       		.uleb128 0xb
 782 ???? 3B       		.uleb128 0x3b
 783 ???? 0B       		.uleb128 0xb
 784 ???? 49       		.uleb128 0x49
 785 ???? 13       		.uleb128 0x13
 786 ???? 38       		.uleb128 0x38
 787 ???? 0B       		.uleb128 0xb
 788 ???? 00       		.byte	0
 789 ???? 00       		.byte	0
 790 ???? 0A       		.uleb128 0xa
 791 ???? 0D       		.uleb128 0xd
 792 ???? 00       		.byte	0
GAS LISTING /tmp/cczEardo.s 			page 18


 793 ???? 03       		.uleb128 0x3
 794 ???? 0E       		.uleb128 0xe
 795 ???? 3A       		.uleb128 0x3a
 796 ???? 0B       		.uleb128 0xb
 797 ???? 3B       		.uleb128 0x3b
 798 ???? 05       		.uleb128 0x5
 799 ???? 49       		.uleb128 0x49
 800 ???? 13       		.uleb128 0x13
 801 ???? 38       		.uleb128 0x38
 802 ???? 0B       		.uleb128 0xb
 803 ???? 00       		.byte	0
 804 ???? 00       		.byte	0
 805 ???? 0B       		.uleb128 0xb
 806 ???? 16       		.uleb128 0x16
 807 ???? 00       		.byte	0
 808 ???? 03       		.uleb128 0x3
 809 ???? 0E       		.uleb128 0xe
 810 ???? 3A       		.uleb128 0x3a
 811 ???? 0B       		.uleb128 0xb
 812 ???? 3B       		.uleb128 0x3b
 813 ???? 0B       		.uleb128 0xb
 814 ???? 00       		.byte	0
 815 ???? 00       		.byte	0
 816 ???? 0C       		.uleb128 0xc
 817 ???? 01       		.uleb128 0x1
 818 ???? 01       		.byte	0x1
 819 ???? 49       		.uleb128 0x49
 820 ???? 13       		.uleb128 0x13
 821 ???? 01       		.uleb128 0x1
 822 ???? 13       		.uleb128 0x13
 823 ???? 00       		.byte	0
 824 ???? 00       		.byte	0
 825 ???? 0D       		.uleb128 0xd
 826 ???? 21       		.uleb128 0x21
 827 ???? 00       		.byte	0
 828 ???? 49       		.uleb128 0x49
 829 ???? 13       		.uleb128 0x13
 830 ???? 2F       		.uleb128 0x2f
 831 ???? 0B       		.uleb128 0xb
 832 ???? 00       		.byte	0
 833 ???? 00       		.byte	0
 834 ???? 0E       		.uleb128 0xe
 835 ???? 13       		.uleb128 0x13
 836 ???? 00       		.byte	0
 837 ???? 03       		.uleb128 0x3
 838 ???? 0E       		.uleb128 0xe
 839 ???? 3C       		.uleb128 0x3c
 840 ???? 19       		.uleb128 0x19
 841 ???? 00       		.byte	0
 842 ???? 00       		.byte	0
 843 ???? 0F       		.uleb128 0xf
 844 ???? 34       		.uleb128 0x34
 845 ???? 00       		.byte	0
 846 ???? 03       		.uleb128 0x3
 847 ???? 0E       		.uleb128 0xe
 848 ???? 3A       		.uleb128 0x3a
 849 ???? 0B       		.uleb128 0xb
GAS LISTING /tmp/cczEardo.s 			page 19


 850 ???? 3B       		.uleb128 0x3b
 851 ???? 05       		.uleb128 0x5
 852 ???? 49       		.uleb128 0x49
 853 ???? 13       		.uleb128 0x13
 854 ???? 3F       		.uleb128 0x3f
 855 ???? 19       		.uleb128 0x19
 856 ???? 3C       		.uleb128 0x3c
 857 ???? 19       		.uleb128 0x19
 858 ???? 00       		.byte	0
 859 ???? 00       		.byte	0
 860 ???? 10       		.uleb128 0x10
 861 ???? 34       		.uleb128 0x34
 862 ???? 00       		.byte	0
 863 ???? 03       		.uleb128 0x3
 864 ???? 0E       		.uleb128 0xe
 865 ???? 3A       		.uleb128 0x3a
 866 ???? 0B       		.uleb128 0xb
 867 ???? 3B       		.uleb128 0x3b
 868 ???? 0B       		.uleb128 0xb
 869 ???? 49       		.uleb128 0x49
 870 ???? 13       		.uleb128 0x13
 871 ???? 3F       		.uleb128 0x3f
 872 ???? 19       		.uleb128 0x19
 873 ???? 3C       		.uleb128 0x3c
 874 ???? 19       		.uleb128 0x19
 875 ???? 00       		.byte	0
 876 ???? 00       		.byte	0
 877 ???? 11       		.uleb128 0x11
 878 ???? 21       		.uleb128 0x21
 879 ???? 00       		.byte	0
 880 ???? 00       		.byte	0
 881 ???? 00       		.byte	0
 882 ???? 12       		.uleb128 0x12
 883 ???? 34       		.uleb128 0x34
 884 ???? 00       		.byte	0
 885 ???? 03       		.uleb128 0x3
 886 ???? 08       		.uleb128 0x8
 887 ???? 3A       		.uleb128 0x3a
 888 ???? 0B       		.uleb128 0xb
 889 ???? 3B       		.uleb128 0x3b
 890 ???? 0B       		.uleb128 0xb
 891 ???? 49       		.uleb128 0x49
 892 ???? 13       		.uleb128 0x13
 893 ???? 3F       		.uleb128 0x3f
 894 ???? 19       		.uleb128 0x19
 895 ???? 02       		.uleb128 0x2
 896 ???? 18       		.uleb128 0x18
 897 ???? 00       		.byte	0
 898 ???? 00       		.byte	0
 899 ???? 13       		.uleb128 0x13
 900 ???? 2E       		.uleb128 0x2e
 901 ???? 01       		.byte	0x1
 902 ???? 3F       		.uleb128 0x3f
 903 ???? 19       		.uleb128 0x19
 904 ???? 03       		.uleb128 0x3
 905 ???? 0E       		.uleb128 0xe
 906 ???? 3A       		.uleb128 0x3a
GAS LISTING /tmp/cczEardo.s 			page 20


 907 ???? 0B       		.uleb128 0xb
 908 ???? 3B       		.uleb128 0x3b
 909 ???? 0B       		.uleb128 0xb
 910 ???? 49       		.uleb128 0x49
 911 ???? 13       		.uleb128 0x13
 912 ???? 11       		.uleb128 0x11
 913 ???? 01       		.uleb128 0x1
 914 ???? 12       		.uleb128 0x12
 915 ???? 07       		.uleb128 0x7
 916 ???? 40       		.uleb128 0x40
 917 ???? 18       		.uleb128 0x18
 918 ???? 9642     		.uleb128 0x2116
 919 ???? 19       		.uleb128 0x19
 920 ???? 01       		.uleb128 0x1
 921 ???? 13       		.uleb128 0x13
 922 ???? 00       		.byte	0
 923 ???? 00       		.byte	0
 924 ???? 14       		.uleb128 0x14
 925 ???? 34       		.uleb128 0x34
 926 ???? 00       		.byte	0
 927 ???? 03       		.uleb128 0x3
 928 ???? 08       		.uleb128 0x8
 929 ???? 3A       		.uleb128 0x3a
 930 ???? 0B       		.uleb128 0xb
 931 ???? 3B       		.uleb128 0x3b
 932 ???? 0B       		.uleb128 0xb
 933 ???? 49       		.uleb128 0x49
 934 ???? 13       		.uleb128 0x13
 935 ???? 02       		.uleb128 0x2
 936 ???? 18       		.uleb128 0x18
 937 ???? 00       		.byte	0
 938 ???? 00       		.byte	0
 939 ???? 15       		.uleb128 0x15
 940 ???? 34       		.uleb128 0x34
 941 ???? 00       		.byte	0
 942 ???? 03       		.uleb128 0x3
 943 ???? 0E       		.uleb128 0xe
 944 ???? 49       		.uleb128 0x49
 945 ???? 13       		.uleb128 0x13
 946 ???? 34       		.uleb128 0x34
 947 ???? 19       		.uleb128 0x19
 948 ???? 02       		.uleb128 0x2
 949 ???? 18       		.uleb128 0x18
 950 ???? 00       		.byte	0
 951 ???? 00       		.byte	0
 952 ???? 16       		.uleb128 0x16
 953 ???? 34       		.uleb128 0x34
 954 ???? 00       		.byte	0
 955 ???? 03       		.uleb128 0x3
 956 ???? 0E       		.uleb128 0xe
 957 ???? 3A       		.uleb128 0x3a
 958 ???? 0B       		.uleb128 0xb
 959 ???? 3B       		.uleb128 0x3b
 960 ???? 0B       		.uleb128 0xb
 961 ???? 49       		.uleb128 0x49
 962 ???? 13       		.uleb128 0x13
 963 ???? 02       		.uleb128 0x2
GAS LISTING /tmp/cczEardo.s 			page 21


 964 ???? 18       		.uleb128 0x18
 965 ???? 00       		.byte	0
 966 ???? 00       		.byte	0
 967 ???? 17       		.uleb128 0x17
 968 ???? 01       		.uleb128 0x1
 969 ???? 01       		.byte	0x1
 970 ???? 49       		.uleb128 0x49
 971 ???? 13       		.uleb128 0x13
 972 ???? 00       		.byte	0
 973 ???? 00       		.byte	0
 974 ???? 00       		.byte	0
 975              		.section	.debug_aranges,"",@progbits
 976 ???? 2C000000 		.long	0x2c
 977 ???? 0200     		.value	0x2
 978 ???? 00000000 		.long	.Ldebug_info0
 979 ???? 08       		.byte	0x8
 980 ???? 00       		.byte	0
 981 ???? 0000     		.value	0
 982 ???? 0000     		.value	0
 983 ???? 00000000 		.quad	.Ltext0
 983      00000000 
 984 ???? 28020000 		.quad	.Letext0-.Ltext0
 984      00000000 
 985 ???? 00000000 		.quad	0
 985      00000000 
 986 ???? 00000000 		.quad	0
 986      00000000 
 987              		.section	.debug_line,"",@progbits
 988              	.Ldebug_line0:
 989 ???? 33010000 		.section	.debug_str,"MS",@progbits,1
 989      0200C800 
 989      00000101 
 989      FB0E0D00 
 989      01010101 
 990              	.LASF9:
 991 ???? 5F5F6F66 		.string	"__off_t"
 991      665F7400 
 992              	.LASF13:
 993 ???? 5F494F5F 		.string	"_IO_read_ptr"
 993      72656164 
 993      5F707472 
 993      00
 994              	.LASF25:
 995 ???? 5F636861 		.string	"_chain"
 995      696E00
 996              	.LASF6:
 997 ???? 73697A65 		.string	"size_t"
 997      5F7400
 998              	.LASF31:
 999 ???? 5F73686F 		.string	"_shortbuf"
 999      72746275 
 999      6600
 1000              	.LASF48:
 1001 ???? 5F494F5F 		.string	"_IO_2_1_stderr_"
 1001      325F315F 
 1001      73746465 
 1001      72725F00 
GAS LISTING /tmp/cczEardo.s 			page 22


 1002              	.LASF19:
 1003 ???? 5F494F5F 		.string	"_IO_buf_base"
 1003      6275665F 
 1003      62617365 
 1003      00
 1004              	.LASF59:
 1005 ???? 63616C6C 		.string	"call_asm.c"
 1005      5F61736D 
 1005      2E6300
 1006              	.LASF7:
 1007 ???? 5F5F696E 		.string	"__int64_t"
 1007      7436345F 
 1007      7400
 1008              	.LASF60:
 1009 ???? 2F6D6564 		.string	"/media/m330421/Toshiba externe 500Gb/articles/article5"
 1009      69612F6D 
 1009      33333034 
 1009      32312F54 
 1009      6F736869 
 1010              	.LASF4:
 1011 ???? 7369676E 		.string	"signed char"
 1011      65642063 
 1011      68617200 
 1012              	.LASF64:
 1013 ???? 5F5F5052 		.string	"__PRETTY_FUNCTION__"
 1013      45545459 
 1013      5F46554E 
 1013      4354494F 
 1013      4E5F5F00 
 1014              	.LASF26:
 1015 ???? 5F66696C 		.string	"_fileno"
 1015      656E6F00 
 1016              	.LASF14:
 1017 ???? 5F494F5F 		.string	"_IO_read_end"
 1017      72656164 
 1017      5F656E64 
 1017      00
 1018              	.LASF8:
 1019 ???? 6C6F6E67 		.string	"long int"
 1019      20696E74 
 1019      00
 1020              	.LASF12:
 1021 ???? 5F666C61 		.string	"_flags"
 1021      677300
 1022              	.LASF20:
 1023 ???? 5F494F5F 		.string	"_IO_buf_end"
 1023      6275665F 
 1023      656E6400 
 1024              	.LASF29:
 1025 ???? 5F637572 		.string	"_cur_column"
 1025      5F636F6C 
 1025      756D6E00 
 1026              	.LASF28:
 1027 ???? 5F6F6C64 		.string	"_old_offset"
 1027      5F6F6666 
 1027      73657400 
 1028              	.LASF33:
GAS LISTING /tmp/cczEardo.s 			page 23


 1029 ???? 5F6F6666 		.string	"_offset"
 1029      73657400 
 1030              	.LASF42:
 1031 ???? 5F494F5F 		.string	"_IO_marker"
 1031      6D61726B 
 1031      657200
 1032              	.LASF49:
 1033 ???? 73746469 		.string	"stdin"
 1033      6E00
 1034              	.LASF3:
 1035 ???? 756E7369 		.string	"unsigned int"
 1035      676E6564 
 1035      20696E74 
 1035      00
 1036              	.LASF0:
 1037 ???? 6C6F6E67 		.string	"long unsigned int"
 1037      20756E73 
 1037      69676E65 
 1037      6420696E 
 1037      7400
 1038              	.LASF62:
 1039 ???? 5F494F5F 		.string	"_IO_FILE_plus"
 1039      46494C45 
 1039      5F706C75 
 1039      7300
 1040              	.LASF17:
 1041 ???? 5F494F5F 		.string	"_IO_write_ptr"
 1041      77726974 
 1041      655F7074 
 1041      7200
 1042              	.LASF52:
 1043 ???? 7379735F 		.string	"sys_nerr"
 1043      6E657272 
 1043      00
 1044              	.LASF44:
 1045 ???? 5F736275 		.string	"_sbuf"
 1045      6600
 1046              	.LASF2:
 1047 ???? 73686F72 		.string	"short unsigned int"
 1047      7420756E 
 1047      7369676E 
 1047      65642069 
 1047      6E7400
 1048              	.LASF21:
 1049 ???? 5F494F5F 		.string	"_IO_save_base"
 1049      73617665 
 1049      5F626173 
 1049      6500
 1050              	.LASF58:
 1051 ???? 474E5520 		.string	"GNU C11 7.3.0 -masm=intel -mtune=generic -march=x86-64 -g -fstack-protector-strong"
 1051      43313120 
 1051      372E332E 
 1051      30202D6D 
 1051      61736D3D 
 1052              	.LASF32:
 1053 ???? 5F6C6F63 		.string	"_lock"
 1053      6B00
GAS LISTING /tmp/cczEardo.s 			page 24


 1054              	.LASF27:
 1055 ???? 5F666C61 		.string	"_flags2"
 1055      67733200 
 1056              	.LASF39:
 1057 ???? 5F6D6F64 		.string	"_mode"
 1057      6500
 1058              	.LASF50:
 1059 ???? 7374646F 		.string	"stdout"
 1059      757400
 1060              	.LASF46:
 1061 ???? 5F494F5F 		.string	"_IO_2_1_stdin_"
 1061      325F315F 
 1061      73746469 
 1061      6E5F00
 1062              	.LASF18:
 1063 ???? 5F494F5F 		.string	"_IO_write_end"
 1063      77726974 
 1063      655F656E 
 1063      6400
 1064              	.LASF61:
 1065 ???? 5F494F5F 		.string	"_IO_lock_t"
 1065      6C6F636B 
 1065      5F7400
 1066              	.LASF41:
 1067 ???? 5F494F5F 		.string	"_IO_FILE"
 1067      46494C45 
 1067      00
 1068              	.LASF45:
 1069 ???? 5F706F73 		.string	"_pos"
 1069      00
 1070              	.LASF53:
 1071 ???? 7379735F 		.string	"sys_errlist"
 1071      6572726C 
 1071      69737400 
 1072              	.LASF24:
 1073 ???? 5F6D6172 		.string	"_markers"
 1073      6B657273 
 1073      00
 1074              	.LASF1:
 1075 ???? 756E7369 		.string	"unsigned char"
 1075      676E6564 
 1075      20636861 
 1075      7200
 1076              	.LASF5:
 1077 ???? 73686F72 		.string	"short int"
 1077      7420696E 
 1077      7400
 1078              	.LASF57:
 1079 ???? 6E756D62 		.string	"numbers"
 1079      65727300 
 1080              	.LASF30:
 1081 ???? 5F767461 		.string	"_vtable_offset"
 1081      626C655F 
 1081      6F666673 
 1081      657400
 1082              	.LASF47:
 1083 ???? 5F494F5F 		.string	"_IO_2_1_stdout_"
GAS LISTING /tmp/cczEardo.s 			page 25


 1083      325F315F 
 1083      7374646F 
 1083      75745F00 
 1084              	.LASF11:
 1085 ???? 63686172 		.string	"char"
 1085      00
 1086              	.LASF43:
 1087 ???? 5F6E6578 		.string	"_next"
 1087      7400
 1088              	.LASF10:
 1089 ???? 5F5F6F66 		.string	"__off64_t"
 1089      6636345F 
 1089      7400
 1090              	.LASF15:
 1091 ???? 5F494F5F 		.string	"_IO_read_base"
 1091      72656164 
 1091      5F626173 
 1091      6500
 1092              	.LASF56:
 1093 ???? 64696769 		.string	"digits"
 1093      747300
 1094              	.LASF23:
 1095 ???? 5F494F5F 		.string	"_IO_save_end"
 1095      73617665 
 1095      5F656E64 
 1095      00
 1096              	.LASF34:
 1097 ???? 5F5F7061 		.string	"__pad1"
 1097      643100
 1098              	.LASF35:
 1099 ???? 5F5F7061 		.string	"__pad2"
 1099      643200
 1100              	.LASF36:
 1101 ???? 5F5F7061 		.string	"__pad3"
 1101      643300
 1102              	.LASF37:
 1103 ???? 5F5F7061 		.string	"__pad4"
 1103      643400
 1104              	.LASF38:
 1105 ???? 5F5F7061 		.string	"__pad5"
 1105      643500
 1106              	.LASF40:
 1107 ???? 5F756E75 		.string	"_unused2"
 1107      73656432 
 1107      00
 1108              	.LASF51:
 1109 ???? 73746465 		.string	"stderr"
 1109      727200
 1110              	.LASF22:
 1111 ???? 5F494F5F 		.string	"_IO_backup_base"
 1111      6261636B 
 1111      75705F62 
 1111      61736500 
 1112              	.LASF54:
 1113 ???? 696E7436 		.string	"int64_t"
 1113      345F7400 
 1114              	.LASF63:
GAS LISTING /tmp/cczEardo.s 			page 26


 1115 ???? 6D61696E 		.string	"main"
 1115      00
 1116              	.LASF16:
 1117 ???? 5F494F5F 		.string	"_IO_write_base"
 1117      77726974 
 1117      655F6261 
 1117      736500
 1118              	.LASF55:
 1119 ???? 72657375 		.string	"result"
 1119      6C7400
 1120              		.ident	"GCC: (Ubuntu 7.3.0-27ubuntu1~18.04) 7.3.0"
 1121              		.section	.note.GNU-stack,"",@progbits
