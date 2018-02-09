#!/bin/bash

set -e

# Set up build defaults
SIMULATOR=On
CONFIGURATION=Debug

usage ()
{
    echo "build_azure_iot.sh [options]"
    echo "options"
    echo " simulator | device            Specify build target (default simulator)"
	echo " release | debug               Specify build type (default debug)"
    exit 1
}

for arg in $*
do
	case "$(echo $arg | tr '[A-Z]' '[a-z]')" in
		"simulator" ) 	SIMULATOR=On;;
		"device" ) 		SIMULATOR=Off;;
		"release" )		CONFIGURATION=Release;;
		"debug" )		CONFIGURATION=Debug;;
		* )				usage;;
	esac
done

pushd ..
cd azureiotiosbuild
pwd

BUILDROOT="`pwd`"

cd azure-iot-sdk-c
rm -rf cmake
mkdir cmake
cd cmake

cmake -Dsimulator_build:bool=$SIMULATOR -DCMAKE_TOOLCHAIN_FILE=../c-utility/build_all/ios/iOS.cmake .. -GXcode

xcodebuild -configuration $CONFIGURATION

cd "${BUILDROOT}"

if [ ! -d "./azureout" ]
then
	mkdir azureout
fi

if [ "$SIMULATOR" == "On" ]
then
	dirname="Simulator_$CONFIGURATION"
	libsuffix="-iphonesimulator"
else
	dirname="Device_$CONFIGURATION"
	libsuffix="-iphoneos"
fi

rm -rf "./azureout/${dirname}"
mkdir "./azureout/${dirname}"
rm -rf "./azureout/include"
mkdir "./azureout/include"
mkdir "./azureout/include/azure_c_shared_utility"
mkdir "./azureout/include/azureiot"
mkdir "./azureout/include/azure_uamqp_c"
mkdir "./azureout/include/azure_umqtt_c"
mkdir "./azureout/include/iothub_service_client"

echo "dirname=${dirname}"

cp ./azure-iot-sdk-c/cmake/c-utility/${CONFIGURATION}${libsuffix}/libaziotsharedutil.a \
   ./azure-iot-sdk-c/cmake/iothub_client/${CONFIGURATION}${libsuffix}/libiothub_client.a \
   ./azure-iot-sdk-c/cmake/iothub_client/${CONFIGURATION}${libsuffix}/libiothub_client_amqp_transport.a \
   ./azure-iot-sdk-c/cmake/iothub_client/${CONFIGURATION}${libsuffix}/libiothub_client_amqp_ws_transport.a \
   ./azure-iot-sdk-c/cmake/iothub_client/${CONFIGURATION}${libsuffix}/libiothub_client_http_transport.a \
   ./azure-iot-sdk-c/cmake/iothub_client/${CONFIGURATION}${libsuffix}/libiothub_client_mqtt_transport.a \
   ./azure-iot-sdk-c/cmake/iothub_client/${CONFIGURATION}${libsuffix}/libiothub_client_mqtt_ws_transport.a \
   ./azure-iot-sdk-c/cmake/iothub_service_client/${CONFIGURATION}${libsuffix}/libiothub_service_client.a \
   ./azure-iot-sdk-c/cmake/serializer/${CONFIGURATION}${libsuffix}/libserializer.a \
   ./azure-iot-sdk-c/cmake/uamqp/${CONFIGURATION}${libsuffix}/libuamqp.a \
   ./azure-iot-sdk-c/cmake/umqtt/${CONFIGURATION}${libsuffix}/libumqtt.a \
   "./azureout/${dirname}/"

cp ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/agenttime.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/base64.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/buffer_.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/condition.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/connection_string_parser.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/consolelogger.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/constbuffer.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/constmap.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/crt_abstractions.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/doublylinkedlist.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/gballoc.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/gb_rand.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/gb_stdio.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/gb_time.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/hmac.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/hmacsha256.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/httpapiex.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/httpapiexsas.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/httpapi.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/httpheaders.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/http_proxy_io.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/lock.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/macro_utils.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/map.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/optimize_size.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/optionhandler.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/platform.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/refcount.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/sastoken.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/sha.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/sha-private.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/shared_util_options.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/singlylinkedlist.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/socketio.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/stdint_ce6.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/strings.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/strings_types.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/string_tokenizer.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/string_tokenizer_types.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/threadapi.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/tickcounter.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/tlsio.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/tlsio_openssl.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/umock_c_prod.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/uniqueid.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/urlencode.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/utf8_checker.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/uws_client.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/uws_frame_encoder.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/vector.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/vector_types.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/vector_types_internal.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/wsio.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/x509_openssl.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/xio.h \
   ./azure-iot-sdk-c/c-utility/inc/azure_c_shared_utility/xlogging.h \
   "./azureout/include/azure_c_shared_utility/"

