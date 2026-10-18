{
  inputs,
  self,
  ...
}: {
  flake.homeModules.voice-input = {
    lib,
    pkgs,
    config,
    ...
  }: let
    script = pkgs.writeShellScriptBin "voice-input" ''
      MODEL_DIR="$HOME/.local/share/whisper-cpp"
      MODEL="$MODEL_DIR/ggml-medium.bin"
      PIDFILE="/tmp/voice-input.pid"
      LANGFILE="/tmp/voice-input.lang"
      AUDIOFILE="/tmp/voice-input.wav"

      notify() {
        ${pkgs.libnotify}/bin/notify-send "Voice Input" "$1"
      }

      if [ ! -f "$MODEL" ]; then
        mkdir -p "$MODEL_DIR"
        notify "Downloading Whisper medium model (~1.5 GB)…"
        ${pkgs.curl}/bin/curl -L \
          "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-medium.bin" \
          -o "$MODEL"
        notify "Model downloaded."
      fi

      if [ -f "$PIDFILE" ]; then
        kill "$(cat "$PIDFILE")" 2>/dev/null
        rm -f "$PIDFILE"

        LANG_CODE=$(cat "$LANGFILE" 2>/dev/null || echo "auto")
        rm -f "$LANGFILE"

        notify "Transcribing…"

        ${pkgs.whisper-cpp}/bin/whisper-cli \
          -m "$MODEL" \
          -l "$LANG_CODE" \
          -nt \
          -otxt \
          -of "/tmp/voice-output" \
          -f "$AUDIOFILE" \
          > /dev/null 2>&1

        if [ -f "/tmp/voice-output.txt" ]; then
          TEXT=$(tr -d '\n' < "/tmp/voice-output.txt" \
            | sed 's/^[[:space:]]*//' \
            | sed 's/[[:space:]]*$//' \
            | sed 's/^「//; s/」$//')
          [ -n "$TEXT" ] && ${pkgs.wtype}/bin/wtype "$TEXT"
          rm -f "/tmp/voice-output.txt"
        fi
        rm -f "$AUDIOFILE"
      else
        LANG_CHOICE=$(printf 'Japanese\nEnglish\nGerman\nAuto-detect' \
          | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt "Voice input: ")

        case "$LANG_CHOICE" in
          Japanese)    LANG_CODE="ja" ;;
          English)     LANG_CODE="en" ;;
          German)      LANG_CODE="de" ;;
          Auto-detect) LANG_CODE="auto" ;;
          *)           exit 0 ;;
        esac

        echo "$LANG_CODE" > "$LANGFILE"
        notify "Recording ($LANG_CHOICE)… (press Mod+T again to stop)"

        ${pkgs.alsa-utils}/bin/arecord -f S16_LE -r 16000 -c 1 -q "$AUDIOFILE" &
        RECORD_PID=$!
        disown
        echo "$RECORD_PID" > "$PIDFILE"
      fi
    '';
  in {
    home.packages = [script];

    niri.extraBinds = ''
      Mod+T { spawn "${script}/bin/voice-input"; }
    '';
  };
}
