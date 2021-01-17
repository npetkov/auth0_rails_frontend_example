import {default as App} from './app'
import './services/apiTokenFetcher'
import './controllers/indexController'

App.config(['$httpProvider', 'jwtInterceptorProvider',
  function($httpProvider, jwtInterceptorProvider) {
    function apiTokenGetter(ApiTokenFetcher, jwtHelper, options) {
      var requestUrl;

      try {
        requestUrl = new URL(options.url);
      } catch(e) {
        // The URL parsing will fail for relative paths, for which we don't want to send the
        // API token anyway (e.g. templates). API requests should always have absolute URLs.
        return null;
      }

      if (requestUrl.origin !== window.location.origin) {
        return ApiTokenFetcher.fetchToken().then(function(token) {
          var date = jwtHelper.getTokenExpirationDate(token),
            expTime = date.getTime();

          if (expTime - Date.now() <= 60000) {
            // Refresh token if expired or expiring in one minute
            return ApiTokenFetcher.fetchToken({ renew: true });
          } else {
            return token;
          }
        });
      } else {
        // Don't send token for non-API requests
        return null;
      }
    }

    apiTokenGetter.$inject = ['ApiTokenFetcher', 'jwtHelper', 'options'];
    jwtInterceptorProvider.tokenGetter = apiTokenGetter;
    $httpProvider.interceptors.push('jwtInterceptor');
  }
]);

App.run(['$http', 'ApiTokenFetcher',
  function($http, ApiTokenFetcher) {
    $http.defaults.headers.common.Accept = 'application/json';
    $http.defaults.xsrfHeaderName = 'X-CSRF-TOKEN';
    ApiTokenFetcher.fetchToken();
}]);
