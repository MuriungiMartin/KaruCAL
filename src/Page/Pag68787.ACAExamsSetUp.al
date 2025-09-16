#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68787 "ACA-Exams Set Up"
{
    PageType = Card;
    SourceTable = UnknownTable61567;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Desription;Desription)
                {
                    ApplicationArea = Basic;
                }
                field("Max. Score";"Max. Score")
                {
                    ApplicationArea = Basic;
                }
                field("% Contrib. Final Score";"% Contrib. Final Score")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account";"G/L Account")
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

