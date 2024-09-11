"-------------------------------------------------------------------------------------------------------------------------------------------------------------

*Introduction
*Reversing strings (reading them from right to left, rather than from left to right) is a surprisingly common task in programming.
*
*For example, in bioinformatics, reversing the sequence of DNA or RNA strings is often important for various analyses, such as finding complementary strands or identifying palindromic sequences that have biological significance.
*
*Instructions
*Your task is to reverse a given string.
*
*Some examples:
*
*Turn "stressed" into "desserts".
*Turn "strops" into "sports".
*Turn "racecar" into "racecar".

"-------------------------------------------------------------------------------------------------------------------------------------------------------------

report exercism.

class zcl_reverse_string definition.
  public section.
    methods reverse_string
      importing
        input         type string
      returning
        value(result) type string.
endclass.

class zcl_reverse_string implementation.

  method reverse_string.

    data: count_letter type i,     "conta de letra em letra
          strlen_word  type i,     "quantidade de letras
          letter       type char1. "variavel para armazenar letra por letra

    data: it_letters type standard table of string. "tabela para receber letra por letra

    strlen_word = strlen( input ). "passa a quantidade de letras da palavra

    count_letter = 0. "inicializa o contador

    "ciclo dura a quantidade de letras da palavra
    do strlen_word times.

      letter = input+count_letter(1). "variavel recebe a letra na posicao do contador
      append letter to it_letters.    "insere a letra na tabela de letras
      add 1 to count_letter.          "incrementa o contador de letras para avançar a proxima letra

    enddo.

    "itera sobre a tabela de letras
    loop at it_letters into data(ls_letter).

      "le a tabela de trás pra frente
      read table it_letters into ls_letter index strlen_word.
        
        "verifica se há algum espaço em branco 
        if ls_letter is initial.

          "se houver, concatena o espaço em branco a palavra
          concatenate result ls_letter into result separated by space.

        else.

          "concatena as letras no parametro de saida de forma inversa
          concatenate result ls_letter into result.

        endif.

        "decrementa o index.
        strlen_word = strlen_word - 1.

    endloop.

  endmethod.

endclass.

start-of-selection.

  data: ol_reverse_string type ref to zcl_reverse_string.

  data: string         type string,
        reverse_string type string.

  create object ol_reverse_string.

  string = 'robot'.

  reverse_string = ol_reverse_string->reverse_string( input = string ).

  write: reverse_string.
