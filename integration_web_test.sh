killall chromedriver
chromedriver --port=4444 &
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/main_test.dart \
  -d web --release --web-renderer=canvaskit --no-headless \
  --browser-name=chrome --chrome-binary=/usr/bin/chromium

