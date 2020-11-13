# Room Booking API

## Stack

* Ruby 2.7.1

* Rails 6

* Database: PostgreSQL

* Tests: [RSpec](https://github.com/rspec/rspec-rails)

## Running

Tests:
``` 
rspec 
```
Seeds:
```
rake db:seed
```
Server:
```
rails s
```

## API

### GET /rooms
#### Example:
 ``` 
 curl http://localhost:3000/rooms
 ```

### POST /rooms/:id/bookings
#### Example:
```
curl --header "Content-Type: application/json" \
     --header "X-User-ID: 1"\
     --request POST \
     --data '{"bookings": [{"start_date":"2020-12-13", "end_date":"2020-12-15"}, {"start_date":"2020-12-20", "end_date":"2020-12-22"}]}'\
     http://localhost:3000/rooms/1/bookings
```

### GET /rooms/:id/bookings
#### Examples:

All bookings:
 ``` 
 curl http://localhost:3000/rooms/1/bookings
 ```

From ```2020-12-12``` to ```2020-12-14```:
 ``` 
 curl 'http://localhost:3000/rooms/1/bookings?from=2020-12-12&to=2020-12-14'
 ```




