"-------------------------------------------------------------------------------------------------------------------------

*Introduction
*You are starting a secret coding club with some friends and friends-of-friends. Not everyone knows each other, so you and your friends have decided to create a secret handshake that you can use to recognize that someone is a member. You don't want anyone who isn't in the know to be able to crack the code.
*
*You've designed the code so that one person says a number between 1 and 31, and the other person turns it into a series of actions.
*
*Instructions
*Your task is to convert a number between 1 and 31 to a sequence of actions in the secret handshake.
*
*The sequence of actions is chosen by looking at the rightmost five digits of the number once it's been converted to binary. Start at the right-most digit and move left.
*
*The actions for each number place are:
*
*00001 = wink
*00010 = double blink
*00100 = close your eyes
*01000 = jump
*10000 = Reverse the order of the operations in the secret handshake.
*Let's use the number 9 as an example:
*
*9 in binary is 1001.
*The digit that is farthest to the right is 1, so the first action is wink.
*Going left, the next digit is 0, so there is no double-blink.
*Going left again, the next digit is 0, so you leave your eyes open.
*Going left again, the next digit is 1, so you jump.
*That was the last digit, so the final code is:
*
*wink, jump
*Given the number 26, which is 11010 in binary, we get the following actions:
*
*double blink
*jump
*reverse actions
*The secret handshake for 26 is therefore:
*
*jump, double blink

"-------------------------------------------------------------------------------------------------------------------------

*&---------------------------------------------------------------------*
*& Report ZEXERCISM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXERCISM.

class zcl_secret_handshake definition
  final
  create public .

  public section.
    methods get_commands
      importing code            type i
      returning value(commands) type string_table.
  protected section.
  private section.
endclass.

class zcl_secret_handshake implementation.

  method get_commands.

*    00001 = wink
*    00010 = double blink
*    00100 = close your eyes
*    01000 = jump
*    10000 = Reverse the order of the operations in the secret handshake.

    if code < 1 or code > 31.
      message 'Código inválido' type 'E'.
    endif.

    "variavel inteiro recebe parametro codigo de entrada.
    data: lv_number type i.
    lv_number = code.

    data: lv_binary    type string,      "string para armazenar numero binario
          lv_remainder type i.           "inteiro para armazenar o resto

    data: it_data type table of i.                    "tabela para guardar os dígitos binários.
    data: it_commands type table of string.           "tabela para receber os comandos
    data: it_reverse_commands type table of string.   "tabela para receber os comandos invertidos

    "popula a tabela de comandos
    append 'wink' to it_commands.
    append 'double blink' to it_commands.
    append 'close your eyes' to it_commands.
    append 'jump' to it_commands.
    append 'secret handshake' to it_commands.

    data: count_lines type i.         "index das tabelas
    data: count_reverse_lines type i. "index reverso

    "enquanto o numero nao for reduzido a menor do que zero
    while lv_number > 0.
      lv_remainder = lv_number mod 2.         "calcula o resto da divisão por 2 (0 ou 1)
      append lv_remainder to it_data.         "adiciona o digito a tabela
      lv_binary = lv_remainder && lv_binary.  "adiciona o resto ao início da string
      lv_number = lv_number div 2.            "divide o número por 2 (divisão inteira)
    endwhile.

    "redefine o binario como zero caso esteja vazio
    if lv_binary is initial.
      lv_binary = '0'.
    endif.

    "redefine o index para contar agora pra frente
    count_lines = 1.

    "itera sobre a tabela de digitos 2
    loop at it_data into data(ls_data).

      "se encontrar o numero 1...
      if ls_data eq 1.

        "le a tabela de comandos no index do contador
        read table it_commands into data(ls_commands) index count_lines.

        "insere a linha na tabela de saída
        append ls_commands to commands.

      endif.

      "a ultima verificacao é sobre a ultima linha da tabela
      "se for encontrado um digito 1...
      if ls_data eq 1 and count_lines eq 5.

        "a variavel recebe o valor da quantidade de linhas na tabela
        count_reverse_lines = lines( commands ).

        "itera sobre a tabela de saida
        loop at commands into data(ls_commands2).

          "dentro do ciclo, le a tabela de traz pra frente
          read table commands into ls_commands2 index count_reverse_lines.

          "verificacao para nao inserir esta linha na tabela
          if ls_commands2 ne 'secret handshake'.

            "insere a linha na tabela reversa
            append ls_commands2 to it_reverse_commands.

          endif.

          "decrementa o index
          count_reverse_lines = count_reverse_lines - 1.

        endloop.

        "limpa os dados da tabela de saida
        clear commands.

        "passa a tabela inversa para a tabela de saida
        commands = it_reverse_commands.

      endif.

      "incrementa o index.
      add 1 to count_lines.

    endloop.

  endmethod.

endclass.

start-of-selection.

data: num type i,
      it_data type table of string.

data : ol_secret_handshake type ref to zcl_secret_handshake.

create object ol_secret_handshake.

it_data = ol_secret_handshake->get_commands( code = 31 ).

cl_demo_output=>display( it_data ).

"-------------------------------------------------------------------------------------------------------------------------
