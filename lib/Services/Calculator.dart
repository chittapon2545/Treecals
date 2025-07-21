import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

class Calculator {
  double NomalCS(double D, double H) {
    double ws = 0.0396 * pow(((D * D) * H), 0.933);
    double wb = 0.00349 * pow(((D * D) * H), 1.03);
    double wl = 1 / ((28 / (ws + wb)) + 0.025);
    double wt = ws + wb + wl;
    double wr = wt * 27;
    double wa = wt + wr;
    double cs = wa * 0.47;

    return cs;
  }

  double Plem(double H) {
    double wt = 6.666 + 12.86 * pow(H, 0.5) * log(H);
    double wr = wt * 41;
    double wa = wt + wr;
    double cs = wa * 0.413;
    return cs;
  }

  double Vine(double D) {
    double wt = 0.8622 * pow(D, 2.0210);
    double wr = wt * 27;
    double wa = wt + wr;
    double cs = wa * 0.47;

    return cs;
  }

  double Co2eq(double cs) {
    double co2eq = cs * (44 / 12);

    return co2eq;
  }
}
