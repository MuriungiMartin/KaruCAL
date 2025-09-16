#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68055 "HRM-Applicant Qualif. lines"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = UnknownTable61064;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Qualification code";"Qualification code")
                {
                    ApplicationArea = Basic;
                }
                field("Qualification Description";"Qualification Description")
                {
                    ApplicationArea = Basic;
                }
                field("From Date";"From Date")
                {
                    ApplicationArea = Basic;
                }
                field("To Date";"To Date")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if ("To Date"<>0D) and ("From Date"<>0D) then
                         "No of Years":="To Date"-"From Date";
                    end;
                }
                field(Institution;Institution)
                {
                    ApplicationArea = Basic;
                }
                field("Qualification Type";"Qualification Type")
                {
                    ApplicationArea = Basic;
                }
                field("No of Years";"No of Years")
                {
                    ApplicationArea = Basic;
                    Caption = 'No of days';
                    Editable = false;
                }
                field("Actual Score";"Actual Score")
                {
                    ApplicationArea = Basic;
                }
                field("Desired Score";"Desired Score")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Qualified;Qualified)
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
        Year: Integer;
}

