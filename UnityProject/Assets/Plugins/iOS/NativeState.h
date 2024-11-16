#import <Metal/MTLTexture.h>

struct NativeState {
    const double x;
    const double y;
    const double z;
};

typedef void (*SetNativeStateCallback)(struct NativeState nextState);

@protocol SetsNativeState
/* Function pointer that will be used to send state from Swift to Unity.
   Encapsulation within a protocol lets us take advantage of Swift's didSet property observer. */
@property (nullable) SetNativeStateCallback setNativeState;
@end

__attribute__ ((visibility("default")))
void RegisterNativeStateSetter(id<SetsNativeState> _Nonnull setter);