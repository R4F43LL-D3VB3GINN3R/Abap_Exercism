*&---------------------------------------------------------------------*
*& Report ZEXERCISM_MINESWEEPER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zexercism_minesweeper.

*&---------------------------------------------------------------------*

*Introduction
*Minesweeper is a popular game where the user has to find the mines using numeric hints that indicate how many mines are directly adjacent (horizontally, vertically, diagonally) to a square.
*
*Instructions

*Your task is to add the mine counts to empty squares in a completed Minesweeper board.
*The board itself is a rectangle composed of squares that are either empty (' ') or a mine ('*').
*
*For each empty square, count the number of mines adjacent to it (horizontally, vertically, diagonally).
*If the empty square has no adjacent mines, leave it empty. Otherwise replace it with the adjacent mines count.
*
*For example, you may receive a 5 x 4 board like this (empty spaces are represented here with the '·' character for display on screen):
*
*·*·*·
*··*··
*··*··
*·····
*Which your code should transform into this:
*
*1*3*1
*13*31
*·2*2·
*·111·

*&---------------------------------------------------------------------*

class zcl_minesweeper definition final create public.

  public section.
    types: string_table type standard table of string with empty key.
    methods annotate
      importing
        !input        type string_table
      returning
        value(result) type string_table.

endclass.

class zcl_minesweeper implementation.

  method annotate.

    field-symbols <other_line> type string.
    field-symbols <current_line> type string.
    result = input.
*   Trabalhando a partir de cada mina para fora - adicionando 1 a cada campo adjacente que não seja uma mina
    loop at result assigning <current_line>.
      check <current_line> ca '*'.
      data(current_row) = sy-tabix.
*     começar uma linha acima
      do strlen( <current_line> ) times.
        data(row) = current_row - 1.
        data(current_off) = sy-index - 1.
        check substring( val = <current_line> off = current_off len = 1 ) eq '*'.
        do 3 times.
*         para cada linha, comece um caractere à esquerda do atual
          data(off) = current_off - 1.
*         "uma linha acima, mesma linha e uma linha abaixo - se a linha existir
          read table result index row assigning <other_line>.
          if sy-subrc eq 0.
            do 3 times.
*             exceto o caractere atual
              if row ne current_row or off ne current_off.
*               verificar limites porque as funções internas substring e replace não lançam exceções
                if off between 0 and ( strlen( <other_line> ) - 1 ).
                  data(current_field) = substring( val = <other_line> off = off len = 1 ).
                  if current_field ne '*'.  "campo é uma mina - não fazer nada
                    data(count_mines) = conv i( substring( val = <other_line> off = off len = 1 ) ).
                    count_mines = count_mines + 1.
                    <other_line> = replace( val = <other_line> off = off len = 1 with = |{ count_mines }| ).
                  endif.
                endif.  "fora dos limites
              endif.
              off = off + 1.
            enddo.
          endif.
*         linha não existe - tente a próxima
          row = row + 1.
        enddo.
      enddo.
    endloop.


  endmethod.

endclass.

start-of-selection.

  data: ol_minesweeper type ref to zcl_minesweeper.
  create object ol_minesweeper.

  data: it_input  type ol_minesweeper->string_table,
        it_result type ol_minesweeper->string_table.

  it_input = value #( ( `   ` )
                      ( ` * ` )
                      ( `   ` ) ).

  it_result = ol_minesweeper->annotate( input = it_input ).
