report zexercism.

class zcl_phone_number definition
  final
  create public .

  public section.

    methods clean
      importing
        !number       type string
      returning
        value(result) type string
      raising
        cx_parameter_invalid.
  protected section.
  private section.
endclass.

class zcl_phone_number implementation.

  method clean.

    "verifica o tamanho maximo o minimo do numero
    if strlen( number ) gt 17 or strlen( number ) lt 11.
      raise exception type cx_parameter_invalid
        exporting
          parameter = number.
      .
    endif.

    "primeiro digito do numero
    data: first_digit type c length 1.
    first_digit = number+0(1).

    "verifica se a entrada tem 11 digitos e começa com 1
    if strlen( number ) eq 11 and first_digit ne '1'.
      raise exception type cx_parameter_invalid
        exporting
          parameter = number.
      .
    endif.

    "primeiro digito do codigo de área
    data: area_code type c length 1.
    area_code = number+1(1).

    "verifica se o código de área começa com 0 ou 1
    if strlen( number ) eq 14 and area_code eq '0'.
      raise exception type cx_parameter_invalid
        exporting
          parameter = number.
      .
    elseif strlen( number ) eq 14 and area_code eq '1'.
      raise exception type cx_parameter_invalid
        exporting
          parameter = number.
      .
    endif.
    
    "primeiro digito do numero com codigo de area
    data: exchange_code type c length 1.
          exchange_code = number+6(1).
    
    "verifica se o primeiro digito do numero começa com 0...
    "quando o codigo de área for enviado
    if strlen( number ) eq 14 and exchange_code eq '0' or exchange_code eq '1'.
      raise exception type cx_parameter_invalid
        exporting
          parameter = number.
    endif.
    
    "primeiro digito do codigo de area num digito de 11 numeros.
    data: extended_areacode type c length 1.
    extended_areacode = number+3(1).
    
    "verifica o codigo de área quando antes disso for enviado o 1
    if strlen( number ) eq 16 and extended_areacode eq '0' or extended_areacode eq '1'.
      raise exception type cx_parameter_invalid
        exporting
          parameter = number.
    endif.
    
    "primeiro digito do numero com codigo de area e prefixo 1
    data: extended_exchange_code type c length 1.
    extended_exchange_code = number+8(1).
    
    "verifica o numero 
    if strlen( number ) eq 16 and extended_exchange_code eq '0' or extended_exchange_code eq '1'.
      raise exception type cx_parameter_invalid
        exporting
          parameter = number.
    endif.

    data: it_phone     type table of string, "tabela para receber cada digito do numero
          it_new_phone type table of string. "tabela para receber o numero tratado

    data: digit       type c length 1, "digito do numero
          count_digit type i,          "contador de digitos
          size_phone  type i.          "comprimento do numero

    "inicializa as variaveis
    digit = ''.
    count_digit = 0.
    size_phone = strlen( number ).

    "itera sobre o numero
    do size_phone times.
      digit = number+count_digit(1). "variavel recebe cada digito

      "verifica se o digito é um numero
      if digit cn '0123456789-()+. '.
        raise exception type cx_parameter_invalid
        exporting
          parameter = number.
      .
      endif.

      append digit to it_phone.      "insere o digito na tabela
      add 1 to count_digit.          "incrementa o contador de digitos
    enddo.

    "reinicia as variaveis
    count_digit = 0.
    digit = ''.

    loop at it_phone into data(ls_phone). "itera sobre a tabela que recebeu cada digito do numero.
      if ls_phone is not initial          "se o caractere nao for um espaço em branco
         "e tambem nao contiver nenhum destes caracteres...
         and ls_phone ne '-'
         and ls_phone ne '('
         and ls_phone ne ')'
         and ls_phone ne '+'
         and ls_phone ne '.'.
        append ls_phone to it_new_phone. "insere o caractere na nova tabela
      endif.
    endloop.

    "limpa variaveis.
    clear digit.
    clear it_phone.
    clear ls_phone.
    clear count_digit.

    data: new_phone type string. "string que recebe o telefone tratado
    data: flag type abap_bool.   "flag para saber se o digito existe na tabela de numeros
    flag = abap_false.           "define a flag inicialmente como false

    "itera sobre a nova tabela
    do size_phone times.
      digit = number+count_digit(1). "variavel recebe cada digito

      "itera sobre a tabela de numeros
      loop at it_new_phone into ls_phone.
        "se houver alguma incidencia do digito na tabela...
        if digit eq ls_phone.
          flag = abap_true. "muda a flag
        endif.
      endloop.

      "se a flag estiver ativa
      if flag eq abap_true.
        concatenate new_phone digit into new_phone. "concatena o difito a string
      endif.

      flag = abap_false.     "redefine a flag
      add 1 to count_digit. "incrementa o contador de digitos
    enddo.

    "cria um novo numero
    data: new_phone2 type string.

    "verifica se o primeiro digito do numero é 1
    read table it_new_phone into ls_phone index 1.
      if ls_phone eq '1'.             "e se for...
        new_phone2 = new_phone+1(10). "passa a string sem o numero 1
      endif.

    "verifica se a saída tem mais que 11 dígitos
    if strlen( new_phone ) gt 11 or strlen( new_phone2 ) gt 11.
      raise exception type cx_parameter_invalid
        exporting
          parameter = number.
      .
    endif.

    "verifica qual variavel vai inserir no parametro de saida
    if new_phone2 is not initial.
      result = new_phone2.
    else.
      result = new_phone.
    endif.

  endmethod.
endclass.

start-of-selection.

  data ol_phone_number type ref to zcl_phone_number.
  create object ol_phone_number.

  data: lv_number type string,
        lv_result type string.

  lv_number = '(223) 456-7890'.

  try.
      lv_result = ol_phone_number->clean( number = lv_number ).
    catch cx_parameter_invalid into data(lx_invalid).
      write: / 'Erro', lx_invalid->get_text( ).
      return.
  endtry.

  write: lv_result.
