/**
 * Created by zhengzhangmin on 17/3/16.
 */
import React from "react";
import {
    requireNativeComponent,
} from "react-native";

var ZoomImageView =requireNativeComponent('ZoomImage', ZoomImage);

class ZoomImage extends React.Component {

    static propTypes = {
        uri:React.PropTypes.string
    };

    constructor(props) {
        super(props);
    }

    render(){
        return <ZoomImageView {...this.props}/>
    }
}

module.exports = ZoomImage;