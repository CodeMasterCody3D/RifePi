#!/bin/bash

# Define variables
DEFAULT_OUTPUT_FREQ=3.1e6
HOME_DIR="$HOME"
IMPORT_DIR="$HOME_DIR/rpitx/src/rife/sweeps"
TMP_DIR="$HOME_DIR/rpitx/src/rife/tmp_files"
TMP_SWEEP_DIR="$HOME_DIR/rpitx/src/rife/tmp_sweeps"
AUDIO_AMPLITUDE=0.5
GAIN_AMPLITUDE=8.0
DEFAULT_DURATION=180
CUSTOM_SWEEP_DURATION=300
JSON_FILE="$HOME_DIR/rpitx/src/rife/bdata_clean.json"
RPITX_PATH="$HOME_DIR/rpitx"
LOG_FILE="/tmp/rife_transmission.log"

choose_output_frequency() {
    OUTPUT_FREQ=$(whiptail --inputbox "Enter output Frequency (in MHz). Default is 3.1 MHz" 8 78 $DEFAULT_OUTPUT_FREQ --title "Change Carrier Frequency" 3>&1 1>&2 2>&3)
    OUTPUT_FREQ="${OUTPUT_FREQ}e6" # Append e6 to the input
    OUTPUT_FREQ=${OUTPUT_FREQ:-"${DEFAULT_OUTPUT_FREQ}e6"}
}

choose_audio_amplitude() {
    AUDIO_AMPLITUDE=$(whiptail --inputbox "Enter audio amplitude for WAV file generation (0.0 - 1.0). Default is 0.5" 8 78 $AUDIO_AMPLITUDE --title "Change Audio Amplitude" 3>&1 1>&2 2>&3)
    AUDIO_AMPLITUDE=${AUDIO_AMPLITUDE:-0.5}
}

choose_gain_amplitude() {
    GAIN_AMPLITUDE=$(whiptail --inputbox "Enter gain amplitude for transmission. Default is 8.0" 8 78 $GAIN_AMPLITUDE --title "Change Gain Amplitude" 3>&1 1>&2 2>&3)
    GAIN_AMPLITUDE=${GAIN_AMPLITUDE:-8.0}
}

