document.addEventListener('DOMContentLoaded', function () {
    let CurrentTimer = 0;
    let RespawnButtonTimer = 0;
    var timerId;
    let isDead = false;
    let hasRespawned = false;
    let hasDispatched = false;
    let hasSynced = false;

    window.addEventListener('message', function(event) {
        let item = event.data;
        if (item.type === "show") {
            if (item.status == true) {
                isDead = true;
                CurrentTimer = 0;
                $('#main').fadeIn();
            } else {
                CurrentTimer = 0;
                RespawnButtonTimer = 0;
                $('#time').text('00:00');
                isDead = false;
                hasRespawned = false;
                hasDispatched = false;
                hasSynced = false;
                $("#main").fadeOut();
                setTimeout(function() {
                    $('.respawn-border').fadeIn();
                    $('.dispatch-border').fadeIn();
                    $('.sync-border').fadeIn();
                }, 500);
            }
        } else if (item.type == 'setUPValues') {
            clearTimeout(timerId);
            timerId = setInterval(timer, 1000);
            CurrentTimer = item.timer;
            RespawnButtonTimer = item.respawntimer;
            $('#main-title').text(item.dead);
            $('#main-disc').text(item.deaddisc);
            $('#button-text-respawn').text(item.respawn);
            $('#button-text-dispatch').text(item.dispatch);
            $('#button-text-sync').text(item.sync);
            $('#button-letter-respawn').text(item.respawnkey);
            $('#button-letter-dispatch').text(item.dispatchkey);
            $('#button-letter-sync').text(item.synckey);
        }
    });

    function timer() {
        if (isDead) {
            if (CurrentTimer < 0) {
                $("#main").fadeOut();
                $.post(`https://${GetParentResourceName()}/time_expired`);
                clearTimeout(timerId);
                CurrentTimer = 0;
                isDead = false;
            } else {
                $('#time').text(new Date(CurrentTimer * 1000).toISOString().substr(14, 5));
                $('.respawn-border').fadeOut();
                if (CurrentTimer <= RespawnButtonTimer) {
                    $('.respawn-border').fadeIn();
                }
                CurrentTimer = CurrentTimer - 1;
            }
        }
    }

    $(function() {
        $('#main').hide();

        function bindKeyListeners() {
            const respawnKey = $('#button-letter-respawn').text();
            const dispatchKey = $('#button-letter-dispatch').text();
            const syncKey = $('#button-letter-sync').text();

            const keyFunctionMap = {};
            keyFunctionMap[respawnKey.toUpperCase()] = function() {

                if (CurrentTimer <= RespawnButtonTimer) {
                    if (!hasRespawned) {
                        $.post(`https://${GetParentResourceName()}/accept_to_die`);
                        hasRespawned = true;
                        hiderespawn();
                    }
                }
            };
            keyFunctionMap[dispatchKey.toUpperCase()] = function() {
                if (!hasDispatched) {
                    $.post(`https://${GetParentResourceName()}/call_emergency`);
                    $('#button-text-dispatch').addClass("disabled");
                    hasDispatched = true;
                    hidedispatch();
                }
            };
            keyFunctionMap[syncKey.toUpperCase()] = function() {
                if (!hasSynced) {
                    $.post(`https://${GetParentResourceName()}/sync`);
                    hasSynced = true;
                    hidesync();
                }
            };

            $(document).on('keydown', function(event) {
                const pressedKey = event.key.toUpperCase();
                if (keyFunctionMap[pressedKey]) {
                    keyFunctionMap[pressedKey]();
                }
            });
        }

        function hiderespawn() {
            $('.respawn-border').fadeOut();
        }

        function hidedispatch() {
            $('.dispatch-border').fadeOut();
        }

        function hidesync() {
            $('.sync-border').fadeOut();
        }

        bindKeyListeners();
    });
});
