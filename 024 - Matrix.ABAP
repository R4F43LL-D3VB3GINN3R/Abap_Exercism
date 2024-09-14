*&---------------------------------------------------------------------*
*& Report ZEXERCISM_MATRIX
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zexercism_matrix.

*&---------------------------------------------------------------------*

*Instructions
*Given a string representing a matrix of numbers, return the rows and columns of that matrix.
*
*So given a string with embedded newlines like:
*
*9 8 7
*5 3 2
*6 6 7
*representing this matrix:
*
*    1  2  3
*  |---------
*1 | 9  8  7
*2 | 5  3  2
*3 | 6  6  7
*your code should be able to spit out:
*
*A list of the rows, reading each row left-to-right while moving top-to-bottom across the rows,
*A list of the columns, reading each column top-to-bottom while moving from left-to-right.
*The rows for our example matrix:
*
*9, 8, 7
*5, 3, 2
*6, 6, 7
*And its columns:
*
*9, 5, 6
*8, 3, 6
*7, 2, 7

*&---------------------------------------------------------------------*

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
        string       type string
      exporting
        count_rows   type i
        endlines     type i
        blank_spaces type i
      changing
        result       type integertab.
  protected section.
  private section.

endclass.

class zcl_matrix implementation.
  method matrix_row.

    "-------------------------------

    "variavel para receber entrada
    data: lv_string type string.
    lv_string = string.

    "-------------------------------

    data: it_result  type table of string, "guarda caracteres da string com espaço
          it_result2 type table of string, "numeros tratados
          it_result3 type table of string. "numeros tratados

    data: len_string   type i,          "tamanho da string
          letter       type c length 1, "letra
          count_letter type i,          "contador de letras
          stringnum    type string.     "string de numero

    data: lv_blank_spaces type i. "espacos em branco

    len_string = strlen( lv_string ). "pega o tamanho da string

    "itera sobre a string e passa os caracteres para a tabela
    do len_string times.
      letter = lv_string+count_letter(1). "recebe a letra da string
      "se a string nao tiver nem /...
      if letter cn '\/'.
        "se o caractere for vazio
        "separamos os numeros com blank spaces
        if letter eq ' '.
          stringnum = ' '.
          "se houver uma quebra de linha
          "separamos as linhas com --
        elseif letter eq 'n'.
          stringnum = '-'.
          "do contrario...
          "formamos o numer tenha ele um ou mais caracteres
        else.
          concatenate stringnum letter into stringnum.
        endif.
        "ao fim, inserimos o numero na tabela e limpamos a variavel
        append stringnum to it_result. "insere o numero na tabela
        clear stringnum.
      endif.
      add 1 to count_letter. "incrementa o contrador de letras
    enddo.

    if it_result is not initial.

      "controlador do index
      data: index_control type i.
      index_control = 1.


      data: stringnumber type string, "string do numero
            row1         type string, "linha
            row2         type string. "linha da frente

      "tratamento da tabela
      loop at it_result into data(ls_result).

        "le a tabela a partir do index
        read table it_result into ls_result index index_control.

        row1 = ls_result. "recebe a linha

        "le a linha da frente da tabela
        read table it_result into ls_result index index_control + 1.

        row2 = ls_result. "recebe a linha da frente

        "se ainda estiver na mesma linha
        if row1 ne '-'.
          "se for apenas um digito com um numero a frente antes de acabar a linha
          if row1 ne ' ' and row2 ne ' ' and row2 ne '-'.
            concatenate stringnumber row1 into stringnumber.
            "se chegar ao fim do numero, tenha ele um digito ou mais
          elseif row1 ne ' ' and row2 eq ' ' and row2 ne '-'.
            concatenate stringnumber row1 into stringnumber.
            append stringnumber to it_result2. "insere a tabela
            clear stringnumber.                "limpa o numero
            "se for um numero logo antes da linha terminar
          elseif row1 ne ' ' and row2 ne ' ' and row2 eq '-'.
            concatenate stringnumber row1 into stringnumber.
            append stringnumber to it_result2. "insere a tabela
            clear stringnumber.                "limpa o numero
          endif.
          "se ultrapassar a linha
        else.
          append 'x' to it_result2. "demarca que ultrapassou a linha
        endif.

        add 1 to index_control. "incrementa o index
      endloop.

      "insere a ultima linha na tabela
      append stringnumber to it_result2.

    endif.

    "---------------
    "output ex:
