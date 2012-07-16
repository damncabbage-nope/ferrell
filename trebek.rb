require 'rubygems'
require 'data_mapper'
require 'sinatra'

enable :sessions

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

class Response
    include DataMapper::Resource
    property :id, Serial
    property :age, String
    property :gender, String
    property :postcode, String
    property :times, String
    property :education, Text
    property :media, Text
    property :attractions, Text
    property :overall, String
    property :tickets, String
    property :lineride, String
    property :guests, String
    property :facilities, String
    property :hosts, String
    property :staff, String
    property :value, String
    property :enjoyable_thing, Text
    property :enjoyable_details, Text
    property :unenjoyable_thing, Text
    property :unenjoyable_details, Text
    property :future, Text
    property :comments, Text
    property :email, Text
    property :session, Text
    property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

DataMapper.auto_upgrade!

get '/' do
	erb :index
end

get '/sent' do
	erb :sent
end

post '/sent' do
	# This is not the best way to do it since there's a small risk of the same token being generated for two different users
	unless session[:surveyed]
		session[:surveyed] = rand(36**16).to_s(36)
	end

	response = Response.new

	response.age = params[:survey_age]
	response.gender = params[:survey_gender]
	response.postcode = params[:survey_postcode]
	response.times = params[:survey_times]
	response.overall = params[:survey_overall]
	response.tickets = params[:survey_tickets]
	response.lineride = params[:survey_lineride]
	response.guests = params[:survey_guests]
	response.facilities = params[:survey_facilities]
	response.hosts = params[:survey_hosts]
	response.staff = params[:survey_staff]
	response.value = params[:survey_value]
	response.enjoyable_thing = params[:survey_enjoyable_thing]
	response.enjoyable_details =  params[:survey_enjoyable_details]
	response.unenjoyable_thing = params[:survey_unenjoyable_thing]
	response.unenjoyable_details = params[:survey_unenjoyable_details]
	response.future = params[:survey_future]
	response.comments = params[:survey_comments]
	response.email = params[:survey_newsletter]
	response.session = session[:surveyed]

	response.education = params[:survey_education].join(', ') if params[:survey_education]
	response.media = params[:survey_media].join(', ') if params[:survey_media]
	response.attractions = params[:survey_attractions].join(', ') if params[:survey_attractions]
	
	response.save

	erb :sent
end