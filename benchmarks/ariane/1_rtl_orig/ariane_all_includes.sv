typedef enum logic[1:0] {
  PRIV_LVL_M = 2'b11,
  PRIV_LVL_S = 2'b01,
  PRIV_LVL_U = 2'b00
} priv_lvl_t;

// type which holds xlen
typedef enum logic [1:0] {
    XLEN_32  = 2'b01,
    XLEN_64  = 2'b10,
    XLEN_128 = 2'b11
} xlen_t;

typedef enum logic [1:0] {
    Off     = 2'b00,
    Initial = 2'b01,
    Clean   = 2'b10,
    Dirty   = 2'b11
} xs_t;

typedef struct packed {
    logic         sd;     // signal dirty - read-only - hardwired zero
    logic [62:36] wpri4;  // writes preserved reads ignored
    xlen_t        sxl;    // variable supervisor mode xlen - hardwired to zero
    xlen_t        uxl;    // variable user mode xlen - hardwired to zero
    logic [8:0]   wpri3;  // writes preserved reads ignored
    logic         tsr;    // trap sret
    logic         tw;     // time wait
    logic         tvm;    // trap virtual memory
    logic         mxr;    // make executable readable
    logic         sum;    // permit supervisor user memory access
    logic         mprv;   // modify privilege - privilege level for ld/st
    xs_t          xs;     // extension register - hardwired to zero
    xs_t          fs;     // floating point extension register
    priv_lvl_t    mpp;    // holds the previous privilege mode up to machine
    logic [1:0]   wpri2;  // writes preserved reads ignored
    logic         spp;    // holds the previous privilege mode up to supervisor
    logic         mpie;   // machine interrupts enable bit active prior to trap
    logic         wpri1;  // writes preserved reads ignored
    logic         spie;   // supervisor interrupts enable bit active prior to trap
    logic         upie;   // user interrupts enable bit active prior to trap - hardwired to zero
    logic         mie;    // machine interrupts enable
    logic         wpri0;  // writes preserved reads ignored
    logic         sie;    // supervisor interrupts enable
    logic         uie;    // user interrupts enable - hardwired to zero
} status_rv64_t;

typedef struct packed {
    logic         sd;     // signal dirty - read-only - hardwired zero
    logic [7:0]   wpri3;  // writes preserved reads ignored
    logic         tsr;    // trap sret
    logic         tw;     // time wait
    logic         tvm;    // trap virtual memory
    logic         mxr;    // make executable readable
    logic         sum;    // permit supervisor user memory access
    logic         mprv;   // modify privilege - privilege level for ld/st
    logic [1:0]   xs;     // extension register - hardwired to zero
    logic [1:0]   fs;     // extension register - hardwired to zero
    priv_lvl_t    mpp;    // holds the previous privilege mode up to machine
    logic [1:0]   wpri2;  // writes preserved reads ignored
    logic         spp;    // holds the previous privilege mode up to supervisor
    logic         mpie;   // machine interrupts enable bit active prior to trap
    logic         wpri1;  // writes preserved reads ignored
    logic         spie;   // supervisor interrupts enable bit active prior to trap
    logic         upie;   // user interrupts enable bit active prior to trap - hardwired to zero
    logic         mie;    // machine interrupts enable
    logic         wpri0;  // writes preserved reads ignored
    logic         sie;    // supervisor interrupts enable
    logic         uie;    // user interrupts enable - hardwired to zero
} status_rv32_t;

typedef struct packed {
    logic [3:0]  mode;
    logic [15:0] asid;
    logic [43:0] ppn;
} satp_t;

// --------------------
// Instruction Types
// --------------------
typedef struct packed {
    logic [31:25] funct7;
    logic [24:20] rs2;
    logic [19:15] rs1;
    logic [14:12] funct3;
    logic [11:7]  rd;
    logic [6:0]   opcode;
} rtype_t;

typedef struct packed {
    logic [31:27] rs3;
    logic [26:25] funct2;
    logic [24:20] rs2;
    logic [19:15] rs1;
    logic [14:12] funct3;
    logic [11:7]  rd;
    logic [6:0]   opcode;
} r4type_t;

typedef struct packed {
    logic [31:27] funct5;
    logic [26:25] fmt;
    logic [24:20] rs2;
    logic [19:15] rs1;
    logic [14:12] rm;
    logic [11:7]  rd;
    logic [6:0]   opcode;
} rftype_t; // floating-point

typedef struct packed {
    logic [31:30] funct2;
    logic [29:25] vecfltop;
    logic [24:20] rs2;
    logic [19:15] rs1;
    logic [14:14] repl;
    logic [13:12] vfmt;
    logic [11:7]  rd;
    logic [6:0]   opcode;
} rvftype_t; // vectorial floating-point

