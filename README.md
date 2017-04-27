# react-native-image-zoom
image zoom for android and ios

 ## Getting started
 
 
 ### Installation

```bash
npm install react-native-zzm-image-zoom --save
```

### Manual install
#### iOS
1. `npm install react-native-zzm-image-zoom --save`
2. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
3. Go to `node_modules` ➜ `react-native-zzm-image-zoom` and add `imageZoom.xcodeproj`
4. In XCode, in the project navigator, select your project. Add `libImageZoom.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`


#### Android
1. `npm install react-native-zzm-image-zoom --save`
2. Open up `android/app/src/main/java/[...]/MainApplication.java
   Add `new ImageZoomReactPackage()` to the list returned by the `getPackages()` method. 
3. Append the following lines to `android/settings.gradle`:

	```
	include ':react-native-zzm-image-zoom'
	project(':react-native-zzm-image-zoom').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-camera/android')
	```

4. Insert the following lines inside the dependencies block in `android/app/build.gradle`:

	```
    compile project(':react-native-zzm-image-zoom')
	```

## Usage

```javascript
var ImageZoom = require('react-native-zzm-image-zoom');

<ZoomImage
   style={{flex:1}}
     uri=''/>
```

## Properties

#### `uri`

support url and path
