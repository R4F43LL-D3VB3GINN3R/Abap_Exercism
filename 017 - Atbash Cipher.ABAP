"-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*Instructions
*Create an implementation of the atbash cipher, an ancient encryption system created in the Middle East.
*
*The Atbash cipher is a simple substitution cipher that relies on transposing all the letters in the alphabet such that the resulting alphabet is backwards. 
*The first letter is replaced with the last letter, the second with the second-last, and so on.
*
*An Atbash cipher for the Latin alphabet would be as follows:
*
*Plain:  abcdefghijklmnopqrstuvwxyz
*Cipher: zyxwvutsrqponmlkjihgfedcba
*It is a very weak cipher because it only has one possible key, and it is a simple mono-alphabetic substitution cipher. 
*However, this may not have been an issue in the cipher's time.
*
*Ciphertext is written out in groups of fixed length, the traditional group size being 5 letters, leaving numbers unchanged, and punctuation is excluded. 
*This is to make it harder to guess things based on word boundaries. All text will be encoded as lowercase letters.
*
*Examples
*Encoding test gives gvhg
*Encoding x123 yes gives c123b vh
*Decoding gvhg gives test
*Decoding gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt gives thequickbrownfoxjumpsoverthelazydog

"-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

report exercism.

class zcl_atbash_cipher definition final create public.

  public section.
    methods decode
      importing
        cipher_text       type string
      returning
        value(plain_text) type string .
    methods encode
      importing
        plain_text         type string
      returning
        value(cipher_text) type string .
  protected section.
  private section.

    types: begin of wa_cipher,
             line_decoding type c length 1,
             line_encoding type c length 1,
             line_result   type c length 1,
           end of wa_cipher.

    data: cipher_table type standard table of wa_cipher.

    data: decoding type string value 'abcdefghijklmnopqrstuvwxyz1234567890',
          encoding type string value 'zyxwvutsrqponmlkjihgfedcba1234567890'.

endclass.

