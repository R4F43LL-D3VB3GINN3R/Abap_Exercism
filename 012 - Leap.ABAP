"--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*Introduction
*A leap year (in the Gregorian calendar) occurs:
*
*In every year that is evenly divisible by 4.
*Unless the year is evenly divisible by 100, in which case it's only a leap year if the year is also evenly divisible by 400.
*Some examples:
*
*1997 was not a leap year as it's not divisible by 4.
*1900 was not a leap year as it's not divisible by 400.
*2000 was a leap year!
*
*Instructions
*Your task is to determine whether a given year is a leap year.

"--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

report zexercism.

class zcl_leap definition.
  public section.
    methods leap
      importing
        year          type i
      returning
        value(result) type abap_bool.
endclass.

class zcl_leap implementation.

  method leap.
    
    "se o ano for divisivel por 4...
    if year mod 4 = 0.
      result = 'X'.
    else.
      result = abap_false.
    endif.
    
    "se o ano for divisivel por 100 e nao for por 400...
    if year mod 100 = 0 and year mod 400 ne 0.
      result = abap_false.
    endif.

  endmethod.

endclass.

start-of-selection.

data ol_leap type ref to zcl_leap.
create object ol_leap.

data: date type i,
      leap_year type abap_bool.

date = 2100.

leap_year = ol_leap->leap( year = date ).

write: leap_year.
