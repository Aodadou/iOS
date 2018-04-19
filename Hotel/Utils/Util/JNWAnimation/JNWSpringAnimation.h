#import <QuartzCore/QuartzCore.h>

// Adds the ability to add spring to your animations.
//
// Duration cannot be set directly. Instead, duration is
// a side effect of changing the various properties below.
//
// Although JNWSpringAnimation is a subclass of CAKeyframeAnimation,
// it should be treated as if it were a subclass of CABasicAnimation.
@interface JNWSpringAnimation : CAKeyframeAnimation

// The dedicated initializer for the animation.
//
// Not all layer properties can be animated. The following are compatible:
// - position
// - position.{x, y}
// - cornerRadius
// - shadowRadius
// - bounds
// - bounds.size
// - transform.translation.{x, y, z}
// - transform.rotation.{x, y, z}
// - transform.scale.{x, y, z}
// - transform.translation
// - transform (** experimental, only performs linear interpolation on all components **)
+ (instancetype)animationWithKeyPath:(NSString *)path;

// A damped spring can be modeled with the following equation:
// F = - kx - bv
// where k is the spring constant, x is the distance from equilibrium,
// and b is the coefficient of damping.
//
// Under the hood, a damped harmonic oscillation equation is used to
// provide the same results as the data obtained from Hooke's law.

// The spring constant.
//
// Defaults to 300.
@property (nonatomic, assign) CGFloat stiffness;

// The coefficient of damping.
//
// Defaults to 30.
@property (nonatomic, assign) CGFloat damping;

// The mass of the object.
//
// Defaults to 5.
@property (nonatomic, assign) CGFloat mass;

// Equivalent to CABasicAnimation's counterparts.
//
// Both must be non-nil.
@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;

// The duration, which is derived from the stiffness, damping, mass, and values.
//
// Note that this property will only return a non-zero value if both the `fromValue`
// and the `toValue` properties have both been set.
//
// Defaults to 0 if no from or to values have been set.
@property (nonatomic, assign, readonly) CFTimeInterval duration;

@end
