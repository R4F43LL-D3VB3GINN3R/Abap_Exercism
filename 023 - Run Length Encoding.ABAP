*&---------------------------------------------------------------------*
*& Report ZEXERCISM_RUN_LENGTH_DECODING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zexercism_run_length_decoding.

class zcl_rle definition
  final
  create public .

  public section.

    methods encode importing input         type string
                   returning value(result) type string.

    methods decode importing input         type string
                   returning value(result) type string.

  private section.

    data: letter       type c length 1,
          len_word     type i,
          count_letter type i.

endclass.


class zcl_rle implementation.

  method encode.

    if input is not initial.

      "----------------------------------------------------------------------

      data: letter_ahead       type c length 1, "letra a frente
            count_letter_ahead type i,          "contador de letras a frente
            matches_letters    type i,          "contador de letras iguais
            stringnum          type string,     "contador de letras iguais em formato string.
            len_word           type i,          "tamanho da palavra
            flag               type abap_bool,  "evento de reset de contador
            last_char          type c length 1. "ultimo caractere

      me->count_letter = 0.                     "contador de caracteres da string
      count_letter_ahead = 1.                   "inicia o contador
      matches_letters    = 0.                   "inicia o contador de letras iguais
      flag = abap_false.                        "flag de evento
      len_word = strlen( input ).               "tamanho da palavra

      "----------------------------------------------------------------------
*      data: input2 type string.
*      input2 = input.
*
*      data: new_word type string value 'Rafael'.
*
*      shift input2 right deleting trailing space.
*      if input2 ne input.
*        add 1 to len_word.
*      endif.

      "o ciclo dura a quantidade de caracteres da string
      do len_word times.

        "se o contador de caracteres da letra a frente chegar na ultima letra...
        if count_letter_ahead eq len_word.
          "limpa as variaveis relacionadas a letra da frente para que nao hajam comparacoes
          "essa comparacao tem de ser evitada para nao haver estouro de index ao fim da string
          clear count_letter_ahead.
          clear letter_ahead.
          flag = abap_true.
        endif.

        "se a palavra ainda nao tiver chegado até o fim...
        if count_letter_ahead ne len_word.
          me->letter = input+count_letter(1).         "letra da string
          letter_ahead = input+count_letter_ahead(1). "letra da string a frente
        endif.

        if flag eq abap_true.
          clear letter_ahead.
        endif.

        "se a letra for igual a letra da frente...
        if letter eq letter_ahead.
          "e ainda nao tiver sido detectado uma letra igual a outra...
          if matches_letters eq 0.
             add 2 to matches_letters. "incrementa dois "AA" para sempre contar a primeira
            "se a mesma letra ja apareceu mais de duas vezes...
          else.
            add 1 to matches_letters. "incrementa um pra contar "AA + A"
          endif.
          "se a letra da frente for diferente da letra...
        else.
          "e se não houveram letras repetidas. "AB"
          if matches_letters eq 0.
            if me->letter is initial.
              concatenate result ' ' into result separated by space.
            else.
              concatenate result me->letter into result. "concatena ´string de saída a letra
            endif.
            "se houveram letras repetidas...
          else.
            stringnum = matches_letters. "casting int >> string
            if me->letter is not initial.
              concatenate stringnum me->letter into stringnum.
              condense stringnum no-gaps.
            else.
              if me->letter is initial and letter_ahead is initial.
                concatenate me->letter letter_ahead into stringnum.
              else.
                concatenate stringnum me->letter into stringnum separated by space.
              endif.
            endif.
            concatenate result stringnum into result. "concatena numero em string e letra
            matches_letters = 0. "redefine o contador de letras iguais
          endif.
        endif.

        add 1 to count_letter.       "incrementa o contador de caracteres
        add 1 to count_letter_ahead. "incrementa o contador de letras a frente.

      enddo.

    endif.

  endmethod.

  method decode.



  endmethod.

endclass.

start-of-selection.

  data: ol_rle type ref to zcl_rle.
  create object ol_rle.

  data: lv_input1  type string,
        lv_input2  type string,
        lv_result1 type string,
        lv_result2 type string.

  lv_input1 = '  hsqq qww  '. "codificar
  lv_input2 = '12WB12W3B24WB'.                                         "decodificar

  lv_result1 = ol_rle->encode( input = lv_input1 ).
  lv_result2 = ol_rle->decode( input = lv_input2 ).

  write: / lv_result1.
  write: / lv_result2.
