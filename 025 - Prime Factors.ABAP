*&---------------------------------------------------------------------*
*& Report ZEXERCISM_PRIME_FACTORS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zexercism_prime_factors.

*&---------------------------------------------------------------------*

*Instructions

*Compute the prime factors of a given natural number.
*
*A prime number is only evenly divisible by itself and 1.
*
*Note that 1 is not a prime number.
*
*Example
*What are the prime factors of 60?
*
*Our first divisor is 2. 2 goes into 60, leaving 30.
*2 goes into 30, leaving 15.
*2 doesn't go cleanly into 15. So let's move on to our next divisor, 3.
*3 goes cleanly into 15, leaving 5.
*3 does not go cleanly into 5. The next possible factor is 4.
*4 does not go cleanly into 5. The next possible factor is 5.
*5 does go cleanly into 5.

*We're left only with 1, so now, we're done.
*Our successful divisors in that computation represent the list of prime factors of 60: 2, 2, 3, and 5.
*
*You can check this yourself:
*
*2 * 2 * 3 * 5
*= 4 * 15
*= 60

*Success!

*&---------------------------------------------------------------------*

class zcl_prime_factors definition
  final
  create public .

  public section.
    types integertab type standard table of i with empty key.
    methods factors
      importing
        input         type int8
      returning
        value(result) type integertab.
  protected section.
  private section.

endclass.


class zcl_prime_factors implementation.
  method factors.

    "numero de fastoracao
    data: lv_input2 type int8.
    lv_input2 = input.


    data: lv_divided type p decimals 2. "dividendo
    data: lv_nextnum type i.            "divisor
    lv_nextnum = 2.                     "inicia o divisor

    "enquanto houver numero a ser dividido...
    while lv_input2 ne 1.

      "se o resto da divisao for zero...
      if lv_input2 mod lv_nextnum eq 0.
        lv_divided = lv_input2 / lv_nextnum. "realiza a operacao de divisao
        lv_input2 = lv_divided.              "ajusta a entrada para receber o resultado da divisao
        append lv_nextnum to result.         "insere o divisor na tabela
      "se o numero nao for divisivel...
      else.
        add 1 to lv_nextnum. "incrementa o divisor
      endif.

      "se nao houver mais nada para dividir
      if lv_divided eq 1.
        exit. "interrompe o ciclo

      endif.

    endwhile.

  endmethod.

endclass.

start-of-selection.

  data: ol_primefactors type ref to zcl_prime_factors.
  create object ol_primefactors.

  data: lv_input8 type int8,
        it_result type ol_primefactors->integertab.

  lv_input8 = 10.

  it_result = ol_primefactors->factors( input = lv_input8 ).

  cl_demo_output=>display( it_result ).
