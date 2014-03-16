# Used to extract token from `devise` emails since they are no longer stored in
# the database.
module ExtractDeviseTokenFromEmail
  def extract_devise_token_from_email(email)
    match_data = /token=(.*)"/.match(email.body.encoded)
    match_data[1].chomp
  end
end
