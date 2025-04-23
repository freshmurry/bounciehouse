Rails.configuration.stripe = {
  #---- TEST ----
  # :publishable_key => 'pk_test_51HBlcnECjG0RNiV0zVi05XLlHNI1pVQPRuVC2osB16L8wGrHrilvHRTSlyhkKYusxmfu0sCt8Qsulkxmlx5wPrU500RPHbdFaM',
  # :secret_key => 'sk_test_51HBlcnECjG0RNiV071N2SuUyVAgNR1YTRBsAsvNq4GY6BUYHPZGkOutNyBA1HocobHhA3wssI56kFvBJCijunTsV00KqYnmC0i'
  
  #---- LIVE ----
  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'],
  :secret_key      => ENV['STRIPE_SECRET_KEY']
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]
