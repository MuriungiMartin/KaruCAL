#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68485 "ACA-Applic. Form Batch View"
{
    PageType = Document;
    SourceTable = UnknownTable61368;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Batch No.";"Batch No.")
                {
                    ApplicationArea = Basic;
                }
                field("Batch Date";"Batch Date")
                {
                    ApplicationArea = Basic;
                }
                field("Batch Time";"Batch Time")
                {
                    ApplicationArea = Basic;
                }
                field("No. Of Applications Pending";"No. Of Applications Pending")
                {
                    ApplicationArea = Basic;
                }
                field("No.Of Applications Ratified";"No.Of Applications Ratified")
                {
                    ApplicationArea = Basic;
                }
                field("No. Of Applications Rejected";"No. Of Applications Rejected")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1102760016;"ACA-Applic. Form Batch List")
            {
                SubPageLink = "Batch No."=field("Batch No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Print Summary")
            {
                ApplicationArea = Basic;
                Caption = '&Print Summary';
                Image = print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*Print out the summary*/
                    Apps.Reset;
                    Apps.SetRange(Apps."Batch No.");
                    Apps.SetRange(Apps.Status,Apps.Status::"Admission Board");
                    Report.Run(39005762,true,true,Apps);

                end;
            }
        }
    }

    var
        Apps: Record UnknownRecord61358;
}

