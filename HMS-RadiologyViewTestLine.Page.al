#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68590 "HMS-Radiology View Test Line"
{
    Editable = false;
    PageType = Document;
    SourceTable = UnknownTable61420;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Radiology Type Code";"Radiology Type Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Radiology Type Name";"Radiology Type Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Performed Date";"Performed Date")
                {
                    ApplicationArea = Basic;
                }
                field("Performed Time";"Performed Time")
                {
                    ApplicationArea = Basic;
                }
                field(Completed;Completed)
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
        area(processing)
        {
            action("Radiology Image(s)")
            {
                ApplicationArea = Basic;
                Caption = 'Radiology Image(s)';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    RadiologyLine.Reset;
                    RadiologyLine.SetRange(RadiologyLine."Radiology no.","Radiology no.");
                    RadiologyLine.SetRange(RadiologyLine."Radiology Type Code","Radiology Type Code");
                    Page.Run(52573, RadiologyLine);
                end;
            }
        }
    }

    var
        RadiologyLine: Record UnknownRecord61420;
}

