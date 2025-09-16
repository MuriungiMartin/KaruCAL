#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9507 "Debugger Breakpoint Condition"
{
    Caption = 'Debugger Breakpoint Condition';
    DataCaptionExpression = DataCaption;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = StandardDialog;
    ShowFilter = false;
    SourceTable = "Debugger Breakpoint";

    layout
    {
        area(content)
        {
            group("Conditional Breakpoint")
            {
                InstructionalText = 'Enter a C/AL expression. When the debugger reaches the breakpoint, it evaluates the expression and code execution breaks only if the expression is true. Example: Amount > 0', Comment='Description text for the Condition field.';
                field(Condition;Condition)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the condition that is set on the breakpoint.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        CalcFields("Object Name");
        DataCaption := StrSubstNo(Text001,"Object Type","Object ID","Object Name","Line No.");
    end;

    var
        DataCaption: Text[100];
        Text001: label '%1 %2 : %3, Line %4', Comment='Breakpoint text for the Data Caption: %1 = Object Type, %2 = Object ID, %3 = Object Name, %4 = Line No.';
}

