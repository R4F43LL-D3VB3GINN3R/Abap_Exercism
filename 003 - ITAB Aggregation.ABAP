"-----------------------------------------------------------------------------------------------------------------------------------------------------------

*Instructions
*Learn how to aggregate and group data within an ABAP internal table.
*
*Your class will be given an internal table named initial_numbers. It has two columns: GROUP and NUMBER.
*
*TYPES: BEGIN OF initial_numbers_type,
*        group  TYPE group,
*        number TYPE i,
*       END OF initial_numbers_type,
*       initial_numbers TYPE STANDARD TABLE OF initial_numbers_type WITH EMPTY KEY.
*The data in this table consists of three groups - A, B, and C. There are multiple records in each group.
*
*GROUP	NUMBER
*A	10
*B	5
*A	6
*C	22
*A	13
*C	500
*Your task is to return an internal table with one record per group. This record should contain the number of records in the original table per group (COUNT), the sum of all NUMBER values in this group (SUM), the minimum value in the group (MIN), the maximum value in the group (MAX) and the average of all values in that group (AVERAGE).
*
*The expected return table has the following definition:
*
*TYPES: BEGIN OF aggregated_data_type,
*        group   TYPE group,
*        count   TYPE i,
*        sum     TYPE i,
*        min     TYPE i,
*        max     TYPE i,
*        average TYPE f,
*       END OF aggregated_data_type,
*       aggregated_data TYPE STANDARD TABLE OF aggregated_data_Type WITH EMPTY KEY.
*Bonus
*There are many ways to accomplish this task in ABAP. How efficiently can you complete the task? Can you do this while only reading each record in the table once?

"-----------------------------------------------------------------------------------------------------------------------------------------------------------

report zexercism.


class zcl_itab_aggregation definition
  final
  create public .

  public section.
    types group type c length 1.
    types: begin of initial_numbers_type,
             group  type group,
             number type i,
           end of initial_numbers_type,
           initial_numbers type standard table of initial_numbers_type with empty key.

    types: begin of aggregated_data_type,
             group   type group,
             count   type i,
             sum     type i,
             min     type i,
             max     type i,
             average type f,
           end of aggregated_data_type,
           aggregated_data type standard table of aggregated_data_type with empty key.

    methods perform_aggregation
      importing
        initial_numbers        type initial_numbers
      returning
        value(aggregated_data) type aggregated_data.
  protected section.
  private section.

endclass.



class zcl_itab_aggregation implementation.
  method perform_aggregation.

    "dados dos tipos dos objetos de classe
    data: itab    type initial_numbers,      "tabela de entrada
          itab2   type aggregated_data,      "tabela de saída
          ls_itab type initial_numbers_type. "estrutura da tabela de entrada

    data: count_group        type i,        "variavel para contar grupo
          count_group_column type i.        "variavel para contrar a quantidade que uma coluna aparece na tabela
    
    "maximo, minimo e media dos grupos.
    data: lv_max type i,
          lv_min type i,
          lv_avg type p decimals 2.
    
    "inicializando variáveis numericas com zero
    lv_max = 0.
    lv_min = 0.
    lv_avg = 0.
    count_group = 0.
    count_group_column = 0.
    
    "popula a tabela interna de entrada com os dados requeridos
    itab = value #( ( group = 'A' number = 10  )
                    ( group = 'B' number = 5   )
                    ( group = 'A' number = 6   )
                    ( group = 'C' number = 22  )
                    ( group = 'A' number = 13  )
                    ( group = 'C' number = 500 ) ).
    
    "agrupando a tabela interna por colunas.
    "itera sobre a tabela interna de entrada.
    loop at itab into data(ls_data).
      "limpa a variavel para que a contagem seja reiniciada
      clear count_group.
      "estrutura recebe a primeira linha da tabela
      ls_itab-group = ls_data-group.
      "itera sobre a tabela de saída
      loop at itab2 into data(ls_data2).
        "se o grupo da tabela de entrada for igual ao grupo da tabela de saída
        if ls_itab-group eq ls_data2-group.
          "incrementa a variável
          add 1 to count_group.
        endif.
      endloop.
      
      "se nao houver contagem
      "ou seja, se o grupo aparece pela primeira vez no ciclo...
      if count_group eq 0.
        "insere a coluna do grupo na tabela de saída
        append ls_itab to itab2.
        "limpa a estrutura
        clear ls_data.
      endif.

    endloop.
    
    "preenchendo a tabela de saída com os dados requeridos.
    "itera sobre a tabela de saída
    loop at itab2 into data(ls_data3).
      "itera sobre a tabela de entrada para realizamos verificacoes
      loop at itab into ls_data.
        "se os grupos forem iguais
        if ls_data3-group eq ls_data-group.
          "a instrucao verifica o grupo enviado pela estrutura e busca
          "com esta informacao o maior e o menor numero relacionado
          lv_max = reduce i(
          init x = ls_data-number
          for wa in itab
          where ( group = ls_data3-group )
          next x = cond #( when wa-number > x then wa-number else x )
          ).
          lv_min = reduce i(
          init x = ls_data-number
          for wa in itab
          where ( group = ls_data3-group )
          next x = cond #( when wa-number < x then wa-number else x )
          ).
          "incrementa os numeros relacionados ao grupo
          ls_data3-sum = ls_data3-sum + ls_data-number.
          "realiza uma contagem para sabermos a incidência que este numero surge na tabela
          add 1 to count_group_column.
        endif.
      endloop.
      
      "apos todas as verificacoes preenchemos as outras colunas.
      "a media recebe a somatoria dividido pela quantidade
      lv_avg = ls_data3-sum / count_group_column.
      ls_data3-average = lv_avg.
      ls_data3-max = lv_max.
      ls_data3-min = lv_min.
      ls_data3-count = count_group_column.
      "insere a linha da tabela preenchida diretamente na tabela de saida
      append ls_data3 to aggregated_data.
      "limpa estruturas e variaveis
      clear count_group_column.
      clear ls_data3.
      clear ls_data.
      clear lv_max.
      clear lv_min.
      clear lv_avg.
    endloop.

  endmethod.

endclass.

start-of-selection.

  "utiliza os tipos definidos na classe para garantir compatibilidade
  data: ol_itab_aggregation type ref to zcl_itab_aggregation,
        it_data             type zcl_itab_aggregation=>aggregated_data,
        it_data2            type zcl_itab_aggregation=>initial_numbers.

  create object ol_itab_aggregation.
  
  "envia-se a tabela de entrada e se recebe uma tabela de saída devidamente preenchida.
  it_data = ol_itab_aggregation->perform_aggregation( initial_numbers = it_data2 ).
  "display da tabela interna.
  cl_demo_output=>display( it_data ).
