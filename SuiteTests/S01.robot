*** Settings ***
Documentation       API: https://fakerestapi.azurewebsites.net/swagger/ui/index

Resource            ..//Resources//Base.resource

Suite Setup         Run Keywords  Suite Setup Base  AND  create_session_to_api

Suite Teardown      Run Keywords  delete_session_to_api


*** Test Case ***
GET infos all user
    get_all_user

GET infos all books
    get_all_books

GET infos specific book
    get_book  1

POST new book
    post_a_new_book

PUT update infos book
    update_book  5434

DELETE a book
    delete_book  5434

POST a new book with params
    post_new_book_with_params  5434  "Title"  "Description"  189  "Excerpt"  "2021-12-28T09:31:32.327Z" 
