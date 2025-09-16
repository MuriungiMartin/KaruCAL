#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68767 "ACA-Lecturers Units/Subjects"
{
    PageType = ListPart;
    SourceTable = UnknownTable65202;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
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
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                }
                field(Unit;Unit)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Rate;Rate)
                {
                    ApplicationArea = Basic;
                }
                field("No. Of Hours";"No. Of Hours")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Claimed Amount";"Claimed Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Claim to pay";"Claim to pay")
                {
                    ApplicationArea = Basic;
                }
                field("Student Type";"Student Type")
                {
                    ApplicationArea = Basic;
                }
                field("Available From";"Available From")
                {
                    ApplicationArea = Basic;
                }
                field("Available To";"Available To")
                {
                    ApplicationArea = Basic;
                }
                field(Allocation;Allocation)
                {
                    ApplicationArea = Basic;
                }
                field("No. Of Hours Contracted";"No. Of Hours Contracted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contracted Hours ';
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

    trigger OnAfterGetRecord()
    begin
        //Units.RESET;
        //IF Units.GET(Programme,Stage,Unit) THEN
    end;

    var
        Units: Record UnknownRecord61517;
}

