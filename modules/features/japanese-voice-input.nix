{
  inputs,
  self,
  ...
}: {
  flake.homeModules.japanese-voice-input = {
    lib,
    pkgs,
    config,
    ...
  }: let
    script = pkgs.writeShellScriptBin "jp-voice-input" ''
      MODEL_DIR="$HOME/.local/share/whisper-cpp"
      MODEL="$MODEL_DIR/ggml-medium.bin"
      PIDFILE="/tmp/jp-voice-input.pid"
      AUDIOFILE="/tmp/jp-voice-input.wav"

      notify() {
        ${pkgs.libnotify}/bin/notify-send "Japanese Voice" "$1"
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
        notify "Transcribing…"

        ${pkgs.whisper-cpp}/bin/whisper-cpp \
          -m "$MODEL" \
          -l ja \
          -nt \
          -otxt \
          -of "/tmp/jp-voice-output" \
          -f "$AUDIOFILE" \
          > /dev/null 2>&1

        if [ -f "/tmp/jp-voice-output.txt" ]; then
          TEXT=$(tr -d '\n' < "/tmp/jp-voice-output.txt" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
          [ -n "$TEXT" ] && ${pkgs.wtype}/bin/wtype "$TEXT"
          rm -f "/tmp/jp-voice-output.txt"
        fi
        rm -f "$AUDIOFILE"
      else
        notify "Recording… (trigger again to stop)"
        ${pkgs.alsa-utils}/bin/arecord -f S16_LE -r 16000 -c 1 -q "$AUDIOFILE" &
        RECORD_PID=$!
        disown
        echo "$RECORD_PID" > "$PIDFILE"
      fi
    '';
  in {
    home.packages = [script];

    niri.extraBinds = ''
      Mod+Y { spawn "${script}/bin/jp-voice-input"; }
    '';
  };
}