cp \
	./azure-iot-sdk-c/serializer/inc/agenttypesystem.h \
	./azure-iot-sdk-c/serializer/inc/codefirst.h \
	./azure-iot-sdk-c/serializer/inc/commanddecoder.h \
	./azure-iot-sdk-c/serializer/inc/datamarshaller.h \
	./azure-iot-sdk-c/serializer/inc/datapublisher.h \
	./azure-iot-sdk-c/serializer/inc/dataserializer.h \
	./azure-iot-sdk-c/serializer/inc/iotdevice.h \
	./azure-iot-sdk-c/serializer/inc/jsondecoder.h \
	./azure-iot-sdk-c/serializer/inc/jsonencoder.h \
	./azure-iot-sdk-c/serializer/inc/methodreturn.h \
	./azure-iot-sdk-c/serializer/inc/multitree.h \
	./azure-iot-sdk-c/serializer/inc/schema.h \
	./azure-iot-sdk-c/serializer/inc/schemalib.h \
	./azure-iot-sdk-c/serializer/inc/schemaserializer.h \
	./azure-iot-sdk-c/serializer/inc/serializer_devicetwin.h \
	./azure-iot-sdk-c/serializer/inc/serializer.h \
	"./azureout/include/azureiot"

cp \
	./azure-iot-sdk-c/iothub_client/inc/blob.h \
	./azure-iot-sdk-c/iothub_client/inc/iothub_client_authorization.h \
	./azure-iot-sdk-c/iothub_client/inc/iothub_client.h \
	./azure-iot-sdk-c/iothub_client/inc/iothub_client_ll.h \
	./azure-iot-sdk-c/iothub_client/inc/iothub_client_ll_uploadtoblob.h \
	./azure-iot-sdk-c/iothub_client/inc/iothub_client_options.h \
	./azure-iot-sdk-c/iothub_client/inc/iothub_client_private.h \
	./azure-iot-sdk-c/iothub_client/inc/iothub_client_retry_control.h \
	./azure-iot-sdk-c/iothub_client/inc/iothub_client_version.h \
	./azure-iot-sdk-c/iothub_client/inc/iothub_message.h \
	./azure-iot-sdk-c/iothub_client/inc/iothubtransport_amqp_cbs_auth.h \
	./azure-iot-sdk-c/iothub_client/inc/iothubtransport_amqp_common.h \
	./azure-iot-sdk-c/iothub_client/inc/iothubtransport_amqp_connection.h \
	./azure-iot-sdk-c/iothub_client/inc/iothubtransport_amqp_device.h \
	./azure-iot-sdk-c/iothub_client/inc/iothubtransportamqp.h \
	./azure-iot-sdk-c/iothub_client/inc/iothubtransport_amqp_telemetry_messenger.h \
	./azure-iot-sdk-c/iothub_client/inc/iothubtransportamqp_websockets.h \
	./azure-iot-sdk-c/iothub_client/inc/iothubtransport.h \
	./azure-iot-sdk-c/iothub_client/inc/iothubtransporthttp.h \
	./azure-iot-sdk-c/iothub_client/inc/iothub_transport_ll.h \
	./azure-iot-sdk-c/iothub_client/inc/iothubtransport_mqtt_common.h \
	./azure-iot-sdk-c/iothub_client/inc/iothubtransportmqtt.h \
	./azure-iot-sdk-c/iothub_client/inc/iothubtransportmqtt_websockets.h \
	./azure-iot-sdk-c/iothub_client/inc/uamqp_messaging.h \
	./azure-iot-sdk-c/deps/parson/parson.h \
	"./azureout/include/azureiot"

cp \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/amqp_definitions.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/amqp_frame_codec.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/amqp_management.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/amqp_types.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/amqpvalue.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/amqpvalue_to_string.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/cbs.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/connection.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/frame_codec.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/header_detect_io.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/link.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/message.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/message_receiver.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/message_sender.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/messaging.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/sasl_anonymous.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/saslclientio.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/sasl_frame_codec.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/sasl_mechanism.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/sasl_mssbcbs.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/sasl_plain.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/sasl_server_io.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/sasl_server_mechanism.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/server_protocol_io.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/session.h \
	./azure-iot-sdk-c/uamqp/inc/azure_uamqp_c/socket_listener.h \
	"./azureout/include/azure_uamqp_c/"

cp \
	./azure-iot-sdk-c/umqtt/inc/azure_umqtt_c/mqtt_client.h \
	./azure-iot-sdk-c/umqtt/inc/azure_umqtt_c/mqtt_codec.h \
	./azure-iot-sdk-c/umqtt/inc/azure_umqtt_c/mqttconst.h \
	./azure-iot-sdk-c/umqtt/inc/azure_umqtt_c/mqtt_message.h \
	"./azureout/include/azure_umqtt_c/"

cp \
	./azure-iot-sdk-c/iothub_service_client/inc/iothub_devicemethod.h \
	./azure-iot-sdk-c/iothub_service_client/inc/iothub_devicetwin.h \
	./azure-iot-sdk-c/iothub_service_client/inc/iothub_messaging.h \
	./azure-iot-sdk-c/iothub_service_client/inc/iothub_messaging_ll.h \
	./azure-iot-sdk-c/iothub_service_client/inc/iothub_registrymanager.h \
	./azure-iot-sdk-c/iothub_service_client/inc/iothub_sc_version.h \
	./azure-iot-sdk-c/iothub_service_client/inc/iothub_service_client_auth.h \
	./azure-iot-sdk-c/iothub_client/inc/iothub_message.h \
	"./azureout/include/iothub_service_client"

popd
echo 'Script is complete'
