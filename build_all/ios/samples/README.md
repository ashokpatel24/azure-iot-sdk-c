This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). 
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or 
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Azure IoT Samples for iOS

### Instructions

#### 1. Create a working directory

`mkdir <working>`</br>
`cd <working>`

#### 2. Create an 'azureiotiosbuild' subdirectory

`mkdir azureiotiosbuild`</br>
`cd azureiotiosbuild`

#### 3. Clone the 'ios' branch of the Azure IoT SDK

`git clone -b ios --recursive https://github.com/Azure/azure-iot-sdk-c.git`

#### 4. Move the 'azure-iot-sdk-c/build_all/ios/samples' directory into '<working>'

`mv azure-iot-sdk-c/build_all/ios/samples ..`

#### 5. Run the library build script

`cd ../samples`</br>
`./build_azure_iot`

#### 6. Run the samples

You can now open and run any of the samples in the `<working>/samples` directory