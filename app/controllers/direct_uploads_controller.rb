# frozen_string_literal: true

# ref: https://github.com/rails/rails/issues/32208#issuecomment-611007718
class DirectUploadsController < ActiveStorage::DirectUploadsController

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, only: :create


  def create
    blob = create_blob

    if blob.persisted?
      render json: direct_upload_json(blob), status: :created
    else
      render json: { error: 'Failed to create Blob' }, status: :unprocessable_entity
    end
  end

  private

  def create_blob
    ActiveStorage::Blob.create_before_direct_upload! blob_args
  end

  def blob_args
    params.require(:blob).permit(
      :filename,
      :byte_size,
      :checksum,
      :content_type,
      :metadata
    ).to_h.symbolize_keys
  end

  def direct_upload_json(blob)
    {
      headers:           blob.service_headers_for_direct_upload,
      direct_upload_url: blob.service_url_for_direct_upload,
      signed_id:         blob.signed_id
    }
  end

end
