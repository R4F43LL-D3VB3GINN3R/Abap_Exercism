*&---------------------------------------------------------------------*
*& Report ZEXERCISM_ANAGRAM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zexercism_anagram.

class zcl_anagram definition
  final
  create public .

  public section.
    methods anagram
      importing
        input         type string
        candidates    type string_table
      returning
        value(result) type string_table.
  protected section.
  private section.
endclass.

class zcl_anagram implementation.
  method anagram.

    "tamanho da palavra de entrada
    data: len_word     type i.

    "palavras da tabela
    data: t_letter       type c length 1,
          len_t_word     type i,
          count_t_letter type i.

    "contador de matches entre as palavras.
    data: letter_matches type i.

    "palavra para ser inserida na tabela
    data: append_word type string.

    "index da tabela
    data: index_control type i.

    "flag para append na tabela.
    data: flag_append type abap_bool.

    "input com letras maiusculas ou minusculas
    data: upper_letters type string,
          lower_letters type string.
    upper_letters = input.
    lower_letters = input.
    translate upper_letters to upper case.
    translate lower_letters to lower case.

    "alfabeto uppercase"
    data: alpha           type string value 'ABCDEFGHIJKLMNOPQRSTUVXWYZ',
          first_letter    type string,
          no_first_letter type string.

    "tabelas de ordenacao de strings
    data: tablesorted1 type table of string,
          tablesorted2 type table of string,
          tablesorted3 type table of string,
          tablesorted4 type table of string.

    "variaveis para inserir catacteres em tabelas
    data: letter type c length 1,
          countletter type i,
          strlen type i.

    "inicia variaveis
    count_t_letter = 0.
    letter_matches = 0.
    index_control = 1.
    flag_append = abap_false.

    "pega o tamanho da palavra de entrada.
    len_word = strlen( input ).

    "itera sobre a apalvra de entrada.
    do lines( candidates ) times.

      "verificamos palavra por palavra da tabela e comparamos com a palavra de entrada.
      read table candidates into data(ls_candidate) index index_control.

      len_t_word = strlen( ls_candidate ). "pega o tamanho da palavra

      "itera sobre a palavra
      do len_t_word times.

        t_letter = ls_candidate+count_t_letter(1). "pega a letra da palavra da tabela.

        "se as letras forem iguais independe de maiusculas ou minusculas...
        if t_letter co input or t_letter co upper_letters or t_letter co lower_letters.
          add 1 to letter_matches. "incrementa o contador de letras iguais
          concatenate append_word t_letter into append_word.
        endif.

        "se o numero de letras iguais for igual ao tamanho da palavra
        "ou seja...se for um anagrama...
        if letter_matches eq len_word and append_word eq ls_candidate.

          append append_word to result. "insere a palavra na tabela de saída
          flag_append = abap_true. "ativa a flag
          first_letter = ls_candidate+0(1). "primeira letra da palavra inserida
          shift append_word by 1 places. "arranca o primeiro catactere da palavra
          no_first_letter = append_word. "insere a palavra sem a primeira letra na variavel
          concatenate first_letter append_word into append_word. "reestabelece a palavra

          "insere a palavra na tabela de ordenacao
          append append_word to tablesorted4.

          "itera sobre a primeira tabela de ordenacao
          loop at tablesorted4 into data(ls_result2).
              strlen = strlen( ls_result2 ). "pega o tamanho da palavra da estrutura

              "ciclo dura a quantidade de letras que a palavra da linha tiver
              do strlen times.
                letter = ls_result2+countletter(1). "pega a letra da palavra
                append letter to tablesorted1. "insere na tabela de ordenacao
                add 1 to countletter. "incrementa o contador
              enddo.
          endloop.

          sort tablesorted1. "ordena a tabela por ordem alfabetica

          "limpa as variaveis
          clear letter.
          clear countletter.
          clear strlen.

          "insere a palavra na tabela de ordenacao
          append input to tablesorted3.

          "itera sobre a primeira tabela de ordenacao
          loop at tablesorted3 into data(ls_new).
              translate ls_new to lower case.
              strlen = strlen( input ). "pega o tamanho da palavra da estrutura

              "ciclo dura a quantidade de letras que a palavra da linha tiver
              do strlen times.
                letter = ls_new+countletter(1). "pega a letra da palavra
                append letter to tablesorted2.  "insere na tabela de ordenacao
                add 1 to countletter. "incrementa o contador
              enddo.
          endloop.

          sort tablesorted2. "ordena a tabela por ordem alfabetica

          "se as duas tabelas forem diferentes
          if tablesorted1 ne tablesorted2.
            delete result where table_line = append_word. "remove a linha que foi inserida na tabela de saida
          endif.

          "limpa as variaveis
          clear tablesorted1.
          clear tablesorted2.
          clear tablesorted3.
          clear tablesorted4.
          clear letter.
          clear countletter.
          clear strlen.

          "e se mesmo o anagrama tendo sido encontrada e posto na tabela...
          "...a palavra formada não tiver o mesmo tamanho da palavra da linha
          "significa que o anagrama foi encontrado, mas sobraram caracteres a serem verificados
          "removemos a palavra inserida porque ela não é um anagrama.
          if strlen( append_word ) ne strlen( ls_candidate ) and flag_append eq abap_true.
          delete result where table_line = append_word.
          flag_append = abap_false. "reinicia a flag
        endif.

        "se a primeira letra for maiuscula...
        find first_letter in alpha.
          if sy-subrc eq 0.
            "se o resto da palavra estiver na linha
            find no_first_letter in append_word.
              if sy-subrc eq 0.
                "se a palavra já estiver sido inserida na tabela
                if flag_append eq abap_true.
                "passa a primeira letra para maiuscula
                 translate first_letter to upper case.
                "passa o resto da palavra para minuscula
                 translate append_word to lower case.
                 clear append_word. "limpa a variavel da palavra
                 concatenate first_letter no_first_letter into append_word. "remonta a palavra sendo "Xxxxxx"
                 delete result where table_line = ls_candidate. "remove a antiga linha da tabela
                 append append_word to result. "insere a nova palavra no novo formato
                 flag_append = abap_false. "reinicia a flag
                endif.
            endif.
         endif.

        letter_matches = 0. "reinicia o contador de letras iguais.
        clear append_word. "limpa a palavra
        add 1 to index_control. "incrementa o index

      endif.

      add 1 to count_t_letter. "incrementa o contador

      "se o contador de letras da tabela for igual ao tamanho da palavra de entrada...
      "...e o numero de letras iguais encontradas não tiver sido reiniciada
      "...ou seja, se a palavra não for igual a palavra de entrada
      if count_t_letter eq len_t_word and letter_matches ne 0.
        add 1 to index_control. "incrementa o index
        clear append_word. "limpa a tentativa de formar um anagrama.
      endif.

    enddo.

    clear count_t_letter. "reseta o contador de letras da tabela.
    clear letter_matches. "reseta o contador de letras iguais.

  enddo.

  "como a palavra de entrada nao pode estar na tabela de saída...
  "se acharmos ela dentro da tabela, vamos remove-la
  loop at result into data(ls_result).
    if input eq ls_result or strlen( ls_result ) lt len_word.
      delete result where table_line = ls_result.
    endif.
  endloop.

endmethod.

endclass.

start-of-selection.

  data: ol_anagram type ref to zcl_anagram.
  create object ol_anagram.

  data: lv_input      type string,
        it_candidates type string_table,
        it_result     type string_table.

  "teste
  append 'cashregister' to it_candidates.
  append 'carthorse' to it_candidates.
  append 'radishes' to it_candidates.

  lv_input = 'Orchestra'.

  it_result = ol_anagram->anagram(
                input      = lv_input
                candidates = it_candidates
              ).

  cl_demo_output=>display( it_result ).
