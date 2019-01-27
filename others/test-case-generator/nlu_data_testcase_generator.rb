# encoding: utf-8
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'fileutils'
require 'pathname'
require 'json'
require 'pp'
require 'redcarpet'
require 'net/http'

target_positive_md_file_name = "nlu_data.md"
target_positive_md_file = File.join(__dir__, "testcases", "positive", target_positive_md_file_name)

markdown = File.read(target_positive_md_file)
# pp markdown

result = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new).render(markdown)
# pp result

doc = Nokogiri::HTML(result)
# pp doc

h2_nodes = doc.search("h2")
h2_length = h2_nodes.length

ul_nodes = doc.search("ul")
ul_length = ul_nodes.length

pp "h2_length: #{h2_length}, ul_length: #{ul_length}"

output_folder = "testcase-output"
FileUtils.mkdir_p output_folder
output_file = File.join(output_folder, "#{DateTime.now.strftime('%Y%m%d%H%M%S')}.csv")

def test(content)
  # Run Test Case
  url = URI("http://localhost:5000/parse?project=current&model=nlu&q=#{URI::encode(content)}")
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Get.new(url)
  request["content-type"] = 'application/json;charset=utf-8;'
  response = http.request(request)
  response.read_body
end

open output_file, 'w' do |f|
  f << "意图, 问题, 结果意图, 是否匹配, 信心, output\n"

  current_h2 = 0
  current_ul = 0

  while current_h2 < h2_length - 1 and current_ul < ul_length - 1
    intent_content = h2_nodes[current_h2].content.split(':')[1]

    ul_nodes[current_ul].search("li").each do |li|
      question = li.content
      raw_result = test(question)
      result = JSON.parse(raw_result)
      puts result
      result_intent_node = result['intent']
      puts result_intent_node
      result_intent = result_intent_node['name']
      result_match = result_intent.eql? intent_content
      result_confidence = result_intent_node['confidence']
      f << "#{intent_content}, #{question}, #{result_intent}, #{result_match}, #{result_confidence},\"#{result.to_json.gsub(/\n/, ';').gsub(/,/, ';')}\"\n"
    end

    current_h2 += 1
    current_ul += 1
  end

end

