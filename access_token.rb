require 'oauth'

SITE_URI          = 'https://www.hatena.com'
REQUEST_TOKEN_URI = '/oauth/initiate?scope=read_public%2Cread_private%2Cwrite_public%2Cwrite_private'
ACCESS_TOKEN_URI  = '/oauth/token'

consumer_key = ""
consumer_secret = ""

consumer = OAuth::Consumer.new(consumer_key,
                               consumer_secret,
                               site: SITE_URI,
                               request_token_url: REQUEST_TOKEN_URI,
                               access_token_url: ACCESS_TOKEN_URI,
                               oauth_callback: 'oob')

request_token = consumer.get_request_token
puts "Visit this website and get the oauth verifier: #{request_token.authorize_url}"
print 'Enter the oauth verifier:'

consumer.options.delete(:oauth_callback)
oauth_verifier = STDIN.readline.chomp
access_token = request_token.get_access_token(oauth_verifier: oauth_verifier)
puts "Access token: #{access_token.token}"
puts "Access token secret: #{access_token.secret}"
