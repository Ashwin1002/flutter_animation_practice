flutter pub run pigeon \
  --input pigeons/device_info.dart \
  --dart_out lib/messages.g.dart \
  --objc_header_out ios/Classes/messages.h \
  --objc_source_out ios/Classes/messages.m \
  --objc_prefix FLT \
  --java_out android/src/main/java/com/example/pigeon_plugin/Messages.java \
  --java_package "com.example.pigeon_plugin"