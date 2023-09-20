Passwordless.restrict_token_reuse = true # Can a token/link be used multiple times?
Passwordless.default_from_address = "user-research@gov.uk"
Passwordless.expires_at = lambda { 1.week.from_now } # How long until a token/magic link times out.
Passwordless.timeout_at = lambda { 30.minutes.from_now } # How long until a signed in session expires.
Passwordless.after_session_save = lambda do |session, request|
  user_email = User.find(session.authenticatable_id).email
  notify = NotifyService.new
  notify.send_email(session.token, user_email)
end