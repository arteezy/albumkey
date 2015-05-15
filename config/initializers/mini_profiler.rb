if Rails.env.development?
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
end
