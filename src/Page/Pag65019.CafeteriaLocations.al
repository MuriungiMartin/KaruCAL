#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65019 "Cafeteria Locations"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = Location;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("Cafeteria Location";"Cafeteria Location")
                {
                    ApplicationArea = Basic;
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                }
                field("Cafeteria Location Category";"Cafeteria Location Category")
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
        SetFilter("Cafeteria Location",'=%1',true);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Cafeteria Location":=true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Cafeteria Location":=true;
    end;

    trigger OnOpenPage()
    begin
        SetFilter("Cafeteria Location",'=%1',true);
    end;
}

