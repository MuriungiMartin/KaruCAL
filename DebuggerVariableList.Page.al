#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9508 "Debugger Variable List"
{
    Caption = 'Debugger Variable List';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Watch';
    SourceTable = "Debugger Variable";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = Indentation;
                ShowAsTree = true;
                field(Name;Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field(Value;Value)
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                }
                field(Type;Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            separator(Action9)
            {
            }
            action("Add Watch")
            {
                ApplicationArea = All;
                Caption = 'Add Watch';
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ShortCutKey = 'Ctrl+Insert';
                ToolTip = 'Add the selected variable to the watch list.';

                trigger OnAction()
                var
                    DebuggerManagement: Codeunit "Sequence No. Mgt.";
                begin
                    DebuggerManagement.AddWatch(Path,false);
                end;
            }
        }
    }
}

