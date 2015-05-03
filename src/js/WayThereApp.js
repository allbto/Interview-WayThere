/**
 * Created by allan on 5/2/15.
 */


(function(ng) {
    'use strict';

    var app = ng.module("wayThereApp", ["wayThere-dataStore", 'ui.bootstrap', 'youtube-embed']);

    app.directive('onCarouselChange', function ($parse) {
        return {
            require: 'carousel',
            link: function (scope, element, attrs, carouselCtrl) {
                var fn = $parse(attrs.onCarouselChange);
                var origSelect = carouselCtrl.select;
                carouselCtrl.select = function (nextSlide, direction) {
                    if (nextSlide !== this.currentSlide) {
                        fn(scope, {
                            nextSlide: nextSlide,
                            direction: direction,
                            index: nextSlide.$parent.$index
                        });
                    }
                    return origSelect.apply(this, arguments);
                };
            }
        };
    });

    app.controller('WayThereController', function($scope, WayThereDataStore) {

        //
        //  Vars
        //

        /// WayThere

        $scope.weathers = WayThereDataStore.retrieveWeathers(function(weathers) {
            $scope.weathers = weathers;
            $scope.onSlideChanged(0);
        });

        /// Youtube player

        //$scope.ytPlayer = {};
        $scope.ytPlayerVars = {
            controls: 0,
            autoplay: 1,
            disablekb : 1,
            showinfo : 0,
            vq : 'hd720',
            iv_load_policy : 3
        };

        $scope.currentYtId = '2G8LAiHSCAs';

        $scope.mute = true;

        //
        //  Scope functions
        //

        /// Carousel

        $scope.$watch('currentYtId', function(newVal) {
            if ($scope.ytPlayer)
                $scope.ytPlayer.loadVideoById(newVal, 50 * 5, "hd720");
        });

        $scope.setMute =  function(newVal) {
            $scope.mute = newVal;
            if ($scope.ytPlayer)
                newVal ? $scope.ytPlayer.mute() : $scope.ytPlayer.unMute();
        };

        $scope.isPlaying = function() {
            if ($scope.ytPlayer)
                return $scope.ytPlayer.getPlayerState() != 2;
            return false;
        };

        function _randomTo(number)
        {
            return Math.floor((Math.random() * 100) + 1) % number;
        }

        $scope.onSlideChanged = function(index) {
            if (index < $scope.weathers.length && $scope.weathers[index].video_ids && $scope.weathers[index].video_ids.length > 0)
            {
                var ids = $scope.weathers[index].video_ids;
                $scope.currentYtId = ids[_randomTo(ids.length)];
            }
        };

        /// Youtube player

        $scope.$on('youtube.player.ready', function ($event, player) {
            player.mute();
            player.setPlaybackQuality('hd720');
            $scope.ytPlayer = player;
        });

        $scope.$on('youtube.player.ended', function ($event, player) {
            // play it again when it stops
            player.playVideo();
        });
    });

})(angular);
