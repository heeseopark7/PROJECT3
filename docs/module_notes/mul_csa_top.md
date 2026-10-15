# mul_csa_top

**하는 일**: carry-save 형태까지만 만드는 구조형 곱셈기들의 단일 입구. `MULT_ARCH`로 고른다(1 Array, 2 Booth+Wallace). 포트는 `i_a, i_b → o_s, o_c`로 같다. 약속: `o_s + o_c ≡ a×b (mod 2^(2·A_W))`.

**구조**: `generate if`로 `mul_array_csa`(1)를 인스턴스한다. 2(Booth)는 아직 없다.

**왜 이렇게**
- `MULT_ARCH=0`(BEH)은 지원하지 않는다. `*` 연산자는 툴이 안에서 알아서 곱셈 구조를 만들기 때문에 carry-save 경계가 없어서다(그래서 MAC 3단도 BEH에서는 불가).
- 미구현 `MULT_ARCH`나 `A_W`는 존재하지 않는 모듈(`mul_csa_arch_not_implemented`)을 인스턴스해서 컴파일 단계에서 에러가 난다. 다른 구현으로 조용히 대체하지 않는다.
- `mul_top`이 이 모듈에 `adder_top`을 붙여 `o_p`를 만들고, 3단 MAC은 이 둘 사이에 레지스터를 둔다. 이 모듈이 따로 있어야 그 자리를 자를 수 있다.

**합성 가설**: 이 모듈 자체는 배선이다. 합성 후에도 `u_mul` 경계가 남는지로 구조 유지 여부를 본다.
