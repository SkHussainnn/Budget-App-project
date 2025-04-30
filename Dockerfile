# Use the official Ruby image as a base image
FROM ruby:3.1.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

RUN gem install bundler:2.3.6

# Set an environment variable to tell Bundler to install gems to /usr/local/bundle
ENV BUNDLE_PATH /usr/local/bundle

# Set the working directory to /app
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the image
COPY Gemfile* ./

# Install the required gems
RUN bundle install

# Copy the rest of the application code into the image
COPY . .

# Precompile assets (if you have any)
RUN bundle exec rake assets:precompile

EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
