import 'package:flutter/material.dart';

class InfiniteAnimation extends StatefulWidget {
  final Widget child;
  final int durationInSeconds;
  final bool isPlaying;

  const InfiniteAnimation({
    required this.child,
    required this.isPlaying,
    this.durationInSeconds = 2,
  });

  @override
  _InfiniteAnimationState createState() => _InfiniteAnimationState();
}

class _InfiniteAnimationState extends State<InfiniteAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationInSeconds),
    );
    animation = Tween<double>(
      begin: 0,
      end: 12.5664, // 2Radians (360 degrees)
    ).animate(animationController);

    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     //     animationController.repeat();
    //   }
    // }
    // );

    // animationController.addListener(() {
    //   if (!widget.isPlaying) {
    //     setState(() {
    //       print("STOP TRIED");
    //       animationController.stop();
    //     });
    //   } else {
    //     setState(() {
    //       print("FORWARD TRIED");
    //       animationController.forward();
    //     });
    //   }
    // });
  }

  // @override
  // void didChangeDependencies() {
  //   animationController.addListener(() {
  //     if (!widget.isPlaying) {
  //       setState(() {
  //         print("STOP TRIED");
  //         animationController.stop();
  //       });
  //     } else {
  //       setState(() {
  //         print("FORWARD TRIED");
  //         animationController.forward();
  //       });
  //     }
  //   });
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.isPlaying) {
      animationController.forward();
      if (animationController.isCompleted) {
        animationController.repeat();
      } else if (animationController.isDismissed) {
        animationController.forward();
      }
    } else {
      animationController.stop();
    }
    // ...
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: animation.value,
            child: widget.child,
          );
        });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
