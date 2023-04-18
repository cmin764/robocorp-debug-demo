*** Settings ***
Documentation       Simple debugging demo while playing with strings.

Library    String


*** Tasks ***
Concatenate Strings
    @{words} =    Split String    apple orange banana
    ${string} =    Catenate    SEPARATOR=,    @{words}

    Log    ${string}
    Log To Console    Console: ${string}

    ${string} =    Replace String    ${string}   apple   kiwi
    Log To Console    Console: ${string}
