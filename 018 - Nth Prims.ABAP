"---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*Instructions
*Given a number n, determine what the nth prime is.
*
*By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.
*
*If your language provides methods in the standard library to deal with prime numbers, pretend they don't exist and implement them yourself.

"---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

report exercism.

class zcl_nth_prime definition final create public .
  public section.
    methods prime
      importing
        input         type i
      returning
        value(result) type i
      raising
        cx_parameter_invalid.
  protected section.
  private section.

endclass.

class zcl_nth_prime implementation.
  method prime.

    "tratamento de erros para parametros...
    data: stringnum type char10,
          message   type string.

    "casting do parametro de entrada
    stringnum = input. "int >> char
    message = input.   "int >> string

    "verifica se o parametro de entrada é um numero...
    "...e se ele está contido na string numerica
    if stringnum na '0123456789. '.
      raise exception type cx_parameter_invalid
        exporting
          parameter = message.
    endif.

    "inicia o contador
    data: start_counter type i, "contador para verificar cada numero
          count_divs    type i, "conta a quantidade exata de divisoes
          flag          type i. "flag de duracao do ciclo

    "inicia a flag e o contador
    flag = 1.
    start_counter  = 1.

    "tabela para guardar numeros
    data: it_nums   type table of i, "indice de numeros
          it_primes type table of i. "armazenamento de primos

    "ciclo gera de verificao de numeros primos com duracao infinita
    while flag eq 1.
      "insere o valor do contador na tabela de numeros
      append start_counter to it_nums. "insere o contador na tabela de numeros.

      "itera sobre a tabela de numeros para verificar se é primo.
      loop at it_nums into data(ls_num).
        "se o valor atual do contador for divisivel pela numero da estrutura...
        if start_counter mod ls_num eq 0.
          add 1 to count_divs. "incrementa a variavel de numero de divisoes
        endif.
      endloop.

      "se apos o contador ter passado pela tabela, apenas duas divisoes tenham ocorrido
      "ou seja...por 1 e por ele mesmo...
      "constatamos assim que o numero era primo
      if count_divs eq 2.
        append start_counter to it_primes. "inserimos o valor atual do contador primo na tabela de primos
      endif.
      count_divs = 0. "reiniciamos o contador de divisoes
      add 1 to start_counter. "incrementa o contador geral

      "verificacao para sair do loop...
      "caso o numero de primos na tabela de primos exceda em linhas o valor do parametro de entrada
      if lines( it_primes ) eq input.
        flag = 0. "alteramos apenas o valor da flag para sair do ciclo infinito.
      endif.
    endwhile.

    "depois da tabela de primos preenchida...
    "lemos a ultima linha da tabela de primos e buscamos o ultimo valor inserido la
    read table it_primes into data(ls_prime2) index input.
      result = ls_prime2. "atribuimos o valor encontrado no parametro de saída

  endmethod.

endclass.

start-of-selection.

  data: ol_nth_prime type ref to zcl_nth_prime.

  create object ol_nth_prime.

  data: lv_input type i,
        lv_prime type i.

  lv_input = 6.

  try.
      lv_prime = ol_nth_prime->prime( input =  lv_input ).
    catch cx_parameter_invalid into data(lx_invalid).
      write: / 'Erro: ', lx_invalid->get_text( ).
      return.
  endtry.

  write: lv_prime.
