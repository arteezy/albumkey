set :rbenv, '"$HOME/.rbenv/shims":"$HOME/.rbenv/bin"'

job_type :rake,   'cd :path && PATH=:rbenv:"$PATH" :environment_variable=:environment bundle exec rake :task --silent :output'
job_type :runner, 'cd :path && PATH=:rbenv:"$PATH" bin/rails runner -e :environment ":task" :output'

set :output, 'log/whenever.log'

every '2-14/4 5,6 * * *' do
  rake 'albums:getlatest'
end

every 8.hours do
  rake 'albums:update'
end

every :day, at: '10:10pm' do
  rake 'slugs:update'
end

every :day, at: '07:25pm' do
  rake 'sitemap:refresh'
end

every :sunday, at: '09:15am' do
  rake 'discogs:fullscan'
end

every :weekday, at: '08:30am' do
  rake 'albums:wall'
end

every :weekend, at: '08:30am' do
  rake 'albums:wall:bnm'
end
