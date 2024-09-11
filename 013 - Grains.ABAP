"----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*Instructions
*Calculate the number of grains of wheat on a chessboard given that the number on each square doubles.
*
*There once was a wise servant who saved the life of a prince. The king promised to pay whatever the servant could dream up. 
*Knowing that the king loved chess, the servant told the king he would like to have grains of wheat. 
*One grain on the first square of a chess board, with the number of grains doubling on each successive square.
*
*There are 64 squares on a chessboard (where square 1 has one grain, square 2 has two grains, and so on).
*
*Write code that shows:
*
*how many grains were on a given square, and
*the total number of grains on the chessboard

"----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

report exercism.

class zcl_grains definition
  final
  create public .

  public section.
    types type_result type p length 16 decimals 0.
    methods square
      importing
        input         type i
      returning
        value(result) type type_result
      raising
        cx_parameter_invalid.
    methods total
      returning
        value(result) type type_result
      raising
        cx_parameter_invalid.
  protected section.
  private section.

endclass.

class zcl_grains implementation.
  method square.

    " valida o parametro de entrada
    if input < 1 or input > 64.
      raise exception type cx_parameter_invalid
        exporting
          parameter = 'Input fora do intervalo permitido (1-64)'.
    endif.
    
    "pega o quadrado do numero - 1 para começar como elevado a zero.
    "visto que o index em abap sempre começa em 1
    result = 2 ** ( input - 1 ).

  endmethod.

  method total.
    
    "variavel para receber o total
    data: lv_total type type_result.
    
    "inicia a variavel
    lv_total = 0.

    "conta as 64 casas do xadrez
    do 64 times.
      "total recebe a soma dos quadrados do index
      lv_total = lv_total + me->square( sy-index ).
    enddo.
    
    "parametro de saida recebe o total
    result = lv_total.

  endmethod.
endclass.

start-of-selection.

  data: ol_grains type ref to zcl_grains,
        lv_decnum type zcl_grains=>type_result.

  create object ol_grains.

  try.
      lv_decnum = ol_grains->total( ).
    catch cx_parameter_invalid into data(lx_invalid).
      write: / 'Erro: ', lx_invalid->get_text( ).
      return.
  endtry.

  write: / 'Total de grãos:', lv_decnum.
