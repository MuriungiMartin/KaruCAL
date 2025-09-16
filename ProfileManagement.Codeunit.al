#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5059 ProfileManagement
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'General';
        Text001: label 'No profile questionnaire is created for this contact.';
        ProfileQuestnHeaderTemp: Record "Profile Questionnaire Header" temporary;

    local procedure FindLegalProfileQuestionnaire(Cont: Record Contact)
    var
        ContBusRel: Record "Contact Business Relation";
        ProfileQuestnHeader: Record "Profile Questionnaire Header";
        ContProfileAnswer: Record "Contact Profile Answer";
        Valid: Boolean;
    begin
        ProfileQuestnHeaderTemp.DeleteAll;

        with ProfileQuestnHeader do begin
          Reset;
          if Find('-') then
            repeat
              Valid := true;
              if ("Contact Type" = "contact type"::Companies) and
                 (Cont.Type <> Cont.Type::Company)
              then
                Valid := false;
              if ("Contact Type" = "contact type"::People) and
                 (Cont.Type <> Cont.Type::Person)
              then
                Valid := false;
              if Valid and ("Business Relation Code" <> '') then
                if not ContBusRel.Get(Cont."Company No.","Business Relation Code") then
                  Valid := false;
              if not Valid then begin
                ContProfileAnswer.Reset;
                ContProfileAnswer.SetRange("Contact No.",Cont."No.");
                ContProfileAnswer.SetRange("Profile Questionnaire Code",Code);
                if ContProfileAnswer.FindFirst then
                  Valid := true;
              end;
              if Valid then begin
                ProfileQuestnHeaderTemp := ProfileQuestnHeader;
                ProfileQuestnHeaderTemp.Insert;
              end;
            until Next = 0;
        end;
    end;


    procedure GetQuestionnaire(): Code[10]
    var
        ProfileQuestnHeader: Record "Profile Questionnaire Header";
    begin
        if ProfileQuestnHeader.FindFirst then
          exit(ProfileQuestnHeader.Code);

        ProfileQuestnHeader.Init;
        ProfileQuestnHeader.Code := Text000;
        ProfileQuestnHeader.Description := Text000;
        ProfileQuestnHeader.Insert;
        exit(ProfileQuestnHeader.Code);
    end;


    procedure ProfileQuestionnaireAllowed(Cont: Record Contact;ProfileQuestnHeaderCode: Code[10]): Code[10]
    begin
        FindLegalProfileQuestionnaire(Cont);

        if ProfileQuestnHeaderTemp.Get(ProfileQuestnHeaderCode) then
          exit(ProfileQuestnHeaderCode);
        if ProfileQuestnHeaderTemp.FindFirst then
          exit(ProfileQuestnHeaderTemp.Code);

        Error(Text001);
    end;


    procedure ShowContactQuestionnaireCard(Cont: Record Contact;ProfileQuestnLineCode: Code[10];ProfileQuestnLineLineNo: Integer)
    var
        ProfileQuestnLine: Record "Profile Questionnaire Line";
        ContProfileAnswers: Page "Contact Profile Answers";
    begin
        ContProfileAnswers.SetParameters(Cont,ProfileQuestionnaireAllowed(Cont,''),ProfileQuestnLineCode,ProfileQuestnLineLineNo);
        if ProfileQuestnHeaderTemp.Get(ProfileQuestnLineCode) then begin
          ProfileQuestnLine.Get(ProfileQuestnLineCode,ProfileQuestnLineLineNo);
          ContProfileAnswers.SetRecord(ProfileQuestnLine);
        end;
        ContProfileAnswers.RunModal;
    end;


    procedure CheckName(CurrentQuestionsChecklistCode: Code[10];var Cont: Record Contact)
    begin
        FindLegalProfileQuestionnaire(Cont);
        ProfileQuestnHeaderTemp.Get(CurrentQuestionsChecklistCode);
    end;


    procedure SetName(ProfileQuestnHeaderCode: Code[10];var ProfileQuestnLine: Record "Profile Questionnaire Line";ContactProfileAnswerLine: Integer)
    begin
        ProfileQuestnLine.FilterGroup := 2;
        ProfileQuestnLine.SetRange("Profile Questionnaire Code",ProfileQuestnHeaderCode);
        ProfileQuestnLine.FilterGroup := 0;
        if ContactProfileAnswerLine = 0 then
          if ProfileQuestnLine.Find('-') then;
    end;


    procedure LookupName(var ProfileQuestnHeaderCode: Code[10];var ProfileQuestnLine: Record "Profile Questionnaire Line";var Cont: Record Contact)
    begin
        Commit;
        FindLegalProfileQuestionnaire(Cont);
        if ProfileQuestnHeaderTemp.Get(ProfileQuestnHeaderCode) then;
        if Page.RunModal(
             Page::"Profile Questionnaire List",ProfileQuestnHeaderTemp) = Action::LookupOK
        then
          ProfileQuestnHeaderCode := ProfileQuestnHeaderTemp.Code;

        SetName(ProfileQuestnHeaderCode,ProfileQuestnLine,0);
    end;


    procedure ShowAnswerPoints(CurrProfileQuestnLine: Record "Profile Questionnaire Line")
    begin
        CurrProfileQuestnLine.SetRange("Profile Questionnaire Code",CurrProfileQuestnLine."Profile Questionnaire Code");
        Page.RunModal(Page::"Answer Points",CurrProfileQuestnLine);
    end;
}

