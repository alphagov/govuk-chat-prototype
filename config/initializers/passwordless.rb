Passwordless.restrict_token_reuse = true # Can a token/link be used multiple times?
Passwordless.expires_at = lambda { 2.days.from_now } # How long until a token/magic link times out.
Passwordless.timeout_at = lambda { 2.days.from_now } # How long until a signed in session expires.
