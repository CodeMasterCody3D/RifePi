# RifePi

This project uses RPiTX to generate and transmit Rife frequencies. It includes scripts for installing the necessary software, generating and transmitting frequencies, and stopping transmissions.

## Installation

1. **Clone the Repository:**
   
```sh
git clone https://github.com/CodeMasterCody3D/RifePi.git
   cd RifePi
```

3. **Run the Installation Script:**

   The installation script will install the required dependencies, clone the RPiTX repository, and set up the necessary directories and files. Set permissions first with chmod.

```sh
chmod +x rifeinstall.sh

   ###Now you can run the script by typing.

    ./rifeinstall.sh
```
   

   This script will:
   - Install dependencies (sox, screen).
   - Remove any existing RPiTX directory.
   - Clone the RPiTX repository.
   - Copy and set up the required files in the appropriate directories.

## Usage

1. **Start the Transmission:**

   Use the start.sh script to start the transmission process.

```sh
./start.sh
```

2. **Stop the Transmission:**

   Use the stop.sh script to stop the transmission process and clear the temporary files.

```sh
./stop.sh
```

## Configuration

### Customizing Frequencies and Waveforms

You can customize the frequencies and waveforms by modifying the relevant scripts and JSON files.

- tran.sh: Main script for generating and transmitting frequencies.
- start.sh: Script to start the transmission process.
- stop.sh: Script to stop the transmission process.
- rifeinstall.sh: Installation script.

### File Locations

- Temporary Files: Stored in ~/rpitx/src/rife/tmp_files.
- Sweep Files: Stored in ~/rpitx/src/rife/tmp_sweeps.

## Troubleshooting

If you encounter any issues, ensure that you have run the installation script as root (sudo). Check the log file at /tmp/rife_transmission.log for error messages.

### Common Issues

- Permission Denied: Ensure you are running scripts with the necessary permissions.
- Dependencies Not Installed: Ensure all dependencies are installed by running the installation script.
- Incorrect Paths: Ensure all paths in the scripts are correct and use the $HOME environment variable to ensure compatibility with different user directories.

## Contributing

Feel free to fork this repository and submit pull requests. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License.
