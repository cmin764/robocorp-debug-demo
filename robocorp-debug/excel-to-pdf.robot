*** Settings ***
Documentation       Debug form filling during browser automation.

Library    Collections
Library    RPA.Desktop
Library    RPA.Excel.Files
Library    RPA.PDF
Library    RPA.Robocorp.WorkItems
Library    RPA.Tables

Suite Teardown    Close All PDFs


*** Variables ***
${ROBOT_PARTS}    robot-parts.xlsx
${PARTS_TEMPLATE_PATH}    devdata${/}invoice-template.html
${PARTS_INVOICE}    invoice.pdf
${PARTS_INVOICE_PATH}    ${OUTPUT_DIR}${/}${PARTS_INVOICE}


*** Keywords ***
Robot Parts Table To Dict
    [Arguments]    ${table}

    @{heads} =    Get Table Column    ${table}    Heads
    ${heads_total} =    Evaluate    sum($heads)
    @{bodies} =    Get Table Column    ${table}    Bodies
    ${bodies_total} =    Evaluate    sum($bodies)
    @{legs} =    Get Table Column    ${table}    Legs
    ${legs_total} =    Evaluate    sum($legs)

    &{parts_dict} =    Create Dictionary
    ...    heads    ${heads_total}
    ...    bodies    ${bodies_total}
    ...    legs    ${legs_total}
    Log Dictionary    ${parts_dict}

    RETURN    ${parts_dict}


*** Tasks ***
Excel To PDF
    ${path} =    Get Work Item File    ${ROBOT_PARTS}    ${OUTPUT_DIR}${/}${ROBOT_PARTS}
    Open Workbook    ${path}
    ${table} =    Read Worksheet As Table    header=${True}
    Log    Read table: ${table}

    &{parts_dict} =    Robot Parts Table To Dict    ${table}
    Template Html To Pdf    ${PARTS_TEMPLATE_PATH}    ${PARTS_INVOICE_PATH}
    ...    variables=${parts_dict}
    Create Output Work Item    files=${PARTS_INVOICE_PATH}    save=${True}

    [Teardown]    Close Workbook


Open Invoice PDF
    ${path} =    Get Work Item File    ${PARTS_INVOICE}
    ...    ${OUTPUT_DIR}${/}${PARTS_INVOICE}
    Run Keyword And Ignore Error    Open File    ${path}
