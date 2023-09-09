## 🌏 Swift-Project-Translator(지속 업데이트 중)

Swift 언어를 활용한 번역기 앱

## 🎨 와이어프레임

🔗 [와이어프레임 링크](https://www.figma.com/file/cl712CEZg2TRcQtBqoZaBA/Translator?type=design&node-id=6%3A24&mode=dev)<br>

## 🕰️ 개발 기간

- 23.08.18 ~ (진행중)

## 💻 프로젝트 소개

**Swift UIKit 프레임워크**와 **MVC 패턴**을 공부할 목적으로 구현한 앱입니다.

평소 외국어 공부에 관심이 많아 자주 이용하는 어플 중 하나인 '**Google 번역**' 앱을 모티브로 앱을 구현하였습니다.

## 🗺️ 아키텍처

<img width="810" alt="Translator-Architecture" src="https://github.com/constdreamcoder/Translator-swift/assets/95998675/41b998c1-1b43-49a0-a63e-81eb8253e58e">

## 📌 구현 기능

- 번역 기능
  - Google Translation API 이용
- 텍스트 읽기 기능
  - Google TTS(Text-to-Speech) API 이용
- 음성 텍스트 입력 기능
  - Speech 프레임워크 사용
- 다국어 지원(한국어, 영어, 일본어, 중국어)
  - Localiztion 이용
- 변역한 내용 기록 기능
- 번역된 내용 저장 기능
- 대화 기능(**구현 예정**)
- 카메라 인식 기능(**구현 예정**)

## 👨‍👧‍👧 사용 기술 스택

### 🔗 [Frontend](https://github.com/constdreamcoder/Translator-swift)

<div align='left'>
  <img src="https://img.shields.io/badge/swift-e8e8e8?style=for-the-badge&logo=swift&logoColor=F05138">
</div>

### 🔗 [Backend](https://github.com/constdreamcoder/translator-backend)

<div align='left'>
  <img src="https://img.shields.io/badge/node.js-339933?style=for-the-badge&logo=Node.js&logoColor=white">
  <img src="https://img.shields.io/badge/express-blue?style=for-the-badge&logo=express&logoColor=000000">
  <img src="https://img.shields.io/badge/swagger-85EA2D?style=for-the-badge&logo=swagger&logoColor=FFFFFF">
</div>

### Deployment

<div align='left'>
  <img src="https://img.shields.io/badge/google cloud-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white">
</div>

## 📌 커밋 메세지 룰입니다. 📌

✔ FEAT : 새로운 기능의 추가

✔ FIX: 버그 수정

✔ DOCS: 문서 수정

✔ STYLE: 스타일 관련 기능(코드 포맷팅, 세미콜론 누락, 코드 자체의 변경이 없는 경우)

✔ REFACTOR: 코드 리펙토링

✔ TEST: 테스트 코트, 리펙토링 테스트 코드 추가

✔ CHORE: 빌드 업무 수정, 패키지 매니저 수정(ex .gitignore 수정 같은 경우)
