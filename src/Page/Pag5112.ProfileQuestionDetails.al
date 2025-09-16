#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5112 "Profile Question Details"
{
    Caption = 'Profile Question Details';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Profile Questionnaire Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the profile question or answer.';
                }
                field("Multiple Answers";"Multiple Answers")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that the question has more than one possible answer.';
                }
            }
            group(Classification)
            {
                Caption = 'Classification';
                field("Auto Contact Classification";"Auto Contact Classification")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that the question is automatically answered when you run the Update Contact Classification batch job.';

                    trigger OnValidate()
                    begin
                        AutoContactClassificationOnAft;
                    end;
                }
                field("Customer Class. Field";"Customer Class. Field")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = CustomerClassFieldEditable;
                    ToolTip = 'Specifies the customer information that the automatic classification is based on. There are seven options: Blank, Sales ($), Profit ($), Sales Frequency (Invoices/Year), Avg. Invoice Amount ($), Discount (%), and Avg. Overdue (Day).';

                    trigger OnValidate()
                    begin
                        CustomerClassFieldOnAfterValid;
                    end;
                }
                field("Vendor Class. Field";"Vendor Class. Field")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = VendorClassFieldEditable;
                    ToolTip = 'Specifies the vendor information that the automatic classification is based on. There are six options:';

                    trigger OnValidate()
                    begin
                        VendorClassFieldOnAfterValidat;
                    end;
                }
                field("Contact Class. Field";"Contact Class. Field")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = ContactClassFieldEditable;
                    ToolTip = 'Specifies the contact information on which the automatic classification is based. There are seven options:';

                    trigger OnValidate()
                    begin
                        ContactClassFieldOnAfterValida;
                    end;
                }
                field("Min. % Questions Answered";"Min. % Questions Answered")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = MinPctQuestionsAnsweredEditable;
                    HideValue = MinPctQuestionsAnsweredHideValue;
                    ToolTip = 'Specifies the number of questions in percentage that must be answered for this rating to be calculated.';
                }
                field("Starting Date Formula";"Starting Date Formula")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = StartingDateFormulaEditable;
                    ToolTip = 'Specifies the date to start the automatic classification of your contacts.';
                }
                field("Ending Date Formula";"Ending Date Formula")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = EndingDateFormulaEditable;
                    ToolTip = 'Specifies the date to stop the automatic classification of your contacts.';
                }
                field("Classification Method";"Classification Method")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = ClassificationMethodEditable;
                    ToolTip = 'Specifies the method you can use to classify contacts. There are four options: Blank, Defined Value, Percentage of Value and Percentage of Contacts.';

                    trigger OnValidate()
                    begin
                        ClassificationMethodOnAfterVal;
                    end;
                }
                field("Sorting Method";"Sorting Method")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = SortingMethodEditable;
                    ToolTip = 'Specifies the sorting method for the automatic classification on which the question is based. This field is only valid when you select Percentage of Value or Percentage of Contacts in the Classification Method field. It indicates the direction of the percentage. There are two options:';
                }
                field("No. of Decimals";"No. of Decimals")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = NoOfDecimalsEditable;
                    HideValue = NoOfDecimalsHideValue;
                    ToolTip = 'Specifies the number of decimal places to use when entering values in the From Value and To Value fields.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(AnswerValues)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = '&Answer Points';
                Enabled = AnswerValuesEnable;
                Image = Answers;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'View or edit the number of points a questionnaire answer gives.';

                trigger OnAction()
                var
                    ProfileManagement: Codeunit ProfileManagement;
                begin
                    ProfileManagement.ShowAnswerPoints(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        MinPctQuestionsAnsweredHideValue := false;
        NoOfDecimalsHideValue := false;
        SetEditable;
        NoofDecimalsOnFormat;
        Min37QuestionsAnsweredOnFormat;
    end;

    trigger OnInit()
    begin
        AnswerValuesEnable := true;
        SortingMethodEditable := true;
        NoOfDecimalsEditable := true;
        EndingDateFormulaEditable := true;
        ClassificationMethodEditable := true;
        StartingDateFormulaEditable := true;
        MinPctQuestionsAnsweredEditable := true;
        ContactClassFieldEditable := true;
        VendorClassFieldEditable := true;
        CustomerClassFieldEditable := true;
    end;

    trigger OnOpenPage()
    begin
        SetRange(Type,Type::Question);
    end;

    var
        [InDataSet]
        NoOfDecimalsHideValue: Boolean;
        [InDataSet]
        NoOfDecimalsEditable: Boolean;
        [InDataSet]
        MinPctQuestionsAnsweredHideValue: Boolean;
        [InDataSet]
        CustomerClassFieldEditable: Boolean;
        [InDataSet]
        VendorClassFieldEditable: Boolean;
        [InDataSet]
        ContactClassFieldEditable: Boolean;
        [InDataSet]
        MinPctQuestionsAnsweredEditable: Boolean;
        [InDataSet]
        StartingDateFormulaEditable: Boolean;
        [InDataSet]
        ClassificationMethodEditable: Boolean;
        [InDataSet]
        EndingDateFormulaEditable: Boolean;
        [InDataSet]
        SortingMethodEditable: Boolean;
        [InDataSet]
        AnswerValuesEnable: Boolean;


    procedure SetEditable()
    begin
        CustomerClassFieldEditable :=
          "Auto Contact Classification" and ("Vendor Class. Field" = "vendor class. field"::" ") and ("Contact Class. Field" =
                                                                                                      "contact class. field"::" ");
        VendorClassFieldEditable :=
          "Auto Contact Classification" and ("Customer Class. Field" = "customer class. field"::" ") and ("Contact Class. Field" =
                                                                                                          "contact class. field"::" ");
        ContactClassFieldEditable :=
          "Auto Contact Classification" and ("Customer Class. Field" = "customer class. field"::" ") and ("Vendor Class. Field" =
                                                                                                          "vendor class. field"::" ");

        MinPctQuestionsAnsweredEditable := "Contact Class. Field" = "contact class. field"::Rating;

        StartingDateFormulaEditable :=
          ("Customer Class. Field" <> "customer class. field"::" ") or
          ("Vendor Class. Field" <> "vendor class. field"::" ") or
          (("Contact Class. Field" <> "contact class. field"::" ") and ("Contact Class. Field" <> "contact class. field"::Rating));

        EndingDateFormulaEditable := StartingDateFormulaEditable;

        ClassificationMethodEditable :=
          ("Customer Class. Field" <> "customer class. field"::" ") or
          ("Vendor Class. Field" <> "vendor class. field"::" ") or
          (("Contact Class. Field" <> "contact class. field"::" ") and ("Contact Class. Field" <> "contact class. field"::Rating));

        SortingMethodEditable :=
          ("Classification Method" = "classification method"::"Percentage of Value") or
          ("Classification Method" = "classification method"
           ::"Percentage of Contacts");

        NoOfDecimalsEditable := ClassificationMethodEditable;

        AnswerValuesEnable := ("Contact Class. Field" = "contact class. field"::Rating);
    end;

    local procedure AutoContactClassificationOnAft()
    begin
        SetEditable;
    end;

    local procedure CustomerClassFieldOnAfterValid()
    begin
        SetEditable;
    end;

    local procedure VendorClassFieldOnAfterValidat()
    begin
        SetEditable;
    end;

    local procedure ContactClassFieldOnAfterValida()
    begin
        SetEditable;
    end;

    local procedure ClassificationMethodOnAfterVal()
    begin
        SetEditable;
    end;

    local procedure NoofDecimalsOnFormat()
    begin
        if not NoOfDecimalsEditable then
          NoOfDecimalsHideValue := true;
    end;

    local procedure Min37QuestionsAnsweredOnFormat()
    begin
        if "Contact Class. Field" <> "contact class. field"::Rating then
          MinPctQuestionsAnsweredHideValue := true;
    end;
}

