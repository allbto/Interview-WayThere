/**
 * Created by allan on 5/2/15.
 */


(function(ng) {
    'use strict';

    var app = ng.module("wayThereApp", ['ui.bootstrap', 'youtube-embed']);

    app.controller('WayThereController', function($scope) {

        //$scope.ytPlayer = {};
        $scope.ytPlayerVars = {
            controls: 0,
            autoplay: 1,
            disablekb : 1,
            showinfo : 0,
            hd : 1
        };

        $scope.currentYtId = '2G8LAiHSCAs';

        $scope.$on('youtube.player.ready', function ($event, player) {
            player.mute();
        });

        $scope.$on('youtube.player.ended', function ($event, player) {
            // play it again when stoped
            player.playVideo();
        });
    });

})(angular);
