#include <cstdio>

#if defined(ESP_PLATFORM)

#include "esp_log.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

static const char *TAG = "app";

extern "C" void app_main(void) {
  while (true) {
    ESP_LOGI(TAG, "platform: esp32");
    vTaskDelay(pdMS_TO_TICKS(1000));
  }
}

#else

int main() {
#if defined(_WIN32)
  const char *platform = "windows";
#elif defined(__linux__)
  const char *platform = "linux";
#else
  const char *platform = "unknown";
#endif
  std::printf("platform: %s\n", platform);
  return 0;
}

#endif
