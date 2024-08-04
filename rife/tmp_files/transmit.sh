#!/bin/bash
while true; do
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/1250.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/1250.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/1250.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/1460.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/1460.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/1460.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/15500.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/15500.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/15500.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/16000.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/16000.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/16000.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/18000.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/18000.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/18000.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/18650.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/18650.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/18650.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/21700.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/21700.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/21700.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/24890.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/24890.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/24890.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/27200.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/27200.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/27200.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/3800.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/3800.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/3800.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/4280.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/4280.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/4280.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/4400.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/4400.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/4400.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/4440.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/4440.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/4440.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/4500.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/4500.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/4500.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/4650.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/4650.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/4650.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/6600.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/6600.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/6600.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/7270.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/7270.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/7270.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/7760.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/7760.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/7760.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/7870.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/7870.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/7870.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/8020.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/8020.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/8020.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/8320.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/8320.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/8320.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/8800.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/8800.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/8800.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
echo 'Transmitting $(basename /home/Ri/rpitx/src/rife/tmp_files/950.wav .wav) using /home/Ri/rpitx/src/rife/tmp_files/950.wav at sample rate 48000' | tee -a /tmp/rife_transmission.log
screen -dmS rpitx_session bash -c "cat '/home/Ri/rpitx/src/rife/tmp_files/950.wav' | csdr convert_i16_f | csdr gain_ff 10 | csdr dsb_fc | sudo /home/Ri/rpitx/rpitx -i - -m IQFLOAT -f '3e6' -s 48000"
sleep 180.000000
sudo killall rpitx
sleep 1
done
