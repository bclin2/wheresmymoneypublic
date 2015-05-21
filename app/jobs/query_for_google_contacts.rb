class QueryForGoogleContacts < ActiveJob::Base

  queue_as :QueryForGoogleContacts

  def perform(user_id, token)
    user = User.find(user_id)
    url = "https://www.google.com/m8/feeds/contacts/#{user.email}/full?alt=json&max-results=9999999"
    response = HTTParty.get(url, headers:{"Authorization" => "Bearer #{token}"})
    response["feed"]["entry"].each do |google_contact_info|
      begin
        email = google_contact_info["gd$email"][0]["address"]
        googlecontactid = google_contact_info["link"][1]["href"].split("/").pop
        contact = user.contacts.find_or_create_by({
          provider: "google",
          email: email,
          name: google_contact_info["title"]["$t"],
          googlecontactid: googlecontactid,
        })
        unless contact.have_google_photo
          url = "https://www.google.com/m8/feeds/photos/media/default/" +
            contact.googlecontactid +
            "?access_token=" +
            token
          response = HTTParty.get(url)
          if (response.code == 200)
            File.open(Rails.root.join('app', 'assets', 'images', 'googlecontacts', googlecontactid + '.jpg'), "wb") do |f|
              f.write response.parsed_response
            end
            contact.update_attributes(have_google_photo: true)
          end
        end
      rescue NoMethodError
        puts "no email found in google json blob"
      end
    end

    user.contacts.each do |friend|
      QueryForMoney.new(friend.id).enqueue unless friend.id.nil?
    end
  end


end
