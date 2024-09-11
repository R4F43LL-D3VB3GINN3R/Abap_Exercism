"----------------------------------------------------------------------------------------------------------------------------------------------------------------

*Instructions
*If you want to build something using a Raspberry Pi, you'll probably use resistors. For this exercise, you need to know two things about them:
*
*Each resistor has a resistance value.
*Resistors are small - so small in fact that if you printed the resistance value on them, it would be hard to read.
*To get around this problem, manufacturers print color-coded bands onto the resistors to denote their resistance values. Each band has a position and a numeric value.
*
*The first 2 bands of a resistor have a simple encoding scheme: each color maps to a single number.
*
*In this exercise you are going to create a helpful program so that you don't have to remember the values of the bands.
*
*These colors are encoded as follows:
*
*black: 0
*brown: 1
*red: 2
*orange: 3
*yellow: 4
*green: 5
*blue: 6
*violet: 7
*grey: 8
*white: 9
*The goal of this exercise is to create a way:
*
*to look up the numerical value associated with a particular color band
*to list the different band colors

"----------------------------------------------------------------------------------------------------------------------------------------------------------------

report zexercism.

class zcl_resistor_color definition create public.
  public section.
    methods resistor_color
      importing
        color_code   type string
      returning
        value(value) type i.
endclass.

class zcl_resistor_color implementation.

  method resistor_color.
    
    "estrutura para comportar valores relacionados a cores
    types: begin of wa_struct,
             color type string,
             code  type i,
           end of wa_struct.
    
    "tabela interna da estrutura
    data: it_codecolors type table of wa_struct.
    
    "preenchimendo da tabela com cores e codigos relacionados
    it_codecolors = value #( ( color = 'black'  code = 0 )
                             ( color = 'brown'  code = 1 )
                             ( color = 'red'    code = 2 )
                             ( color = 'orange' code = 3 )
                             ( color = 'yellow' code = 4 )
                             ( color = 'green'  code = 5 )
                             ( color = 'blue'   code = 6 )
                             ( color = 'violet' code = 7 )
                             ( color = 'grey'   code = 8 )
                             ( color = 'white'  code = 9 ) ).
    
    "itera sobre a tabela
    loop at it_codecolors into data(ls_codecolor).
      
      "se a cor enviada pelo parametro for encontrada na tabela...
      if color_code eq ls_codecolor-color.
        
        "parametro de saida recebe o codigo relacionado
        value = ls_codecolor-code.

      endif.

    endloop.

  endmethod.

endclass.

start-of-selection.

data: ol_resistor_color type ref to zcl_resistor_color.

data: color type string,
      code type i.

color = 'black'.

create object ol_resistor_color.

code = ol_resistor_color->resistor_color( color_code = color ).

write: code.
