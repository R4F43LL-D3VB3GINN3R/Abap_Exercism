"-------------------------------------------------------------------------------------------------------------------------------------------------------------"

*Introduction
*Scrabble is a word game where players place letter tiles on a board to form words. Each letter has a value. A word's score is the sum of its letters' values.
*
*Instructions
*Your task is to compute a word's Scrabble score by summing the values of its letters.
*
*The letters are valued as follows:
*
*Letter	Value
*A, E, I, O, U, L, N, R, S, T	1
*D, G	2
*B, C, M, P	3
*F, H, V, W, Y	4
*K	5
*J, X	8
*Q, Z	10
*For example, the word "cabbage" is worth 14 points:
*
*3 points for C
*1 point for A
*3 points for B
*3 points for B
*1 point for A
*2 points for G
*1 point for E

"-------------------------------------------------------------------------------------------------------------------------------------------------------------"

report zexercism.

class zcl_scrabble_score definition .

  public section.
    methods score
      importing
        input         type string optional
      returning
        value(result) type i.
  protected section.
  private section.

endclass.


class zcl_scrabble_score implementation.
  method score.

    "variaveis para strings da tabela
    data: letter      type c,
          countletter type i,
          strlen      type i.

    "variaveis para strings do parametro
    data: letter2      type c,
          countletter2 type i,
          strlen2      type i.

    "estrutura e tabela com os valores das letras.
    types: begin of wa_struct,
             letter type string,
             value  type i,
           end of wa_struct.

    data: it_table  type table of wa_struct,
          ls_struct type wa_struct.

    "preenche a tabela com as strings e seus respectivos valores
    it_table = value #( ( letter = 'AEIOULNRST' value = 1 )
                        ( letter = 'DG'         value = 2 )
                        ( letter = 'BCMP'       value = 3 )
                        ( letter = 'FHVWY'      value = 4 )
                        ( letter = 'K'          value = 5 )
                        ( letter = 'JX'         value = 8 )
                        ( letter = 'QZ'         value = 10 ) ).
    
    "variavel recebe o parametro
    data: word type string.
    word = input.
    
    "converte variavel para minuscula
    translate word to lower case.

    "itera sobre a tabela preenchida
    loop at it_table into ls_struct.

      "conta a quantidade de caracteres na string da primeira linha
      strlen = strlen( ls_struct-letter ).
      "conta a quantidade de caracteres do parametro
      strlen2 = strlen( word ).
      
      "converte palavra da tabela para minuscula
      translate ls_struct-letter to lower case.

      "reinicia os contadores
      countletter = 0.
      countletter2 = 0.

      "a comparacao de caracteres começa aqui
      "e vai contar a quantidade de vezes = a quantidade de letras do parametro
      do strlen2 times.

        "pega a letra do parametro
        letter2 = word+countletter2(1).

        "começa a contar do começo da palavra
        countletter = 0.

        "conta a quantidade de vezes = a quantidade de letras da palavra da primeira linha
        do strlen times.

          "pega a letra da palavra da primeira linha
          letter = ls_struct-letter+countletter(1).

          "se as letras forem iguais...
          if letter eq letter2.

            "o parametro de saída recebe o valor referente ao da letra
            result = result + ls_struct-value.

          endif.

          "passa para a próxima letra
          add 1 to countletter.

        enddo.

        "passa para a próxima letra
        add 1 to countletter2.

      enddo.

    endloop.

  endmethod.

endclass.

start-of-selection.

data: ol_scrabble_score type ref to zcl_scrabble_score.

create object ol_scrabble_score.

data: value type i.
data: word type string value 'RAFAEL'.

value = ol_scrabble_score->score(
            input = word
        ).

write: value.
