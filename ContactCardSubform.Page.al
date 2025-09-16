#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5051 "Contact Card Subform"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Contact Profile Answer";
    SourceTableView = sorting("Contact No.","Answer Priority","Profile Questionnaire Priority")
                      order(descending)
                      where("Answer Priority"=filter(<>"Very Low (Hidden)"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Answer Priority";"Answer Priority")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the priority of the profile answer. There are five options:';
                    Visible = false;
                }
                field("Profile Questionnaire Priority";"Profile Questionnaire Priority")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the priority of the questionnaire that the profile answer is linked to. There are five options: Very Low, Low, Normal, High, and Very High.';
                    Visible = false;
                }
                field(Question;Question)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Question';
                    ToolTip = 'Specifies the question in the profile questionnaire.';
                }
                field(Answer;Answer)
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    ToolTip = 'Specifies your contact''s answer to the question.';

                    trigger OnAssistEdit()
                    var
                        ContactProfileAnswer: Record "Contact Profile Answer";
                        Rating: Record Rating;
                        RatingTemp: Record Rating temporary;
                        ProfileQuestionnaireLine: Record "Profile Questionnaire Line";
                        Contact: Record Contact;
                        ProfileManagement: Codeunit ProfileManagement;
                    begin
                        ProfileQuestionnaireLine.Get("Profile Questionnaire Code","Line No.");
                        ProfileQuestionnaireLine.Get("Profile Questionnaire Code",ProfileQuestionnaireLine.FindQuestionLine);
                        if ProfileQuestionnaireLine."Auto Contact Classification" then begin
                          if ProfileQuestionnaireLine."Contact Class. Field" = ProfileQuestionnaireLine."contact class. field"::Rating then begin
                            Rating.SetRange("Profile Questionnaire Code","Profile Questionnaire Code");
                            Rating.SetRange("Profile Questionnaire Line No.",ProfileQuestionnaireLine."Line No.");
                            if Rating.Find('-') then
                              repeat
                                if ContactProfileAnswer.Get(
                                     "Contact No.",Rating."Rating Profile Quest. Code",Rating."Rating Profile Quest. Line No.")
                                then begin
                                  RatingTemp := Rating;
                                  RatingTemp.Insert;
                                end;
                              until Rating.Next = 0;

                            if not RatingTemp.IsEmpty then
                              Page.RunModal(Page::"Answer Points List",RatingTemp)
                            else
                              Message(Text001);
                          end else
                            Message(Text002,"Last Date Updated");
                        end else begin
                          Contact.Get("Contact No.");
                          ProfileManagement.ShowContactQuestionnaireCard(Contact,"Profile Questionnaire Code","Line No.");
                          CurrPage.Update(false);
                        end;
                    end;
                }
                field("Questions Answered (%)";"Questions Answered (%)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of questions in percentage of total questions that have scored points based on the question you used for your rating.';
                }
                field("Last Date Updated";"Last Date Updated")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the date when the contact profile answer was last updated. This field shows the first date when the questions used to rate this contact has been given points.';
                }
            }
        }
    }

    actions
    {
    }

    var
        Text001: label 'There are no answer values for this rating answer.';
        Text002: label 'This answer reflects the state of the contact on %1 when the Update Contact Class. batch job was run.\To make the answer reflect the current state of the contact, run the batch job again.';
}

