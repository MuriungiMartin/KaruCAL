#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68510 "ACA-Academic Year List"
{
    CardPageID = "ACA-Academic Year Card";
    PageType = List;
    SourceTable = UnknownTable61382;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Current;Current)
                {
                    ApplicationArea = Basic;
                }
                field("Allow View of Transcripts";"Allow View of Transcripts")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Group (PhD)";"Graduation Group (PhD)")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Group (Masters)";"Graduation Group (Masters)")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Group (Degree)";"Graduation Group (Degree)")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Group (Diploma)";"Graduation Group (Diploma)")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Group (Certificate)";"Graduation Group (Certificate)")
                {
                    ApplicationArea = Basic;
                }
                field("Release Results";"Release Results")
                {
                    ApplicationArea = Basic;
                }
                field("Current Supplementary Year";"Current Supplementary Year")
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
            action(Application_deadlines)
            {
                ApplicationArea = Basic;
                Image = Info;
                Promoted = true;
                RunObject = Page "ACA-Online Application Notes";
                RunPageLink = "Academic Year"=field(Code);
            }
            action("Academic Year Schedule")
            {
                ApplicationArea = Basic;
                Image = CalendarMachine;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "ACA-Academic Year Schedule";
                RunPageLink = "Academic Year"=field(Code);
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

