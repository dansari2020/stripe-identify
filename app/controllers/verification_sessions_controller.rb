class VerificationSessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def create
    verification_session = Stripe::Identity::VerificationSession.create(
      {
        type: 'document',
        metadata: {
          property_uid: 'secr',
        },
        options: {
          document: {
            allowed_types: %w[driving_license passport id_card],
            require_live_capture: true,
            require_matching_selfie: true
          }
        },
      })

    render json: { client_secret: verification_session.client_secret }
  end

  def webhook
    event = nil

    # Verify webhook signature and extract the event
    # See https://stripe.com/docs/webhooks/signatures for more information.
    begin
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      payload = request.body.read
      return head :ok if payload.empty?

      Event.create(body: payload)

      event = Stripe::Webhook.construct_event(payload, sig_header, Stripe.api_key)
      puts event.inspect

      my_logger = Logger.new("#{Rails.root}/log/stripe.log")
      my_logger.info(event.inspect)
    rescue JSON::ParserError => e
      # Invalid payload
      puts e.inspect
      my_logger = Logger.new("#{Rails.root}/log/stripe.log")
      my_logger.error(e.inspect)
      return head :bad_request
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      puts e.inspect
      my_logger = Logger.new("#{Rails.root}/log/stripe.log")
      my_logger.error(e.inspect)
      return head :bad_request
    end

    head :ok
  end

  def show
    @data = Stripe::Identity::VerificationSession.retrieve(
      id: params[:id],
      expand: [
        'verified_outputs',
        'verified_outputs.dob',
        'verified_outputs.id_number',
        'id_number.dob',
        'id_number.id_number',
        'last_verification_report',
      ])
  end

  def verification_report
    @data = Stripe::Identity::VerificationReport.retrieve(
      id: params[:id],
      expand: [
        'id_number.dob',
        'id_number.id_number',
      ])
  end

  def search
    redirect_to retrieve_verification_path(params[:verification_session_id])
  end
end
