# Notarized
Tiny tool to reveal notarized applications

## What's Inside

Notarized is a small application that checks how many of your applications passed notarization by Apple Notary Service.

## How it works

KISS. Application traverses `/Applications` folder and ivokes `spctl -a -v <path>` on every app found.

## Screenshots

![Screenshot 2](https://github.com/MacPaw/Notarized/raw/master/assets/screenshot2.png)
![Screenshot 1](https://github.com/MacPaw/Notarized/raw/master/assets/screenshot1.png)

## License

[License](License.md)



