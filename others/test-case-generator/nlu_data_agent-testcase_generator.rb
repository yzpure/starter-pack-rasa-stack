# encoding: utf-8
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'fileutils'
require 'pathname'
require 'json'
require 'csv'
require 'yaml'
require 'pp'
require 'net/http'

target_file = File.join __dir__, 'testcases', 'agent', '201901-test-case.csv'
pp target_file

rows = CSV.read target_file
# pp rows[0..3]
max_length = rows.length
pp max_length

output_folder = File.join(__dir__, "testcase-output", 'agent')
FileUtils.mkdir_p output_folder

output_file = File.join(output_folder, "#{"agent-" + DateTime.now.strftime('%Y%m%d%H%M%S')}.csv")

def test(content)
  # Run Test Case
  # url = URI("http://192.168.60.80:5000/parse?project=current&model=nlu&q=#{URI::encode(content)}")
  url = URI("http://127.0.0.1:5000/parse?project=current&model=nlu&q=#{URI::encode(content)}")
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Get.new(url)
  request["content-type"] = 'application/json;charset=utf-8;'
  response = http.request(request)
  response.read_body
end

open output_file, 'w' do |f|
  f << "意图, 问题, 结果意图, 是否匹配, 信心, output\n"

  current_row_index = 1
  while current_row_index < max_length
    question = rows[current_row_index][0]
    intent = rows[current_row_index][1]
    # pp "#{question}, #{intent}"

    raw_result = test(question)
    result = JSON.parse(raw_result)
    # puts result
    result_intent_node = result['intent']
    # puts result_intent_node
    result_intent = result_intent_node['name']
    result_match = result_intent.eql? intent
    result_confidence = result_intent_node['confidence']
    f << "#{intent}, #{question}, #{result_intent}, #{result_match}, #{result_confidence},\"#{result.to_json.gsub(/\n/, ';').gsub(/,/, ';')}\"\n"

    current_row_index += 1
  end

end

