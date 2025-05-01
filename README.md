# tensorflow_lite_app

모바일 디바이스에서 실행 가능한 TensorFlow Lite 기반 앱 예제입니다.  
이 앱은 이미지에서 사람의 자세를 감지(Pose Estimation)하기 위해 **MoveNet 모델**을 사용합니다.

## ✨ 주요 기능

- 갤러리에서 이미지 선택
- 선택한 이미지에서 사람의 관절(Keypoint) 감지
- 관절 위치를 이미지 위에 시각적으로 표시

## 🛠 사용 기술

- **Flutter**: 크로스플랫폼 UI 개발
- **TensorFlow Lite**: 경량화된 머신러닝 모델 실행
- **image 패키지**: 이미지 디코딩 및 리사이징