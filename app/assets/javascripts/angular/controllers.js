app.controller('subdomainsCtrl', ['$scope', 'Subdomain', function ($scope, Subdomain) {
  $scope.subdomains = [];

  $scope.fetchSubdomains = function(domain) {
    $scope.searching = true;
    
    var resolved = function(data) {
      $scope.subdomains = data;
      $scope.error = "";
      if(data.length == 0) {
        $scope.notice = "Nothing found";
      } else {
        $scope.notice = "";
      }
    };

    var rejected = function(response) {
      $scope.error = "Error during fetching subdomains: " + response.data.error;
    };

    var always = function() {
      $scope.searching = false;
    };

    Subdomain.query({domain: domain}).then(resolved, rejected).finally(always);
  };
}]);