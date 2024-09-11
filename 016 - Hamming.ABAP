"---------------------------------------------------------------------------------------------------------------------------------------------------------------------

*Instructions
*Calculate the Hamming Distance between two DNA strands.
*
*Your body is made up of cells that contain DNA. 
*Those cells regularly wear out and need replacing, which they achieve by dividing into daughter cells. 
*In fact, the average human body experiences about 10 quadrillion cell divisions in a lifetime!
*
*When cells divide, their DNA replicates too. 
*Sometimes during this process mistakes happen and single pieces of DNA get encoded with the incorrect information. 
*If we compare two strands of DNA and count the differences between them we can see how many mistakes occurred. 
*This is known as the "Hamming Distance".
*
*We read DNA using the letters C,A,G and T. Two strands might look like this:
*
*GAGCCTACTAACGGGAT
*CATCGTAATGACGGCCT
*^ ^ ^  ^ ^    ^^
*They have 7 differences, and therefore the Hamming Distance is 7.
*
*The Hamming Distance is useful for lots of things in science, not just biology, so it's a nice phrase to be familiar with :)
*
*Implementation notes
*The Hamming distance is only defined for sequences of equal length, so an attempt to calculate it between sequences of different lengths should not work.

"---------------------------------------------------------------------------------------------------------------------------------------------------------------------

report exercism.

class zcl_hamming definition.
  public section.
    methods hamming_distance
      importing
        first_strand  type string
        second_strand type string
      returning
        value(result) type i
      raising
        cx_parameter_invalid.
endclass.

class zcl_hamming implementation.

  method hamming_distance.

    "se os parametros diverem comprimentos diferentes...
    if strlen( first_strand ) ne strlen( second_strand ).
      raise exception type cx_parameter_invalid
        exporting
          parameter = second_strand.
    endif.

    data: lv_countletter type i,       "contador para iterar sobre as strings
          lv_letter_a type c length 1, "recebe o caractere do primeiro dna
          lv_letter_b type c length 1, "recebe o caractere do segundo dna
          lv_strlen_strand type i.     "comprimento do dna

    lv_countletter = 0. "inicia o contador.
    lv_strlen_strand = strlen( first_strand ). "variavel recebe o tamanho em comprimento das strings

    "percorre os dnas procurando eventuais diferenças
    do lv_strlen_strand times.

      "cada variável recebe uma letra na posicao correspondente ao contador de letras
      lv_letter_a = first_strand+lv_countletter(1).
      lv_letter_b = second_strand+lv_countletter(1).

      "se as letras forem diferentes
      if lv_letter_a ne lv_letter_b.
        add 1 to result.
      endif.

      "incrementa o contador
      add 1 to lv_countletter.

    enddo.

  endmethod.

endclass.

start-of-selection.

  data ol_hamming type ref to zcl_hamming.

  create object ol_hamming.

  data: lv_strand1 type string value 'ABCDABCDABCD',
        lv_strand2 type string value 'ABCDABCDAAAA'.

  data: lv_hamming_distance type i.

  try.
    ol_hamming->hamming_distance(
      exporting
        first_strand  = lv_strand1
        second_strand = lv_strand2
      receiving
        result        = lv_hamming_distance
    ).
  catch cx_parameter_invalid into data(lx_invalid).
    write: / 'Erro: ', lx_invalid->get_text( ).
    return.
  endtry.

  write: lv_hamming_distance.
