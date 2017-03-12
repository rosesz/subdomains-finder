angular.module('subdomainsApp.services').factory('Subdomain', ['railsResourceFactory', function (railsResourceFactory) {
  return railsResourceFactory({
    url: '/subdomains',
    name: 'subdomain'
  });
}]);