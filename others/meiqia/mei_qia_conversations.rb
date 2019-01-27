require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'fileutils'
require 'pathname'
require 'json'
require 'pp'


def handle_all(f, target_folder)

  pp "#{target_folder}"
  # target_folder = File.join(__dir__, 'history', folder)
  file_length = Dir.entries(target_folder).length - 2
  puts "file_length: #{file_length}"

  current_file_index = 0
  while current_file_index < file_length
    target_file = File.join(target_folder, "result-" + current_file_index.to_s + ".json")
    puts "target_file: #{target_file}"

    result = File.read target_file
    json_result = JSON.parse result

    result_list = json_result["result"]
    handle_result f, result_list

    current_file_index = current_file_index + 1
  end

end

def handle_result(f, result_list)
  result_list.each do |conv|
    time_start = conv["conv_start_tm"]
    time_end = conv["conv_end_tm"]

    visitor_tags = conv["visitor_tags"].join(";")
    client = conv["client_id"]
    conv_id = conv["conv_id"]
    conv_agent_msg_count = conv["conv_agent_msg_count"]
    conv_visitor_msg_count = conv["conv_visitor_msg_count"]
    output = "#{conv_id}, #{time_start}, #{time_end}, #{visitor_tags},-,-,-, #{conv_agent_msg_count}, #{conv_visitor_msg_count}"
    # start to handle conv level
    conv_content = conv["conv_content"]
    #pp "conv_content: #{conv_content}"
    f << output
    f << "\n"
    max_client_count = 3
    current_client_count = 1
    conv_content.each do |content_item|
      type = content_item["type"]
      client = '-'
      agent = '-'
      from = content_item["from"].strip
      if from.eql? 'client'
        if current_client_count > max_client_count
          break
        end
        current_client_count += 1
        client = "#{content_item["content"].gsub("\n", ';')}"
      else
        agent = "#{content_item["content"].gsub("\n", ';')}"
      end
      output_content = "-,#{content_item['timestamp']},-,#{visitor_tags},#{client},#{agent},#{type},-,-"
      f << output_content
      f << "\n"
    end
  end
  # end to handle conv level
end


folder_list = ["201810", "201811", "201812", "201901"]

folder_list.each do |folder|
  target_folder = File.join(__dir__, "history", folder)
  output_folder = File.join(__dir__, "output", folder)
  FileUtils.mkdir_p output_folder

  output_file = File.join(output_folder, "#{DateTime.now.strftime('%Y%m%d%H%M%S')}.csv")

  open output_file, 'a' do |f|
    f << "对话 ID, 开始时间, 结束时间, 标签, 客户, 客服, 类型, 客户回复总数, 客户回复总数\n"
    handle_all f, target_folder
  end

end