*         1  1
*         2  2
*         3  x
*         4  10
*         5  20
    "---------------

    "se a tabela nao estiver vazia
    if it_result2 is not initial.

      "controlador de index e string de linha
      data: count_indexes type i.
      count_indexes = 0.
      data: numstring2 type string.
      numstring2 = ''.

      "ciclo dura a quantidade de linhas da tabela
      do lines( it_result2 ) times.

        "se houver uma quebra de linha
        if ls_result eq 'x'.
          append numstring2 to it_result3. "insere a linha na tabela
          clear numstring2.                "limpa a variavel
          add 1 to count_indexes.          "incrementa o index
        "se ainda estiver na mesma linha
        else.
          add 1 to count_indexes. "apenas incrementa o index
        endif.
        "le a linha da tabela referente ao index e so passa a frente caso a linha tenha terminado
        read table it_result2 into ls_result index count_indexes.
        concatenate numstring2 ls_result into numstring2 separated by space. "continua concatenando os numeros
      enddo.

      "insere a ultima linha da tabela
      append numstring2 to it_result3.

    endif.

    "se a tabela de tratamento nao estiver vazia
    if it_result3 is not initial.

      data: len_line type i,        "tamanho da linha
            numstring3 type string, "string do numero
            num3 type c length 1,   "digito
            countnum type i.        "contador da string

      "le a tabela no index do parametro
      read table it_result3 into data(ls_data3) index index.

      len_line = strlen( ls_data3 ). "recebe o tamanho da linha do index

      "ciclo dura a quantidade de caracteres que a linha possui
      do len_line times.

        "le a linha da tabela e apenas ela
        read table it_result3 into ls_data3 index index.

            "output - it_result3
                "----------
*                1   1  2 x
*                2   10 20
                "----------

        num3 = ls_data3+countnum(1). "recebe caractere da linha

        "se o caractere nao for um espaço vazio...
        if num3 ne ' '.
          concatenate numstring3 num3 into numstring3. "concatena na string
        "se a o caractere for vazio, nao for um x e nao for o primeiro caractere da linha...
        elseif num3 eq ' ' and num3 ne 'x' and countnum is not initial.
          append numstring3 to result. "insere o numero na tabela de saida
          clear numstring3.            "limpa a string para receber o proximo numero
        endif.

        add 1 to countnum. "incrementa para o proximo digito ou caractere

      enddo.

      append numstring3 to result. "insere a ultima linha na tabela
      clear numstring3.            "limpa a string

    endif.

  endmethod.

  method matrix_column.

    data: it_numtable     type standard table of i with empty key, "tabela que recebe os numeros tratados
          index_control   type i,                                  "controlador de index
          numrows         type i,                                  "numero de linhas
          lv_string       type string,                             "string da matriz
          lv_endline      type i,                                  "finais de linhas
          lv_index        type i,                                  "recebe valores do index
          lv_blank_spaces type i.                                  "espacos em branco

    lv_index = index.         "recebe a variavel do index
    lv_string     = string.   "variavel recebe a string da matriz
    index_control = lv_index. "controlador de index recebe o index

    "metodo para tratar a tabela a partir da string da matriz
    me->data_table_prepare(
      exporting
        string     = string            "envia a string da matriz
      importing
        count_rows = numrows           "recebe o numero de linhas
        endlines   = lv_endline        "conta o numero de finais de linhas
        blank_spaces = lv_blank_spaces "espacos em branco
      changing
        result     = it_numtable "recebe a tabela interna tratada
    ).

    "verificacao final para controlar a posicao do index conforme a string de entrada
    if numrows mod 2 eq 0 and lv_blank_spaces mod 2 eq 1 and index mod 2 eq 0.
      numrows = ( numrows / 2 ) .
    elseif numrows mod 2 eq 0 and lv_blank_spaces mod 2 eq 0 and index mod 2 eq 1.
      numrows = ( numrows / 2 ).
    elseif numrows mod 2 eq 0 and lv_blank_spaces mod 2 eq 0 and index mod 2 eq 0.
      numrows = ( numrows / 2 ) - 1.
    elseif lv_blank_spaces mod 2 = 0 and lv_blank_spaces mod 2 eq 1.
      numrows = ( numrows / 2 ) - 1.
    elseif lv_blank_spaces mod 2 = 1.
      numrows = ( numrows / 2 ) + 1 .
    endif.

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

      "se a letra for vazia...
      if letter is initial.
        add 1 to blank_spaces. "conta o caractere como espaco em branco
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

  lv_string = '1 2 3\n4 5 6\n7 8 9\n8 7 6'.
  lv_index = 4.

  it_result = ol_matrix->matrix_column(
                string = lv_string
                index  = lv_index
              ).

  it_result = ol_matrix->matrix_row(
                string = lv_string
                index  = lv_index
              ).

  cl_demo_output=>display( it_result ).
