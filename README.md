# README

This is a sample Rails 5 project demonstrating authentication with [auth0](https://auth0.com/). It requires an auth0
account (registration is free) and depends on a simple [API](https://github.com/npetkov/auth0_rails_api_example). Please 
consult the readme of that project for backend configuration. Below I'll assume that the API is served at 
`http://localhost:3001`.

I'm using AngularJs 1 as it fits the purpose of keeping things simple well. The angular app depends only on the 
[angular-jwt](https://github.com/auth0/angular-jwt) module to intercept API calls and insert the `Authorization` header.
 
The motivation behind this project is to provide a brief, concise introduction to JWT authentication using Rails. 
I've read through a lot of resources covering different aspects of the topic so I decided to put them together in one 
working example. The implementation is deliberately kept extremely sparse, as my goal isn't to present a state-of-the-art 
architecture but rather to illustrate a basic OAuth2 code grant flow.

## Installation

Clone the repo and run the usual `bundle install`. I'm using ruby 2.3.2p217 and can't guarantee that everything will 
work as expected with earlier ( `< 2.2`) versions.
  
To launch the server, use `rails s`.

## A word on Rails

As this is a very thin frontend with no models, database connection etc., there is actually no need to use a full-blown 
Rails application to serve the views and client-side logic. There is no reason why you shouldn't use a more suitable
stack, e.g. node.js + react or something similar, as well. In fact, there are a lot of npm modules by auth0 targeted
especially at node.js frontend deployments. Migrating the code from this project should be straightforward.
  
## OAuth configuration
  
The project uses `config/auth0_dev.yml` in development to read several auth0 configuration parameters: 
 
  * client id: used to uniquely identify the application you're authenticating 
  * client secret: used to sign auth0-issued JWT tokens
  * auth0 application domain 
  
  
All of these can be found under 'Clients -> _(your auth0 client name)_ -> Settings' at the auth0 dashboard. In a 
hypothetical production environment, these should of course be provided via environmental variable or some other secure 
means.

The application relies on the [omniauth](https://github.com/omniauth/omniauth) and 
[omniauth-auth0](https://github.com/auth0/omniauth-auth0) gems to implement the code grant flow. The only configuration
needed is in `config/initializers/auth0.rb`.

## Authentication flow

The following points give a high-level view of the authentication process.
  
  1. A user-agent hits the application root. 
  
     If an `auth_token` cookie is sent with the request, the application attempts to verify it. Upon success, the 
     application layout is rendered (step 5). Upon failure, a 401 response is returned 
     (no error messages implemented for now).
     
     If no cookie is sent, a redirect to the sign-in page occurs (step 2).
  2. The sign-in page renders the Lock widget with the configuration parameters supplied in `config/auth0_dev.yaml`.
     A login state parameter is passed to the widget and stored in the session as well.
  3. After the user credentials are verified, the widget will render a form and make a `POST` request to the
     configured callback (`http://localhost:3000/auth/callback`), with a one-time code and the state parameter passed
     in step 2 as parameters.
  4. After exchanging the code for a JWT, the server will verify the state parameter. In case of any failure, a 401
     response will be returned. If all goes well, the token is stored in an `http_only` cookie and the user is
     redirected to the application layout.
  5. The main application layout bootstraps the angular app. 
  6. The client (angular app) requests API configuration parameters from the front end via POST request. The response
     contains the API origin and a CSRF token signed with the auth0 secret.
  7. The client requests an access token from the API, providing both the auth0 JWT stored in step 4. as well as the
     CSRF token from step 6. Upon success, this new access token is sent as an `Authorization` header for all API calls.

## Testing

I haven't implemented any tests yet so please feel free to contribute.

## Contributing

Don't hesitate to create issues or feature requests. Any suggestions are welcome.

## External links

Below are some authentication/authorization resources I found quite useful.

  * [OAuth2 overview by Google](https://developers.google.com/identity/protocols/OAuth2)
  * [OAuth2 code grant](http://oauthlib.readthedocs.io/en/latest/oauth2/grants/authcode.html)
  * [JWT and APIs in the auth0 blog](https://auth0.com/blog/2014/12/02/using-json-web-tokens-as-api-keys/)
  * [JWT vulnerabilities in the auth0 blog](https://auth0.com/blog/critical-vulnerabilities-in-json-web-token-libraries/)
  * [The go-to JWT ruby library, with a nice claims overview/examples](https://github.com/jwt/ruby-jwt)
  * [The state parameter in OAuth2](http://www.twobotechnologies.com/blog/2014/02/importance-of-state-in-oauth2.html)
  * [The WWW-Authenticate Response Header Field](http://self-issued.info/docs/draft-ietf-oauth-v2-bearer.html#authn-header)
  * [CSRF Tokens](https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF)_Prevention_Cheat_Sheet#Synchronizer_.28CSRF.29_Tokens)
  * [Cookies and CORS](https://quickleft.com/blog/cookies-with-my-cors/)
  * [OPTIONS requests in Rails](https://bibwild.wordpress.com/2014/10/07/catching-http-options-request-in-a-rails-app/)
  * [Some useful CORS practices for Rails projects](https://gist.github.com/dhoelzgen/cd7126b8652229d32eb4)

## Disclaimer

I am not part of the auth0 team nor am I affiliated to auth0 in any way. I'm using auth0 for the sole purpose of
demonstrating a basic OAuth2 code grant flow.

## License

This product is licensed under the [MIT License](https://github.com/npetkov/auth0_rails_frontend_example/blob/dev/LICENSE).
