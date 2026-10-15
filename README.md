# ALU / MAC RTL (합성 비교용)

RISC-V 방식 연산 10종 ALU와 곱해서 누적하는 MAC. 덧셈기, 시프터, 곱셈기, MAC 파이프라인 단수를 **파라미터만 바꿔** 갈아 끼우면서 같은 포트, 같은 테스트로 기능이 같음을 확인하고, 이후 같은 RTL로 합성·PPA 비교를 하기 위한 코드다. Verilog-2001.

| 보고 싶은 것 | 위치 |
|---|---|
| 코드 해석 (구조, 파라미터, 동작, 검증 상태, 한계) | `docs/RTL_코드_해석.md` (`.docx` 포함) |
| 스펙의 단일 출처 (포트, 인코딩, 플래그, 검증 항목, 결정 기록) | `docs/ALU_MAC_design_note.md` |
| 모듈별 설명 | `docs/module_notes/` |
| 합성에 쓰는 RTL, 파일 목록 | `proj3_make/TOP/1_RTL/` , `rtl.f` |
| 테스트벤치와 회귀 | `proj3_make/TOP/2_SIM/` |

**톱 모듈**: `alu_top`(파라미터 `XLEN`, `ADDER_ARCH`, `SHIFTER_ARCH`), `mac_top`(`A_W`, `MULT_ARCH`, `ADDER_ARCH`, `MAC_STAGES`).
**회귀**: `bash proj3_make/TOP/2_SIM/run_regress.sh` (끝에 `ALL OK`). 사용 도구: Verilator, iverilog, Yosys.
**작업 지침**: `CLAUDE.md`.
