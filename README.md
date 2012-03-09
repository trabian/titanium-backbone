## titanium-backbone

Titanium-backbone is a framework for building native iOS and Android
apps using Titanium and Backbone.

### Current status

This project is in very early stages of extraction from a production
[mobile banking
application](http://itunes.apple.com/us/app/sf-fire-credit-union-mobile/id492113880?mt=8),
but the ideas and patterns extracted have worked very well within this
large app. We're taking the time to refactor as we extract so it should
be even cleaner.

### Installation

#### Clone the project to your development machine:

```console
$ git clone git@github.com:trabian/titanium-backbone.git
$ cd titanium-backbone
```

#### Install package dependencies

```console
$ npm install
```

#### Run the app generator to create a new mobile app

```console
$ ./bin/titanium-backbone new [app name]
# Run ./bin/titanium-backbone new --help for instructions
```

_Optional:_ Install and run the app generator globally by running:

```console
$ npm install -g
$ titanium-backbone new --help
```
