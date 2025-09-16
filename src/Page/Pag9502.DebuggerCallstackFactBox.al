#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9502 "Debugger Callstack FactBox"
{
    Caption = 'Debugger Callstack FactBox';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Debugger Call Stack";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Object Type";"Object Type")
                {
                    ApplicationArea = All;
                    Caption = 'Object Type';
                    ToolTip = 'Specifies the type of the object where the breakpoint is set.';
                }
                field("Object ID";"Object ID")
                {
                    ApplicationArea = All;
                    Caption = 'Object ID';
                    ToolTip = 'Specifies the ID of the object on which the breakpoint is set.';
                }
                field("Object Name";"Object Name")
                {
                    ApplicationArea = All;
                    Caption = 'Object Name';
                    ToolTip = 'Specifies the name of the object in which the breakpoint is set.';
                }
                field("Function Name";"Function Name")
                {
                    ApplicationArea = All;
                    Caption = 'Function Name';
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Line No.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        if Update and (ID = 1) then begin
          SetRange(ID);
          Update := false;
        end;
        CurrentCallstack := Rec;
    end;

    var
        CurrentCallstack: Record "Debugger Call Stack";
        Update: Boolean;


    procedure GetCurrentCallstack(var CurrentCallstackRec: Record "Debugger Call Stack")
    begin
        CurrentCallstackRec := CurrentCallstack;
    end;


    procedure ResetCallstackToTop()
    begin
        if CurrentCallstack.ID <> 1 then begin
          SetRange(ID,1,1);
          CurrPage.Update;
          Update := true;
        end;
    end;
}

