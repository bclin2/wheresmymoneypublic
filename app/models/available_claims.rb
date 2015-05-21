class AvailableClaims

  def self.find(personInfo)
    mmData = get_missing_money(personInfo)
    caData = get_california(personInfo)
    caData + mmData
  end

  private

  def self.get_missing_money(personInfo)
    options = {
      body: {
          SearchFirstName: personInfo[:first_name],
          SearchLastName: personInfo[:last_name],
          HomeState: "FL",
          frontpage: "1",
      },
    }
    responseData = HTTParty.post('http://www.missingmoney.com/Main/Search.cfm', options)
    format_missing_money(responseData)
  end

  def self.format_missing_money(responseData)
    page_data = Nokogiri::HTML(responseData.body)
    people_info = page_data.css('tr[id^="rColor"] td').map {|element| element.text}


    people_info.map do |string|  #removes escape sequences
      string.delete!("\n")
      string.delete!("\t")
      string.delete!("\r")
    end

    result_info = parse_missing_money_info(people_info)
  end


  def self.parse_missing_money_info(info)
    individual_info = info.each_slice(5).to_a
    organized_info = organize_info(individual_info)
    hash_info(organized_info)
  end

  def self.organize_info(individual_info)
    info_headers = ["name", "state", "address", "company", "money_owed"]
    organized_info = []
    individual_info.each {|info| organized_info << info_headers.zip(info)}
    return organized_info

  end

  def self.hash_info(organized_info)
    result_info = []
    organized_info.each {|info| result_info << Hash[info]}
    return result_info
  end

  def self.get_california(personInfo)
  # Get response cookies and session info
    get_response = HTTParty.get("https://ucpi.sco.ca.gov/UCP/Default.aspx")
    get_data = Nokogiri::HTML(get_response)
    event_validation = get_data.css('#__EVENTVALIDATION').attribute('value').value
    view_state = get_data.css('#__VIEWSTATE').attribute('value').value
    view_state_generator = get_data.css('#__VIEWSTATEGENERATOR').attribute('value').value

  # assign info to options
    options = {
      body: {# your resource
          "__EVENTTARGET" => "",
          "__EVENTARGUMENT" => "",
          "__VIEWSTATE" => view_state,
          "__VIEWSTATEGENERATOR" => view_state_generator,
          "__EVENTVALIDATION" => event_validation,
          "ctl00$ContentPlaceHolder1$txtLastName" => personInfo[:last_name],
          "ctl00$ContentPlaceHolder1$txtFirstName" => personInfo[:first_name],
          "ctl00$ContentPlaceHolder1$txtMiddleInitial" => "",
          "ctl00$ContentPlaceHolder1$txtIndividualCity" => "",
          "ctl00$ContentPlaceHolder1$btnSearch" => "Search",
      },
    }
    # post request
    response = HTTParty.post("https://ucpi.sco.ca.gov/UCP/Default.aspx", options)
    # To refactor, find a way to exclude everything past the results
    # (ie: the links to more results)
    filter_cali_data(response)
  end

  def self.filter_cali_data(response)
    # filters out unneeded elements from table (NEED A BETTER WAY)
    data = Nokogiri::HTML(response)
    data_rows = data.css('#ctl00_ContentPlaceHolder1_gvResults td')
    result = []
    break_flag = false
    data_rows.each do |column|
      # sometimes <td></td> is empty, so add " " to results so parsing doesn't break
      # an empty <td></td> causes the nokogiri element to have no children, so it messes
      # up the order
      if column.children.empty?
        result << " "
      end
      column.children.each do |child|
        if child.keys.include?('border')
          break_flag = true
          break
        end
        unless child.keys.include?('href') || child.keys.include?('src')
          result << column.text
          break
        end
      end
      break if break_flag
    end

    #strips unnecessary whitespace
    result.map! do |field|
      field.rstrip!
      field.gsub(/\s{2,}/, " ")
    end

    #organizes data into a parsed format (really bad code. Lots of dependencies)
    organized_result = result.each_slice(3).to_a
    organized_result.each do |set|
      street_address = set[1]
      city_state_zip = set[2]
      set[1] = street_address + " " + city_state_zip
      set.pop
    end

    headers = ["name", "address"]
    organized_result.map! do |person|
      hash = Hash[headers.zip(person)]
      hash["state"] = "CA"
      hash["company"] = "Available on CA Website"
      hash["money_owed"] = "Unknown"
      hash
    end
    return organized_result
  end

end


   # claimData = AvailableClaims.find(bob)
