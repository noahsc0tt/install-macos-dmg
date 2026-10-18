# Install MacOS DMG

Install .dmg application images from the command line

## Installation

This is just a bash script, so:

1. Clone this repository
    ```sh
    git clone https://github.com/noahsc0tt/install-macos-dmg
    cd install-macos-dmg
    ```

2. Make the script executable

    ```sh
    chmod +x dmg.sh
    ```

3. Put it somewhere on your path
    ```sh
    cp dmg.sh /usr/local/bin/dmg
    ```
    The filename should be the command you would like to invoke the tool with

## Usage

Run the name of the executable with the path to the DMG

  ```sh
  dmg ~/Downloads/MyApp.dmg
  ```
