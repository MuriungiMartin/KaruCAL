#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7600 "Base Calendar Card"
{
    Caption = 'Base Calendar Card';
    PageType = ListPlus;
    SourceTable = "Base Calendar";

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
                    Caption = 'Code';
                    ToolTip = 'Specifies a code for the base calendar you are setting up.';
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
            part(BaseCalendarEntries;"Base Calendar Entries Subform")
            {
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
                        CalendarMgt: Codeunit "Calendar Management";
                        WhereUsedList: Page "Where-Used Base Calendar";
                    begin
                        CalendarMgt.CreateWhereUsedEntries(Code);
                        WhereUsedList.RunModal;
                        Clear(WhereUsedList);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Maintain Base Calendar Changes")
                {
                    ApplicationArea = Basic;
                    Caption = '&Maintain Base Calendar Changes';
                    Image = Edit;
                    RunObject = Page "Base Calendar Changes";
                    RunPageLink = "Base Calendar Code"=field(Code);
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage.BaseCalendarEntries.Page.SetCalendarCode(Code);
    end;
}

