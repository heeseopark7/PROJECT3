# mul_top

**하는 일**: 곱셈기의 단일 입구. `MULT_ARCH`로 곱셈기 구현을 고른다(0 BEH, 1 Array, 2 Booth+Wallace). 포트는 `i_a, i_b → o_p`로 모두 같다.

**구조**: `generate if`로 고른다.
- `MULT_ARCH=0`: `mul_beh` (곱셈 `*` 한 줄).
- `MULT_ARCH=1`(Array) 또는 `2`(Booth+Wallace): `mul_csa_top`이 `o_s`, `o_c`를 만들고, 마지막 덧셈을 `adder_top`(`ADDER_ARCH`로 선택, 폭 2·A_W)이 한다. 곱 `o_p`는 2^(2·A_W)로 나머지를 취한 값이라 `adder_top`의 carry-out은 쓰지 않는다.
- 그 외 값은 `mul_csa_top`에서 컴파일 에러가 난다.

**왜 이렇게**: 아직 없는 `MULT_ARCH`(또는 지원하지 않는 `A_W`)가 들어오면 **존재하지 않는 모듈**(`mul_arch_not_implemented`)을 인스턴스해서 컴파일 단계에서 에러가 난다. `adder_top`, `alu_shifter`와 같은 규칙이다. 구조형 곱셈기의 최종 합산이 `adder_top`을 지나므로 `ADDER_ARCH` 파라미터가 생겼다(BEH일 때는 쓰이지 않는다). 곱셈기를 비교할 때는 `ADDER_ARCH`를 BEH로 고정해서 덧셈기 차이가 섞이지 않게 한다.

**합성 가설**: 이 모듈 자체는 배선뿐이고 차이는 안쪽 곱셈기에서 나온다. 합성 후에도 `u_mul` 경계가 남아 있는지로 구조 유지 여부를 볼 수 있다.

**검증** (`tb_mul.v`, M1, M2): A_W=4, 8은 모든 (a, b) 전수(65,536개 포함), A_W=16은 코너 49쌍(−32768×−32768 포함) + 고정 시드 100만 랜덤. 양×양, 음×음, 양×음, 0, min×min 도달 확인 100%. BEH와 Array의 출력 해시가 같고, Array는 `ADDER_ARCH` 0, 2, 4 모두에서도 같다(10만 랜덤).
