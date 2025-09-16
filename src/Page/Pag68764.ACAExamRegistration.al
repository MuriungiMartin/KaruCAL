#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68764 "ACA-Exam Registration"
{
    PageType = List;
    SourceTable = UnknownTable61537;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Registration Date";"Registration Date")
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                    Caption = 'Intake';
                }
                field("Register for";"Register for")
                {
                    ApplicationArea = Basic;
                }
                field(Unit;Unit)
                {
                    ApplicationArea = Basic;
                }
                field(Exam;Exam)
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