typedef struct packed {
    logic [31:20] imm;
    logic [19:15] rs1;
    logic [14:12] funct3;
    logic [11:7]  rd;
    logic [6:0]   opcode;
} itype_t;

typedef struct packed {
    logic [31:25] imm;
    logic [24:20] rs2;
    logic [19:15] rs1;
    logic [14:12] funct3;
    logic [11:7]  imm0;
    logic [6:0]   opcode;
} stype_t;

typedef struct packed {
    logic [31:12] funct3;
    logic [11:7]  rd;
    logic [6:0]   opcode;
} utype_t;

// atomic instructions
typedef struct packed {
    logic [31:27] funct5;
    logic         aq;
    logic         rl;
    logic [24:20] rs2;
    logic [19:15] rs1;
    logic [14:12] funct3;
    logic [11:7]  rd;
    logic [6:0]   opcode;
} atype_t;

typedef union packed {
    logic [31:0]   instr;
    rtype_t        rtype;
    r4type_t       r4type;
    rftype_t       rftype;
    rvftype_t      rvftype;
    itype_t        itype;
    stype_t        stype;
    utype_t        utype;
    atype_t        atype;
} instruction_t;

// --------------------
// Opcodes
// --------------------
// RV32/64G listings:
// Quadrant 0
localparam OpcodeLoad      = 7'b00_000_11;
localparam OpcodeLoadFp    = 7'b00_001_11;
localparam OpcodeCustom0   = 7'b00_010_11;
localparam OpcodeMiscMem   = 7'b00_011_11;
localparam OpcodeOpImm     = 7'b00_100_11;
localparam OpcodeAuipc     = 7'b00_101_11;
localparam OpcodeOpImm32   = 7'b00_110_11;
// Quadrant 1
localparam OpcodeStore     = 7'b01_000_11;
localparam OpcodeStoreFp   = 7'b01_001_11;
localparam OpcodeCustom1   = 7'b01_010_11;
localparam OpcodeAmo       = 7'b01_011_11;
localparam OpcodeOp        = 7'b01_100_11;
localparam OpcodeLui       = 7'b01_101_11;
localparam OpcodeOp32      = 7'b01_110_11;
// Quadrant 2
localparam OpcodeMadd      = 7'b10_000_11;
localparam OpcodeMsub      = 7'b10_001_11;
localparam OpcodeNmsub     = 7'b10_010_11;
localparam OpcodeNmadd     = 7'b10_011_11;
localparam OpcodeOpFp      = 7'b10_100_11;
localparam OpcodeRsrvd1    = 7'b10_101_11;
localparam OpcodeCustom2   = 7'b10_110_11;
// Quadrant 3
localparam OpcodeBranch    = 7'b11_000_11;
localparam OpcodeJalr      = 7'b11_001_11;
localparam OpcodeRsrvd2    = 7'b11_010_11;
localparam OpcodeJal       = 7'b11_011_11;
localparam OpcodeSystem    = 7'b11_100_11;
localparam OpcodeRsrvd3    = 7'b11_101_11;
localparam OpcodeCustom3   = 7'b11_110_11;

// RV64C listings:
// Quadrant 0
localparam OpcodeC0             = 2'b00;
localparam OpcodeC0Addi4spn     = 3'b000;
localparam OpcodeC0Fld          = 3'b001;
localparam OpcodeC0Lw           = 3'b010;
localparam OpcodeC0Ld           = 3'b011;
localparam OpcodeC0Rsrvd        = 3'b100;
localparam OpcodeC0Fsd          = 3'b101;
localparam OpcodeC0Sw           = 3'b110;
localparam OpcodeC0Sd           = 3'b111;
// Quadrant 1
localparam OpcodeC1             = 2'b01;
localparam OpcodeC1Addi         = 3'b000;
localparam OpcodeC1Addiw        = 3'b001;
localparam OpcodeC1Li           = 3'b010;
localparam OpcodeC1LuiAddi16sp  = 3'b011;
localparam OpcodeC1MiscAlu      = 3'b100;
localparam OpcodeC1J            = 3'b101;
localparam OpcodeC1Beqz         = 3'b110;
localparam OpcodeC1Bnez         = 3'b111;
// Quadrant 2
localparam OpcodeC2             = 2'b10;
localparam OpcodeC2Slli         = 3'b000;
localparam OpcodeC2Fldsp        = 3'b001;
localparam OpcodeC2Lwsp         = 3'b010;
localparam OpcodeC2Ldsp         = 3'b011;
localparam OpcodeC2JalrMvAdd    = 3'b100;
localparam OpcodeC2Fsdsp        = 3'b101;
localparam OpcodeC2Swsp         = 3'b110;
localparam OpcodeC2Sdsp         = 3'b111;

