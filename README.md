## Chat App 

#### To run the app:
- install ``docker`` and ``docker-compose``
- ``git clone https://github.com/xamohsen/chat_system.git && cd chat_system``
- ``docker-compose up``
- go to ``http://localhost:3000/``
- to run specs
    - ``docker exec -it chat_system_app_1 bash``
    - ``rspec``
- Documentation: https://documenter.getpostman.com/view/54956/SVYkx2XW?version=latest

## ToDo

- Reject old requests by adding date/time to each request and reject any request with date/time older than the date/time in database.
- Refactor create-and-queuing APIs to be in another service to be able to handle more requests.
- Add update APIs to the queue.
- Create queue per API for example create a queue for create app API and another one for create chat API.
- Revisit specs to make sure all corner cases and bad requests are handle correctly.
