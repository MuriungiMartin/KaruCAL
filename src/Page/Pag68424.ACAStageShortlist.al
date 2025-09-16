#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68424 "ACA-Stage Shortlist"
{
    PageType = ListPart;
    SourceTable = UnknownTable61315;
    SourceTableView = sorting("Stage Score")
                      order(descending);

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Applicant;Applicant)
                {
                    ApplicationArea = Basic;
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field("ID No";"ID No")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Stage Score";"Stage Score")
                {
                    ApplicationArea = Basic;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field(Qualified;Qualified)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        "Manual Change":=true;
                        Modify;
                    end;
                }
                field("Manual Change";"Manual Change")
                {
                    ApplicationArea = Basic;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                }
                field(Employ;Employ)
                {
                    ApplicationArea = Basic;
                }
                field("Reporting Date";"Reporting Date")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    var
        MyCount: Integer;


    procedure GetApplicantNo() AppicantNo: Code[20]
    begin
        AppicantNo:=Applicant;
    end;
}

