# alu_shifter

**하는 일**: ALU의 SLL / SRL / SRA를 한 모듈로 처리한다. 포트: `i_din, i_shamt, i_right, i_arith, o_dout`.

**구조**: 오른쪽 시프트 코어(`shr_barrel`) 하나를 3가지 연산이 공유한다.
- SRL / SRA: 입력을 그대로 코어에 넣는다.
- SLL: 입력 비트 순서를 뒤집어서 → 오른쪽 시프트 → 결과를 다시 뒤집는다. (왼쪽 시프트 = 뒤집고 오른쪽 시프트하고 되돌리기)
- 채움 비트 = `i_right & i_arith & i_din[최상위]` → SRA이고 음수일 때만 1.

**왜 이렇게**
- 시프터 로직을 하나만 두면 SLL/SRL/SRA가 면적을 나눠 쓰고, 구조 비교(loop vs barrel)도 코어 하나만 바꾸면 된다.
- `SHIFTER_ARCH`(0 loop / 1 barrel)로 코어 선택. 아직 없는 loop(0)이나 지원 안 하는 XLEN은 존재하지 않는 모듈을 인스턴스해서 컴파일 에러가 나게 했다(조용한 대체 금지).

**합성 가설**: 비트 반전은 배선뿐이라 비용이 거의 없고, 입출력 2:1 mux 두 줄이 추가된다. 덧셈기보다 느린 경로가 되는지는 기준선(barrel)에서 보면 된다.

**검증**: `tb_alu_shifter.v` — XLEN=8은 모든 데이터 × 모든 shamt × 3연산 전수, 16/32는 코너 + 랜덤 × 모든 shamt. SRA 부호 0/1, shamt 전체 도달 확인.
