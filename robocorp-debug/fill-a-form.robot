*** Settings ***
Documentation       Debug form filling during browser automation.

Library    RPA.Browser.Selenium

Suite Teardown    Close All Browsers


*** Tasks ***
Fill A Form
    [Setup]    Open Available Browser
    Go To    https://jkorpela.fi/forms/testing.html

    Select Checkbox    box
    Checkbox Should Be Selected    box

    ${elem} =    Get WebElement    name:Comments
    Wait Until Element Is Visible    ${elem}
    Textarea Should Contain    ${elem}    some text
    Input Text    ${elem}    another text
    Textarea Should Contain    ${elem}    another text

    Submit Form    xpath://form[1]
    Page Should Contain    another

    Log    Done
