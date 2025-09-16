#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 55509 "FLT-Closed Duty Rotar Weeks"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable55507;
    SourceTableView = where(Status=filter(Closed));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Week ID";"Week ID")
                {
                    ApplicationArea = Basic;
                }
                field("Week Start";"Week Start")
                {
                    ApplicationArea = Basic;
                }
                field("Week End";"Week End")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(RotarList)
            {
                ApplicationArea = Basic;
                Caption = 'Duty Rotar List';
                Image = ApplyEntries;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FLTDutyRoster.Reset;
                    FLTDutyRoster.SetRange("Week No",Rec."Week ID");
                    if FLTDutyRoster.Find('-') then  Page.Run(55511,FLTDutyRoster);
                end;
            }
            action(RotarReport)
            {
                ApplicationArea = Basic;
                Caption = 'Roster Report';
                Image = Attach;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FLTDutyRosterWeeks.Reset;
                    FLTDutyRosterWeeks.SetRange("Week ID",Rec."Week ID");
                    if FLTDutyRosterWeeks.Find('-') then  Report.Run(55504,true,false,FLTDutyRosterWeeks);
                end;
            }
        }
    }

    var
        FLTDutyRosterWeeks: Record UnknownRecord55507;
        FLTDutyRoster: Record UnknownRecord55506;
}