// ----------------------
// Virtual Memory
// ----------------------
// memory management, pte
typedef struct packed {
    logic [9:0]  reserved;
    logic [43:0] ppn;
    logic [1:0]  rsw;
    logic d;
    logic a;
    logic g;
    logic u;
    logic x;
    logic w;
    logic r;
    logic v;
} pte_t;

// ----------------------
// Exception Cause Codes
// ----------------------
localparam logic [63:0] INSTR_ADDR_MISALIGNED = 0;
localparam logic [63:0] INSTR_ACCESS_FAULT    = 1;
localparam logic [63:0] ILLEGAL_INSTR         = 2;
localparam logic [63:0] BREAKPOINT            = 3;
localparam logic [63:0] LD_ADDR_MISALIGNED    = 4;
localparam logic [63:0] LD_ACCESS_FAULT       = 5;
localparam logic [63:0] ST_ADDR_MISALIGNED    = 6;
localparam logic [63:0] ST_ACCESS_FAULT       = 7;
localparam logic [63:0] ENV_CALL_UMODE        = 8;  // environment call from user mode
localparam logic [63:0] ENV_CALL_SMODE        = 9;  // environment call from supervisor mode
localparam logic [63:0] ENV_CALL_MMODE        = 11; // environment call from machine mode
localparam logic [63:0] INSTR_PAGE_FAULT      = 12; // Instruction page fault
localparam logic [63:0] LOAD_PAGE_FAULT       = 13; // Load page fault
localparam logic [63:0] STORE_PAGE_FAULT      = 15; // Store page fault

localparam int unsigned IRQ_S_SOFT  = 1;
localparam int unsigned IRQ_M_SOFT  = 3;
localparam int unsigned IRQ_S_TIMER = 5;
localparam int unsigned IRQ_M_TIMER = 7;
localparam int unsigned IRQ_S_EXT   = 9;
localparam int unsigned IRQ_M_EXT   = 11;

localparam logic [63:0] MIP_SSIP = (1 << IRQ_S_SOFT);
localparam logic [63:0] MIP_MSIP = (1 << IRQ_M_SOFT);
localparam logic [63:0] MIP_STIP = (1 << IRQ_S_TIMER);
localparam logic [63:0] MIP_MTIP = (1 << IRQ_M_TIMER);
localparam logic [63:0] MIP_SEIP = (1 << IRQ_S_EXT);
localparam logic [63:0] MIP_MEIP = (1 << IRQ_M_EXT);

localparam logic [63:0] S_SW_INTERRUPT    = (1 << 63) | IRQ_S_SOFT;
localparam logic [63:0] M_SW_INTERRUPT    = (1 << 63) | IRQ_M_SOFT;
localparam logic [63:0] S_TIMER_INTERRUPT = (1 << 63) | IRQ_S_TIMER;
localparam logic [63:0] M_TIMER_INTERRUPT = (1 << 63) | IRQ_M_TIMER;
localparam logic [63:0] S_EXT_INTERRUPT   = (1 << 63) | IRQ_S_EXT;
localparam logic [63:0] M_EXT_INTERRUPT   = (1 << 63) | IRQ_M_EXT;

