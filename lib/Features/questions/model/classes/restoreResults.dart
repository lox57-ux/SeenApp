class RestoreResults {
  final int? questionId;
  final bool? show;
  final bool? isMcq;
  final int? correctAnswer;
  final int? correctID;
  final dynamic isSelected;
  final dynamic selectedAnswer;
  final dynamic isWrong;
  final dynamic right_times;
  final dynamic nextDate;
  RestoreResults(
      {this.questionId,
      this.show,
      this.isWrong,
      this.nextDate,
      this.right_times,
      this.isMcq,
      this.correctAnswer,
      this.isSelected,
      this.selectedAnswer,
      this.correctID});
}