choose_waveform() {
    waveform=$(whiptail --title "Choose Waveform" --menu "Select a waveform:" 15 60 4 \
        "sine" "Sine wave" \
        "square" "Square wave" \
        "sawtooth" "Sawtooth wave" \
        "harmonic" "Harmonic wave" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        exit 1
    fi
    echo $waveform
}

prompt_sweep_duration() {
    start_freq="$1"
    end_freq="$2"
    CUSTOM_SWEEP_DURATION=$(whiptail --inputbox "Enter duration for sweep from ${start_freq} Hz to ${end_freq} Hz (seconds). Warning: Long durations combined with high frequencies may cause the process to fail." 8 78 $CUSTOM_SWEEP_DURATION --title "Sweep Duration" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        exit 1
    fi
}

generate_wav_files() {
    condition="$1"
    waveform="$2"
    audio_amplitude="$3"
    custom_sweep_duration="$4"
    default_duration=$DEFAULT_DURATION
    python3 << EOF
import os
import numpy as np
import wave
import json

def generate_wave(freq, sample_rate, duration, amplitude, waveform):
    t = np.linspace(0, duration, int(sample_rate * duration), endpoint=False)
    if waveform == "sine":
        wave_data = amplitude * np.sin(2 * np.pi * freq * t)
    elif waveform == "square":
        wave_data = amplitude * np.sign(np.sin(2 * np.pi * freq * t))
    elif waveform == "sawtooth":
        wave_data = amplitude * (2 * (t * freq - np.floor(t * freq + 0.5)))
    elif waveform == "harmonic":
        wave_data = np.zeros_like(t)
        for n in range(1, 11):
            wave_data += amplitude * np.sin(2 * np.pi * freq * n * t)
    return (wave_data * 32767).astype(np.int16)

def determine_sample_rate(freq):
    return 48000 if freq <= 24000 else min(2 * freq, 250000)

def create_wav_files_for_condition(condition, data, tmp_dir, tmp_sweep_dir, amplitude, default_duration, custom_sweep_duration, waveform):
    if not os.path.exists(tmp_dir):
        os.makedirs(tmp_dir)
    if not os.path.exists(tmp_sweep_dir):
        os.makedirs(tmp_sweep_dir)
    
    generated_files = []
    for freq_entry in condition['frequencies']:
        freq_entries = str(freq_entry).split(', ')
        for freq in freq_entries:
            if '=' in freq:
                if '-' in freq:
                    start_freq, rest = freq.split('-')
                    end_freq, _ = rest.split('=')
                    start_freq = float(start_freq)
                    end_freq = float(end_freq)
                    duration = float(custom_sweep_duration)
                    
                    print(f"Using duration: {duration} for sweep {start_freq}-{end_freq}")  # Debug statement

                    sample_rate = determine_sample_rate(max(start_freq, end_freq))
                    wav_file_name = f"sweep_{int(start_freq)}-{int(end_freq)}_{int(duration)}.wav"
                    wav_file_path = os.path.join(tmp_sweep_dir, wav_file_name)

                    if not os.path.exists(wav_file_path):
                        t = np.linspace(0, duration, int(sample_rate * duration), endpoint=False)
                        sweep_wave = np.zeros_like(t)
                        k = (end_freq - start_freq) / duration
                        for i in range(len(t)):
                            sweep_wave[i] = amplitude * np.sin(2 * np.pi * (start_freq * t[i] + (k / 2) * t[i] ** 2))
                        with wave.open(wav_file_path, 'w') as wav_file:
                            wav_file.setnchannels(1)
                            wav_file.setsampwidth(2)
                            wav_file.setframerate(sample_rate)
                            wav_file.writeframes((sweep_wave * 32767).astype(np.int16).tobytes())
                        print(f"Generated WAV file for sweep {start_freq} Hz to {end_freq} Hz over {duration} seconds at {wav_file_path}")
                    else:
                        print(f"WAV file for sweep {start_freq} Hz to {end_freq} Hz already exists at {wav_file_path}")
                    generated_files.append(wav_file_path)
                else:
                    freq, duration = freq.split('=')
                    freq = float(freq)
                    duration = float(duration)

                    sample_rate = determine_sample_rate(freq)
                    wav_file_name = f"{int(freq)}_{int(duration)}.wav"
                    wav_file_path = os.path.join(tmp_dir, wav_file_name)

                    if not os.path.exists(wav_file_path):
                        wave_data = generate_wave(freq, sample_rate, duration, amplitude, waveform)
                        with wave.open(wav_file_path, 'w') as wav_file:
                            wav_file.setnchannels(1)
                            wav_file.setsampwidth(2)
                            wav_file.setframerate(sample_rate)
                            wav_file.writeframes(wave_data.tobytes())
                        print(f"Generated WAV file for {freq} Hz with duration {duration} seconds at {wav_file_path}")
                    else:
                        print(f"WAV file for {freq} Hz with duration {duration} seconds already exists at $wav_file_path")
                    generated_files.append(wav_file_path)
            else:
                freq = float(freq)
                sample_rate = determine_sample_rate(freq)

                wav_file_name = f"{int(freq)}_{int(default_duration)}.wav"
                wav_file_path = os.path.join(tmp_dir, wav_file_name)

                if not os.path.exists(wav_file_path):
                    wave_data = generate_wave(freq, sample_rate, default_duration, amplitude, waveform)
                    with wave.open(wav_file_path, 'w') as wav_file:
                        wav_file.setnchannels(1)
                        wav_file.setsampwidth(2)
                        wav_file.setframerate(sample_rate)
                        wav_file.writeframes(wave_data.tobytes())
                    print(f"Generated WAV file for {freq} Hz with default duration {default_duration} seconds at ${wav_file_path}")
                else:
                    print(f"WAV file for {freq} Hz with default duration ${default_duration} seconds already exists at ${wav_file_path}")
                generated_files.append(wav_file_path)
    return generated_files

with open("$JSON_FILE", 'r') as f:
    data = json.load(f)

condition = next((cond for cond in data['conditions'] if cond['name'] == "$condition"), None)

if condition:
    print(f"Generating WAV files for condition: {condition['name']}")
    generated_files = create_wav_files_for_condition(condition, data, "$TMP_DIR", "$TMP_SWEEP_DIR", $AUDIO_AMPLITUDE, $DEFAULT_DURATION, $CUSTOM_SWEEP_DURATION, "$waveform")
    with open("$TMP_DIR/generated_files.txt", 'w') as f:
        for file in generated_files:
            f.write(file + "\n")
else:
    print(f"Condition '$condition' not found.")
EOF
}

confirm_transmission() {
    condition_choice="$1"
    waveform="$2"
    frequencies=$(jq -r --arg condition "$condition_choice" '.conditions[] | select(.name == $condition) | .frequencies[]' "$JSON_FILE")
    
    # Prompt for sweep durations before confirmation
    for freq_entry in $(jq -r --arg condition "$condition_choice" '.conditions[] | select(.name == $condition) | .frequencies[]' "$JSON_FILE"); do
        if [[ "$freq_entry" == *"="* ]] && [[ "$freq_entry" == *"-"* ]]; then
            start_freq=$(echo $freq_entry | cut -d'-' -f1)
            end_freq=$(echo $freq_entry | cut -d'-' -f2 | cut -d'=' -f1)
            prompt_sweep_duration $start_freq $end_freq
        fi
    done

    # Display the selected frequencies and durations for confirmation
    frequencies_with_durations=""
    IFS=$'\n'
    for freq_entry in $(jq -r --arg condition "$condition_choice" '.conditions[] | select(.name == $condition) | .frequencies[]' "$JSON_FILE"); do
        if [[ "$freq_entry" == *"="* ]] && [[ "$freq_entry" == *"-"* ]]; then
            start_freq=$(echo $freq_entry | cut -d'-' -f1)
            end_freq=$(echo $freq_entry | cut -d'-' -f2 | cut -d'=' -f1)
            frequencies_with_durations+="Sweep: $start_freq-$end_freq = $CUSTOM_SWEEP_DURATION seconds\n"
        else
            frequencies_with_durations+="$freq_entry\n"
        fi
    done

    if (whiptail --title "Confirm Transmission" --yesno "Condition: $condition_choice\nFrequencies:\n$frequencies_with_durations\nWaveform: $waveform\n\nDo you want to generate WAV files and transmit these frequencies?" 20 78); then
        generate_wav_files "$condition_choice" "$waveform" "$AUDIO_AMPLITUDE" "$CUSTOM_SWEEP_DURATION"
        transmit_files
    else
        view_all_conditions
    fi
}

view_all_conditions() {
    conditions=$(jq -r '.conditions[] | .name' "$JSON_FILE")
    menu_items=()
    while IFS= read -r condition; do
        menu_items+=("$condition" "")
    done <<< "$conditions"

    condition_choice=$(whiptail --title "RPiTX - All Conditions" --menu "Choose a condition to view:" 20 78 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        rife_menu
        return
    fi

    waveform=$(choose_waveform)
    confirm_transmission "$condition_choice" "$waveform"
}

database_menu() {
    databases=$(jq -r '.conditions[] | .database' "$JSON_FILE" | sort -u)
    menu_items=()
    while IFS= read -r db; do
        menu_items+=("$db" "")
    done <<< "$databases"

    database_choice=$(whiptail --title "RPiTX - Databases" --menu "Choose a database:" 20 78 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        rife_menu
        return
    fi

    conditions=$(jq -r --arg db "$database_choice" '.conditions[] | select(.database == $db) | .name' "$JSON_FILE")
    menu_items=()
    while IFS= read -r condition; do
        menu_items+=("$condition" "")
    done <<< "$conditions"

    condition_choice=$(whiptail --title "RPiTX - Conditions in $database_choice" --menu "Choose a condition to transmit:" 20 78 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        database_menu
        return
    fi

    waveform=$(choose_waveform)
    confirm_transmission "$condition_choice" "$waveform"
}

rife_menu() {
    menu_items=("Database's" "" "View All Database's" "" "Search Database's" "")
    menuchoice=$(whiptail --title "RPiTX - Rife Frequencies" --menu "Choose an option:" 20 78 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        main_menu
        return
    fi

    case $menuchoice in
        "Database's")
            database_menu
            ;;
        "View All Database's")
            view_all_conditions
            ;;
        "Search Database's")
            search_database
            ;;
    esac
}

search_database() {
    search_term=$(whiptail --inputbox "Enter search term:" 8 78 --title "Search Database" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        rife_menu
        return
    fi

    results=$(jq -r --arg search "$search_term" '.conditions[] | select(.name | ascii_downcase | contains($search | ascii_downcase)) | .name' "$JSON_FILE")
    if [ -z "$results" ]; then
        whiptail --msgbox "No results found for '$search_term'." 8 78
        search_database
        return
    fi

    menu_items=()
    while IFS= read -r result; do
        menu_items+=("$result" "")
    done <<< "$results"

    condition_choice=$(whiptail --title "RPiTX - Search Results" --menu "Choose a condition:" 20 78 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        search_database
        return
    fi

    waveform=$(choose_waveform)
    confirm_transmission "$condition_choice" "$waveform"
}

list_imported_wav_files() {
    wav_files=()
    while IFS= read -r wav_file; do
        wav_files+=("$(basename "$wav_file")" "")
    done < <(find "$IMPORT_DIR" -name '*.wav')

    wav_choice=$(whiptail --title "RPiTX - Imported WAV Files" --menu "Choose a WAV file to transmit:" 20 78 10 "${wav_files[@]}" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        main_menu
        return
    fi

    echo "$IMPORT_DIR/$wav_choice" > "$TMP_DIR/generated_files.txt"
    transmit_files
}

stop_transmissions() {
    sudo pkill -f rpitx
    sudo pkill -f tran.sh
    rm -rf "$TMP_DIR/*"
    echo "Stopped all transmissions and cleared the temporary files."
}

generate_custom_wav() {
    freq="$1"
    duration="$2"
    waveform="$3"

    python3 << EOF
import numpy as np
import wave

def determine_sample_rate(freq):
    return 48000 if freq <= 24000 else min(2 * freq, 250000)

freq = $freq
duration = $duration
sample_rate = determine_sample_rate(freq)
amplitude = $AUDIO_AMPLITUDE
waveform = "$waveform"

t = np.linspace(0, duration, int(sample_rate * duration), endpoint=False)
if waveform == "sine":
    wave_data = amplitude * np.sin(2 * np.pi * freq * t)
elif waveform == "square":
    wave_data = amplitude * np.sign(np.sin(2 * np.pi * freq * t))
elif waveform == "sawtooth":
    wave_data = amplitude * (2 * (t * freq - np.floor(t * freq + 0.5)))
elif waveform == "harmonic":
    wave_data = np.zeros_like(t)
    for n in range(1, 11):
        wave_data += amplitude * np.sin(2 * np.pi * freq * n * t)

wave_data = (wave_data * 32767).astype(np.int16)

with wave.open("$TMP_DIR/custom.wav", 'w') as wav_file:
    wav_file.setnchannels(1)
    wav_file.setsampwidth(2)
    wav_file.setframerate(sample_rate)
    wav_file.writeframes(wave_data.tobytes())
EOF
    echo "$TMP_DIR/custom.wav" > "$TMP_DIR/generated_files.txt"
    transmit_files1
}

custom_menu() {
    menu_items=("Single Frequency" "" "Sweep" "")
    menuchoice=$(whiptail --title "RPiTX - Custom Transmission" --menu "Choose a transmission type:" 20 78 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        main_menu
        return
    fi

    case $menuchoice in
        "Single Frequency")
            custom_single
            ;;
        "Sweep")
            custom_sweep
            ;;
    esac
}

custom_single() {
    freq=$(whiptail --inputbox "Enter frequency (Hz):" 8 78 --title "Custom Single Frequency" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        custom_menu
        return
    fi

    duration=$(whiptail --inputbox "Enter duration (seconds):" 8 78 --title "Custom Single Frequency" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        custom_menu
        return
    fi

    waveform=$(choose_waveform)
    generate_custom_wav "$freq" "$duration" "$waveform"
    transmit_files1
}

custom_sweep() {
    start_freq=$(whiptail --inputbox "Enter start frequency (Hz):" 8 78 --title "Custom Sweep" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        custom_menu
        return
    fi

    end_freq=$(whiptail --inputbox "Enter end frequency (Hz):" 8 78 --title "Custom Sweep" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        custom_menu
        return
    fi

    duration=$(whiptail --inputbox "Enter sweep duration (seconds):" 8 78 --title "Custom Sweep" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        custom_menu
        return
    fi

    waveform=$(choose_waveform)
    python3 << EOF
import numpy as np
import wave

start_freq = $start_freq
end_freq = $end_freq
duration = $duration
sample_rate = max(int(max($start_freq, $end_freq) * 2), 44100)  # Ensure sample rate is at least 44100
if sample_rate > 500000:
    sample_rate = 500000
amplitude = $AUDIO_AMPLITUDE

t = np.linspace(0, duration, int(sample_rate * duration), endpoint=False)
k = (end_freq - start_freq) / duration
sweep_wave = amplitude * np.sin(2 * np.pi * (start_freq * t + (k / 2) * t ** 2))

sweep_wave = (sweep_wave * 32767).astype(np.int16)

with wave.open("$TMP_SWEEP_DIR/custom_sweep.wav", 'w') as wav_file:
    wav_file.setnchannels(1)
    wav_file.setsampwidth(2)
    wav_file.setframerate(sample_rate)
    wav_file.writeframes(sweep_wave.tobytes())
EOF

    echo "$TMP_SWEEP_DIR/custom_sweep.wav" > "$TMP_DIR/generated_files.txt"
    transmit_files1
}

transmit_files() {
    TRANSMIT_SCRIPT="$TMP_DIR/transmit.sh"
    echo "#!/bin/bash" > $TRANSMIT_SCRIPT
    echo "while true; do" >> $TRANSMIT_SCRIPT

    while IFS= read -r wav_path; do
        sample_rate=$(soxi -r "$wav_path")
        duration=$(soxi -D "$wav_path")

        echo "echo 'Transmitting \$(basename $wav_path .wav) using $wav_path at sample rate $sample_rate' | tee -a $LOG_FILE" >> $TRANSMIT_SCRIPT
        echo "screen -dmS rpitx_session bash -c \"cat '$wav_path' | csdr convert_i16_f | csdr gain_ff $GAIN_AMPLITUDE | csdr dsb_fc | sudo $RPITX_PATH/rpitx -i - -m IQFLOAT -f '$OUTPUT_FREQ' -s $sample_rate\"" >> $TRANSMIT_SCRIPT
        echo "sleep $duration" >> $TRANSMIT_SCRIPT
        echo "sudo killall rpitx" >> $TRANSMIT_SCRIPT
        echo "sleep 1" >> $TRANSMIT_SCRIPT
    done < "$TMP_DIR/generated_files.txt"

    echo "done" >> $TRANSMIT_SCRIPT
    chmod +x $TRANSMIT_SCRIPT

    screen -dmS rpitx_session bash -c "$TRANSMIT_SCRIPT"
}

transmit_files1() {
    TRANSMIT_SCRIPT="$TMP_DIR/transmit.sh"
    echo "#!/bin/bash" > $TRANSMIT_SCRIPT
    echo "while true; do" >> $TRANSMIT_SCRIPT

    while IFS= read -r wav_path; do
        sample_rate=$(soxi -r "$wav_path")
        duration=$(soxi -D "$wav_path")

        echo "echo 'Transmitting \$(basename $wav_path .wav) using $wav_path at sample rate $sample_rate' | tee -a $LOG_FILE" >> $TRANSMIT_SCRIPT
        echo "screen -dmS rpitx_session bash -c \"cat '$wav_path' | csdr convert_i16_f | csdr gain_ff $GAIN_AMPLITUDE | csdr dsb_fc | sudo $RPITX_PATH/rpitx -i - -m IQFLOAT -f '$OUTPUT_FREQ' -s $sample_rate\"" >> $TRANSMIT_SCRIPT
        echo "sleep $duration" >> $TRANSMIT_SCRIPT
        echo "sudo killall rpitx" >> $TRANSMIT_SCRIPT
        echo "sleep 1" >> $TRANSMIT_SCRIPT
    done < "$TMP_DIR/generated_files.txt"

    echo "done" >> $TRANSMIT_SCRIPT
    chmod +x $TRANSMIT_SCRIPT

    screen -dmS rpitx_session bash -c "$TRANSMIT_SCRIPT"
}

main_menu() {
    menu_items=("View All Database's" "" "Database's" "" "Custom" "" "Stop Transmission" "" "Imported WAV files" "")
    menuchoice=$(whiptail --title "RPiTX - Main Menu" --menu "Choose a category:" 20 78 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        exit 0
    fi

    case $menuchoice in
        "View All Database's")
            view_all_conditions
            ;;
        "Database's")
            rife_menu
            ;;
        "Stop Transmission")
            stop_transmissions
            ;;
        "Custom")
            custom_menu
            ;;
        "Imported WAV files")
            list_imported_wav_files
            ;;
    esac
}

# Main script execution
choose_output_frequency
choose_audio_amplitude
choose_gain_amplitude
main_menu