// -----
// CSRs
// -----
typedef enum logic [11:0] {
    // Floating-Point CSRs
    CSR_FFLAGS         = 12'h001,
    CSR_FRM            = 12'h002,
    CSR_FCSR           = 12'h003,
    CSR_FTRAN          = 12'h800,
    // Supervisor Mode CSRs
    CSR_SSTATUS        = 12'h100,
    CSR_SIE            = 12'h104,
    CSR_STVEC          = 12'h105,
    CSR_SCOUNTEREN     = 12'h106,
    CSR_SSCRATCH       = 12'h140,
    CSR_SEPC           = 12'h141,
    CSR_SCAUSE         = 12'h142,
    CSR_STVAL          = 12'h143,
    CSR_SIP            = 12'h144,
    CSR_SATP           = 12'h180,
    // Machine Mode CSRs
    CSR_MSTATUS        = 12'h300,
    CSR_MISA           = 12'h301,
    CSR_MEDELEG        = 12'h302,
    CSR_MIDELEG        = 12'h303,
    CSR_MIE            = 12'h304,
    CSR_MTVEC          = 12'h305,
    CSR_MCOUNTEREN     = 12'h306,
    CSR_MSCRATCH       = 12'h340,
    CSR_MEPC           = 12'h341,
    CSR_MCAUSE         = 12'h342,
    CSR_MTVAL          = 12'h343,
    CSR_MIP            = 12'h344,
    CSR_PMPCFG0        = 12'h3A0,
    CSR_PMPADDR0       = 12'h3B0,
    CSR_MVENDORID      = 12'hF11,
    CSR_MARCHID        = 12'hF12,
    CSR_MIMPID         = 12'hF13,
    CSR_MHARTID        = 12'hF14,
    CSR_MCYCLE         = 12'hB00,
    CSR_MINSTRET       = 12'hB02,
    CSR_DCACHE         = 12'h701,
    CSR_ICACHE         = 12'h700,

    CSR_TSELECT        = 12'h7A0,
    CSR_TDATA1         = 12'h7A1,
    CSR_TDATA2         = 12'h7A2,
    CSR_TDATA3         = 12'h7A3,
    CSR_TINFO          = 12'h7A4,

    // Debug CSR
    CSR_DCSR           = 12'h7b0,
    CSR_DPC            = 12'h7b1,
    CSR_DSCRATCH0      = 12'h7b2, // optional
    CSR_DSCRATCH1      = 12'h7b3, // optional

    // Counters and Timers
    CSR_CYCLE          = 12'hC00,
    CSR_TIME           = 12'hC01,
    CSR_INSTRET        = 12'hC02,
    // Performance counters
    CSR_L1_ICACHE_MISS = 12'hC03,  // L1 Instr Cache Miss
    CSR_L1_DCACHE_MISS = 12'hC04,  // L1 Data Cache Miss
    CSR_ITLB_MISS      = 12'hC05,  // ITLB Miss
    CSR_DTLB_MISS      = 12'hC06,  // DTLB Miss
    CSR_LOAD           = 12'hC07,  // Loads
    CSR_STORE          = 12'hC08,  // Stores
    CSR_EXCEPTION      = 12'hC09,  // Taken exceptions
    CSR_EXCEPTION_RET  = 12'hC0A,  // Exception return
    CSR_BRANCH_JUMP    = 12'hC0B,  // Software change of PC
    CSR_CALL           = 12'hC0C,  // Procedure call
    CSR_RET            = 12'hC0D,  // Procedure Return
    CSR_MIS_PREDICT    = 12'hC0E,  // Branch mis-predicted
    CSR_SB_FULL        = 12'hC0F,  // Scoreboard full
    CSR_IF_EMPTY       = 12'hC10   // instruction fetch queue empty
} csr_reg_t;

localparam logic [63:0] SSTATUS_UIE  = 64'h00000001;
localparam logic [63:0] SSTATUS_SIE  = 64'h00000002;
localparam logic [63:0] SSTATUS_SPIE = 64'h00000020;
localparam logic [63:0] SSTATUS_SPP  = 64'h00000100;
localparam logic [63:0] SSTATUS_FS   = 64'h00006000;
localparam logic [63:0] SSTATUS_XS   = 64'h00018000;
localparam logic [63:0] SSTATUS_SUM  = 64'h00040000;
localparam logic [63:0] SSTATUS_MXR  = 64'h00080000;
localparam logic [63:0] SSTATUS_UPIE = 64'h00000010;
localparam logic [63:0] SSTATUS_UXL  = 64'h0000000300000000;
localparam logic [63:0] SSTATUS64_SD = 64'h8000000000000000;
localparam logic [63:0] SSTATUS32_SD = 64'h80000000;

localparam logic [63:0] MSTATUS_UIE  = 64'h00000001;
localparam logic [63:0] MSTATUS_SIE  = 64'h00000002;
localparam logic [63:0] MSTATUS_HIE  = 64'h00000004;
localparam logic [63:0] MSTATUS_MIE  = 64'h00000008;
localparam logic [63:0] MSTATUS_UPIE = 64'h00000010;
localparam logic [63:0] MSTATUS_SPIE = 64'h00000020;
localparam logic [63:0] MSTATUS_HPIE = 64'h00000040;
localparam logic [63:0] MSTATUS_MPIE = 64'h00000080;
localparam logic [63:0] MSTATUS_SPP  = 64'h00000100;
localparam logic [63:0] MSTATUS_HPP  = 64'h00000600;
localparam logic [63:0] MSTATUS_MPP  = 64'h00001800;
localparam logic [63:0] MSTATUS_FS   = 64'h00006000;
localparam logic [63:0] MSTATUS_XS   = 64'h00018000;
localparam logic [63:0] MSTATUS_MPRV = 64'h00020000;
localparam logic [63:0] MSTATUS_SUM  = 64'h00040000;
localparam logic [63:0] MSTATUS_MXR  = 64'h00080000;
localparam logic [63:0] MSTATUS_TVM  = 64'h00100000;
localparam logic [63:0] MSTATUS_TW   = 64'h00200000;
localparam logic [63:0] MSTATUS_TSR  = 64'h00400000;
localparam logic [63:0] MSTATUS32_SD = 64'h80000000;
localparam logic [63:0] MSTATUS_UXL  = 64'h0000000300000000;
localparam logic [63:0] MSTATUS_SXL  = 64'h0000000C00000000;
localparam logic [63:0] MSTATUS64_SD = 64'h8000000000000000;

