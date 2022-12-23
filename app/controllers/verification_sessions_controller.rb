class VerificationSessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    verification_session = Stripe::Identity::VerificationSession.create(
      {
        type: 'document',
        metadata: {
          user_id: '{{USER_ID}}',
        },
      })

    render json: { client_secret: verification_session.client_secret }
  end
end
