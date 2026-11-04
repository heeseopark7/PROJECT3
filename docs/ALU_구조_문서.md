# ALU 구조 문서

ALU에 해당하는 RTL, 스펙, 검증만 모은 문서다. MAC·곱셈기는 다루지 않는다.
스펙의 단일 출처는 `docs/ALU_MAC_design_note.md`이고, 이 문서는 현재 RTL(`proj3_make/TOP/1_RTL`)을 읽고 정리한 것이다.
모듈별 쉬운 설명은 `docs/module_notes/`에 있다.

## 1. 한눈에 보기

- 연산 10종(ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND)과 Reserved 6개 코드, 플래그 4개(zero, neg, carry, ovf)를 낸다.
- `alu_top` = 입력 레지스터 → `alu_core`(순수 조합) → 출력 레지스터. 지연 2에지, 처리량 매 클록 1건.
- 덧셈기 하나와 시프터 하나를 연산들이 공유한다.
- 구조 비교용 변형: `ADDER_ARCH`(5가지) × `SHIFTER_ARCH`(2가지). 포트는 모든 변형이 같다.

## 2. 모듈 계층

```
alu_top                      입출력 레지스터 + valid 파이프라인
└─ alu_core                  조합 로직: 디코드, 결과 mux, 플래그
   ├─ adder_top              ADDER_ARCH로 아래 중 하나를 고름 (인스턴스 1개)
   │   ├─ adder_rca   (0)    Ripple-carry
   │   ├─ adder_cla   (1)    Carry-lookahead, radix-4 트리   [선택]
   │   ├─ adder_ks    (2)    Kogge-Stone prefix
   │   ├─ adder_bk    (3)    Brent-Kung prefix               [선택]
   │   └─ adder_beh   (4)    `+` 한 줄 (기본, 기준선)
   └─ alu_shifter            비트 반전 + fill 계산 + 코어 선택
       ├─ shr_loop    (0)    1비트씩 XLEN-1단 직렬
       └─ shr_barrel  (1)    log2(XLEN)단 (기본, 기준선)
```

공용 헤더는 `alu_defs.vh`(연산 코드 매크로)다. `alu_core`가 `include`한다.

## 3. 파라미터

| 파라미터 | 값 | 기본 | 적용 모듈 |
| --- | --- | --- | --- |
| `XLEN` | 8, 16, 32 | 32 | `alu_top`, `alu_core`, `alu_shifter`, `shr_*` |
| `ADDER_ARCH` | 0 RCA, 1 CLA, 2 KS, 3 BK, 4 BEH | 4 | `alu_top`, `alu_core` → `adder_top` |
| `SHIFTER_ARCH` | 0 loop, 1 barrel | 1 | `alu_top`, `alu_core` → `alu_shifter` |
| `W` | 덧셈기 폭 | 32 | `adder_*` (ALU에서는 `W = XLEN`) |

기준선 조합은 `ADDER_ARCH=4`, `SHIFTER_ARCH=1`이다. 비교할 때는 한 번에 한 블록만 바꾼다.
지원하지 않는 `ADDER_ARCH`, `SHIFTER_ARCH`, `XLEN`은 다른 구현으로 대체되지 않는다. 존재하지 않는 모듈(`adder_arch_not_implemented`, `shifter_arch_not_implemented`)을 인스턴스해서 elaboration이 실패한다.

## 4. 포트

### alu_top

| 포트 | 방향 | 폭 | 설명 |
| --- | --- | --- | --- |
| `i_clk` | in | 1 | 클록. 상승 에지만 사용 |
| `i_rst_n` | in | 1 | active-low 리셋. 비동기 assert |
| `i_valid` | in | 1 | 입력 유효 |
| `i_a`, `i_b` | in | XLEN | 피연산자. 시프트양은 `i_b`의 하위 log2(XLEN)비트 |
| `i_alu_op` | in | 4 | 연산 코드 |
| `o_valid` | out | 1 | 결과 유효 |
| `o_result` | out | XLEN | 결과. `o_valid=0`이면 don't care |
| `o_flag_zero` / `neg` / `carry` / `ovf` | out | 1 | 플래그 |

