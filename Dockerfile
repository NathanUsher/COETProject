FROM ruby:latest AS build
WORKDIR /app
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install
RUN gem install puma

FROM build
COPY . .
CMD ["ruby", "app.rb"]

