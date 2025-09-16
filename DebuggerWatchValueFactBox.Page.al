#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9503 "Debugger Watch Value FactBox"
{
    Caption = 'Debugger Watch Value FactBox';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Debugger Watch Value";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
            action("Delete Watch")
            {
                ApplicationArea = All;
                Caption = 'Delete Watch';
                Image = Delete;
                ShortCutKey = 'Ctrl+Delete';
                ToolTip = 'Delete the selected variables from the watch list.';

                trigger OnAction()
                var
                    DebuggerWatch: Record "Debugger Watch";
                    DebuggerWatchValue: Record "Debugger Watch Value";
                    DebuggerWatchValueTemp: Record "Debugger Watch Value" temporary;
                begin
                    CurrPage.SetSelectionFilter(DebuggerWatchValue);

                    // Copy the selected records to take a snapshot of the watches,
                    // otherwise the DELETEALL would dynamically change the Debugger Watch Value primary keys
                    // causing incorrect records to be deleted.

                    if DebuggerWatchValue.Find('-') then
                      repeat
                        DebuggerWatchValueTemp := DebuggerWatchValue;
                        DebuggerWatchValueTemp.Insert;
                      until DebuggerWatchValue.Next = 0;

                    if DebuggerWatchValueTemp.Find('-') then begin
                      repeat
                        DebuggerWatch.SetRange(Path,DebuggerWatchValueTemp.Name);
                        DebuggerWatch.DeleteAll(true);
                      until DebuggerWatchValueTemp.Next = 0;
                    end;
                end;
            }
        }
    }
}

