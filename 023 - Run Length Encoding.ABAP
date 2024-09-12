"----------------------------------------------------------------------------------------------------------------------------------------------------------

*Instructions
*Implement run-length encoding and decoding.
*
*Run-length encoding (RLE) is a simple form of data compression, where runs (consecutive data elements) are replaced by just one data value and count.
*
*For example we can represent the original 53 characters with only 13.
*
*WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB"  ->  "12WB12W3B24WB"
*RLE allows the original data to be perfectly reconstructed from the compressed data, which makes it a lossless data compression.
*
*AABCCCDEEEE"  ->  "2AB3CD4E"  ->  "AABCCCDEEEE"
*For simplicity, you can assume that the unencoded string will only contain the letters A through Z (either lower or upper case) and whitespace. 
*This way data to be encoded will never contain any numbers and numbers inside data to be decoded always represent the count for the following character.

"----------------------------------------------------------------------------------------------------------------------------------------------------------

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

endclass.


class zcl_rle implementation.

  method encode.

    data: char2      type string,
          duplicates type string.

    data(str) = input.
    
    "percorre a string até que a mesma esteja vazia
    while str is not initial.
      
      "tenta encontrar incidencias de duplicacoes
      find regex '([\w|\s])(\1*)(.*)' in str submatches char2 duplicates str  ##SUBRC_OK.
      
      "se houver strings duplicadas...
      if duplicates is not initial.
        result = |{ result }{ strlen( duplicates ) + 1 }{ char2 }|. "concatena o numero + letra
      "se nao houver...
      else.
        result = |{ result }{ char2 }|. "concatena apenas a letra
      endif.

    endwhile.

  endmethod.

  method decode.

    data: char2 type string,
          reps  type string.

    data(str) = input.
    
    "percorre a string até que a mesma esteja vazia
    while str is not initial.
      
      "tenta encontrar incidencias de duplicacoes
      find regex '(\d*)([\w|\s])(.*)' in str submatches reps char2 str  ##SUBRC_OK.
      
      "se houver strings duplicadas...
      if reps is not initial.
        result = |{ result }{ repeat( val = char2 occ = reps ) }|. "concatena a letra pela quantidade de vezes do numero de repeticoes
      "se nao houver...
      else.
        result = |{ result }{ char2 }|. "concatena apenas a letra
      endif.

    endwhile.

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
