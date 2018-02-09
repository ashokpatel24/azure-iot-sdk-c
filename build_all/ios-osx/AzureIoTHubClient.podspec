# Podspec files like this one are Ruby code

Pod::Spec.new do |s|
  s.name             = 'AzureIoTHubClient'
  s.version          = '0.0.1'
  s.summary          = 'Unfinished AzureIoTSDKs preview library for CocoaPods.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is an unfinished (and non-functional) preview CocoaPods 
release of the Azure C SDKs.
                       DESC

  s.homepage         = 'https://github.com/azure/azure-iot-sdk-c'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Microsoft' => '' }
  s.source           = { :git => 'https://github.com/Azure/azure-iot-sdk-c.git', :branch => 'ios-pod' }

  s.ios.deployment_target = '8.0'
  
  # This bash command is performed after the git repo is cloned. It puts
  # the SDK header files under a single root directory, which either
  # either CocoaPods or XCode demands. 
  s.prepare_command = <<-CMD
  git submodule update --init deps/parson
    mkdir -p inc
    cp deps/parson/parson.h inc
    cp iothub_client/inc/*.h inc
  CMD

  s.source_files = 
    'inc/*.h',
    'deps/parson/parson.c', 
    'iothub_client/src/*.c' 
  
  # The header_mappings_dir is a location where the header files directory structure
  # is preserved.  If not provided the headers files are flattened.
  s.header_mappings_dir = 'inc/'

  s.public_header_files = 'inc/*.h'
  
  s.xcconfig = {
    'USE_HEADERMAP' => 'NO',
    'HEADER_SEARCH_PATHS' => '"${SRCROOT}/AzureIoTHubClient/inc/" "${SRCROOT}/AzureIoTUtility/inc/" "${SRCROOT}/AzureIoTuMqtt/inc/" "${SRCROOT}/AzureIoTuAmqp/inc/"',
    'ALWAYS_SEARCH_USER_PATHS' => 'NO'
  }
  
  s.dependency 'AzureIoTUtility', '0.0.0.1-pre-release' 
  s.dependency 'AzureIoTuAmqp', '0.0.0.1-pre-release' 
  s.dependency 'AzureIoTuMqtt', '0.0.0.1-pre-release' 

end
