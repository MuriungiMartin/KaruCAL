#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68588 "HMS-Radiology Test Line Images"
{
    PageType = ListPart;
    SourceTable = UnknownTable61421;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Radiology No.";"Radiology No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
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
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field(Image;Image)
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
        HasValue: Boolean;
}

