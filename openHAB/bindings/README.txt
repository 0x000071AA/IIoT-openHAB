https://www.openhab.org/docs/developer/

|- src/main
|---- feature
|-------- feature.xml   Your OSGI feature file
|---- java             Your Java code
|-------- org/openhab/[...]
|- src/main/resources/ESH-INF
|---- binding
|-------- binding.xml      Binding name, description, author and other meta data
|---- config              Configuration description files when not in things files
|-------- *.xml
|---- i18n                Your localized binding texts
|-------- *_<local>.properties
|---- thing               One or more xml files with thing descriptions
|-------- *.xml
|- src/test
|---- java             It's easy to write unit tests and fellow developers will thank you
|-------- org/openhab/[...]
|---- resources        Any resource files used in your unit tests, like test data
|-------- [...]
|- NOTICE                 License information
|                         3rd party content has to be given in the NOTICE file
|- pom.xml                Build system file: Describe your dependencies here
|- README.md              The file describing your binding