`alu_core`는 여기서 `i_clk`, `i_rst_n`, `i_valid`, `o_valid`를 뺀 조합 인터페이스다.

### 하위 모듈

| 모듈 | 입력 | 출력 |
| --- | --- | --- |
| `adder_top`, `adder_*` | `i_a`, `i_b` (W), `i_cin` (1) | `o_sum` (W), `o_cout` (1) |
| `alu_shifter` | `i_din` (XLEN), `i_shamt` (log2 XLEN), `i_right`, `i_arith` | `o_dout` (XLEN) |
| `shr_loop`, `shr_barrel` | `i_din` (XLEN), `i_shamt` (log2 XLEN), `i_fill` | `o_dout` (XLEN) |

## 5. 연산과 플래그

### 연산 코드 (`alu_defs.vh`, RV32I의 {funct7[5], funct3})

| `i_alu_op` | 연산 | 결과 | 사용 유닛 |
| --- | --- | --- | --- |
| `4'b0000` | ADD | a + b | 덧셈기 |
| `4'b1000` | SUB | a − b | 덧셈기 (sub=1) |
| `4'b0001` | SLL | a << shamt | 시프터 (좌) |
| `4'b0010` | SLT | 부호 있는 a < b 이면 1 | 덧셈기 (sub=1) |
| `4'b0011` | SLTU | 부호 없는 a < b 이면 1 | 덧셈기 (sub=1) |
| `4'b0100` | XOR | a ^ b | 논리 |
| `4'b0101` | SRL | 논리 우시프트 (0 채움) | 시프터 (우) |
| `4'b1101` | SRA | 산술 우시프트 (부호 채움) | 시프터 (우, arith) |
| `4'b0110` | OR | a \| b | 논리 |
| `4'b0111` | AND | a & b | 논리 |
| 나머지 6개 | Reserved | 0 | - |

SLT/SLTU의 결과는 0 또는 1이고 XLEN으로 0 확장한다.

### 플래그

| 플래그 | 정의 | 유효 범위 |
| --- | --- | --- |
| `zero` | `result == 0` | 모든 연산 (Reserved는 result=0이라 1) |
| `neg` | `result[M]` | 모든 연산 (SLT/SLTU는 결과가 0/1이라 항상 0) |
| `carry` | 덧셈기 `cout` | ADD, SUB, SLT, SLTU만. 그 외 0 |
| `ovf` | 부호 있는 오버플로 | ADD, SUB, SLT, SLTU만. 그 외 0 |

SUB에서 `carry=1`은 borrow가 없다는 뜻이다(a ≥ b, 부호 없음).

## 6. alu_core 내부 구조

### 6.1 덧셈기 공유 (ADD, SUB, SLT, SLTU)

```
sub    = (op == SUB) | (op == SLT) | (op == SLTU)
b_eff  = i_b ^ {XLEN{sub}}
{cout, sum} = adder_top(i_a, b_eff, cin = sub)        // a + b_eff + sub
ovf    = (a[M] == b_eff[M]) & (sum[M] != a[M])        // M = XLEN-1
SLT 비트  = sum[M] ^ ovf
SLTU 비트 = ~cout
```

빼기는 a + ~b + 1(2의 보수)이라 `b`를 뒤집고 `cin=1`을 넣는 것으로 처리한다. 비교용 별도 비교기는 없다.
`adder_top` 인스턴스는 `alu_core`에 하나뿐이고, `+ - *` 연산자도 `alu_core`에는 없다.

### 6.2 시프터 공유 (SLL, SRL, SRA)

- `alu_core`는 `w_shift_right = SRL | SRA`, `w_shift_arith = SRA`를 만들고 `i_shamt = i_b[SHAMT_W-1:0]`을 넘긴다. SHAMT_W는 XLEN 8/16/32에 대해 3/4/5다.
- `alu_shifter` 안에서 우시프트 코어 하나를 공유한다.
  - 우시프트: 입력을 그대로 코어에 넣고 출력을 그대로 쓴다.
  - 좌시프트: 입력 비트 반전 → 우시프트 → 출력 비트 반전.
  - 채움 비트 `fill = i_right & i_arith & i_din[XLEN-1]`. SRA이고 음수일 때만 1이다.

