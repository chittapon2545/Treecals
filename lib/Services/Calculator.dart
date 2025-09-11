import 'dart:math' as Math;

class BiomassResult {
  final double wt;
  final double blg;
  final double carbon;

  BiomassResult(this.wt, this.blg, this.carbon);
}

class BiomassCalculator {
  static BiomassResult? calculate(
    String groupId,
    double circumference,
    double height,
  ) {
    final D = circumference / Math.pi;
    final H = height;

    switch (groupId) {
      case 'G1': // กลุ่มพรรณไม้ทั่วไป
        final ws = 0.0396 * Math.pow(D * D * H, 0.933);
        final wb = 0.00349 * Math.pow(D * D * H, 1.030);
        final wl = Math.pow((28 / (ws + wb) + 0.025), -1);
        final wt = ws + wb + wl;
        final blg = wt * 0.27;
        final carbon = (wt + blg) * 0.47;
        return BiomassResult(wt, blg, carbon);

      case 'G2': // กลุ่มปาล์ม
        final wt = 6.666 + 12.826 * H * 0.5 * Math.log(H);
        final blg = wt * 0.413;
        final carbon = (wt + blg) * 0.413;
        return BiomassResult(wt, blg, carbon);

      case 'G3': // กลุ่มเถาวัลย์
        final wt = 0.8622 * Math.pow(D, 2.0210);
        final blg = wt * 0.27;
        final carbon = (wt + blg) * 0.47;
        return BiomassResult(wt, blg, carbon);

      case 'G4': // กลุ่มไผ่ (สมมุติใช้สูตรของไผ่ไร่)
        final wt = 0.2425 * Math.pow(D * D, 1.0751);
        final blg = wt * 0.27;
        final carbon = (wt + blg) * 0.47;
        return BiomassResult(wt, blg, carbon);

      default:
        return null;
    }
  }
}
