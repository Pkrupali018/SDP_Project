enum MessageEnum{
  text('String'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  //Constructor for enum
  const MessageEnum(this.type);
  final String type;
}

extension ConvertMessage on String{
  MessageEnum toEnum() {
    switch(this){
      case 'audio':
        return MessageEnum.audio;
      case 'image':
        return MessageEnum.image;
      case 'text':
        return MessageEnum.text;
      case 'gif':
        return MessageEnum.gif;
      case 'video':
        return MessageEnum.video;
      default:
        return MessageEnum.text;
    }
  }
}

// extension ConvertMessage on MessageEnum{
//   MessageEnum toEnum(){
//     switch(this){
//       case MessageEnum.audio:
//         return audio;
//     }
//   }
// }

/// We want to convert into String for text and from text to Enum.
/// Here we have two ways
/// 1) Using an extensions
/// 2) Enhaced enums  --> introduce in flutter 3 and dart 2.17
