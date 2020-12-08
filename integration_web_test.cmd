@echo off
taskkill /IM chromedriver.exe
start "Chrome Driver For Flutter Web Testing" chromedriver.exe --port=4444 &
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/main_test.dart -d web --release --web-renderer=canvaskit --no-headless --browser-name=chrome --chrome-binary="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
