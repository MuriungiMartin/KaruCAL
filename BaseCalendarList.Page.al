#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7601 "Base Calendar List"
{
    ApplicationArea = Basic;
    Caption = 'Base Calendar List';
    CardPageID = "Base Calendar Card";
    Editable = false;
    PageType = List;
    SourceTable = "Base Calendar";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Caption = 'Code';
                    ToolTip = 'Specifies the code for the base calendar you have set up.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the base calendar in the entry.';
                }
                field("Customized Changes Exist";"Customized Changes Exist")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customized Changes Exist';
                    ToolTip = 'Specifies that the base calendar has been used to create customized calendars.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Base Calendar")
            {
                Caption = '&Base Calendar';
                Image = Calendar;
                action("&Where-Used List")
                {
                    ApplicationArea = Basic;
                    Caption = '&Where-Used List';
                    Image = Track;

                    trigger OnAction()
                    var
                        CalendarMgmt: Codeunit "Calendar Management";
                        WhereUsedList: Page "Where-Used Base Calendar";
                    begin
                        CalendarMgmt.CreateWhereUsedEntries(Code);
                        WhereUsedList.RunModal;
                        Clear(WhereUsedList);
                    end;
                }
                separator(Action11)
                {
                    Caption = '-';
                }
                action("&Base Calendar Changes")
                {
                    ApplicationArea = Basic;
                    Caption = '&Base Calendar Changes';
                    Image = Change;
                    RunObject = Page "Base Calendar Change List";
                    RunPageLink = "Base Calendar Code"=field(Code);
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

