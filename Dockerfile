FROM ruby:latest

WORKDIR /app

COPY . .

RUN bundle install

CMD ["ruby", "src/app.rb"]

