{ ... }: {
    mkIfElse =
        condition: trueContent: falseContent:
            if condition then trueContent else falseContent;
}