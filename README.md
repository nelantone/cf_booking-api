## REST API Booking Calendar

Booking calendar RESTful backend API to enable students to schedule a call with the mentors and document the API endpoints for the Front-end developers.

### Versions:
**Ruby 3.0**
**Rails 6.1.3**

#### Dependencies:
  * **'guard'** - Command line tool to easily handle events on file system modifications.
    * **'guard-rspec'** - Specific for rspec.
    * **'guard-rubocop'** - Specific for rubocop.
  * **'rspec-rails'** -  Testing framework on Rails as alternative to Minitest.
  * **'database_cleaner'** - to ensure a clean slate for testing.
  * **'factory_bot_rails'** - 'factory_bot' is a fixtures replacement with a straightforward definition syntax using factories, in this case provides integration with rails.
  * **'faker'**  - a Data::Faker to easily generate fake data: names, addresses etc...
  * **'shoulda-matchers'** - provides RSpec- and Minitest-compatible one-liners to test common Rails functionality.
#### Installation/Setup
  1. Have installed `rails 6.1` and `ruby 3.0`
  2. `bundle`
  3. `rails db:create && rails db:migrate`

#### Instructions for http request/endpoints and run the project:

 Using for example [httpie](https://httpie.io/) as HTTP client.

* Inside the project Run **`rails server`** .
* on another console window also inside the project run:

  * Test-endpoints for mentors
  ```
  # GET /mentors
  $ http :3000/mentors
  # POST /mentors
  $ http POST :3000/mentors name=Mark time_zone=London/UK
  # PUT /mentors/:id (update name)
  $ http PUT :3000/mentors/1 name=Elon
  # DELETE /mentors/:id
  $ http DELETE :3000/mentors/1
  ```
  * Test-endpoints for mentors and respective bookings
  ```
  ## in case you need to create a mentor
  # POST /mentors
  $ http POST :3000/mentors name=Mark time_zone=London/UK

  # GET /mentors/:mentor_id/bookings
  $ http :3000/mentors/1/bookings
  # POST /mentors/:mentor_id/bookings
  $ http POST :3000/mentors/1/bookings call_reason='Say hi!' start_time='2021-02-03T04:05:06+00:00'
  # PUT /mentors/:mentor_id/bookings/:id
  $ http PUT :3000/mentors/1/bookings/1 call_reason='Say buh!'
  # DELETE /mentors/:mentor_id/bookings/1
  $ http DELETE :3000/mentors/1/bookings/1
  ```

### run test suite.
* rspec tests:
`bundle exec rspec`

*  For control in code related changes you can keep running in a specific console-window:
`guard`

#### Task process, methods and design decision:


##### Understanding the Problem

* **Mental Model**:
Create a booking calendar RESTful backend API to enable students to schedule a call with the mentors and document the API endpoints for the Front-end developers.

  * **Restrictions:**
  **General from this task**
  * Don’t spend more than 4 hours on the test and find a simple solution
  * Only endpoints for REST-API(only backend with http-requests)

  **Requirements/ Assumptions:**
  * The confirmation must be stored in a database of your choice.
  * Allocated **slots from the external api might change any time**.
  * A **call will always take 1 full hour and start at the full hour**.
  * Our **mentors** are superheroes and **work 24/7**.
  * If there is an **allocated slot within the hour**, the full hour is **considered unavailable**.


  * **Main points**
  Are most **interested in understand my working process**:
  **How I organize and execute ideas**
  **Describe design decision in README** and relevant methods.
  **Include instructions and how to run the project and automate the test suite.**


  * Questions:
       -  	from API (CF Calendar) example https://cfcalendar.docs.apiary.io/#reference/0/mentors-agenda

      The api doc only shows a list of hours **(slots), are available or allocated?**
      ```ruby
        {
        "mentor": {
          "name": "Max Mustermann",
          "time_zone": "-03:00"
        },
        "calendar": [
      {
            "date_time": "2020-10-24 17:10:09 +0200"
          },
          {
            "date_time": "2020-10-25 13:11:55 +0100"
          },
      }]
      ```

    ** *Seems like student-mentor bookings (as supposed to be 24 hrs availability)*


    * **Students need to be part of the main API architecture?** We only need an API whose main responsibility is to schedule/book a call with mentors.

    ** *As the description says, to find a simple solution, for now I think it is simpler to have only booking and mentor and a student as valid token accessing our CF-booking-API.*
    Also as is not clear about the calendar that available or allocated slots, I will use the `booking` attribute  (as are related to mentors and will have more sense to see only the booking-hours)
    so for now **`booking` is `calendar`**


##### Examples:

  * First approach:
      - Mentor, booking and student models in a rails API.
      Mentor has many bookings, booking belongs to mentor and student. Do Students have many  bookings?  Do we really need a student model?
</br>
  * **Current approach:**
    - Mentor has many bookings, and booking belongs to menor. This is how I will proceed and then add the user-student as an JWT access-token-session.

##### Data structure.
- The simplest as possible. I will use rails default database `sqlite3` but I am also comfortable with `pg` (PostgreSQL).

##### Algorithm:

  * **Architecture**
    ```
    class Mentor < User

    class Mentor
      has_many :bookings
    end

    attr: name: string, timezone: string

    class Booking
      belongs_to :mentor
    end

    attr: date_time: datetime, call_reason: string
    ```


### Process

##### 1. Start project and init commit.
Restful API:

* `rails new cf_booking-api --api  -T`
	-  Tell rails is an API(-api)
  -  Exclude minitest as default (-T)

</br>

* Add the specific dependencies we will use from start and commit changes.

##### 2. Add folders, files and set/initialize dependencies
* rspec `rails generate rspec:install`
* add `spec/rails_helper.rb` configuration for database cleaner, shoulda matchers and
factory bot
* guard `bundle exec guard init`
* rubocop `.rubocop.yml` require `rubocop-rails` & `rubocop-rspec`
* Fix rubocop offensess and add todo list for rubocop small issues.
* `bundle exec guard` is continuosly executed in the background to find rubocop ofensess and in case rspec tests are falining.

##### 3. Add and migrate Mentor and Booking models
`rails g model Mentor name:string time_zone:string`
`rails g model Booking date_time:datetime call_reason:string mentor:references`

* By adding references we are telling the generator to set up an association with the Mentor model.
  This will:

  * Add a foreign key column mentor_id to the bookings table
  * Setup a belongs_to association in the Item model

`rails db:migrate`

##### 4. Models: TDD mentor_spec & booking_spec
* Add shoulda-matchers from booking and mentor model
* Make test failing
* Fix booking and mentor models adding relations and validations

##### 5. Controllers: TDD mentor_spec
`rails g controller Models`
`rails g controller Bookings`

* We’re going to write **request specs**.
** *The official recommendation of the Rails team and the RSpec core team is to write request specs*
  </br>
  * As we are building an API application, this is exactly the behavior we want from our tests, we want to hit the HTTP endpoints as opposed to controller specs which call methods directly.
  </br>
  * Add `spec/requests` folder and inside `mentors_spec` and `bookings_spec` files.
  </br>
  * Add the factory files `mentors` & `booking`s
    </br>
  * Add the database with a list of 2 mentor records with factories.
    </br>
  * Add a custom helper method json to parse the JSON response to a Ruby Hash for our tests:
  `support/request_spec_helper` & respective `spec`.
    </br>
  * Enable in rails helper and comment out the support directory auto-loading and then
include it as shared module for all request specs in the RSpec configuration block (Support directory is not autoloaded by default).
    - We have a routing error
* Define routes,for mentor resource with a nested bookings resource. This enforces the 1:m (one to many) route-associations.
    - we fix the routing error
    - we have a controller error
* Define the mentors controller and add `json_response` helper method.
 Rescue this exception and return 404
* Fix all failing tests via TDD
* Now we can make mentor requests to the API(see Above *instructions for http request/endpoints*: ).

##### 6. Controllers: TDD booking_spec
* Add requests booking specs
* Add bookings controller
* Fix factory booking issues
* Fix rubocop offenses

* Now we can make booking requests to the API(see Above *instructions for http request/endpoints*: ).

- **Scenario 1**
Show from a specific day time slots(as a list from 23-00, 00-01 * 24hr slots)
Show time slots booked. 
</br>


#### 7. Find valid/not_valid booking scenarios and rename Booking time_date to start_time...

- **When  the student click on a date:**

	- **Scenario 2**
      - A time slot is booked? => false
      - Fill-in call-reason:
      - Confirm call and receive a confirmation message

  - First approach of Scenario 3:

    - Send request, which request?
    - A time slot is booked? =>  true
    - Error(this time slot is not available) * there is no-call-reason.

  - **Current approach scenario 3:**
    - Click on date
    - Fill in reason
    - Error. (this time slot is not available)

  - **Rename Booking time_date to start_time**
    - is better and more self explanatory to have an attribute as `start_time` instead `date_time`

  - **Rename `Response` to `ResponseJsonHandler`** to have clarity on the helper name.

#### 8. Timezone and add Mentor as User class and add service token/jwt..
- Deal with timezone by convention `Time.current.utc.iso8601` working with APIs

* **Front-end** can be **on charge** to show the **current hour** from the mentor/student for ("-0300") we can somehow use something similar as `formatted_offset`.

- `Class Mentor < User`
- Add http-requests and Authenticate User as service `token/jwt`.