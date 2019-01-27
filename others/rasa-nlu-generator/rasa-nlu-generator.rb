require 'rubygems'
require 'open-uri'
require 'date'
require 'fileutils'
require 'pathname'
require 'json'
require 'pp'
require 'csv'
require 'yaml'

target_file = File.join __dir__, 'QA.csv'
pp target_file

rows = CSV.read target_file
# pp rows[0..3]
max_length = rows.length
pp max_length

output_folder = File.join(__dir__, "data", DateTime.now.to_s)

FileUtils.mkdir_p output_folder

target_nlu_data = File.join(output_folder, "nlu_data.md")
target_stories = File.join(output_folder, "stories.md")
target_domain = File.join(output_folder, "domain.yml")

pp output_folder

current_length = 1

results = []

while current_length < max_length
  intent = rows[current_length][1].gsub(/_*$/, '').gsub(/\//, '-')
  answer = rows[current_length][5]

  pp "intent: #{intent}, answer: #{answer}"
  results << {:intent => intent, :answer => answer}
  current_length += 1
end

pp results

open(target_nlu_data, 'w') do |f|
  results.each do |item|
    f << %Q(

## intent:#{item[:intent]}

    )
  end
end


open(target_stories, 'w') do |f|
  results.each do |item|
    f << %Q(
## story_#{item[:intent]}
* #{item[:intent]}
 - utter_#{item[:intent]}

    )
  end

end

open(target_stories, 'w') do |f|
  results.each do |item|
    f << %Q[
## story_#{item[:intent]}
* #{item[:intent]}
 - utter_#{item[:intent]}

    ]
  end
end


domain_yml_result = {}

domain_yml_result["intents".to_s] = []
domain_yml_result["actions".to_s] = []
domain_yml_result["templates"] = {}

results.each do |item|
  domain_yml_result["intents"] << item[:intent]
  domain_yml_result["actions"] << "utter_#{item[:intent]}"
  domain_yml_result["templates"]["utter_#{item[:intent]}"] = []
  domain_yml_result["templates"]["utter_#{item[:intent]}"] << {"text" => item[:answer].strip}
end

YAML.dump domain_yml_result, open(target_domain, 'w')
