This sample exhibits the performance difference between pre-loading and caching large images versus loading them "on demand." Specifically, observe how the animated spinner stutters/stops when a new photo is loaded on demand, but if the images are pre-loaded and cached, the spinner animation is not interrupted.

The performance difference is more apparent when this sample is built/deployed to an actual mobile device.

Note that network connectivity is required to initially download the large image files.

RELATED GUIDES
[Texture Loading/Management](https://docs.coronalabs.com/guide/graphics/textureManagement.html)
