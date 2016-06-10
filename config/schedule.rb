set :rbenv, '"$HOME/.rbenv/shims":"$HOME/.rbenv/bin"'

job_type :rake,   'cd :path && PATH=:rbenv:"$PATH" :environment_variable=:environment bundle exec rake :task --silent :output'
job_type :runner, 'cd :path && PATH=:rbenv:"$PATH" bin/rails runner -e :environment ":task" :output'

set :output, 'log/whenever.log'

every 8.hours do
  rake 'albums:update'
end

every :day, at: '06:05am' do
  rake 'albums:getlatest'
end

every :day, at: '10:10pm' do
  rake 'slugs:update'
end

every :sunday, at: '09:15am' do
  rake 'discogs:fullscan'
end
