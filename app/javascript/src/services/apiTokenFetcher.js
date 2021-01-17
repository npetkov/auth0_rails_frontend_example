import {default as App} from '../app'

App.factory('ApiTokenFetcher', ['$http', '$q',
  function($http, $q) {
    var apiParams,
        apiToken;

    var deferred = $q.defer(),
        syncDeferred = deferred.promise;

    deferred.resolve();

    function getApiParams() {
      return $http({
        method: 'POST',
        url: '/api_params',
        skipAuthorization: true // Don't send Authorization header
      });
    }

    function getApiToken(origin, csrfToken) {
      return $http({
        method: 'POST',
        url: origin + '/auth/token',
        skipAuthorization: true,  // Don't send Authorization header
        withCredentials: true,    // Send auth cookie instead
        headers: {
          'X-API-CSRF-TOKEN': csrfToken
        }
      });
    }

    function saveApiParams() {
      return getApiParams().then(function(response) {
        var params = response.data.api_params;
        apiParams = params;
        return params;
      });
    }

    function saveApiToken(origin, csrfToken) {
      return getApiToken(origin, csrfToken).then(function(response) {
        var token = response.data.api_token;
        apiToken = token;
        return token;
      });
    }


    function fetch(options) {
      if (!apiParams) {
        return saveApiParams().then(function(params) {
          return saveApiToken(params.origin, params.csrf);
        });
      } else if (apiToken && !options.renew) {
        return $q.when(apiToken);
      } else {
        return saveApiToken(apiParams.origin, apiParams.csrf);
      }
    }

    return {
      fetchToken: function(options) {
        options = options || {};
        var deferred = $q.defer();

        syncDeferred = syncDeferred.then(function() {
          return fetch(options).then(function(token) {
            deferred.resolve(token);
          }, function(reason) {
            deferred.reject(reason);
          });
        });

        return deferred.promise;
      }
    };
  }
]);
