#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68190 "HMS-Radiology History List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61419;
    SourceTableView = where(Status=filter(=Completed|=Forwarded));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Radiology No.";"Radiology No.")
                {
                    ApplicationArea = Basic;
                }
                field("Link No.";"Link No.")
                {
                    ApplicationArea = Basic;
                }
                field("Link Type";"Link Type")
                {
                    ApplicationArea = Basic;
                }
                field("Radiology Date";"Radiology Date")
                {
                    ApplicationArea = Basic;
                }
                field("Radiology Time";"Radiology Time")
                {
                    ApplicationArea = Basic;
                }
                field("Radiology Area";"Radiology Area")
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("&Request Lines")
            {
                ApplicationArea = Basic;
                Caption = '&Request Lines';
                Image = LineDescription;
                Promoted = true;
                RunObject = Page "HMS-Radiology Req. Hist. Lines";
                RunPageLink = "Radiology no."=field("Radiology No.");
            }
        }
    }
}