class zcl_atbash_cipher implementation.

  method decode.

    "variavel para receber o codigo sem tratamento
    data: brute_code type string.

    "passa o parametro de entrada para outra variavel e coloca-a em minuscula
    data: cipher_text2 type string.
    cipher_text2 = cipher_text.
    translate cipher_text2 to lower case.

    "pega o comprimento do alfabeto codificado e do parametro de entrada
    data: strlen_alpha  type i,
          strlen_encode type i.
    strlen_alpha = strlen( me->decoding ).
    strlen_encode = strlen( cipher_text2 ).

    "contadores de letras iniciados
    data: count_letter type i,  "conta as letras da palavra
          count_alpha  type i.  "contra as letras da encriptação
    count_letter = 0. "inicia a variável

    "variaveis para receber as letras do decode, encode e da palavra
    data: encode_letter type c length 1,
          decode_letter type c length 1,
          word_letter   type c length 1.

    "itera sobre cada letra do parametro de entrada
    do strlen_encode times.
      word_letter = cipher_text2+count_letter(1). "pega a primeira letra da entrada
      count_alpha = 0. "reinicia este contador sempre para iterar sobre os caracteres de codificacao e decodificacao.
      "itera sobre os alfabetos de codificacao e decodificacao
      do strlen_alpha times.
        "variaveis recebem as letras dos alfabetos
        decode_letter = me->decoding+count_alpha(1).
        encode_letter = me->encoding+count_alpha(1).
        "se a letra do parametro for igual a letra do alfabeto de decodificacao...
        if word_letter eq encode_letter.
          concatenate brute_code decode_letter into brute_code. "cria a palavra de codificacao
          condense brute_code no-gaps. "remove os espaços em branco
        endif.
        add 1 to count_alpha. "incrementa o contador
      enddo.
      add 1 to count_letter. "incrementa o contador
    enddo.

  plain_text = brute_code.

  endmethod.

  method encode.

    "variavel para receber o codigo sem tratamento
    data: brute_code type string.

    "passa o parametro de entrada para outra variavel e coloca-a em minuscula
    data: plain_text2 type string.
    plain_text2 = plain_text.
    translate plain_text2 to lower case.

    "pega o comprimento do alfabeto codificado e do parametro de entrada
    data: strlen_alpha  type i,
          strlen_encode type i.
    strlen_alpha = strlen( me->decoding ).
    strlen_encode = strlen( plain_text2 ).

    "contadores de letras iniciados
    data: count_letter type i,  "conta as letras da palavra
          count_alpha  type i.  "contra as letras da encriptação
    count_letter = 0. "inicia a variável

    "variaveis para receber as letras do decode, encode e da palavra
    data: encode_letter type c length 1,
          decode_letter type c length 1,
          word_letter   type c length 1.

    "itera sobre cada letra do parametro de entrada
    do strlen_encode times.
      word_letter = plain_text2+count_letter(1). "pega a primeira letra da entrada
      count_alpha = 0. "reinicia este contador sempre para iterar sobre os caracteres de codificacao e decodificacao.
      "itera sobre os alfabetos de codificacao e decodificacao
      do strlen_alpha times.
        "variaveis recebem as letras dos alfabetos
        decode_letter = me->decoding+count_alpha(1).
        encode_letter = me->encoding+count_alpha(1).
        "se a letra do parametro for igual a letra do alfabeto de decodificacao...
        if word_letter eq decode_letter.
          concatenate brute_code encode_letter into brute_code. "cria a palavra de codificacao
          condense brute_code no-gaps. "remove os espaços em branco
        endif.
        add 1 to count_alpha. "incrementa o contador
      enddo.
      add 1 to count_letter. "incrementa o contador
    enddo.

    "depois de ter a palavra codificada, é hora de inserir os espaços em branco, caso haja a necessidade.

    data: strlen_code type i,          "novo tamanho do codigo
          count_code  type i,          "contador de intervalos
          count_code2 type i,          "contador de letras
          code_letter type c length 1, "letra do codigo
          new_code    type string.     "novo codigo

    strlen_code = strlen( brute_code ). "pega o novo comprimento do codigo

    "inicia os contadores
    count_code = 0.
    count_code2 = 0.

    "itera sobre o codigo usando o tamanho atualizado do codigo
    do strlen_code times.
      code_letter = brute_code+count_code2(1). "pega a letra do codigo
      concatenate new_code code_letter into new_code. "joga esta nova letra para o novo codigo
      "se o contador tiver contado 5 letras...
      if count_code eq 4.
        concatenate new_code space into new_code separated by space. "insere um espaço em branco depois da quinta letra
        count_code = -1. "reinicia o contador
        add 1 to strlen_code. "incrementa a contagem total de letras do codigo, ja que foi inserido um espaço em branco
      endif.
      add 1 to count_code. "incrementa o contador de intervalos
      add 1 to count_code2. "incrementa o contador
    enddo.

    "remove possíveis espaços em branco no começo e final da string.
    "pode acontecer, caso uma parte da string tenha 5 letreas.
    shift new_code right deleting trailing space.
    shift new_code left deleting leading space.

    cipher_text = new_code. "passa o novo código tratado para o parametro de saida

  endmethod.

endclass.

start-of-selection.

  data ol_atbash_cipher type ref to zcl_atbash_cipher.

  create object ol_atbash_cipher.

  data: lv_word   type string,
        lv_encode type string,
        lv_decode type string.

*  lv_word = 'The quick brown fox jumps over the lazy dog.'.
*
*  lv_encode = ol_atbash_cipher->encode( plain_text = lv_word ).

  lv_word = 'vcvix rhn'.

  lv_decode = ol_atbash_cipher->decode( cipher_text = lv_word ).

*  write: lv_encode.
  write: lv_decode.