### 6.3 결과 선택과 플래그

`always @*`에서 `r_result`, `r_carry`, `r_ovf`에 기본값 0을 주고 `case (i_alu_op)`로 고른다.
`default`가 Reserved 처리이며 result=0이다. `zero`, `neg`는 선택된 결과에서 뽑고, `carry`, `ovf`는 ADD/SUB/SLT/SLTU 분기에서만 값을 채운다.

## 7. 덧셈기 변형

모든 덧셈기는 p = a^b, g = a&b에서 시작한다. 구조마다 carry를 만드는 방식이 다르다.

| 변형 | 코드 | 구조 | 설계 노트 기준 이론 특성 (가설) |
| --- | --- | --- | --- |
| `adder_rca` | 0 | 전가산기 W개 직렬. carry는 패킹 벡터 `w_c[W:0]`를 비트별 generate로 연결 | 면적 최소, 지연 최대 |
| `adder_cla` | 1 | radix-4 lookahead 트리. 아래로 내려오는 carry 방식 | 중간 |
| `adder_ks` | 2 | Kogge-Stone prefix, `ceil(log2 W)` 레벨, 레벨마다 span=2^l. carry-in을 bit 0 generate에 흡수 | 속도 최상 후보, 셀·배선 최대 |
| `adder_bk` | 3 | Brent-Kung prefix. up-sweep 후 down-sweep, `2L-1` 레벨 | KS보다 작고 느림 |
| `adder_beh` | 4 | `{cout,sum} = a + b + cin` 한 줄. `+`가 허용되는 유일한 덧셈기 | 툴이 구조를 고름. 기준선 |

KS, BK, CLA는 레벨을 패킹 벡터의 슬라이스(`[k*W +: W]`)로 표현해서 generate 블록 안의 net을 이름으로 읽는 계층 참조를 쓰지 않는다.
RCA, KS의 `/* verilator split_var */`는 lint 전용 힌트이며 합성에는 영향이 없다.

## 8. 시프터 코어 변형

둘 다 우시프트 전용이고 가변 시프트 연산자(`<<`, `>>`, `>>>`)를 쓰지 않는다.

| 변형 | 코드 | 구조 | 가설 |
| --- | --- | --- | --- |
| `shr_loop` | 0 | 1비트 시프트 단 XLEN-1개 직렬. 단 k는 `shamt > k`일 때 동작 | 면적·지연 모두 최대 후보 |
| `shr_barrel` | 1 | 단 k는 `shamt[k]`가 1이면 2^k만큼 이동. log2(XLEN)단 | 면적·지연 모두 작음 |

기준선을 barrel로 둔 이유: loop가 항상 critical path가 되어 덧셈기 차이를 가리기 때문이다.

## 9. alu_top: 레지스터와 타이밍

| 위치 | 레지스터 | 리셋 | enable |
| --- | --- | --- | --- |
| 입력단 | `a_q`, `b_q`, `op_q` (데이터) | 없음 | 없음 |
| 입력단 | `valid_in_q` | 비동기 active-low | - |
| 출력단 | `result_q`, `flag_q[3:0] = {zero, neg, carry, ovf}` (데이터) | 없음 | 없음 |
| 출력단 | `valid_out_q` | 비동기 active-low | - |

- XLEN=32 기준 입력 69비트 + 출력 37비트 = 106비트(설계 노트 표와 일치).
- 지연 2에지: 입력은 에지 n에 입력 레지스터에, 에지 n+1에 출력 레지스터에 잡힌다. 매 클록 1건 처리한다.
- `o_valid=0`일 때 `o_result`와 플래그는 don't care다. 검증도 `o_valid=1`일 때만 비교한다.
- 데이터 레지스터에 리셋·enable이 없는 정책은 모든 변형에 똑같이 적용한다. I/O 제약의 영향을 빼고 reg-to-reg 경로를 공정하게 비교하려고 입출력을 레지스터로 감쌌다.

### 관찰할 조합 경로 (합성 단계용)

