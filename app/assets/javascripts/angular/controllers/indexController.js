angular.module('auth0-rails-frontend-example')
  .controller('IndexController', ['ApiTokenFetcher',
    function(ApiTokenFetcher) {
      var indexController = this;

      ApiTokenFetcher.fetchToken().then(function(token) {
        indexController.apiToken = token;
      });
    }
  ]);
