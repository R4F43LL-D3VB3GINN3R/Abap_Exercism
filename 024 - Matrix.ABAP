....
*&---------------------------------------------------------------------*
*& Report ZEXERCISM_MATRIX
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zexercism_matrix.

class zcl_matrix definition
  final
  create public .

  public section.
    types integertab type standard table of i with empty key.
    methods matrix_row
      importing
        string        type string
        index         type i
      returning
        value(result) type integertab.
    methods matrix_column
      importing
        string        type string
        index         type i
      returning
        value(result) type integertab.
    methods data_table_prepare
      importing
        string     type string
      exporting
        count_rows type i
        endlines   type i
      changing
        result     type integertab.
  protected section.
  private section.

endclass.

class zcl_matrix implementation.
  method matrix_row.

  endmethod.

  method matrix_column.

*    -----------------------------------------------------------

    data: it_numtable type standard table of i with empty key, "tabela que recebe os numeros tratados
          index_control type i,                                "controlador de index
          numrows type i,                                      "numero de linhas
          lv_string type string,                               "string da matriz
          lv_endline type i,                                   "finais de linhas
          lv_index type i.                                     "recebe valores do index

    lv_index = index.         "recebe a variavel do index

    if index mod 2 eq 1.
      add 1 to lv_index.
    endif.

    lv_string     = string.   "variavel recebe a string da matriz
    index_control = lv_index. "controlador de index recebe o index

    "metodo para tratar a tabela a partir da string da matriz
    me->data_table_prepare(
      exporting
        string     = string      "envia a string da matriz
      importing
        count_rows = numrows     "recebe o numero de linhas
        endlines   = lv_endline  "conta o numero de finais de linhas
      changing
        result     = it_numtable "recebe a tabela interna tratada
    ).

    "-----------------------------------------------------------

    "itera sobre a tabela tratada
    loop at it_numtable into data(ls_numtable).

      "le a linha da tabela relacionada ao index enviado
      read table it_numtable into ls_numtable index index_control.

*     se as linha da tabela de saida forem iguais ao limite do numero de linhas
      if lines( result ) ge lv_endline.
        exit. "quebra o ciclo...
      endif.

      append ls_numtable to result.            "insere o numero na tabela
      index_control = index_control + numrows. "incrementa o index

    endloop.

  endmethod.

  method data_table_prepare.

    "-------------------------------

    "variavel para receber entrada
    data: lv_string type string.
    lv_string = string.

    "-------------------------------

    data: it_result  type table of string, "guarda caracteres da string com espaço
          it_result2 type table of string. "recebe numeros tratados

    data: len_string   type i,          "tamanho da string
          letter       type c length 1, "letra
          count_letter type i.          "contador de letras

    data: lv_blank_spaces type i. "espacos em branco

    len_string = strlen( lv_string ). "pega o tamanho da string

    "itera sobre a string e passa os caracteres para a tabela
    do len_string times.
      letter = lv_string+count_letter(1). "recebe a letra da string

      if letter is initial.
        add 1 to lv_blank_spaces.
      endif.

      "se a string nao tiver nem / e nem n...
      if letter cn '\/'.
        if letter eq 'n'.
          letter = ''.
          add 1 to endlines.
          clear count_rows.
        endif.
        append letter to it_result. "insere o numero na tabela
      endif.
        add 1 to count_rows.   "incrementa o count row
        add 1 to count_letter. "incrementa o contrador de letras
      enddo.

    "o contador de colunas sempre retorna metade do seu numero...
    "por causa dos espaços em branco
    if lv_blank_spaces mod 2 = 0.
      count_rows = ( count_rows / 2 ) - 1.
    else.
      count_rows = ( count_rows / 2 ) .
    endif.

    add 1 to endlines. "incrementa para contabilizar a ultima linha.

    "se a primeira tabela nao estiver vazia
    if it_result is not initial.

      data: index_control type i. "controla o index

      "variaveis para tratar caracteres...
      data: letter2            type c length 1,
            letter_ahead       type c length 1,
            number             type string,
            number2            type string,
            stringnumber       type i,
            count_letter2      type i,
            count_letter_ahead type i.

      index_control = 1. "inicia o index para começar pela primeira linha

      "itera sobre a tabela para tratar os numeros.
      do lines( it_result ) times.

        "compara a letra com a letra da frente...
        read table it_result into data(ls_result) index index_control.

        letter2 = ls_result. "recebe a letra

        add 1 to index_control. "incrementa o index

        "incrementa o index para comparar com a letra da frente
        read table it_result into ls_result index index_control.

        letter_ahead = ls_result. "recebe a letra da frente

        "se a letra da frente nao for um espaço em branco
        if letter_ahead is not initial.
          concatenate number letter2 into number. "forma o numero digito a digito
          "se for um espaço em branco...
          "ou seja...se o numero esta totalmente formado...
        else.
          concatenate number2 number letter2 into number2. "insere o numero completo na variavel
          append number2 to it_result2. "insere o numero completo na tabela
          "limpa as variaveis
          clear number2.
          clear number.
        endif.

        "verificacao para inserir o ultimo numero da ultima linha na tabela
        if index_control eq lines( it_result ) + 1.
          append number to it_result2.
        endif.
       enddo.

    endif.

    result = it_result2. "passa a tabela para a tabela de saida

  endmethod.

endclass.

start-of-selection.

  data: ol_matrix type ref to zcl_matrix.
  create object ol_matrix.

  data: lv_string type string,
        lv_index  type i,
        it_result type ol_matrix->integertab.

  lv_string = '1 2 3\n4 5 6\n7 8 9'.
  lv_index = 3.

  it_result = ol_matrix->matrix_column(
                string = lv_string
                index  = lv_index
              ).

  cl_demo_output=>display( it_result ).
