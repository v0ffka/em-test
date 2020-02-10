Feeds and its articles are modelled using 2 tables: feeds and feed_items

Feed contents are pulled via the FeedJob (for simplicity, currently only triggered on create).
The job is handled by rails default, no additional configuration.

All tests are RSpec.

Running the app with `rails s`, no additional setup is required