require 'net/http'
require 'uri'

aggregates  = [
  "c545a753-4f22-426c-88dc-8f999ee1f2b9",
  "866440ac-004b-41ae-be89-4eb2e30840f8",
  "0d94ea93-59d6-40be-9573-4db1f5d8375d",
  "d46af242-435a-4773-ad6b-a3e4b6cea943",
  "92db4efa-10d6-4161-88df-4a0c12d9a21a",
  "85454dac-9e7b-45df-9a21-ae3cb94fc862",
  "254a3a9a-862a-4f61-9066-3f72dd2f18a4",
  "f85db033-7845-490a-aef8-f976787ef25d",
  "c5bcfc5b-5c46-4a13-bf04-e3a3e44d53d2",
  "cf535a3e-8ce3-4bfe-8025-efcd40ca4eb8"
]

def send_message(aggregate_id)
  url = "https://warp.gigalixirapp.com/api/messages"

  body = {"to" => aggregate_id, "body" => "Rando messages"}

  uri = URI(url)

  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: url.start_with?("https")) do |http|
    req = Net::HTTP::Post.new(uri)
    req.set_form_data(body)
    http.request(req)
  end

  case res
  when Net::HTTPSuccess, Net::HTTPRedirection
    print '.'
  else
    pp res.value
  end
end


loop do
  aggregates.each do |id|
    send_message(id)
    sleep(2)
  end
end
