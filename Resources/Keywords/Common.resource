*** Settings ***
Documentation       Keywords Common


*** Variables ***
${URL_API}  https://fakerestapi.azurewebsites.net

&{BOOK_1}  ID=1
...        TITLE=Book 1
...        PAGE_COUNT=100


***Keywords***
create_session_to_api
    Create Session    alias    ${URL_API}

delete_session_to_api
    Delete All Sessions

get_all_user
    ${response}     GET On Session    alias    /api/v1/Users
    Log  ${response.headers}
    Log  ${response.headers}[Content-Type]
    Log  ${response.text}
    ${LengthresponseJson}  Get Length  ${response.json()}
    Should Be Equal  ${LengthresponseJson}  ${10}
    Log  ${response.json()}
    Should Be Equal As Strings   ${response.status_code}  200
    Should Be Equal As Strings   ${response.reason}  OK

get_all_books
    ${response}     GET On Session    alias     /api/v1/Books
    Log  ${response.headers}
    Log  ${response.headers}[Content-Type]
    Log  ${response.text}
    ${LengthresponseJson}  Get Length  ${response.json()}
    Should Be Equal  ${LengthresponseJson}  ${200}
    Log  ${response.json()}
    Should Be Equal As Strings   ${response.status_code}  200
    Should Be Equal As Strings   ${response.reason}  OK
    Length Should Be    ${response.json()}    200

get_book
    [Arguments]    ${BOOK_ID}
    ${response}  GET On Session    alias     /api/v1/Books/${BOOK_ID}
    Log  ${response.text}
    Should Be Equal As Strings   ${response.status_code}  200
    Should Be Equal As Strings   ${response.reason}  OK
    Dictionary Should Contain Item      ${response.json()}      id            ${BOOK_1.ID}
    Dictionary Should Contain Item      ${response.json()}      title         ${BOOK_1.TITLE}
    Dictionary Should Contain Item      ${response.json()}      pageCount     ${BOOK_1.PAGE_COUNT}
    Should Not Be Empty      ${response.json()['description']}
    Should Not Be Empty      ${response.json()['excerpt']}
    Should Not Be Empty      ${response.json()['publishDate']}
    Log  ${response.json()['description']}
    Log  ${response.json()['excerpt']}
    Log  ${response.json()['publishDate']}

post_a_new_book
    ${HEADERS}      Create Dictionary   content-type=application/json

    ${JSON_05}    Load JSON From File    ${CURDIR}\\..\\..\\Data\\post001.json
    ${ID}    get value from json    ${JSON_05}    $.ID
    Log  ${JSON_05}

    ${response}     POST On Session    alias     /api/v1/Books  json=${JSON_05}  headers=${HEADERS}

    Should Be Equal As Strings   ${response.status_code}  200
    Should Be Equal As Strings   ${response.reason}  OK

    Dictionary Should Contain Item      ${response.json()}      id              5434
    Dictionary Should Contain Item      ${response.json()}      title           Title
    Dictionary Should Contain Item      ${response.json()}      pageCount       189
    Dictionary Should Contain Item      ${response.json()}      description     Description
    Dictionary Should Contain Item      ${response.json()}      excerpt         Excerpt
    Dictionary Should Contain Item      ${response.json()}      publishDate     2021-12-28T09:31:32.327Z

post_new_book_with_params
    [Arguments]    ${BOOK_ID}  ${BOOK_Title}  ${BOOK_Description}  ${BOOK_PageCount}  ${BOOK_Excerpt}  ${BOOK_PublishDate}
    ${HEADERS}      Create Dictionary   content-type=application/json
    ${response}     POST On Session    alias     /api/v1/Books
    ...  data={"ID": ${BOOK_ID}, "Title": ${BOOK_Title}, "Description": ${BOOK_Description}, "PageCount": ${BOOK_PageCount}, "Excerpt": ${BOOK_Excerpt}, "PublishDate": ${BOOK_PublishDate}}
    ...  headers=${HEADERS}
    Should Be Equal As Strings   ${response.status_code}  200
    Should Be Equal As Strings   ${response.reason}  OK
    Dictionary Should Contain Item      ${response.json()}      id              5434
    Dictionary Should Contain Item      ${response.json()}      title           Title
    Dictionary Should Contain Item      ${response.json()}      pageCount       189
    Dictionary Should Contain Item      ${response.json()}      description     Description
    Dictionary Should Contain Item      ${response.json()}      excerpt         Excerpt
    Dictionary Should Contain Item      ${response.json()}      publishDate     2021-12-28T09:31:32.327Z

update_book
    [Arguments]  ${BOOK_ID}
    ${HEADERS}      Create Dictionary   content-type=application/json
    ${response}     PUT On Session    alias     /api/v1/Books/${BOOK_ID}
    ...  data={"ID": ${BOOK_ID}, "Title": "Title Edited", "Description": "Description Edited", "PageCount": 190, "Excerpt": "Excerpt Edited", "PublishDate": "2018-09-28T09:31:32.327Z"}
    ...  headers=${HEADERS}
    Should Be Equal As Strings   ${response.status_code}  200
    Should Be Equal As Strings   ${response.reason}  OK
    Dictionary Should Contain Item      ${response.json()}      id              5434
    Dictionary Should Contain Item      ${response.json()}      title           Title Edited
    Dictionary Should Contain Item      ${response.json()}      pageCount       190
    Dictionary Should Contain Item      ${response.json()}      description     Description Edited
    Dictionary Should Contain Item      ${response.json()}      excerpt         Excerpt Edited
    Dictionary Should Contain Item      ${response.json()}      publishDate     2018-09-28T09:31:32.327Z

delete_book
    [Arguments]  ${BOOK_ID}
    ${response}     DELETE On Session    alias     /api/v1/Books/${BOOK_ID} 
    Should Be Equal As Strings   ${response.status_code}  200
    Should Be Equal As Strings   ${response.reason}  OK