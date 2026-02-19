{{flutter_js}}
{{flutter_build_config}}

var _status = document.getElementById('loading-status');
var _progress = document.getElementById('loading-progress');

function _setProgress(pct, msg) {
  if (_status) _status.textContent = msg;
  if (_progress) _progress.style.width = pct + '%';
}

_setProgress(20, 'Téléchargement...');

_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}}
  },
  onEntrypointLoaded: async function(engineInitializer) {
    _setProgress(50, 'Initialisation du moteur...');
    var appRunner = await engineInitializer.initializeEngine();
    _setProgress(80, 'Démarrage...');
    await appRunner.runApp();
    _setProgress(100, '');
    var el = document.getElementById('loading');
    if (el) {
      el.style.opacity = '0';
      setTimeout(function() { el.remove(); }, 300);
    }
  }
});