typedef enum logic [2:0] {
    CSRRW  = 3'h1,
    CSRRS  = 3'h2,
    CSRRC  = 3'h3,
    CSRRWI = 3'h5,
    CSRRSI = 3'h6,
    CSRRCI = 3'h7
} csr_op_t;

// decoded CSR address
typedef struct packed {
    logic [1:0]  rw;
    priv_lvl_t   priv_lvl;
    logic  [7:0] address;
} csr_addr_t;

typedef union packed {
    csr_reg_t   address;
    csr_addr_t  csr_decode;
} csr_t;

// Floating-Point control and status register (32-bit!)
typedef struct packed {
    logic [31:15] reserved;  // reserved for L extension, return 0 otherwise
    logic [6:0]   fprec;     // div/sqrt precision control
    logic [2:0]   frm;       // float rounding mode
    logic [4:0]   fflags;    // float exception flags
} fcsr_t;

// -----
// Debug
// -----
typedef struct packed {
    logic [31:28]     xdebugver;
    logic [27:16]     zero2;
    logic             ebreakm;
    logic             zero1;
    logic             ebreaks;
    logic             ebreaku;
    logic             stepie;
    logic             stopcount;
    logic             stoptime;
    logic [8:6]       cause;
    logic             zero0;
    logic             mprven;
    logic             nmip;
    logic             step;
    priv_lvl_t        prv;
} dcsr_t;

/*
// Instruction Generation *incomplete*
function automatic logic [31:0] jal (logic[4:0] rd, logic [20:0] imm);
    // OpCode Jal
    return {imm[20], imm[10:1], imm[11], imm[19:12], rd, 7'h6f};
endfunction

function automatic logic [31:0] jalr (logic[4:0] rd, logic[4:0] rs1, logic [11:0] offset);
    // OpCode Jal
    return {offset[11:0], rs1, 3'b0, rd, 7'h67};
endfunction

function automatic logic [31:0] andi (logic[4:0] rd, logic[4:0] rs1, logic [11:0] imm);
    // OpCode andi
    return {imm[11:0], rs1, 3'h7, rd, 7'h13};
endfunction

function automatic logic [31:0] slli (logic[4:0] rd, logic[4:0] rs1, logic [5:0] shamt);
    // OpCode slli
    return {6'b0, shamt[5:0], rs1, 3'h1, rd, 7'h13};
endfunction

function automatic logic [31:0] srli (logic[4:0] rd, logic[4:0] rs1, logic [5:0] shamt);
    // OpCode srli
    return {6'b0, shamt[5:0], rs1, 3'h5, rd, 7'h13};
endfunction

function automatic logic [31:0] load (logic [2:0] size, logic[4:0] dest, logic[4:0] base, logic [11:0] offset);
    // OpCode Load
    return {offset[11:0], base, size, dest, 7'h03};
endfunction

function automatic logic [31:0] auipc (logic[4:0] rd, logic [20:0] imm);
    // OpCode Auipc
    return {imm[20], imm[10:1], imm[11], imm[19:12], rd, 7'h17};
endfunction

function automatic logic [31:0] store (logic [2:0] size, logic[4:0] src, logic[4:0] base, logic [11:0] offset);
    // OpCode Store
    return {offset[11:5], src, base, size, offset[4:0], 7'h23};
endfunction

function automatic logic [31:0] float_load (logic [2:0] size, logic[4:0] dest, logic[4:0] base, logic [11:0] offset);
    // OpCode Load
    return {offset[11:0], base, size, dest, 7'b00_001_11};
endfunction

function automatic logic [31:0] float_store (logic [2:0] size, logic[4:0] src, logic[4:0] base, logic [11:0] offset);
    // OpCode Store
    return {offset[11:5], src, base, size, offset[4:0], 7'b01_001_11};
endfunction

function automatic logic [31:0] csrw (csr_reg_t csr, logic[4:0] rs1);
                     // CSRRW, rd, OpCode System
    return {csr, rs1, 3'h1, 5'h0, 7'h73};
endfunction

function automatic logic [31:0] csrr (csr_reg_t csr, logic [4:0] dest);
              // rs1, CSRRS, rd, OpCode System
    return {csr, 5'h0, 3'h2, dest, 7'h73};
endfunction

function automatic logic [31:0] ebreak ();
    return 32'h00100073;
endfunction

function automatic logic [31:0] nop ();
    return 32'h00000013;
endfunction

function automatic logic [31:0] illegal ();
    return 32'h00000000;
endfunction


// trace log compatible to spikes commit log feature
// pragma translate_off
function string spikeCommitLog(logic [63:0] pc, priv_lvl_t priv_lvl, logic [31:0] instr, logic [4:0] rd, logic [63:0] result, logic rd_fpr);
    string rd_s;
    automatic string rf_s = rd_fpr ? "f" : "x";

    if (rd < 10) rd_s = $sformatf("%s %0d", rf_s, rd);
    else rd_s = $sformatf("%s%0d", rf_s, rd);

    if (rd_fpr || rd != 0) begin
        // 0 0x0000000080000118 (0xeecf8f93) x31 0x0000000080004000
        return $sformatf("%d 0x%h (0x%h) %s 0x%h\n", priv_lvl, pc, instr, rd_s, result);
    end else begin
        // 0 0x000000008000019c (0x0040006f)
        return $sformatf("%d 0x%h (0x%h)\n", priv_lvl, pc, instr);
    end
endfunction
// pragma translate_on

typedef struct {
    byte priv;
    longint unsigned pc;
    byte is_fp;
    byte rd;
    longint unsigned data;
    int unsigned instr;
    byte was_exception;
} commit_log_t;
*/

