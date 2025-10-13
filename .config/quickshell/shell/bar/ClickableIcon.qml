import QtQuick

BarButton {
	id: root
	required property string image;
	property alias cache: imageComponent.cache;
	property alias asynchronous: imageComponent.asynchronous;
	property bool scaleIcon: !asynchronous

	Image {
		id: imageComponent
		anchors.fill: parent

		source: root.image
		sourceSize.width: Math.max(16, scaleIcon ? width : (root.width - baseMargin))
		sourceSize.height: Math.max(16, scaleIcon ? height : (root.height - baseMargin))
		cache: false
	}
}
