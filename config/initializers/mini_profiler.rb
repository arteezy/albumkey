if Rails.env.development? do
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
end
