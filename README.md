bump
====
[![Build Status](https://travis-ci.org/timcolonel/bump.svg?branch=master)](https://travis-ci.org/timcolonel/bump)

Bump your application version using command line

##Planned features
* safe mode: Always ask for confirmation
* silent mode: no message saying the command automatically found the version file,...
* git commit: auto commit when bumping
* git tagging: when bumping version automatically create a release with the given version


##Commands:
Create the local config file
```bash
bumb init
```

Display the current version
```bash
bump current
```

Bump the version using the given action(major, minor, patch,...)
Look here for conventions
```bash
bump <action>
```






