# UPM

## Universal Package Manager

UPM is a Linux package manager that can be used to install, remove, and update packages despite any linux distribution. It is written in Shell script and is designed to be simple and easy to use.

### Installation

To install UPM, open the project with a terminal and run the following command:

```bash
sudo -s
chmod +x setup.sh
./setup.sh
```

### Usage

To see the installable packages, run the following command:

```bash
upm list
```

To install a package, run the following command:

```bash
upm install <package-name>
```

To remove a package, run the following command:

```bash
upm uninstall <package-name>
```

To see the help message, run the following command:

```bash
upm --help
```
