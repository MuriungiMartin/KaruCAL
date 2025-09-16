#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68827 "HRM-Lookup Values Card"
{
    PageType = Card;
    SourceTable = UnknownTable61202;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field(Score;Score)
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
        Text19024457: label 'Months';
}

