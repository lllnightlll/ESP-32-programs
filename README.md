# ESP-32-programs

Один и тот же `src/main.cpp` собирается тремя способами:

- Windows и Linux — обычная программа на C++17 через CMake.
- ESP32-S3 — прошивка на ESP-IDF через PlatformIO.

Плата в `platformio.ini`: `esp32-s3-devkitc-1`, flash 2 МБ. Если чип другой, поменяй `board` и `board_build.flash_size` до первой прошивки.

## Что поставить на новый компьютер

Нужны Python 3, PlatformIO и компилятор C++. Тулчейн ESP-IDF PlatformIO скачает сам при первой сборке. Это долго и нужен интернет.

### Windows

1. [Python 3](https://www.python.org/downloads/). При установке включи **Add python.exe to PATH**. Проверка: `py -3 --version`.
2. Компилятор, CMake и gdb:

```powershell
winget install -e --id BrechtSanders.WinLibs.POSIX.UCRT --accept-package-agreements --accept-source-agreements
```

Закрой и снова открой терминал, затем проверь `g++ --version` и `cmake --version`.

3. PlatformIO:

```powershell
py -3 -m pip install --user platformio
py -3 -m platformio --version
```

Драйвер для этой платы обычно не нужен: ESP32-S3 выходит в Windows как USB-порт `COM*`. Если порт не появляется, поставь драйвер моста, который стоит на плате (CP210x или CH340).

### Linux

```bash
sudo apt update
sudo apt install -y build-essential cmake gdb python3 python3-pip python3-venv
python3 -m pip install --user platformio
sudo usermod -aG dialout "$USER"
```

После `usermod` выйди из системы и зайди снова, иначе порт `/dev/ttyACM0` будет недоступен. Проверка: `g++ --version`, `python3 -m platformio --version`.

### Редактор

Открой эту папку в Cursor или VS Code и поставь рекомендуемые расширения:

- C/C++ (`ms-vscode.cpptools`) — запуск и отладка.
- clangd (`llvm-vs-code-extensions.vscode-clangd`).
- PlatformIO IDE (`platformio.platformio-ide`).

В конфигурации **Windows** в `.vscode/launch.json` прописан путь к `gdb.exe` этого компьютера. На новой машине замени `miDebuggerPath` на свой `gdb`, если команда `gdb` не находится сама.

## Записать код на ESP32

Подключи плату USB-кабелем с линиями данных. Затем из корня проекта.

Windows:

```powershell
py -3 -m platformio device list
py -3 -m platformio run -e esp32s3 -t upload
```

Linux:

```bash
python3 -m platformio device list
python3 -m platformio run -e esp32s3 -t upload
```

`device list` показывает порт. Прошивка сама выбирает его. Первая команда `run` ещё и скачивает ESP-IDF, компилятор под чип и собирает проект.

В Cursor то же самое делает конфигурация запуска **ESP32**: она собирает, записывает прошивку и сразу открывает монитор порта.

Если запись обрывается на `Connecting...` или в мониторе висит `waiting for download`:

1. Закрой монитор порта, если он открыт.
2. Зажми **BOOT**.
3. Коротко нажми **RST** и отпусти **BOOT**.
4. Сразу повтори `upload`.

После удачной записи плата сама стартует. В логе раз в секунду есть строка `I (...) app: platform: esp32`.

## Смотреть, что пишет плата

Монитор только читает порт и ничего не прошивает. Скорость 115200.

Windows:

```powershell
py -3 -m platformio device monitor -e esp32s3
```

Linux:

```bash
python3 -m platformio device monitor -e esp32s3
```

Выход: **Ctrl+C**. Если экран пустой, нажми **RST** и не держи **BOOT**.

Предупреждение `firmware.elf does not exist` значит, что локальная папка сборки удалена. Порт при этом всё равно открывается. Чтобы предупреждение пропало, собери проект ещё раз.

## Команды

На Linux везде меняй `py -3` на `python3`. Команды запускаются из корня проекта.

| Действие | Команда |
|---|---|
| Список портов | `py -3 -m platformio device list` |
| Собрать прошивку | `py -3 -m platformio run -e esp32s3` |
| Записать на плату | `py -3 -m platformio run -e esp32s3 -t upload` |
| Собрать, записать и открыть монитор | `py -3 -m platformio run -e esp32s3 -t upload -t monitor` |
| Только монитор порта | `py -3 -m platformio device monitor -e esp32s3` |
| Стереть сборку ESP32 | `py -3 -m platformio run -e esp32s3 -t clean` |
| Собрать программу Windows | `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build-windows.ps1` |
| Запустить программу Windows | `.\build\windows\esp32-programs.exe` |
| Собрать программу Linux | `bash ./scripts/build-linux.sh` |
| Запустить программу Linux | `./build/linux/esp32-programs` |

Ожидаемый вывод настольной программы: `platform: windows` или `platform: linux`.

В Cursor задачи те же: **build: windows**, **build: linux**, **build: esp32**, **build: all**. Запуск через Run and Debug: **Windows**, **Linux**, **ESP32**.
