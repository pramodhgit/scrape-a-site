require "nokogiri"
require "csv"
require "open-uri"
def parse_company(company)
 name = (company.at("h2") || company.at("h3")).text
 ph_no, fax, email, web = company.css("table tr").map{|row| row.css("td")[1]}.map(&:text)
 [name, ph_no, fax, email, web]
end

def parse_page(url)
 page = Nokogiri::HTML(open(url))
 page.css("#main-contents #center-contents .spot-list2 .listing-group").map{|grp| parse_company(grp)}
end

def parse_all
 (1..30).map do |num|
   puts "Page #{num}"
   parse_page("http://iscadirectory.isca.org.sg/index.php/listing/page/#{num}")
 end.flatten(1)
end

def save_companies
 data = parse_all
 csv_file = CSV.generate do |csv|
   csv << %w{name phone fax email web}
   data.each {|row|
     csv << row}
 end
 File.write("test.csv", csv_file)
end


save_companies