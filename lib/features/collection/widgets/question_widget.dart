import 'package:drmohans_homecare_flutter/features/collection/data/models/question_list_model/question.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:drmohans_homecare_flutter/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/space.dart';
import 'export_collection_widgets.dart';

Debouncer _debouncer = Debouncer(milliseconds: 1000);

class QuestionWidget extends ConsumerStatefulWidget {
  const QuestionWidget({
    super.key,
    required this.answer,
    required this.question,
  });
  final Question question;
  final Function(String selectedAns) answer;

  @override
  ConsumerState<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends ConsumerState<QuestionWidget> {
  late ValueNotifier<String> selectedAns;
  @override
  void initState() {
    selectedAns = ValueNotifier('');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.question.queId}. ${widget.question.queName}",
            style: mon14Black,
          ),
          Space.y(10),
          widget.question.answerType == "OPTIONS"
              ? Row(
                  children: [
                    Expanded(
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 3.5,
                        children: List.generate(
                          widget.question.answers.length,
                          (index) => ValueListenableBuilder(
                              valueListenable: selectedAns,
                              builder: (context, ans, _) {
                                return AnswerButton(
                                  onButtonSelected: (ans) {
                                    selectedAns.value = ans;
                                    widget.answer(ans);
                                  },
                                  buttonLabel: widget.question.answers[index],
                                  isSelected: selectedAns.value ==
                                      widget.question.answers[index],
                                );
                              }),
                        ),
                      ),
                    ),
                    // Space.x(20)
                  ],
                )
              : TextFormField(
                  // keyboardType: TextInputType.number,
                  onChanged: (ans) {
                    _debouncer.run(() {
                      widget.answer(ans);
                    });
                  },
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: HcTheme.lightGrey2Color,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: HcTheme.lightGrey2Color,
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
