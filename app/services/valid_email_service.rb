class ValidEmailService

  def initialize(params)
    @first_name = params[:first_name].downcase.delete(' ')
    @last_name = params[:last_name].downcase.delete(' ')
    @url = params[:url].downcase
  end

  def call
    emails = [{email: "#{@first_name}.#{@last_name}@#{@url}"},
              {email: "#{@first_name}@#{@url}"},
              {email: "#{@first_name}#{@last_name}@#{@url}"},
              {email: "#{@last_name}.#{@first_name}@#{@url}"},
              {email: "#{@first_name[0]}.#{@last_name}@#{@url}"},
              {email: "#{@first_name[0]}#{@last_name[0]}@#{@url}"},
    ]

    emails.each do |email|
      response = Excon.get("https://apilayer.net/api/check?access_key=53fd49aaaf762be8b2be2a7dda1c4dc7&email=#{email[:email]}",
                            :headers => { "Content-Type" => "application/JSON" })
      data = JSON.parse(response.body)

      if (data["format_valid"] == true && data["mx_found"] == true && data["smtp_check"] == true )
        return email[:email]
      end
    end

    return nil
  end
end