// ---------------
localparam NR_SB_ENTRIES = 8; // number of scoreboard entries
localparam TRANS_ID_BITS = $clog2(NR_SB_ENTRIES); // depending on the number of scoreboard entries we need that many bits
                                                  // to uniquely identify the entry in the scoreboard
localparam ASID_WIDTH    = 1;
localparam BTB_ENTRIES   = 64;
localparam BHT_ENTRIES   = 128;
localparam RAS_DEPTH     = 2;
localparam BITS_SATURATION_COUNTER = 2;
localparam NR_COMMIT_PORTS = 2;

localparam ENABLE_RENAME = 1'b0;

localparam ISSUE_WIDTH = 1;
// amount of pipeline registers inserted for load/store return path
// this can be tuned to trade-off IPC vs. cycle time
localparam NR_LOAD_PIPE_REGS = 1;
localparam NR_STORE_PIPE_REGS = 0;

// depth of store-buffers, this needs to be a power of two
localparam int unsigned DEPTH_SPEC   = 4;

`ifdef PITON_ARIANE
// in this case we can use a small commit queue since we have a write buffer in the dcache
// we could in principle do without the commit queue in this case, but the timing degrades if we do that due
// to longer paths into the commit stage
localparam int unsigned DEPTH_COMMIT = 2;
`else
// allocate more space for the commit buffer to be on the save side, this needs to be a power of two
localparam int unsigned DEPTH_COMMIT = 8;
`endif

// Floating-point extensions configuration
localparam bit RVF = 1'b0; // Is F extension enabled
localparam bit RVD = 1'b0; // Is D extension enabled
localparam bit RVA = 1'b1; // Is A extension enabled

// Transprecision floating-point extensions configuration
localparam bit XF16    = 1'b0; // Is half-precision float extension (Xf16) enabled
localparam bit XF16ALT = 1'b0; // Is alternative half-precision float extension (Xf16alt) enabled
localparam bit XF8     = 1'b0; // Is quarter-precision float extension (Xf8) enabled
localparam bit XFVEC   = 1'b0; // Is vectorial float extension (Xfvec) enabled

// Transprecision float unit
localparam logic [30:0] LAT_COMP_FP32    = 'd3;
localparam logic [30:0] LAT_COMP_FP64    = 'd4;
localparam logic [30:0] LAT_COMP_FP16    = 'd3;
localparam logic [30:0] LAT_COMP_FP16ALT = 'd3;
localparam logic [30:0] LAT_COMP_FP8     = 'd2;
localparam logic [30:0] LAT_DIVSQRT      = 'd2;
localparam logic [30:0] LAT_NONCOMP      = 'd1;
localparam logic [30:0] LAT_CONV         = 'd2;

// --------------------------------------
// vvvv Don't change these by hand! vvvv
localparam bit FP_PRESENT = RVF | RVD | XF16 | XF16ALT | XF8;

// Length of widest floating-point format
localparam FLEN    = RVD     ? 64 : // D ext.
                     RVF     ? 32 : // F ext.
                     XF16    ? 16 : // Xf16 ext.
                     XF16ALT ? 16 : // Xf16alt ext.
                     XF8     ? 8 :  // Xf8 ext.
                     0;             // Unused in case of no FP

localparam bit NSX = XF16 | XF16ALT | XF8 | XFVEC; // Are non-standard extensions present?

localparam bit RVFVEC     = RVF     & XFVEC & FLEN>32; // FP32 vectors available if vectors and larger fmt enabled
localparam bit XF16VEC    = XF16    & XFVEC & FLEN>16; // FP16 vectors available if vectors and larger fmt enabled
localparam bit XF16ALTVEC = XF16ALT & XFVEC & FLEN>16; // FP16ALT vectors available if vectors and larger fmt enabled
localparam bit XF8VEC     = XF8     & XFVEC & FLEN>8;  // FP8 vectors available if vectors and larger fmt enabled
// ^^^^ until here ^^^^
// ---------------------

localparam logic [63:0] ARIANE_MARCHID = 64'd3;

localparam logic [63:0] ISA_CODE = (RVA <<  0)  // A - Atomic Instructions extension
                                 | (1   <<  2)  // C - Compressed extension
                                 | (RVD <<  3)  // D - Double precsision floating-point extension
                                 | (RVF <<  5)  // F - Single precsision floating-point extension
                                 | (1   <<  8)  // I - RV32I/64I/128I base ISA
                                 | (1   << 12)  // M - Integer Multiply/Divide extension
                                 | (0   << 13)  // N - User level interrupts supported
                                 | (1   << 18)  // S - Supervisor mode implemented
                                 | (1   << 20)  // U - User mode implemented
                                 | (NSX << 23)  // X - Non-standard extensions present
                                 | (1   << 63); // RV64

// 32 registers + 1 bit for re-naming = 6
localparam REG_ADDR_SIZE = 6;
localparam NR_WB_PORTS = 4;



// enables a commit log which matches spikes commit log format for easier trace comparison
localparam bit ENABLE_SPIKE_COMMIT_LOG = 1'b1;

// ------------- Dangerouse -------------
// if set to zero a flush will not invalidate the cache-lines, in a single core environment
// where coherence is not necessary this can improve performance. This needs to be switched on
// when more than one core is in a system
localparam logic INVALIDATE_ON_FLUSH = 1'b1;
// enable performance cycle counter, if set to zero mcycle will be incremented
// with instret (non RISC-V conformal)
localparam bit ENABLE_CYCLE_COUNT = 1'b1;
// mark WIF as nop
localparam bit ENABLE_WFI = 1'b1;
// Spike zeros tval on all exception except memory faults
localparam bit ZERO_TVAL = 1'b0;

// read mask for SSTATUS over MMSTATUS
localparam logic [63:0] SMODE_STATUS_READ_MASK = riscv::SSTATUS_UIE
                                               | riscv::SSTATUS_SIE
                                               | riscv::SSTATUS_SPIE
                                               | riscv::SSTATUS_SPP
                                               | riscv::SSTATUS_FS
                                               | riscv::SSTATUS_XS
                                               | riscv::SSTATUS_SUM
                                               | riscv::SSTATUS_MXR
                                               | riscv::SSTATUS_UPIE
                                               | riscv::SSTATUS_SPIE
                                               | riscv::SSTATUS_UXL
                                               | riscv::SSTATUS64_SD;

localparam logic [63:0] SMODE_STATUS_WRITE_MASK = riscv::SSTATUS_SIE
                                                | riscv::SSTATUS_SPIE
                                                | riscv::SSTATUS_SPP
                                                | riscv::SSTATUS_FS
                                                | riscv::SSTATUS_SUM
                                                | riscv::SSTATUS_MXR;
// ---------------
// Fetch Stage
// ---------------

// leave as is (fails with >8 entries and wider fetch width)
localparam int unsigned FETCH_FIFO_DEPTH  = 8;
localparam int unsigned FETCH_WIDTH       = 32;
// maximum instructions we can fetch on one request (we support compressed instructions)
localparam int unsigned INSTR_PER_FETCH = FETCH_WIDTH / 16;

// Only use struct when signals have same direction
// exception
typedef struct packed {
     logic [63:0] cause; // cause of exception
     logic [63:0] tval;  // additional information of causing exception (e.g.: instruction causing it),
                         // address of LD/ST fault
     logic        valid;
} exception_t;

typedef enum logic [1:0] { BHT, BTB, RAS } cf_t;

// branch-predict
// this is the struct we get back from ex stage and we will use it to update
// all the necessary data structures
typedef struct packed {
    logic [63:0] pc;              // pc of predict or mis-predict
    logic [63:0] target_address;  // target address at which to jump, or not
    logic        is_mispredict;   // set if this was a mis-predict
    logic        is_taken;        // branch is taken
                                  // in the lower 16 bit of the word
    logic        valid;           // prediction with all its values is valid
    logic        clear;           // invalidate this entry
    cf_t         cf_type;         // Type of control flow change
} branchpredict_t;


typedef enum logic [6:0] { // basic ALU op
                           ADD, SUB, ADDW, SUBW,
                           // logic operations
                           XORL, ORL, ANDL,
                           // shifts
                           SRA, SRL, SLL, SRLW, SLLW, SRAW,
                           // comparisons
                           LTS, LTU, GES, GEU, EQ, NE,
                           // jumps
                           JALR,
                           // set lower than operations
                           SLTS, SLTU,
                           // CSR functions
                           MRET, SRET, DRET, ECALL, WFI, FENCE, FENCE_I, SFENCE_VMA, CSR_WRITE, CSR_READ, CSR_SET, CSR_CLEAR,
                           // LSU functions
                           LD, SD, LW, LWU, SW, LH, LHU, SH, LB, SB, LBU,
                           // Atomic Memory Operations
                           AMO_LRW, AMO_LRD, AMO_SCW, AMO_SCD,
                           AMO_SWAPW, AMO_ADDW, AMO_ANDW, AMO_ORW, AMO_XORW, AMO_MAXW, AMO_MAXWU, AMO_MINW, AMO_MINWU,
                           AMO_SWAPD, AMO_ADDD, AMO_ANDD, AMO_ORD, AMO_XORD, AMO_MAXD, AMO_MAXDU, AMO_MIND, AMO_MINDU,
                           // Multiplications
                           MUL, MULH, MULHU, MULHSU, MULW,
                           // Divisions
                           DIV, DIVU, DIVW, DIVUW, REM, REMU, REMW, REMUW,
                           // Floating-Point Load and Store Instructions
                           FLD, FLW, FLH, FLB, FSD, FSW, FSH, FSB,
                           // Floating-Point Computational Instructions
                           FADD, FSUB, FMUL, FDIV, FMIN_MAX, FSQRT, FMADD, FMSUB, FNMSUB, FNMADD,
                           // Floating-Point Conversion and Move Instructions
                           FCVT_F2I, FCVT_I2F, FCVT_F2F, FSGNJ, FMV_F2X, FMV_X2F,
                           // Floating-Point Compare Instructions
                           FCMP,
                           // Floating-Point Classify Instruction
                           FCLASS,
                           // Vectorial Floating-Point Instructions that don't directly map onto the scalar ones
                           VFMIN, VFMAX, VFSGNJ, VFSGNJN, VFSGNJX, VFEQ, VFNE, VFLT, VFGE, VFLE, VFGT, VFCPKAB_S, VFCPKCD_S, VFCPKAB_D, VFCPKCD_D
                         } fu_op;

                         typedef enum logic[3:0] {
                             NONE,      // 0
                             LOAD,      // 1
                             STORE,     // 2
                             ALU,       // 3
                             CTRL_FLOW, // 4
                             MULT,      // 5
                             CSR,       // 6
                             FPU,       // 7
                             FPU_VEC    // 8
                         } fu_t;

typedef struct packed {
    fu_t                      fu;
    fu_op                     operator;
    logic [63:0]              operand_a;
    logic [63:0]              operand_b;
    logic [63:0]              imm;
    logic [TRANS_ID_BITS-1:0] trans_id;
} fu_data_t;

// branchpredict scoreboard entry
// this is the struct which we will inject into the pipeline to guide the various
// units towards the correct branch decision and resolve
typedef struct packed {
    logic        valid;           // this is a valid hint
    logic [63:0] predict_address; // target address at which to jump, or not
    logic        predict_taken;   // branch is taken
                                  // in the lower 16 bit of the word
    cf_t         cf_type;         // Type of control flow change
} branchpredict_sbe_t;

typedef struct packed {
    logic        valid;
    logic [63:0] pc;             // update at PC
    logic [63:0] target_address;
    logic        clear;
} btb_update_t;

typedef struct packed {
    logic        valid;
    logic [63:0] target_address;
} btb_prediction_t;

typedef struct packed {
    logic        valid;
    logic [63:0] ra;
} ras_t;

typedef struct packed {
    logic        valid;
    logic [63:0] pc;          // update at PC
    logic        mispredict;
    logic        taken;
} bht_update_t;

typedef struct packed {
    logic       valid;
    logic       taken;
    logic       strongly_taken;
} bht_prediction_t;



localparam EXC_OFF_RST      = 8'h80;
