#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68745 "ACA-Buildings"
{
    PageType = Card;
    SourceTable = UnknownTable61519;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Building)
            {
                Caption = 'Building';
                action("Lecture Rooms")
                {
                    ApplicationArea = Basic;
                    Caption = 'Lecture Rooms';
                    RunObject = Page "ACA-Lecture Rooms";
                    RunPageLink = "Building Code"=field(Code);
                }
                separator(Action1102760000)
                {
                }
                action(Labs)
                {
                    ApplicationArea = Basic;
                    Caption = 'Labs';
                    RunObject = Page "ACA-Lecture Rooms - Labs";
                    RunPageLink = "Building Code"=field(Code);
                }
            }
        }
    }
}

