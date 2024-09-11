"------------------------------------------------------------------------------------------------------------------

*Instructions
*Learn how to combine data from two different internal tables into one result internal table.
*
*Your class will be given two internal tables which contain two completely different datasets, ALPHAS and NUMS.
*
*TYPES: BEGIN OF alphatab_type,
*         cola TYPE string,
*         colb TYPE string,
*         colc TYPE string,
*       END OF alphatab_type.
*TYPES: alphas TYPE STANDARD TABLE OF alphatab_type.
*TYPES: BEGIN OF numtab_type,
*         col1 TYPE string,
*         col2 TYPE string,
*         col3 TYPE string,
*       END OF numtab_type.
*TYPES: nums TYPE STANDARD TABLE OF numtab_type.
*The data in the ALPHA table is as shown below.
*
*COLA	COLB	COLC
*A	B	C
*D	E	F
*G	H	I
*The data in the NUMS table is as shown below.
*
*COL1	COL2	COL3
*1	2	3
*4	5	6
*7	8	9
*Your task is to return an internal table with records which combine the values of each cell of interal table ALPHAS and internal table NUMS together. 
*For example the value of the first column of the first row of the COMBINED_DATA internal table should be "A1".
*
*The expected return table has the following definition:
*
*TYPES: BEGIN OF combined_data_type,
*         colx TYPE string,
*         coly TYPE string,
*         colz TYPE string,
*       END OF combined_data_type.
*TYPES: combined_data TYPE STANDARD TABLE OF combined_data_type WITH EMPTY KEY.
*Bonus
*There are many ways to accomplish this task in ABAP. How efficiently can you complete the task?

"------------------------------------------------------------------------------------------------------------------

report zexercism.


class zcl_itab_combination definition
  final
  create public .

  public section.

    types: begin of alphatab_type,
             cola type string,
             colb type string,
             colc type string,
           end of alphatab_type.
    types alphas type standard table of alphatab_type.

    types: begin of numtab_type,
             col1 type string,
             col2 type string,
             col3 type string,
           end of numtab_type.
    types nums type standard table of numtab_type.

    types: begin of combined_data_type,
             colx type string,
             coly type string,
             colz type string,
           end of combined_data_type.
    types combined_data type standard table of combined_data_type with empty key.

    methods perform_combination
      importing
        alphas               type alphas
        nums                 type nums
      returning
        value(combined_data) type combined_data.

  protected section.
  private section.


endclass.

class zcl_itab_combination implementation.

  method perform_combination.

    "variaveis do tipo dos objetos da classe
    data: it_alpha type alphas,
          it_nums type nums,
          ls_alpha type alphatab_type,
          ls_nums type numtab_type,
          ls_combined_data type combined_data_type.

"------------------------------------------------------------------
*    it_alpha = value #( ( cola = 'A' colb = 'B' colc = 'C' )
*                        ( cola = 'D' colb = 'E' colc = 'F' )
*                        ( cola = 'G' colb = 'H' colc = 'I' ) ).
*
*    it_nums = value #( ( col1 = 1 col2 = 2 col3 = 3 )
*                       ( col1 = 4 col2 = 5 col3 = 6 )
*                       ( col1 = 7 col2 = 8 col3 = 9 ) ).
"------------------------------------------------------------------

    "tabelas locais recebem tabelas de entrada.
    it_alpha = alphas.
    it_nums = nums.

    "itera sobre a tabela de letras
    loop at it_alpha into ls_alpha.

      "para cada linha da tabela de letras, tambem lê a tabela de numeros
      read table it_nums into ls_nums index sy-tabix.

        if sy-subrc eq 0.

          "concatena as linhas das duas tabelas na linha da terceira tabela
          concatenate ls_alpha-cola ls_nums-col1 into ls_combined_data-colx.
          concatenate ls_alpha-colb ls_nums-col2 into ls_combined_data-coly.
          concatenate ls_alpha-colc ls_nums-col3 into ls_combined_data-colz.

          "insere a linha concatenada na tabela de alphanumericos
          append ls_combined_data to combined_data.

        endif.

    endloop.

  endmethod.

endclass.

start-of-selection.

data: ol_itab_combination type ref to zcl_itab_combination.

create object ol_itab_combination.

data: itab type ol_itab_combination->alphas,
      itab2 type ol_itab_combination->nums,
      itab3 type ol_itab_combination->combined_data.

itab3 = ol_itab_combination->perform_combination(
          alphas = itab
          nums   = itab2
        ).

cl_demo_output=>display( itab3 ).
