/// Contains the type of sensors for motion detection
/// (*accelerometer*, *userAccelerometer*, *gyroscope*, *magnetometer*).
enum ParallaxSensor {
  /// Discrete reading from an accelerometer. Accelerometers measure the velocity
  /// of the device. Note that these readings include the effects of gravity. Put
  /// simply, you can use accelerometer readings to tell if the device is moving in
  /// a particular direction.
  accelerometer,

  /// Like **[accelerometer]**, this is a discrete reading from an accelerometer
  /// and measures the velocity of the device. However, unlike
  /// **[accelerometer]**, this event does not include the effects of gravity.
  userAccelerometer,

  /// Discrete reading from a gyroscope. Gyroscopes measure the rate or rotation of
  /// the device in 3D space.
  gyroscope,

  /// Magnetometers measure the ambient magnetic field surrounding the sensor,
  /// returning values in microteslas ***μT*** for each three-dimensional axis.
  ///
  /// Consider that these samples may bear effects of Earth's magnetic field as
  /// well as local factors such as the metal of the device itself or nearby
  /// magnets, though most devices compensate for these factors.
  ///
  /// A compass is an example of a general utility for magnetometer data.
  magnetometer
}
