//
//  Motion.swift
//  NeighborHarada
//
//  Created by Taishin Miyamoto on 2024/11/16.
//
// https://dev.classmethod.jp/articles/cmmotionmanager_move_view/

import SwiftUI
import CoreMotion
import Combine

/// 加速度を取るクラス。
/// Viewでの使用方法。
/// ```
/// @StateObject var motion = Motion()
///
/// .onChange(of: motion.accelerometerData?.acceleration.x) { _, _ in
///     print("@@ x: \(motion.accelerometerData?.acceleration.x)")
///     print("@@ y: \(motion.accelerometerData?.acceleration.y)")
/// }
/// .onAppear {
///     motion.startAccelerometerUpdates()
/// }
/// .onDisappear {
///     motion.stopUpdates()
/// }
/// ```
final class Motion: ObservableObject {
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()

    @Published var accelerometerData: CMAccelerometerData?

    func startAccelerometerUpdates() {
        guard motionManager.isAccelerometerAvailable else {
            print("Accelerometer is not available on this device.")
            return
        }
        // 更新頻度を秒で設定
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] (data, error) in
            if let error = error {
                print("Error in accelerometer updates: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self?.accelerometerData = data
            }
        }
    }

    func stopUpdates() {
        motionManager.stopAccelerometerUpdates()
    }
}