| ID | 경로 |
| --- | --- |
| P1 | `a_q/b_q/op_q` → `b XOR sub` → 덧셈기 → ovf, SLT 비트 → 결과 mux → zero 검출 → `flag_q` |
| P2 | `a_q/b_q` → 시프터(입력 반전 + 코어 + 출력 반전) → 결과 mux → zero 검출 → `flag_q` |
| P3 | `op_q` → 디코드 → `sub`(팬아웃 XLEN+1) → `b XOR sub` → 덧셈기 → … |
| P4 | `a_q/b_q` → 논리 연산 → 결과 mux → `result_q` (짧은 경로) |

가장 긴 경로가 어느 것인지는 RTL만 보고 단정하지 않고 합성 타이밍 리포트로 확인한다.

## 10. 검증

테스트벤치는 `proj3_make/TOP/2_SIM/TESTBENCH/`에 있고, 블록마다 하나를 모든 변형이 공유한다.

| 테스트벤치 | 대상 | 설계 노트 항목 |
| --- | --- | --- |
| `tb_adder_top.v` | `adder_top` 전 변형 | V1 (W=8 전수), V2 (carry 체인), V3 (랜덤) |
| `tb_alu_shifter.v` | `alu_shifter` (loop, barrel) | V6 |
| `tb_alu_core.v` | `alu_core` | V4, V5, V6, V7, V8, V10 |
| `tb_alu_top.v` | `alu_top` | V9 |

- 기대값은 테스트벤치 안에서 `+ - *`와 시프트 연산자로 계산하고 `!==`로 비교한다(x/z도 잡는다).
- 난수는 테스트벤치 안의 xorshift32를 써서 Verilator와 iverilog가 같은 자극을 받는다. 시드는 고정이고 로그에 남긴다.
- 변형 조합의 출력 해시(HASH)가 모두 같아야 한다(V10). `run_regress.sh`가 자동 비교한다.
- 회귀 조합: `ADDER_ARCH` {4, 0, 1, 2, 3} × `SHIFTER_ARCH` {1, 0}, 그리고 XLEN {8, 16, 32}. lint와 Yosys `read_verilog` 점검도 같은 조합으로 돈다.
- 회귀 명령:

```bash
bash proj3_make/TOP/2_SIM/run_regress.sh   # MODE=full | vl | quick | static
```

## 11. 파일 목록

| 구분 | 파일 (`proj3_make/TOP/1_RTL/`) |
| --- | --- |
| ALU | `alu_top.v`, `alu_core.v`, `alu_shifter.v`, `alu_defs.vh` |
| 시프터 코어 | `shr_barrel.v`, `shr_loop.v` |
| 덧셈기 | `adder_top.v`, `adder_beh.v`, `adder_rca.v`, `adder_cla.v`, `adder_ks.v`, `adder_bk.v` |
| 파일 목록 | `rtl.f` (`+incdir+.` 포함. `alu_defs.vh`를 찾기 위해 필요) |

`adder_*`는 MAC 누산과 곱셈기 최종 합산도 같이 쓰는 공유 모듈이다.

## 12. 이 문서를 쓰면서 확인한 점

- **회귀는 이번에 돌리지 못했다.** 이 환경에 `iverilog`, `verilator`, `yosys`가 설치돼 있지 않다. 위 검증 내용은 테스트벤치와 `run_regress.sh`를 읽고 정리한 것이지, 통과 로그를 확인한 것이 아니다.
- 합성 결과(`3_SYN`)는 `alu_top`용으로 커밋돼 있지만, 이 문서에서는 해석하지 않았다. 합성 분석은 별도 지침의 일이다.
- 기존 모듈 노트에 오래된 표현이 남아 있다.
  - `module_notes/alu_top.md`는 `tb_ALU.v`, `module_notes/alu_shifter.md`는 `tb_shifter.v`라고 쓰는데, 실제 파일은 `tb_alu_top.v`, `tb_alu_shifter.v`다.
  - `module_notes/alu_shifter.md`는 "아직 없는 loop(0)"이라고 쓰는데, `shr_loop.v`는 이미 있고 `alu_shifter`가 선택한다.
  - 노트 수정은 승인을 받은 뒤에 하려고 이번에는 건드리지 않았다.
