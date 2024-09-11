"------------------------------------------------------------------------------------------------------------------------------------------------------------------

*Instructions
*Manage a game player's High Score list.
*
*Your task is to build a high-score component of the classic Frogger game, one of the highest selling and most addictive games of all time, and a classic of the arcade era. 
*Your task is to write methods that return the highest score from the list, the last added score and the three highest scores.

"------------------------------------------------------------------------------------------------------------------------------------------------------------------

*&---------------------------------------------------------------------*
*& Report ZEXERCISM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

report zexercism.

class zcl_high_scores definition
  final
  create public .

  public section.
    types integertab type standard table of i with empty key.
    methods constructor
      importing
        scores type integertab.

    methods list_scores
      returning
        value(result) type integertab.

    methods latest
      returning
        value(result) type i.

    methods personalbest
      returning
        value(result) type i.

    methods personaltopthree
      returning
        value(result) type integertab.
  protected section.
  private section.
    data scores_list type integertab.

endclass.


class zcl_high_scores implementation.

  method constructor.
    me->scores_list = scores.
  endmethod.

  method list_scores.
    
    "itera sobre o a tabela de entrada
    loop at scores_list into data(ls_score).
      
      "se a linha nao estiver vazia...
      if ls_score is not initial.
        
        "insere a linha na tabela de saída
        append ls_score to result.
        
      endif.
      
    endloop.
    
  endmethod.

  method latest.
    
    "variavel para guardar a pior pontuacao
    data: lv_min type i.
    
    "inicia a variavel com um valor de uma linha da tabela
    read table scores_list into data(ls_score) index 1.
      lv_min = ls_score.
    
    "itera sobre a tabela de entrada
    loop at scores_list into ls_score.
      
      "se a variavel for maior do que o valor da linha e a linha nao estiver vazia
      if lv_min > ls_score and ls_score is not initial.
        
        "a variavel recebe o valor da linha
        lv_min = ls_score.

      endif.

    endloop.
    
    "o parametro de saida recebe o valor da variavel
    result = lv_min.

  endmethod.

  method personalbest.
    
    "variavel para receber a melhor pontuacao
    data: lv_max type i.
    
    "inicia a variavel com um valor de uma linha da tabela
    read table scores_list into data(ls_score) index 1.
      lv_max = ls_score.
    
    "itera sobre a tabela de entrada
    loop at scores_list into ls_Score.
      
      "se a variavel for menor do que o valor da linha...
      if lv_max < ls_score.
        
        "a variavel recebe o valor da linha
        lv_max = ls_score.

      endif.

    endloop.
    
    "o parametro de saida recebe o valor da variavel
    result = lv_max.

  endmethod.

  method personaltopthree.
    
    "esta estrutura foi criada para que fosse permitido a ordenacao da tabela
    types: begin of wa_struct,
      number type i,
    end of wa_struct.
    
    "tabela interna e estrutura do tipo
    data: it_number type table of wa_struct,
          ls_number like line of it_number.
    
    "variavel para receber valor da linha da tabela de entrada
    data: lv_num type i.
    
    "itera sobre a tabela de entrada 
    loop at scores_list into data(ls_score).
      
      "este processo so foi necessario por:
      "1 - erros de unicode entre valores, mesmo sendo tabelas e valores inteiros
      "2 - impossivel ordenar a tabela de entrada ou passar valores diretamente
      "3 - impossivel a ordenacao sem linha de cabecalho
      
      "assim, finalmente conseguindo preencher a tabela...
      lv_num = ls_score.
      ls_number-number = lv_num.
      append ls_number to it_number.
      
    endloop.
    
    "...foi possivel ordenar por nome do campo
    sort it_number by number descending.
    
    "agora foi so ler a tabela ordenada pelos indexes correspondentes e inserir os valores.
    read table it_number into data(ls_num) index 1.
      
      "ainda assim, tivemos de fazer o caminho de volta para evitar problemas unicode
      lv_num = ls_num-number.
      append lv_num to result.
      
    if lines( it_number ) gt 1.

      read table it_number into ls_num index 2.

        lv_num = ls_num-number.
        append lv_num to result.
      
    endif.
      
    if lines( it_number ) gt 2.

      read table it_number into ls_num index 3.

        lv_num = ls_num-number.
        append lv_num to result.
      
    endif.

  endmethod.

endclass.

start-of-selection.

data: ol_high_scores type ref to zcl_high_scores.
data: it_data type ol_high_scores->integertab.
data: it_data2 type ol_high_scores->integertab.
data: lv_min type i.
data: lv_max type i.

append 1 to it_data.
append 2 to it_data.
append 3 to it_data.
append 4 to it_data.
append 5 to it_data.

create object ol_high_scores
  exporting
    scores = it_data.
  .

"testes dos métodos

*it_data2 = ol_high_scores->list_scores( ).
*lv_min = ol_high_scores->latest( ).
*lv_max = ol_high_scores->personalbest( ).
*it_data2 = ol_high_scores->personaltopthree( ).

*cl_demo_output=>display( it_data2 ).

*write: lv_min.
*write: lv_max.
