"--------------------------------------------------------------------------------------------------------------------------------------

*Instructions
*Implement a clock that handles times without dates.
*
*You should be able to add and subtract minutes to it.
*
*Two clocks that represent the same time should be equal to each other.

"--------------------------------------------------------------------------------------------------------------------------------------

report exercism.

class zcl_clock definition
  create public.

  public section.

    methods constructor
      importing
        !hours   type i
        !minutes type i default 0.
    methods get
      returning
        value(result) type string.
    methods add
      importing
        !minutes type i.
    methods sub
      importing
        !minutes type i.

  private section.

    "objetos da classe de horas
    data: clock type sy-uzeit.
    data: ohours type i.
    data: omins type i.

endclass.

class zcl_clock implementation.

  method add.

    "para adicionar tempo em minutos ao nosso relogio...
    "chamamos o nosso objeto de classe e acrescentamos a ele os minutos.
    me->omins = minutes * 60.
    "depois somamos os minutos ao relógios
    me->clock = me->clock + me->omins.

  endmethod.


  method constructor.

    "a principio, calculamos as horas sempre baseado em segundos.

    "multiplicamos a quantidade de horas enviadas pela quantidade de segundos contidos em uma hora
    me->ohours = hours * 3600.
    "fazemos o mesmo com os minutos
    me->omins = minutes * 60.
    "ao fim, o relogio recebe a soma de todos os segundos para obtermos a hora do relogio
    me->clock = me->ohours + me->omins.

  endmethod.


  method get.

   data: char_clock type c length 4. "variavel para receber apenas as horas e minutos
   data: split_hour type string.     "horas
   data: split_min type string.      "minutos

   "no metodo get, enviamos o relogio com a hora já estabelecida
   "pegamos apenas os quatro primeiro dígitos do relógio
   char_clock = me->clock+0(4).

   split_hour = char_clock+0(2). "apenas a hora
   split_min = char_clock+2(2).  "apenas o minuto

   "juntamos novamente hora e minuto e entre eles colocamos os dois pontos.
   "dentro do parametro de saída.
   concatenate split_hour ':' split_min into result.

  endmethod.


  method sub.

    "para adicionar tempo em minutos ao nosso relogio...
    "chamamos o nosso objeto de classe e acrescentamos a ele os minutos.
    me->omins = minutes * 60.
    "depois subtraímos os minutos do relógios
    me->clock = me->clock - me->omins.

  endmethod.
endclass.

start-of-selection.

  data ol_clock type ref to zcl_clock.

  data: lv_clock type string,
        lv_hrs type i,
        lv_min type i.

  lv_hrs = 4.
  lv_min = 3.

  create object ol_clock
    exporting
      hours   = lv_hrs
      minutes = lv_min
    .

  lv_clock = ol_clock->get( ).

  write: lv_clock.

  ol_clock->add( minutes = 5 ).

  lv_clock = ol_clock->get( ).

  write: lv_clock.

  ol_clock->sub( minutes = 2 ).

  lv_clock = ol_clock->get( ).

  write: lv_clock.

"--------------------------------------------------------------------------------------------------------------------------------------
