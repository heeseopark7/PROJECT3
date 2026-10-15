# alu_core

**하는 일**: ALU의 계산 부분 전체. 클록 없는 순수 조합 회로로, `i_a, i_b, i_alu_op`를 받아 `o_result`와 플래그 4개(zero, neg, carry, ovf)를 낸다. 연산 10종 + Reserved 6개 코드.

**구조** (블록 하나씩)
1. **덧셈기 하나 공유**: ADD / SUB / SLT / SLTU가 `adder_top` 하나를 같이 쓴다. 빼기는 "b를 뒤집고(`b_eff = b XOR sub`) 1을 더하기"(2의 보수)라서 `sub=1`일 때 `i_b`를 반전하고 `i_cin=sub`로 넣는다.
2. **비교는 덧셈기 결과 재활용**: SLT(부호 있는 비교) = `sum[MSB] XOR ovf`, SLTU(부호 없는 비교) = `~cout`. 별도 비교기가 없다.
   - `ovf`(overflow, 부호 있는 수의 범위를 넘침) = "a와 b_eff의 부호가 같은데 결과 부호가 다르다".
3. **시프터 하나 공유**: SLL/SRL/SRA는 `alu_shifter` 하나를 쓰고, 시프트양은 `i_b`의 하위 log2(XLEN)비트만 쓴다.
4. **논리 연산**: XOR / OR / AND는 비트 연산 그대로.
5. **결과 선택**: `always @*` + `case`로 결과를 고른다. 맨 위에서 result/carry/ovf에 기본값(0)을 주고, `default`(Reserved)는 result = 0.
6. **플래그**: zero = (결과 == 0), neg = 결과의 MSB, carry/ovf는 ADD/SUB/SLT/SLTU에서만 덧셈기 값을 쓰고 나머지는 0.

**왜 이렇게**
- `alu_core`에는 `+ - *`가 없다. 덧셈은 전부 `adder_top`을 거치고, 덧셈기 인스턴스는 하나뿐이다. 그래야 `ADDER_ARCH`만 바꿔서 구조 비교가 된다.
- zero/neg를 "선택된 결과"에서 뽑는다. 그래서 SLT/SLTU의 neg는 자동으로 0이고, Reserved는 result=0이라 zero=1이 된다.
- 플래그 유효 범위(carry/ovf는 4개 연산만)는 case 안에서 명시적으로 정했다.

**합성 단계 가설** (수치 단정 아님)
- P1(`b XOR sub` → 덧셈기 → ovf/SLT 비트 → 결과 mux → zero 검출)이 가장 길 가능성이 있다. 특히 결과 mux 뒤의 zero 검출(OR 트리)이 붙는 게 부담일 것 같다.
- `sub` 신호가 XLEN+1개 부하에 연결되는데, 이건 배치/버퍼링 이야기라 PnR 단계에서 볼 일이다.
- 덧셈기 변형(RCA ↔ BEH ↔ KS)의 차이가 시프터나 zero 검출 경로에 가려지는지가 T2 측정의 핵심 질문이다.

**검증** (`2_SIM/TESTBENCH/tb_alu_core.v`)
- XLEN=8은 a, b 전체 × 16개 코드 전수. 16/32는 코너 7×7쌍 + 고정 시드 랜덤 + 모든 shamt(상위 비트 랜덤) × 16개 코드.
- 노트의 검산용 예시 8개를 숫자 그대로 먼저 검사한다(XLEN=32).
- 기대값 모델은 DUT 수식을 복사하지 않고 "XLEN+1비트로 부호 확장해서 계산"하는 별도 방식이다.
- 모든 출력의 해시를 로그에 찍어서, `ADDER_ARCH` 조합끼리 해시가 완전히 같은지 비교한다(V10).
- 변이 테스트: SLTU 반전 제거 / ovf 수식 오류 / SRA→SRL / Reserved가 a를 내보냄 / carry 누락, 5가지 모두 FAIL로 잡혔다.

**도달 가능한 플래그 조합 (정정 기록)**: zero, neg, carry, ovf 4개를 묶은 16가지 중 실제로 나올 수 있는 건 ADD 9개, SUB 7개다. SUB를 처음에 6개로 유도했는데 틀렸다. 예: a=1, b=−1(0xFFFFFFFF)이면 부호 있는 차이는 +2로 오버플로 없이 결과가 양수이고, 부호 없는 비교로는 a<b라 borrow가 생겨 `z0 n0 c0 v0`이 나온다. 시뮬 도달 결과와 다시 손으로 따져본 값이 일치해서 7개로 확정했다.
