"----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*Instructions
*Determine if a word or phrase is an isogram.
*
*An isogram (also known as a "non-pattern word") is a word or phrase without a repeating letter, however spaces and hyphens are allowed to appear multiple times.
*
*Examples of isograms:
*
*lumberjacks
*background
*downstream
*six-year-old
*The word isograms, however, is not an isogram, because the s repeats.

"----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

report zexercism.

class zcl_isogram definition.

  public section.
    methods is_isogram
      importing
        value(phrase) type string
      returning
        value(result) type abap_bool.
  protected section.
  private section.
endclass.

class zcl_isogram implementation.

  method is_isogram.

    "iniciamos o parametro de saida como verdadeiro
    "ele receberá falso, caso algum digrafo seja detectado na palavra ou frase
    result = abap_true.

    "variavel recebe o parametro de entrada
    data: phrase2 type string.
    phrase2 = phrase.

    data: letter       type c length 1, "letra
          count_letter type i,          "contador de letras
          num_letters  type i.          "quantidade de letras

    num_letters = strlen( phrase ). "pega o comprimento da frase
    count_letter = 0.               "inicia o contador

    data: it_letters type table of string. "tabela para receber cada letra da palavra

    data: letter_appears type i. "variavel para receber a quantidade de vezes que uma letra aparece na frase

    "itera sobre o parametro de entrada
    do num_letters times.
      letter = phrase2+count_letter(1). "recebe a letra da frase
      append letter to it_letters.      "insere a letra na tabela
      add 1 to count_letter.            "incrementa o contador
    enddo.

    "limpa as variaveis
    clear count_letter.
    clear letter.

    "itera novamente sobre a palavra
    do num_letters times.
      letter = phrase2+count_letter(1). "recebe cada letra da palavra

      "itera sobre a tabela de letras
      loop at it_letters into data(ls_letters).

        "verifica se a letra se encontra na tabela de letras
        if letter eq ls_letters and letter ne '-'.
          add 1 to letter_appears. "contabiliza a quantidade de vezes que a variavel apareceu na mesma frase
        endif.

        "verificacao adicional para detectar digrafos como 'ph'
        "comparamos a letra com a linha a sua frente
        read table it_letters into ls_letters index sy-tabix + 1.
        if letter eq 'p' and ls_letters eq 'h'.
          result = abap_false.
        endif.
      endloop.

      "se a letra apareceu duas vezes na tabela...
      "ou seja, na mesma frase...
      if letter_appears gt 1.
        result = abap_false.
      endif.

      clear letter_appears. "limpa o contador de incidências
      add 1 to count_letter. "incrementa o contador
    enddo.

  endmethod.

endclass.

start-of-selection.

  data ol_isogram type ref to zcl_isogram.

  create object ol_isogram.

  data: lv_phrase type string,
        lv_result type abap_bool.

  lv_phrase = 'alpha'.

  lv_result = ol_isogram->is_isogram( phrase = lv_phrase ).

  if lv_result eq abap_false.
    write: 'no'.
  else.
    write: 'yea'.
  endif.

"-------------------------------------------------------------------------------------------------------------------------------------------
