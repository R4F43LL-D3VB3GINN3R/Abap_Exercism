"-------------------------------------------------------------------------------------------------------------------------

*Introduction
*In some English accents, when you say "two for" quickly, it sounds like "two fer". 
*Two-for-one is a way of saying that if you buy one, you also get one for free. So the phrase "two-fer" often implies a two-for-one offer.
*
*Imagine a bakery that has a holiday offer where you can buy two cookies for the price of one ("two-fer one!"). 
*You take the offer and (very generously) decide to give the extra cookie to someone else in the queue.

*Instructions
*Your task is to determine what you will say as you give away the extra cookie.
*
*If you know the person's name (e.g. if they're named Do-yun), then you will say:
*
*One for Do-yun, one for me.
*If you don't know the person's name, you will say you instead.
*
*One for you, one for me.
*Here are some examples:
*
*Name	Dialogue
*Alice	One for Alice, one for me.
*Bohdan	One for Bohdan, one for me.
*One for you, one for me.
*Zaphod	One for Zaphod, one for me. 

"-------------------------------------------------------------------------------------------------------------------------

*&---------------------------------------------------------------------*
*& Report ZTEMP001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report ztemp001.

class zcl_two_fer definition .
  public section.
    methods two_fer
      importing
        input         type string optional
      returning
        value(result) type string.
endclass.

class zcl_two_fer implementation.

  method two_fer.
    
    "verifica se o parametro foi enviado
    if input is initial.
      
      "se nao for, envia uma mensagem padrao de retorno
      result = 'One for you, one for me.'.
    else.
      
      "se for, envia uma mensagem personalizada
      result = |One for { input }, one for me.|.
    endif.

  endmethod.

endclass.

start-of-selection.

data: ol_two_fer type ref to zcl_two_fer.

create object ol_two_fer.

data: value type string.

value = ol_two_fer->two_fer(
            input = 'Name'
        ).

write: value.
