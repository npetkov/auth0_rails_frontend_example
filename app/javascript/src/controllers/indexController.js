import {default as App} from '../app'

App.controller('IndexController', ['ApiTokenFetcher',
  function(ApiTokenFetcher) {
    var indexController = this;

    ApiTokenFetcher.fetchToken().then(function(token) {
      indexController.apiToken = token;
    });
  }
]);
