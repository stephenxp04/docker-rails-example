class UrlsController < ApplicationController
  before_action :find_or_create_user
  before_action :set_url, only: [:destroy]

  def index
    @url = Url.new
    @urls = current_user.urls.includes(:short_urls)
  end

  def show
    short_url = ShortUrl.find_by(short_url: params[:id])

    if short_url
      Click.create(
        short_url: short_url,
        clicked_at: Time.current,
        geolocation: request.remote_ip,
      )

      url = short_url.url

      # Debug log to check the actual value of target_url
      Rails.logger.info("Redirecting to: #{url.target_url}")

      # Ensure the URL is properly formatted
      begin
        uri = URI.parse(url.target_url)
        if uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
          redirect_to url.target_url, allow_other_host: true
        else
          Rails.logger.error("Invalid URL: #{url.target_url}")
          render plain: "Invalid URL", status: :unprocessable_entity
        end
      rescue URI::InvalidURIError => e
        Rails.logger.error("URI::InvalidURIError: #{e.message}")
        render plain: "Invalid URL", status: :unprocessable_entity
      end
    else
      render plain: "Not Found", status: :not_found
    end
  end

  def create
    @input = url_params[:target_url]

    # Ensure the URL has a proper scheme
    unless @input =~ /\Ahttp:\/\/|https:\/\/\z/
      @input = "https://" + @input
    end

    @url = current_user.urls.find_or_initialize_by(target_url: @input)

    # Proceed with saving the URL
    if @url.new_record?
      if @url.save
        @url.update(title: fetch_title_from_url(@url.target_url))
      end
    end

    # Create a new short URL for the URL
    @short_url = @url.short_urls.create(short_url: SecureRandom.alphanumeric(15))

    # Refresh the list of URLs
    @urls = current_user.urls.includes(:short_urls)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path, notice: "URL was successfully shortened." }
    end
  end

  def destroy
    @url = current_user.urls.find(params[:id])

    # Delete associated Click records
    @url.short_urls.each do |short_url|
      short_url.clicks.destroy_all
    end

    # Delete associated ShortUrl records
    @url.short_urls.destroy_all

    # Delete the Url record
    @url.destroy

    # Refresh the list of URLs
    @urls = current_user.urls.includes(:short_urls)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path, notice: "URL was successfully deleted." }
    end
  end

  private

  def find_or_create_user
    if cookies[:user_token].blank?
      user = User.create(cookie: SecureRandom.hex(10))
      cookies[:user_token] = { value: user.cookie, expires: 1.year.from_now }
    else
      user = User.find_by(cookie: cookies[:user_token])
      user ||= User.create(cookie: SecureRandom.hex(10))
    end
    @current_user = user
  end

  def current_user
    @current_user
  end

  def set_url
    @url = current_user.urls.find(params[:id])
  end

  def url_params
    params.require(:url).permit(:target_url)
  end

  def fetch_title_from_url(url)
    return if url.blank?

    require "net/http"
    require "uri"
    require "nokogiri"

    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      document = Nokogiri::HTML(response.body)
      document.title
    else
      "No title found"
    end
  rescue StandardError => e
    Rails.logger.error("Failed to fetch title: #{e.message}")
    "No title found"
  end
end
