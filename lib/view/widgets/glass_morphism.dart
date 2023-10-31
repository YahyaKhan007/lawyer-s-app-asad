// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';

import 'package:flutter/material.dart';

Widget GlassDrop(
    {required double width,
    required double height,
    required blur,
    required opacity,
    required child}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(opacity),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            width: 1.5,
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: child,
      ),
    ),
  );
}

Widget GlassDropCircle(
    {required double width,
    required double height,
    required blur,
    required opacity,
    required child}) {
  return ClipRRect(
    clipBehavior: Clip.antiAlias,
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        height: height,
        // width: width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color.fromARGB(255, 213, 204, 204).withOpacity(opacity),
        ),
        child: child,
      ),
    ),
  );
}

Widget GlassMorphism(
    {required double width,
    required double height,
    required double blur,
    required double borderRadius,
    required dynamic child}) {
  return Padding(
    padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
    child: GlassmorphicContainer(
      width: width,
      height: height,
      borderRadius: borderRadius,
      blur: blur,
      alignment: Alignment.bottomCenter,
      border: 2,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(255, 93, 87, 87).withOpacity(0.1),
            const Color.fromARGB(255, 87, 79, 79).withOpacity(0.2),
          ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFffffff).withOpacity(0.5),
          const Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
      ),
      child: child,
    ),
  );
}
